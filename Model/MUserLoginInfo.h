//
//  MUserLoginInfo.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RIDataProtocol.h"

@interface MUserLoginInfo : NSObject <RIDataMapping, NSCoding>

@property (nonatomic, copy) NSString * headURL;
@property (nonatomic, assign) BOOL isGuided;
@property (nonatomic, assign) BOOL isProfileCompletionNeeded;
@property (nonatomic, strong) NSNumber * loginCount;
@property (nonatomic, strong) NSNumber * loginTime;
@property (nonatomic, copy) NSString * secretKey;
@property (nonatomic, copy) NSString * sessionKey;
@property (nonatomic, copy) NSString * sessionId;// 聊天用的sessionId
@property (nonatomic, copy) NSString * ticket;
@property (nonatomic, strong) NSNumber * userID;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, assign) BOOL rememberPassword;

@end