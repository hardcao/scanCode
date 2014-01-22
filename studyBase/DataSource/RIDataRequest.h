//
//  RIDataRequest.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIDataProtocol.h"
#import "MError.h"

@interface RIDataRequest : NSObject

@property (nonatomic, copy) DataRequestSucceededBlock succeededBlock;
@property (nonatomic, copy) DataRequestFailedBlock failedBlock;
@property (nonatomic, copy) id (^willMapDeserializedResponseBlock)(id deserializedResponseBody);
@property (nonatomic, strong, readonly) NSMutableDictionary *additionalParameters;

+ (RKRequestDescriptor*) requestDescriptor;
+ (RKResponseDescriptor *) responseDescriptor;
- (void) postRequest;
- (NSDictionary*) defaultParameters;
- (NSDictionary *)additionalAndDefaultParameters;
- (void)appendAdditionalParameters:(NSDictionary *)parameters;
- (RKObjectRequestOperation *)requestOperation;

@end
