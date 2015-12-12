//
//  RIUITableViewCell.m
//  studyBase
//
//  Created by hardac on 15/12/9.
//  Copyright © 2015年 renren. All rights reserved.
//

#import "RIUITableViewCell.h"

@implementation RIUITableViewCell

- (void)setTableCellWithCodeContent:(NSString *)codeContent
                            scanNum:(NSString *)scanNum{
    self.codeContent.text = codeContent;
    self.scanNum.text = scanNum;
}

- (instancetype)init
{
    if (self = [super init]) {}
    return self;
}

@end