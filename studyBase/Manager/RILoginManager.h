//
//  RILoginManager.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MUserLoginInfo.h"

extern NSString * const kSecretKey;
extern NSString * const kSessionKey;
extern NSString * const kPasswordKey;
extern NSString * const kHeadURLKey;

typedef void (^LoginSucceededBlock)();
typedef void (^LoginFailedBlock)(NSString* errorMessage);

@class RILoginEmailListInfo;
@class RIRecentLoginUserInfo;
@class MUser;

@interface RILoginManager : NSObject

@property (nonatomic, strong, readonly) MUserLoginInfo* loginInfo;
@property (nonatomic, strong, readonly) NSArray *recentLoginUsers;
@property (nonatomic, strong) MUser *detailUserInfo;

+ (RILoginManager*) sharedInstance;

- (void) loginWithUserName:(NSString*)username
                  password:(NSString*)password
            succeededBlock:(LoginSucceededBlock)succeeded
               failedBlock:(LoginFailedBlock)failed;

- (void) loginWithUserName:(NSString*)username
                  password:(NSString*)password
           rememberPassord:(BOOL)rememberPassword
            succeededBlock:(LoginSucceededBlock)succeeded
               failedBlock:(LoginFailedBlock)failed;

- (void) logout;
- (BOOL) hasLoggedIn;

@end
