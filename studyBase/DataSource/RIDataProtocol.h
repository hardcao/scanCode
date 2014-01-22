//
//  RIDataProtocol.h
//  studyBase
//
//  Created by renren on 14-1-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKMapping;

@protocol RIDataMapping <NSObject>

+ (RKMapping*) dataMapping;

@end

@protocol RIDataProtocol <NSObject>

+ (RKMapping *)requestMapping;
+ (NSString *)requestPath;
+ (RKMapping *)responseMapping;
+ (NSString *)responseKeyPath;

@end

typedef enum {
    EDataSourceTypeNetwork = 0,
    EDataSourceTypeLocal = 1,
} DataSourceType;

@protocol RIDataSourceType <NSObject>
@property (nonatomic, assign) DataSourceType dataSourceType;
@end

