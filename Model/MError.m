//
//  MError.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MError.h"

#import "JSONModel.h"
#import "RIUtility.h"

const static NSInteger kDefaultSafeErrorCode = 10;

#pragma mark - error信息helper类
@interface MErrorMessageHelper : JSONModel

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *msg_en;

@end

@implementation MErrorMessageHelper

@end


