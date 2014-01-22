//
//  RIGlobalMacros.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#ifndef RenrenOfficial_iOS_Base_RIGlobalMacros_h
#define RenrenOfficial_iOS_Base_RIGlobalMacros_h

#import "DDLog.h"

#define RILogError(aspect, frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   ddLogLevel, LOG_FLAG_ERROR,   aspect, frmt, ##__VA_ARGS__)
#define RILogWarn(aspect, frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_WARN,    ddLogLevel, LOG_FLAG_WARN,    aspect, frmt, ##__VA_ARGS__)
#define RILogInfo(aspect, frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_INFO,    ddLogLevel, LOG_FLAG_INFO,    aspect, frmt, ##__VA_ARGS__)
#define RILogVerbose(aspect, frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, ddLogLevel, LOG_FLAG_VERBOSE, aspect, frmt, ##__VA_ARGS__)

#define NSLog1(frmt, ...) RILogInfo(LogAspectGeneral, frmt, ##__VA_ARGS__)
#define RIPostParam(paramDict, paramName, param) \
NSAssert(paramName, @"key for dict should not be nil"); \
if (param) { \
paramDict[paramName] = param; \
}

#define RICallBlockSafely(block, ...) \
if (block) \
block(__VA_ARGS__)

#if ! TARGET_IPHONE_SIMULATOR
#define BUILD_WITH_CAMERA360SDK
#endif

//获取评论列表的宏定义,在manager中使用
#define getCommentList(request, currentList, successBlock, failedBlock) {\
NSInteger page = currentList.currentPage.integerValue + 1; \
request.page = @(page); \
request.succeededBlock = ^(NSArray *results) { \
MCommentList *commentList = results[0]; \
if (commentList.comments.count == 0) { \
currentList.hasMore = NO; \
RICallBlockSafely(successBlock, currentList); \
return; \
} \
commentList.comments = [commentList.comments reversedArray]; \
if (page > 1) { \
NSArray *comments = [RIUtility mergeArray:currentList.comments \
intoArray:commentList.comments \
uniqueKeyPath:@"commentID"]; \
currentList.comments = comments; \
commentList = currentList; \
} \
commentList.hasMore = (commentList.totalCount.integerValue > commentList.comments.count); \
commentList.currentPage = @(page); \
RICallBlockSafely(successBlock, commentList); \
}; \
request.failedBlock = ^(NSString *errorMessage) { \
RICallBlockSafely(failedBlock,errorMessage); \
}; \
[request postRequest]; \
}

//数据请求的成功,失败的回调
typedef void (^DataRequestSucceededBlock) (NSArray* objects);
typedef void (^DataRequestFailedBlock) (NSString *errorMessage);

#endif