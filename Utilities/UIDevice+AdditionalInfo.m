//
//  UIDevice+AdditionalInfo.m
//  RenrenOfficial-iOS-Base
//
//  Created by Jonathan Dong on 13-4-22.
//  Copyright (c) 2013年 Renren-inc. All rights reserved.
//

#import "UIDevice+AdditionalInfo.h"

#import "RISettings.h"
#import "RRKeyChain.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <JSONModel/JSONModel.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>

@interface ClientInfomation : JSONModel
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *uniqid;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *os;
@property (nonatomic, copy) NSString *screen;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *ua;
@property (nonatomic, copy) NSString *other;
@end

@implementation ClientInfomation
@end

@implementation UIDevice (AdditionalInfo)

+ (NSString *)MAC
{
    int                mib[6];
    size_t             len;
    char               *buf;
    unsigned char      *ptr;
    struct if_msghdr   *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)deviceModel
{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *device = malloc(size);
    sysctlbyname("hw.machine", device, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithUTF8String:device];
    free(device);
    return deviceModel;
}

+ (NSString *)deviceModelName
{
    NSString *deviceModel = [UIDevice deviceModel];
    
    // iPhone
    if ([deviceModel isEqualToString:@"iPhone1,1"]) {
        return @"iPhone 1G";
    }
    
    if ([deviceModel isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G";
    }
    
    if ([deviceModel isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS";
    }
    
    if ([deviceModel isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4 (GSM)";
    }
    
    if ([deviceModel isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4 (CDMA)";
    }
    
    if ([deviceModel isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    }
    
    // iPod
    if ([deviceModel isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch 1G";
    }
    
    if ([deviceModel isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch 2G";
    }
    
    if ([deviceModel isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch 3G";
    }
    
    if ([deviceModel isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch 4G";
    }
    
    // iPad
    if ([deviceModel isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    }
    
    if ([deviceModel isEqualToString:@"iPad2,1"]) {
        return @"iPad 2 (WiFi)";
    }
    
    if ([deviceModel isEqualToString:@"iPad2,2"]) {
        return @"iPad 2 (GSM)";
    }
    
    if ([deviceModel isEqualToString:@"iPad2,3"]) {
        return @"iPad 2 (CDMA)";
    }
    
    if ([deviceModel isEqualToString:@"iPad3,1"]) {
        return @"iPad-3G (WiFi)";
    }
    
    if ([deviceModel isEqualToString:@"iPad3,2"]) {
        return @"iPad-3G (4G)";
    }
    
    if ([deviceModel isEqualToString:@"iPad3,3"]) {
        return @"iPad-3G (4G)";
    }
    
    // Simulator
    if ([deviceModel isEqualToString:@"i386"]) {
        return @"Simulator";
    }
    
    if ([deviceModel isEqualToString:@"x86_64"]) {
        return @"Simulator";
    }
    
    return deviceModel;
}

+ (NSString *)carrierCode
{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier              *carrier = [netInfo subscriberCellularProvider];
    
    if (!carrier) {
        return nil;
    }
    
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *carrierCode = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return carrierCode;
}

+ (NSString *)clientInfo:(NSString *)fromID version:(NSString *)version userAgent:(NSString*)userAgent
{
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGSize   screenSize = screen.bounds.size;
    float    screenResoltionHeight = screenSize.height;
    float    screenResoltionWidth = screenSize.width;
    
    if (screen && (screen.scale > 0.001)) {
        screenResoltionHeight *= screen.scale;
        screenResoltionWidth *= screen.scale;
    }
    
    ClientInfomation *clientInfo = [[ClientInfomation alloc] init];
    clientInfo.uniqid = [RRKeyChain sharedUUIDString];
    clientInfo.mac = [self MAC];
    clientInfo.model = [self deviceModelName];
    clientInfo.os = [NSString stringWithFormat:@"%@%@", device.systemName, device.systemVersion];
    clientInfo.screen = [NSString stringWithFormat:@"%.0fX%.0f", screenResoltionHeight, screenResoltionWidth];
    clientInfo.from = fromID;
    clientInfo.version = version;
    clientInfo.ua = userAgent;
    clientInfo.other = [NSString stringWithFormat:@"%@,", [self carrierCode]];
    return [clientInfo toJSONString];
}

@end
