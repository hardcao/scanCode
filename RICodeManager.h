//
//  RICodeManager.h
//  studyBase
//
//  Created by hardac on 15/12/12.
//  Copyright © 2015年 renren. All rights reserved.
//


#ifndef RICodeManager_h
#define RICodeManager_h

#import "MCode.h"


@interface RICodeManager : NSObject

+ (RICodeManager*) sharedInstance;


- (NSMutableArray *) getAllCodeByCodeType:(NSString*)codeType;

- (MCode *) getOneCodeByCodeType:(NSString *)codeType
                     codeContent:(NSString *)codeContent;

- (bool) checkOneCodeByCodeType:(NSString *)codeType
                    codeContent:(NSString *)codeContent;

@end

#endif /* RICodeManager_h */
