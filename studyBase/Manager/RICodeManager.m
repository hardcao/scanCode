//
//  RICodeManager.m
//  studyBase
//
//  Created by hardac on 15/12/12.
//  Copyright © 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RICodeManager.h"


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
    }
    return self;
}

- (NSMutableArray *) getAllCodeByCodeType:(NSString*)codeType {
    NSMutableArray *allCode = [[NSMutableArray alloc] init];
    return allCode;
}

- (MCode *) getOneCodeByCodeType:(NSString *)codeType
                     codeContent:(NSString *)codeContent {
    MCode *reseachCode = [[MCode alloc] init];
    return reseachCode;
}

- (bool) checkOneCodeByCodeType:(NSString *)codeType
                    codeContent:(NSString *)codeContent {
    return true;
}
@end