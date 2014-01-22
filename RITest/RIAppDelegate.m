//
//  RIAppDelegate.m
//  RITest
//
//  Created by renren on 14-1-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "RIAppDelegate.h"

#import "RIDataSource.h"
#import "RILoggingManager.h"
#import "RILoginManager.h"
#import "RIUtility.h"

NSString * const testUsername = @"18614077005";
NSString * const testPassword = @"cao19891210";

@implementation RIAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [super applicationDidFinishLaunching:application];
    
#ifdef DEBUG
    [[RILoggingManager sharedInstance] setLogLevel:LogLevelVerbose];
#else
    [[RILoggingManager sharedInstance] setLogLevel:LogLevelWarn];
#endif
//    [RIUtility copyEmotionPlistToLocalDiskWhenAppFirstRun];
    [RIDataSource sharedInstance];
    [[RILoginManager sharedInstance] loginWithUserName:testUsername
                                              password:[testPassword MD5Digest]
                                        succeededBlock:nil
                                           failedBlock:nil];
    
}

@end
