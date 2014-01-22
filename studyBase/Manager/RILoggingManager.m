//
//  RILoggingManager.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RILoggingManager.h"

#import <DDLog.h>
#import <DDASLLogger.h>
#import <DDFileLogger.h>
#import <DDTTYLogger.h>

RILogLevel ddLogLevel = LogLevelOff;

@interface RILoggingManager()<DDLogFileManager>

@end

@implementation RILoggingManager

+ (RILoggingManager*) sharedInstance
{
    static RILoggingManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RILoggingManager alloc] init];
    });
    return _sharedInstance;
}

// This needs to be done in the applicationDidFinishLaunching method.
- (RILoggingManager*) init
{
    if (self = [super init]) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:self];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:fileLogger];
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
        RKLogConfigureByName("RestKit/CoreData", RKLogLevelOff);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    }
    return self;
}

- (void) setLogLevel:(RILogLevel)level
{
    if (ddLogLevel == level) {
        return;
    }
    
    ddLogLevel = level;
    switch (ddLogLevel) {
        case LogLevelError:
            RKLogSetAppLoggingLevel(RKLogLevelError);
            break;
        case LogLevelWarn:
            RKLogSetAppLoggingLevel(RKLogLevelWarning);
            break;
        case LogLevelInfo:
            RKLogSetAppLoggingLevel(RKLogLevelInfo);
            break;
        case LogLevelVerbose:
            RKLogSetAppLoggingLevel(RKLogLevelDebug);
            break;
        default:
            RKLogSetAppLoggingLevel(RKLogLevelOff);
            break;
    }
}

#pragma mark - DDLogFileManger Private methods
- (void)didArchiveLogFile:(NSString *)logFilePath
{
    // TODO: implementation needed.
}

- (void)didRollAndArchiveLogFile:(NSString *)logFilePath
{
    // TODO: implementation needed.
}

@end
