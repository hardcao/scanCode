//
//  RILoggingManager.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDFileLogger.h"

@interface RILoggingManager : DDLogFileManagerDefault

+ (RILoggingManager*) sharedInstance;

- (void) setLogLevel:(RILogLevel)level;

@end

