//
//  RILoginRequest.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RIDataRequest.h"
#import "RIRegisteredRequest.h"

@class MUserLoginInfo;

@interface RILoginRequest : RIDataRequest<RIDataProtocol>

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, assign) BOOL isVerificationCodeNeeded;

- (RILoginRequest*) initWithCredentials:(NSString*)userName password:(NSString*)password;

@end

@interface RILogoutRequest : RIRegisteredRequest<RIDataProtocol>

@property (nonatomic, copy) NSString* sessionID;
@property (nonatomic, assign) PushTypeEnum pushType;

- (RILogoutRequest*) initWithSessionID:(NSString *)sessionID;

@end

@interface RILoginInfoRequest : RIRegisteredRequest<RIDataProtocol>

@end

@interface RILoginAutoLoginRequest : RIDataRequest<RIDataProtocol>

@property (nonatomic,strong) NSString *sessionKey;
@property (nonatomic,strong) NSString *secretKey;

- (RILoginAutoLoginRequest*) initWithSessionKey:(NSString *)sessionKey
                                      secretKey:(NSString*)secretKey;

@end