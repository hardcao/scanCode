//
//  RILoginManager.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RILoginManager.h"

#import "JSONModel.h"
#import "MUserLoginInfo.h"
#import "RIDataSource.h"
#import "RILoginRequest.h"
#import "RISettings.h"
#import "NSData+CommonCrypto.h"


NSString * const kSecretKey = @"secretKey";
NSString * const kSessionKey = @"sessionKey";
NSString * const kPasswordKey = @"passwordKey";
NSString * const kHeadURLKey = @"headURLKey";
NSString * const kUserNameKey = @"userNameKey";

static NSString * const kRIAutoLoginUserKey = @"AutoLoginUserInfo"; //对应一个字典,包含secretKey, sessionKey以及rememberPassword

static NSString * const kRIRecentLoginUsersKey = @"RecentLoginUsers"; //对应一个数组,类为RIRecentLoginUserInfo
static const NSInteger kRIRecentLoginUserCount = 3;

static NSString * const kRenRenAESCryptorKey = @"com.renren-inc.cd53fb5cf33c342cce7facaf3841af41";

#pragma mark - loginManager
@interface RILoginManager ()

@property (nonatomic, strong) MUserLoginInfo* loginInfo;
@property (nonatomic, strong) NSArray *recentLoginUsers;
@property (nonatomic, assign) BOOL rememberPassword;

@end

@implementation RILoginManager

+ (RILoginManager*) sharedInstance
{
    static RILoginManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RILoginManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        //load AutoLoginUserInfo
        NSError *error;
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kRIAutoLoginUserKey];
        data = [data decryptedAES256DataUsingKey:kRenRenAESCryptorKey error:&error];
        if (error) {
            RILogError(LogAspectLogin, @"Auto login info read with error, drop information");
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kRIAutoLoginUserKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        } else if (data) {
            self.loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            self.rememberPassword =  self.loginInfo.rememberPassword;
        }
        
        //loadRecentLoginUsers
        data = [[NSUserDefaults standardUserDefaults] objectForKey:kRIRecentLoginUsersKey];
        data = [data decryptedAES256DataUsingKey:kRenRenAESCryptorKey error:&error];
        if (error) {
            RILogError(LogAspectLogin, @"rencent login info read with error, drop information");
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:kRIRecentLoginUsersKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        } else if(data) {
            self.recentLoginUsers = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

- (BOOL)isQualifiedToAutoLogin
{
    if (self.loginInfo.rememberPassword && self.loginInfo.secretKey
        && self.loginInfo.sessionKey && self.loginInfo.userID) {
        return YES;
    }
    return NO;
}

- (void) loginWithUserName:(NSString*)username
                  password:(NSString*)password
            succeededBlock:(LoginSucceededBlock)succeeded
               failedBlock:(LoginFailedBlock)failed
{
    [self loginWithUserName:username
                   password:password
            rememberPassord:self.rememberPassword
             succeededBlock:succeeded
                failedBlock:failed];
}

- (void) loginWithUserName:(NSString*)username
                  password:(NSString*)password
           rememberPassord:(BOOL)rememberPassword
            succeededBlock:(LoginSucceededBlock)succeeded
               failedBlock:(LoginFailedBlock)failed;
{
    RILoginRequest *request = [[RILoginRequest alloc] initWithCredentials:username password:password];
    request.succeededBlock = ^(NSArray* objects) {
        if (objects.count != 1) {
            return;
        }
        self.loginInfo = objects[0];
        self.loginInfo.rememberPassword = rememberPassword;
        self.rememberPassword = rememberPassword;
        [[RIDataSource sharedInstance] setupDataSourceWithUserID:self.loginInfo.userID];
        [self persistAutoLoginUserInfo];
        RICallBlockSafely(succeeded);
    };
    request.failedBlock = ^(NSString* errorMessage) {
        RILogError(LogAspectLogin, @"Login request failed with error:%@", errorMessage);
        if (failed) {
            failed(errorMessage);
        }
    };
    [request postRequest];
}

- (void) logout
{
    if (![self hasLoggedIn]) {
        return;
    }
    NSString *sessionID = @" ";
    RILogoutRequest *request = [[RILogoutRequest alloc] initWithSessionID:sessionID];
    request.succeededBlock = ^(NSArray* objects) {
        if (objects.count != 1) {
            return;
        }
        self.loginInfo = nil;
        [[RIDataSource sharedInstance] setupDataSourceWithUserID:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kRIAutoLoginUserKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    };
    request.failedBlock = ^(NSString* errorMessage) {
        RILogError(LogAspectLogin, @"Logout request failed with error:%@", errorMessage);
    };
    [request postRequest];
}

- (BOOL) hasLoggedIn
{
    return self.loginInfo != nil;
}

- (void)persistAutoLoginUserInfo
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.loginInfo];
    NSError *error;
    data = [data AES256EncryptedDataUsingKey:kRenRenAESCryptorKey error:&error];
    if (error) {
        RILogError(LogAspectLogin, @"Auto login info save with error, no change occured");
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:kRIAutoLoginUserKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end

