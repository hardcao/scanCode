//
//  MCode.h
//  studyBase
//
//  Created by hardac on 15/12/12.
//  Copyright © 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MCode : NSManagedObject

@property (nullable, nonatomic, retain) NSString *codeContent;
@property (nullable, nonatomic, retain) NSNumber *scanCount;
@property (nullable, nonatomic, retain) NSNumber *codeType;


@end

