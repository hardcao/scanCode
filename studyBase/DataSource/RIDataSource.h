//
//  RIDataSource.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIDataSource : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext* mainQueueManagedObjectContext;

+ (RIDataSource*) sharedInstance;

- (void)setupDataSourceWithUserID:(NSNumber*)userID;
- (void)registerRequestAndResponse:(Class)dataRequestClass;
- (void)removeAllResponseDescriptors;
- (void)clearCacheData:(NSNumber *)userID;
- (NSNumber *)getCacheDataSizeWithUserID:(NSNumber *)userID;
- (NSManagedObjectContext *)childManagedObjectContextWithParentMOC:(NSManagedObjectContext *)parentMOC
                                                   ConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

@end
