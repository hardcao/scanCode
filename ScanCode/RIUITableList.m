//
//  NSObject+RIUITableList.m
//  studyBase
//
//  Created by hardac on 15/12/13.
//  Copyright © 2015年 renren. All rights reserved.
//

#import "RIUITableList.h"
#import "DropDownListView.h"
#import "RICodeManager.h"
#import "RIUITableViewCell.h"
#import "MCode.h"

@implementation RIUITableList

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataList = [[RICodeManager sharedInstance] getAllCodeByCodeType:@"first"];;
    self.chooseArray = [NSMutableArray arrayWithArray:@[
                                                        @[@"first",@"scond",@"third"]
                                                        ]];
    
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,20, self.view.frame.size.width, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    [self.view addSubview:dropDownView];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.dataList = nil;
    
}
#pragma mark -- UITableViewDataSource DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataList) {
        return self.dataList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableViewCell";
    MCode *tmpCode = self.dataList[indexPath.row];
    RIUITableViewCell *cell = (RIUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = (RIUITableViewCell *)[[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    [cell setTableCellWithCodeContent:tmpCode.codeContent scanNum:tmpCode.scanCount.stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select table cell row === %ld" , (long)indexPath.row);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCode *tmpCode = self.dataList[indexPath.row];
    NSLog(@"will select----%ld",(long)indexPath.row);
     UIAlertView *alert =  [[UIAlertView  alloc]initWithTitle:@"删除二维码" message:tmpCode.codeContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
    return indexPath;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@" buttonIndex === %ld", (long)buttonIndex);
    if(buttonIndex) {
        [RICodeManager.sharedInstance deleteOneCodeByCodeType:self.chooseArray[0][self.codeType.integerValue] codeContent:alertView.message];
        self.dataList = [[RICodeManager sharedInstance] getAllCodeByCodeType:self.chooseArray[0][self.codeType.integerValue]];
        [self.tableView reloadData];
    }
}
#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"童大爷选了section:%ld ,index:%ld name %@",(long)section,(long)index, self.chooseArray[section][index]);
    self.codeType = @(index);
    self.dataList = [[RICodeManager sharedInstance] getAllCodeByCodeType:self.chooseArray[section][index]];
    [self.tableView reloadData];
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [self.chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =self.chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return self.chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}
@end
