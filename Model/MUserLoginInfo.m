//
//  MUserLoginInfo.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MUserLoginInfo.h"

static NSString * const kSecretKey = @"secretKey";
static NSString * const kSessionKey = @"sessionKey";
static NSString * const kPasswordKey = @"passwordKey";
static NSString * const kHeadURLKey = @"headURLKey";
static NSString * const kUserNameKey = @"userNameKey";
static NSString * const kGuidedKey = @"isGuided";
static NSString * const kProfileCompletionNeededKey = @"isProfileCompletionNeeded";
static NSString * const kLoginCountKey = @"loginCount";
static NSString * const kLoginTimeKey = @"loginTime";
static NSString * const kSessionIdKey = @"sessionId";
static NSString * const kTicketKey = @"ticket";
static NSString * const kUserIDKey = @"userID";
static NSString * const kRememberPasswordKey = @"rememberPasswordKey";

@implementation MUserLoginInfo

+ (RKMapping*) dataMapping
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:self.class];
    
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"head_url":@"headURL",
                                                          @"session_key":@"sessionKey",
                                                          @"ticket":@"ticket",
                                                          @"uid":@"userID",
                                                          @"secret_key":@"secretKey",
                                                          @"user_name":@"userName",
                                                          @"now":@"loginTime",
                                                          @"login_count":@"loginCount",
                                                          @"fill_stage":@"isProfileCompletionNeeded",
                                                          @"is_guide":@"isGuided",
                                                          }];
    return responseMapping;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _headURL = [aDecoder decodeObjectForKey:kHeadURLKey];
        _isGuided = [[aDecoder decodeObjectForKey:kGuidedKey] boolValue];
        _isProfileCompletionNeeded = [[aDecoder decodeObjectForKey:kProfileCompletionNeededKey] boolValue];
        _loginCount = [aDecoder decodeObjectForKey:kLoginCountKey];
        _loginTime = [aDecoder decodeObjectForKey:kLoginTimeKey];
        _secretKey = [aDecoder decodeObjectForKey:kSecretKey];
        _sessionKey = [aDecoder decodeObjectForKey:kSessionKey];
        _sessionId = [aDecoder decodeObjectForKey:kSessionIdKey];
        _ticket = [aDecoder decodeObjectForKey:kTicketKey];
        _userID = [aDecoder decodeObjectForKey:kUserIDKey];
        _userName = [aDecoder decodeObjectForKey:kUserNameKey];
        _rememberPassword = [[aDecoder decodeObjectForKey:kRememberPasswordKey] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_headURL forKey:kHeadURLKey];
    [aCoder encodeObject:@(_isGuided) forKey:kGuidedKey];
    [aCoder encodeObject:@(_isProfileCompletionNeeded) forKey:kProfileCompletionNeededKey];
    [aCoder encodeObject:_loginCount forKey:kLoginCountKey];
    [aCoder encodeObject:_loginTime forKey:kLoginTimeKey];
    [aCoder encodeObject:_secretKey forKey:kSecretKey];
    [aCoder encodeObject:_sessionKey forKey:kSessionKey];
    [aCoder encodeObject:_sessionId forKey:kSessionIdKey];
    [aCoder encodeObject:_ticket forKey:kTicketKey];
    [aCoder encodeObject:_userID forKey:kUserIDKey];
    [aCoder encodeObject:_userName forKey:kUserNameKey];
    [aCoder encodeObject:@(_rememberPassword) forKey:kRememberPasswordKey];
}

@end
