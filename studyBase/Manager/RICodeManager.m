//
//  RICodeManager.m
//  studyBase
//
//  Created by hardac on 15/12/12.
//  Copyright © 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RICodeManager.h"
#import "RIDataSource.h"


@implementation RICodeManager

+ (RICodeManager*) sharedInstance
{
    static RICodeManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RICodeManager alloc] init];
    });
    return _sharedInstance;
}

- (RICodeManager*) init
{
    if (self = [super init]) {
        [[RIDataSource sharedInstance] setupDataSourceWithUserID:@98345345];
    }
    return self;
}

- (NSArray *) getAllCodeByCodeType:(NSString*)codeType {
    NSString *predicateFormatString = [NSString stringWithFormat:@"(codeType == '%@')", codeType];
    NSPredicate *inPredicate = [NSPredicate predicateWithFormat:predicateFormatString];
    NSFetchRequest *localFetch = [NSFetchRequest fetchRequestWithEntityName:@"MCode"];
    localFetch.predicate = inPredicate;
    NSSortDescriptor *idDescriptor = [[NSSortDescriptor alloc] initWithKey:@"codeContent" ascending:NO];
    [localFetch setSortDescriptors:@[idDescriptor]];
    
    __block NSArray *savedCodes = nil;
    __block NSInteger totalCount;
    NSManagedObjectContext *context = [RIDataSource sharedInstance].mainQueueManagedObjectContext;
    [context performBlockAndWait:^{
        savedCodes = [context executeFetchRequest:localFetch error:nil];
        totalCount = [context countForEntityForName:@"MCode" predicate:nil error:nil];
    }];
    return savedCodes;
}

- (MCode *) getOneCodeByCodeType:(NSString *)codeType
                     codeContent:(NSString *)codeContent {
    MCode * tmpCode;
    NSString *predicateFormatString = [NSString stringWithFormat:@"(codeType == '%@') AND (codeContent == '%@')", codeType, codeContent];
    NSPredicate *inPredicate = [NSPredicate predicateWithFormat:predicateFormatString];
    NSFetchRequest *localFetch = [NSFetchRequest fetchRequestWithEntityName:@"MCode"];
    localFetch.predicate = inPredicate;
    NSSortDescriptor *idDescriptor = [[NSSortDescriptor alloc] initWithKey:@"codeContent" ascending:YES];
    [localFetch setSortDescriptors:@[idDescriptor]];
    
    __block NSArray *savedCodes = nil;
    __block NSInteger totalCount;
    NSManagedObjectContext *context = [RIDataSource sharedInstance].mainQueueManagedObjectContext;
    [context performBlockAndWait:^{
        savedCodes = [context executeFetchRequest:localFetch error:nil];
        totalCount = [context countForEntityForName:@"MCode" predicate:nil error:nil];
    }];
    if(savedCodes.count > 0) tmpCode = savedCodes[0];
    if([tmpCode.codeType isEqual:codeType]&&[tmpCode.codeContent isEqual:codeContent]) return tmpCode;
    return nil;
}

- (BOOL) checkOneCodeByCodeType:(NSString *)codeType
                    codeContent:(NSString *)codeContent {
    if([self getOneCodeByCodeType:codeType codeContent:codeContent] != nil) return true;
    return false;
}

- (BOOL) insertOneCodeByCodeType:(NSString *)codeType
                     codeContent:(NSString *)codeContent {
    MCode * tmpCode;
    NSString *predicateFormatString = [NSString stringWithFormat:@"(codeType == '%@') AND (codeContent == '%@')", codeType, codeContent];
    NSPredicate *inPredicate = [NSPredicate predicateWithFormat:predicateFormatString];
    NSFetchRequest *localFetch = [NSFetchRequest fetchRequestWithEntityName:@"MCode"];
    localFetch.predicate = inPredicate;
    NSSortDescriptor *idDescriptor = [[NSSortDescriptor alloc] initWithKey:@"codeContent" ascending:YES];
    [localFetch setSortDescriptors:@[idDescriptor]];
    
    __block NSArray *savedCodes = nil;
    __block NSInteger totalCount;
    NSManagedObjectContext *context = [RIDataSource sharedInstance].mainQueueManagedObjectContext;
    [context performBlockAndWait:^{
        savedCodes = [context executeFetchRequest:localFetch error:nil];
        totalCount = [context countForEntityForName:@"MCode" predicate:nil error:nil];
    }];
    if(savedCodes.count > 0) {
        tmpCode = savedCodes[0];
        tmpCode.scanCount = @(tmpCode.scanCount.integerValue + 1);
    } else {
        MCode *tmpcode = [context insertNewObjectForEntityForName:@"MCode"];
        tmpcode.codeType = codeType;
        tmpcode.codeContent = codeContent;
        tmpcode.scanCount = @0;
    }
    [context saveToPersistentStore:nil];
    return true;
}

@end