//
//  MResult.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MResult : NSObject <RIDataMapping>

@property (nonatomic, strong) NSNumber *result;
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *albumID;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *summaryMessage;

@end
