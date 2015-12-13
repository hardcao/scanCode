//
//  NSObject+RIUITableList.h
//  studyBase
//
//  Created by hardac on 15/12/13.
//  Copyright © 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RIUITableList : UIViewController<UITableViewDelegate, UITableViewDataSource> 
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSNumber *codeType;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSMutableArray *chooseArray ;

@end
