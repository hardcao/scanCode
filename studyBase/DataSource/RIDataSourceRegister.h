//
//  RIDataSourceRegister.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RIDataSource;

@interface RIDataSourceRegister : NSObject

+ (void) registerRequestAndResponseToDataSource:(RIDataSource*)dataSource;

@end
