//
//  RIRegisteredRequest.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RIRegisteredRequest.h"

#import "RILoginManager.h"
#import "MUserLoginInfo.h"

@implementation RIRegisteredRequest

- (NSDictionary*) defaultParameters
{
    if (![[RILoginManager sharedInstance] hasLoggedIn]) {
        RILogError(LogAspectDataRequest, @"User hasn't login, can not setup default parameters for RIRegisteredRequest.");
        return nil;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[super defaultParameters]];
    if ([RILoginManager sharedInstance].loginInfo.sessionKey) {
        [parameters setObject:[RILoginManager sharedInstance].loginInfo.sessionKey forKey:@"session_key"];
    }
    return parameters;
}

- (NSString *)secretKey
{
    return [RILoginManager sharedInstance].loginInfo.secretKey;
}

@end

