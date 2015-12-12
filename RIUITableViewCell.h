//
//  RIUITableCell.h
//  studyBase
//
//  Created by hardac on 15/12/9.
//  Copyright © 2015年 renren. All rights reserved.
//

#ifndef RIUITableCell_h
#define RIUITableCell_h

#import <UIKit/UIKit.h>

@interface RIUITableViewCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *codeContent;
@property (weak, nonatomic) IBOutlet UILabel *scanNum;

- (void)setTableCellWithCodeContent:(NSString *)codeContent
                            scanNum:(NSNumber *)scanNum;

@end


#endif /* RIUITableCell_h */
