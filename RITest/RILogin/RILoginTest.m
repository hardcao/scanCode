//
//  RILoginTest.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RILoginRequest.h"

@interface RILoginTest : GHAsyncTestCase

@end


@implementation RILoginTest

- (void)testLogin
{
    [self prepare];
    RILoginRequest *request = [[RILoginRequest alloc] initWithCredentials:testUsername password:[testPassword MD5Digest]];
    request.succeededBlock = ^(NSArray *result) {
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testLogin)];
    };
    request.failedBlock = ^(NSString *errorMessage) {
        [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testLogin)];
    };
    [request postRequest];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2.0];
}

@end
