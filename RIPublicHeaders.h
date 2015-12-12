//
//  RIPublicHeaders.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#ifndef RenrenOfficial_iOS_Base_RIPublicHeaders_h
#define RenrenOfficial_iOS_Base_RIPublicHeaders_h

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

static const float kLineMinY = 185;
static const float kLineMaxY = 385;
static const float kReaderViewWidth = 200;
static const float kReaderViewHeight = 200;

#ifdef __OBJC__
#import "Base64nl/Base64.h"
#import "MD5Digest/NSString+MD5.h"
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#else
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreServices/CoreServices.h>
#endif

// Make RestKit globally available
#import "RestKit/RestKit.h"

#import "RIGlobalMacros.h"
#import "RIGlobalEnums.h"
#import "RIDataProtocol.h"
//#import "RIUserInfoProtocol.h"
//#import "RILikeInfoProtocol.h"
#import "RIUtility.h"

#endif
