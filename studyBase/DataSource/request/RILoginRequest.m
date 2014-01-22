//
//  RILoginRequest.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RILoginRequest.h"
#import "MUserLoginInfo.h"
#import "MResult.h"

#pragma mark - RILoginRequest
@implementation RILoginRequest

- (RILoginRequest*) initWithCredentials:(NSString*)userName password:(NSString*)password
{
    if (self = [super init]) {
        self.userName = userName;
        self.password = password;
        self.isVerificationCodeNeeded = YES;
    }
    return self;
}

+ (RKMapping*) requestMapping
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"userName":@"user",
                                                         @"password":@"password",
                                                         @"isVerificationCodeNeeded":@"isverify",
                                                         }];
    return requestMapping;
}

+ (NSString*) requestPath
{
    return @"client/login";
}

+ (RKMapping *)responseMapping
{
    return [MUserLoginInfo dataMapping];
}

+ (NSString *)responseKeyPath
{
    return nil;
}

@end

@implementation RILogoutRequest

- (RILogoutRequest*) initWithSessionID:(NSString *)sessionID
{
    if (self = [super init]) {
        self.pushType = IPAD_RENREN;
        self.sessionID = sessionID;
    }
    return self;
}

+ (RKMapping*) requestMapping
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"sessionID":@"session_id",
                                                         @"pushType":@"push_type",
                                                         }];
    return requestMapping;
}

+ (NSString*) requestPath
{
    return @"client/logout";
}

+ (RKMapping *)responseMapping
{
    return [MResult dataMapping];
}

+ (NSString *)responseKeyPath
{
    return nil;
}

@end

#pragma mark - RILoginInfoRequest
@implementation RILoginInfoRequest

+ (RKMapping*) requestMapping
{
    return [RKObjectMapping requestMapping];
}

+ (NSString*) requestPath
{
    return @"client/getLoginInfo";
}

+ (RKMapping *)responseMapping
{
    return [MUserLoginInfo dataMapping];
}

+ (NSString *)responseKeyPath
{
    return nil;
}

@end

#pragma mark - RILoginAutoLoginRequest
@implementation RILoginAutoLoginRequest

- (RILoginAutoLoginRequest*) initWithSessionKey:(NSString *)sessionKey
                                      secretKey:(NSString*)secretKey
{
    if (self = [super init]) {
        self.sessionKey = sessionKey;
        self.secretKey = secretKey;
    }
    return self;
}

+ (RKMapping*) requestMapping
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"sessionKey":@"session_key",
                                                         }];
    return requestMapping;
}

+ (NSString*) requestPath
{
    return @"client/getLoginInfo";
}

+ (RKMapping *)responseMapping
{
    return [MUserLoginInfo dataMapping];
}

+ (NSString *)responseKeyPath
{
    return nil;
}

@end