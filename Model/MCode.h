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

@property (nonatomic, retain) NSString *codeContent;
@property (nonatomic, retain) NSString *codeType;
@property (nonatomic, retain) NSNumber *scanCount;

@end
