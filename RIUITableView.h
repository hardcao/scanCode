//
//  RIUITableView.h
//  studyBase
//
//  Created by hardac on 15/12/9.
//  Copyright © 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIUITableView : UITableViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSArray *dataList;

@end