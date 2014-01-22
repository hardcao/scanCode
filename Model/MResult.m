//
//  MResult.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MResult.h"

@implementation MResult

+ (RKMapping *)dataMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
    [mapping addAttributeMappingsFromArray:@[@"result", @"code", @"id"]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"album_id":@"albumID",
                                                  @"url":@"URL",
                                                  @"summary":@"summaryMessage",
                                                  }];
    return mapping;
}

@end