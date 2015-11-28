//
//  RIDataSource.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#define RKCoreDataIncluded
#import "RIDataSource.h"

#import "RIDataRequest.h"
#import "RIDataSourceRegister.h"
#import "RILoginRequest.h"
#import "RISettings.h"
#import "RIUtility.h"
#import "SDImageCache.h"
#import "MError.h"

const char *kDefaultDataBase = "RISQlite.db";
static NSString * const kMfriendKey = @"MFriend";
static NSString * const kMHumanBaseKey = @"MHumanBase";

@interface RIDataSource ()

@property (nonatomic, strong) NSMutableArray *responseDescriptors;

@end


@implementation RIDataSource

+ (RIDataSource*) sharedInstance
{
    static dispatch_once_t once;
    static RIDataSource *_sharedInstance;
    dispatch_once(&once, ^{
        _sharedInstance = [[RIDataSource alloc] init];
    });
    return _sharedInstance;
}

- (RIDataSource*) init
{
    if (self = [super init]) {
        self.responseDescriptors = [NSMutableArray array];
        
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
        
        NSError *error = nil;
        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"RIDataModel" ofType:@"momd"]];
        // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        
        // Initialize the Core Data stack
        [managedObjectStore createPersistentStoreCoordinator];
        
        [managedObjectStore addInMemoryPersistentStore:&error];
        // Set the default store shared instance
        [RKManagedObjectStore setDefaultStore:managedObjectStore];
        
        // Configure the object manager
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[RISettings globalSettings].apiURL];
        objectManager.managedObjectStore = managedObjectStore;
        
        [RKObjectManager setSharedManager:objectManager];
        
        [RIDataSourceRegister registerRequestAndResponseToDataSource:self];
    }
    return self;
}

- (void)setupDataSourceWithUserID:(NSNumber *)userID
{
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"RIDataModel" ofType:@"momd"]];
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    if (userID) {
        NSString *userPath = [RIUtility userDirectoryForUserID:userID];
        NSString *DBFilePath = [userPath stringByAppendingPathComponent:@"RISQlite.db"];
        NSPersistentStore __unused *persistentStore =
        [managedObjectStore addSQLitePersistentStoreAtPath:DBFilePath
                                    fromSeedDatabaseAtPath:nil
                                         withConfiguration:nil
                                                   options:nil
                                                     error:&error];
        if (error) {
            error = nil;
            [[NSFileManager defaultManager]removeItemAtPath:DBFilePath error:nil];
            persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:DBFilePath
                                                          fromSeedDatabaseAtPath:nil
                                                               withConfiguration:nil
                                                                         options:nil
                                                                           error:&error];
        }
        NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    } else {
        [managedObjectStore addInMemoryPersistentStore:&error];
    }
    
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Configure the object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[RISettings globalSettings].apiURL];
    objectManager.managedObjectStore = managedObjectStore;
    [RKObjectManager setSharedManager:objectManager];
    [RIDataSourceRegister registerRequestAndResponseToDataSource:self];
}

- (NSManagedObjectContext *)mainQueueManagedObjectContext
{
    return [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
}

- (NSManagedObjectContext *)childManagedObjectContextWithParentMOC:(NSManagedObjectContext *)parentMOC
                                                   ConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    [managedObjectContext performBlockAndWait:^{
        managedObjectContext.parentContext = parentMOC;
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }];
    
    return managedObjectContext;
}

- (void)registerRequestAndResponse:(Class)dataRequestClass
{
    if ([dataRequestClass conformsToProtocol:@protocol(RIDataProtocol)]) {
        RKObjectManager *manager = [RKObjectManager sharedManager];
        [manager addRequestDescriptor:[dataRequestClass requestDescriptor]];
        RKResponseDescriptor *responseDescriptor = [dataRequestClass responseDescriptor];
        [manager addResponseDescriptor:responseDescriptor];
        [self.responseDescriptors addObject:responseDescriptor];
    }
}

- (void)removeAllResponseDescriptors
{
    for (RKResponseDescriptor *responseDescriptor in self.responseDescriptors) {
        [[RKObjectManager sharedManager]removeResponseDescriptor:responseDescriptor];
    }
}

- (void)clearCacheData:(NSNumber *)userID
{
    //通用
    [[SDImageCache sharedImageCache]clearDisk];
    //聊天图片
    [[RIUtility chatImageCache]clearDisk];
    //语音
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * appCacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *audioCacheDir = [appCacheDir stringByAppendingPathComponent:@"UgcAudioCache"];
    if([fileManager fileExistsAtPath:audioCacheDir isDirectory:NULL]) {
        [fileManager removeItemAtPath:audioCacheDir error:nil];
        [fileManager createDirectoryAtPath:audioCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSNumber *)getCacheDataSizeWithUserID:(NSNumber *)userID
{
    double contentSize = 0;
    //通用
    contentSize += [[SDImageCache sharedImageCache]getSize] / 1024.0 / 1024.0;
    contentSize += [[RIUtility chatImageCache]getSize] / 1024.0 / 1024.0;
    //语音
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * appCacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *audioCacheDir = [appCacheDir stringByAppendingPathComponent:@"UgcAudioCache"];
    if([fileManager fileExistsAtPath:audioCacheDir isDirectory:NULL]) {
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:audioCacheDir error:nil];
        contentSize += fileAttributes.fileSize / 1024.0 / 1024.0;
    }
    return @(contentSize);
}

@end
