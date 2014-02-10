//
//  RIDataSourceRegister.m
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

//
//  RIDataSourceRegister.m
//  RenrenOfficial-iOS-Base
//
//  Created by Jonathan Dong on 13-4-18.
//  Copyright (c) 2013年 Renren-inc. All rights reserved.
//

#import "RIDataSourceRegister.h"
#import "RIDataSource.h"
#import "RILoginRequest.h"
#import "MError.h"
@implementation RIDataSourceRegister

+ (void) registerRequestAndResponseToDataSource:(RIDataSource*)dataSource
{
    // Request registrations
    [dataSource registerRequestAndResponse:RILoginRequest.class];
    // error registration
    // 这里使用了RestKit的一个known tricks：对于nil和@""的keyPath，RestKit将之当作两个不同的路径，并会用后注册
    // 该keyPath的mapping对象覆盖之前注册的对象。
    // 因此工程将人为规定：只有MError的keyPath可以注册到@""上，其它response mapping对象的keyPath只能注册到nil。
    RKResponseDescriptor *errorDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[MError dataMapping]
                                                 method:RKRequestMethodPOST
                                            pathPattern:nil
                                                keyPath:@""
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager]addResponseDescriptor:errorDescriptor];
}

@end
