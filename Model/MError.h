//
//  MError.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIDataProtocol.h"

extern const NSString* MErrorDomain;

@interface MError : NSObject <RIDataMapping>

@property (nonatomic, strong) NSNumber *MCSErrorCode;
@property (nonatomic, strong) NSString *MCSErrorMessage;
@property (nonatomic, strong) NSString *MCSErrorMessageEN;

+ (NSString *)descriptionForError:(id)error;

@end
