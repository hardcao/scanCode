//
//  MError.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MError.h"

#import "JSONModel.h"
#import "RIUtility.h"

const static NSInteger kDefaultSafeErrorCode = 10;

#pragma mark - error信息helper类
@interface MErrorMessageHelper : JSONModel

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *msg_en;

@end

@implementation MErrorMessageHelper

@end

#pragma mark - error类
@implementation MError

+ (RKMapping*) dataMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"error_code":@"MCSErrorCode",
                                                  @"error_msg":@"MCSErrorMessage",
                                                  }];
    return mapping;
}

- (BOOL)validateMCSErrorMessage:(id *)ioValue error:(NSError **)outError
{
    NSString *errorMessage = *ioValue;
    NSRange range = [errorMessage rangeOfString:@"msg"];
    if (range.location != NSNotFound) {
        MErrorMessageHelper *message = [[MErrorMessageHelper alloc]initWithString:errorMessage error:nil];
        *ioValue = message.msg;
        self.MCSErrorMessageEN = message.msg_en;
    }
    return YES;
}

+ (NSString *)descriptionForError:(id)error
{
    if (!error) {
        return @"此内容为空";
    }
    NSString *errorCode = nil;
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    if ([error isKindOfClass:self.class]) {
        MError *mError = error;
        if ([mError.MCSErrorCode isEqual:@(kDefaultSafeErrorCode)]) {
            return mError.MCSErrorMessage;
        }
        errorCode = [numberFormatter stringFromNumber:mError.MCSErrorCode];
        NSString *errorMessage = [RIUtility errorStringForCode:errorCode];
        if (errorMessage) {
            return errorMessage;
        } if (mError.MCSErrorMessage) {
            return mError.MCSErrorMessage;
        }
    } else if (error) {
        NSError *nError = error;
        errorCode = [numberFormatter stringFromNumber:@(nError.code)];
        if ([nError.domain isEqualToString:@"kCLErrorDomain"]) {
            return @"定位失败";
        }
        return [RIUtility errorStringForCode:errorCode];
    }
    return nil;
}
@end

