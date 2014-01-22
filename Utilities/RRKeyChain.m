//
//  RRKeyChain.m
//  studyBase
//
//  Created by renren on 14-1-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RRKeyChain.h"
#import <Security/Security.h>

static NSString * const kUUIDStringKey = @"com.renren-inc.UUIDString";

@implementation RRKeyChain

+ (NSString *)sharedUUIDString
{
    NSString *UUIDString = [self dataForKey:kUUIDStringKey];
//    if (!UUIDString) {
//        if ([[UIDevice currentDevice]respondsToSelector:@selector(identifierForVendor)]) {
//            UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
//        } else {
//            CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
//            CFStringRef UUIDSRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
//            UUIDString = [(NSString *)CFBridgingRelease(CFStringCreateCopy(kCFAllocatorDefault, UUIDSRef))];
//            CFRelease(UUIDRef);
//            CFRelease(UUIDSRef);
//        }
//        [self saveData:UUIDString forKey:kUUIDStringKey];
//    }
    return UUIDString;
}

+ (NSMutableDictionary *)keychainQueryDictForKey:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            //以密码的形式保存
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            //帐户名
            key, (__bridge id)kSecAttrAccount,
            //访问级别,一直可访问,并且用户备份时不进入备份
            (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)saveData:(id)data forKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self keychainQueryDictForKey:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)dataForKey:(NSString *)key
{
    id returnValue = nil;
    NSMutableDictionary *keychainQuery = [self keychainQueryDictForKey:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (status == noErr) {
        @try {
            returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", key, exception);
            SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return returnValue;
}


@end
