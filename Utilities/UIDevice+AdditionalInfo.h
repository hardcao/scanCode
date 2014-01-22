//
//  UIDevice+AdditionalInfo.h
//  studyBase
//
//  Created by renren on 14-1-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (AdditionalInfo)

+ (NSString*) MAC;
+ (NSString*) deviceModelName;
+ (NSString *)clientInfo:(NSString *)fromID version:(NSString *)version userAgent:(NSString*)userAgent;

@end
