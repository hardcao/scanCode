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
#import "RILoginEmailListInfo.h"
#import "RILoginRequest.h"
#import "RIManagerStrategy.h"
#import "RIRecentLoginUserInfo.h"
#import "RISettings.h"
#import "NSData+CommonCrypto.h"
#import "MUser.h"
#import "RIFriendManager.h"
#import "RIUserManager.h"
//chat legacy
#import "RSNetControlCenter.h"
#import "AppContext.h"


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

- (void)loadUserDetailInfo:(NSNumber *)userID
{
    [[RIUserManager sharedManager] userProfileByUserID:userID
                                            completion:^(id object) {
                                                if ([object isKindOfClass:[MUser class]]) {
                                                    self.detailUserInfo = object;
                                                }
                                            }
                                                failed:^(NSString *errorMessage) {
                                                    self.detailUserInfo = nil;
                                                }];
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
        [[RIManagerStrategy sharedInstance] setupWithUserID:self.loginInfo.userID];
        [AppContext resetContext];
        [[RSNetControlCenter sharedInstance] forceRestartSession];
        [self persistAutoLoginUserInfo];
        [self updateRecentUserLoginInfoWithAccountName:username
                                       accountPassword:password
                                             loginInfo:self.loginInfo];
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
    [[RIFriendManager sharedManager] clearMyFriendList];
    NSString *sessionID = @" ";
    RILogoutRequest *request = [[RILogoutRequest alloc] initWithSessionID:sessionID];
    request.succeededBlock = ^(NSArray* objects) {
        if (objects.count != 1) {
            return;
        }
        self.loginInfo = nil;
        [[RIDataSource sharedInstance] setupDataSourceWithUserID:nil];
        [[RIManagerStrategy sharedInstance] setupWithUserID:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kRIAutoLoginUserKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[RSNetControlCenter sharedInstance] forceCloseSession];
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

- (void)updateRecentUserLoginInfoWithAccountName:(NSString *)accountName
                                 accountPassword:(NSString *)password
                                       loginInfo:(MUserLoginInfo *)loginInfo;
{
    NSAssert(accountName, @"accountName should not be nil");
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self recentLoginUsers]];
    RIRecentLoginUserInfo *userInfo = [[RIRecentLoginUserInfo alloc]init];
    userInfo.userID = loginInfo.userID;
    userInfo.accountName = accountName;
    userInfo.accountPassword = self.rememberPassword ? password : nil;
    userInfo.headURL = loginInfo.headURL;
    userInfo.userName = loginInfo.userName;
    NSInteger index = [array indexOfObject:userInfo];
    if (index == NSNotFound) {
        if (array.count >= kRIRecentLoginUserCount) {
            [array removeLastObject];
        }
        [array insertObject:userInfo atIndex:0];
    } else {
        [array removeObject:userInfo];
        [array insertObject:userInfo atIndex:0];
    }
    [self persistRecentLoginUsers:array];
}

- (void)persistRecentLoginUsers:(NSArray *)users
{
#ifdef DEBUG
    for (RIRecentLoginUserInfo *user in users) {
        NSAssert([user isKindOfClass:[RIRecentLoginUserInfo class]], @"user must be kind of class 'RIRecentLoginUserInfo'");
        NSAssert(user.userID && user.accountName, @"userID and userAccountName should not be nil");
    }
#endif
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:users];
    NSError *error;
    data = [data AES256EncryptedDataUsingKey:kRenRenAESCryptorKey error:&error];
    if (error) {
        RILogError(LogAspectLogin, @"recent login info save with error, no change occured");
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:kRIRecentLoginUsersKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.recentLoginUsers = users;
}

- (void)deleteRecentLoginUser:(RIRecentLoginUserInfo *)userInfo
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self recentLoginUsers]];
    NSInteger index = [array indexOfObject:userInfo];
    if (index == NSNotFound) {
        return;
    }
    [array removeObject:userInfo];
    [self persistRecentLoginUsers:array];
}

- (void)updateRecentUserLoginInfoWithUserID:(NSNumber *)userID info:(NSDictionary *)infoDictionary
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self recentLoginUsers]];
    for (RIRecentLoginUserInfo *userInfo in array) {
        if (![userInfo.userID isEqualToNumber:userID]) {
            continue;
        }
        if ([infoDictionary objectForKey:kPasswordKey]) {
            userInfo.accountPassword = [infoDictionary objectForKey:kPasswordKey];
        }
        if ([infoDictionary objectForKey:kHeadURLKey]) {
            userInfo.headURL = [infoDictionary objectForKey:kHeadURLKey];
            self.loginInfo.headURL = userInfo.headURL;
        }
        if ([infoDictionary objectForKey:kUserNameKey]) {
            userInfo.userName = infoDictionary[kUserNameKey];
            self.loginInfo.userName = userInfo.userName;
        }
        break;
    }
    [self persistRecentLoginUsers:array];
    [self persistAutoLoginUserInfo];
}

- (void)updatePromptEmailListWithUserName:(NSString *)userName loginEmailInfo:(RILoginEmailListInfo *)loginEmailListInfo
{
    if (!userName) {
        return;
    }
    NSString *emailPrefix, *emailSuffix, *emailAddress;
    
    if (!loginEmailListInfo) {
        loginEmailListInfo = [[RILoginEmailListInfo alloc] init];
    }
    NSRange range = [userName rangeOfString:@"@"];
    emailPrefix = range.location == NSNotFound ? userName : [userName substringWithRange:NSMakeRange(0, range.location)];
    
    [loginEmailListInfo.emailAddresses removeAllObjects];
    for (emailSuffix in loginEmailListInfo.emailSuffixes) {
        emailAddress = [emailPrefix stringByAppendingString:emailSuffix];
        if (emailAddress.length >= userName.length) {
            if ([userName compare:[emailAddress substringWithRange:NSMakeRange(0, userName.length)]] == NSOrderedSame) {
                [loginEmailListInfo.emailAddresses addObject:emailAddress];
            }
        }
    }
}

- (void)autologin
{
    [[RIDataSource sharedInstance] setupDataSourceWithUserID:self.loginInfo.userID];
    [[RIManagerStrategy sharedInstance] setupWithUserID:self.loginInfo.userID];
    [AppContext resetContext];
    [[RSNetControlCenter sharedInstance] forceRestartSession];
}

@end

