//
//  RIUITableView.m
//  studyBase
//
//  Created by hardac on 15/12/9.
//  Copyright © 2015年 renren. All rights reserved.
//

#import "RIUITableView.h"
#import "RICodeManager.h"
#import "RIUITableViewCell.h"
#import "MCode.h"
#import "DropDownListView.h"
#define IDENTIFIER @"RIUITableViewCell"

@implementation RIUITableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataList = [[RICodeManager sharedInstance] getAllCodeByCodeType:@"first"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, 64)];
    bgView.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 40) / 2.0, 28, 40, 20)];
    //scanCropView.image=[UIImage imageNamed:@""];
    //titleLab.layer.borderColor = [UIColor greenColor].CGColor;
    //titleLab.layer.borderWidth = 2.0;
    //titleLab.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    self.chooseArray = [NSMutableArray arrayWithArray:@[
                                                        @[@"first",@"scond",@"third"]
                                                        ]];
    
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,60, self.view.frame.size.width, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    [self.view addSubview:dropDownView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(self.dataList) {
//        return self.dataList.count;
//    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // MCode *tmp = self.dataList[indexPath.row];
    RIUITableViewCell *cell = (RIUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    
    if (!cell) {
        cell = [[RIUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
//    [cell setTableCellWithCodeContent:tmp.codeContent scanNum:tmp.scanCount.stringValue];
    [cell setTableCellWithCodeContent:@"test" scanNum:@"4"];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will select----%ld",(long)indexPath.row);
    
    
    return indexPath;
}

// 代理方法,当点击一行时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select----%d",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Girl *girl = _array[indexPath.row];
    // 弹出姓名,以供用户更改
    // 设置代理的目的是响应alert的按钮点击事件
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:girl.name message:girl.verdict delgate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"other", nil];
    UIAlertView *alert = [[UIAlertView alloc]init];
    [alert initWithTitle:@"rwar" message:@"test ALert" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    // alertViewStyle 样式----密码
    // alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    // alertViewStyle 样式----一般的文本输入框
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    // alertViewStyle 样式----用户名及密码登录框
    // alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    // alertViewStyle 样式----标签显示
    // alert.alertViewStyle = UIAlertViewStyleDefault;
    
    // 用户名密码的情况下有两个文本框
    UITextField *textField = [alert textFieldAtIndex:0];
//    textField.text = girl.name;
    // 关键代码,通过tag将点击的行号带给alertView的代理方法,还可以通过利用代理即控制器的成员进行 行号 的传递~
    textField.tag = indexPath.row;
    // 显示alertView
    [alert show];
    /*
     默认情况下,上面的alert是局部变量,在本方法调完的时候,会被释放
     但是,[alert show]方法,会有一种机制(比如UIWindow会持有它的引用,使之不被销毁)
     */
}
// 代理方法,当取消点击一行时调用
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did deselect row----%d",indexPath.row);
}



#pragma mark - UIAlertViewDelegate的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 查看点击了alertView里面的哪一个按钮,取消按钮是 0
    NSLog(@"alertView里面的按钮index---%d",buttonIndex);
    if (buttonIndex == 0) {
        // 0代表取消按钮
        return;
    }else if (buttonIndex == 1){
        // 1代表确定按钮,更新数据源,重新加载数据
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *newName = [textField text];
        // robust判断
        if ([newName isEqualToString:@""]) {
            
            return;
        }
        // 先更新数据源
        int row = textField.tag;

        // 再,全部重新加载数据
        // [_tableView reloadData];
        
        // 最好是,局部刷新数据,通过row生成一个一个indexPath组成数组
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        NSArray *indexPaths = @[indexPath];
//        [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    }
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