//
//  SYQRCodeViewController.m
//  SYQRCodeDemo
//
//  Created by sunbb on 15-1-9.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "SYQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DropDownListView.h"
#import "RICodeManager.h"


const NSInteger DefaultInputType = 0;
const NSInteger DefaultOutputType = 1;

@interface SYQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制
@property (nonatomic, strong) NSMutableArray *chooseArray ;
@property (nonatomic, strong) NSNumber *scanType;
@property (nonatomic, strong) NSNumber *codeType;
@property (weak, nonatomic) IBOutlet UIImageView *codeLine;

@end

@implementation SYQRCodeViewController

CGRect startFame;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    startFame = self.codeLine.frame;
    self.codeType = @0;
    self.scanType = @0;
    [self initUI];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
    [self initTitleView];
    [self createBackBtn];
    self.title = @"DropDownMenu";
    self.chooseArray = [NSMutableArray arrayWithArray:@[
                                                   @[@"first",@"scond",@"third"],
                                                   @[@"输入",@"输出"]
                                                   ]];
    
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,60, self.view.frame.size.width, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    
    
    [self.view addSubview:dropDownView];
}

- (void)dealloc
{
    if (self.qrSession) {
        [self.qrSession stopRunning];
        self.qrSession = nil;
    }
    
    if (self.qrVideoPreviewLayer) {
        self.qrVideoPreviewLayer = nil;
    }
    
    if (self.codeLine) {
        self.codeLine = nil;
    }
    
    if (self.lineTimer)
    {
        [self.lineTimer invalidate];
        self.lineTimer = nil;
    }
}

- (void)initTitleView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth, 64)];
    bgView.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 40) / 2.0, 28, 40, 20)];
    //scanCropView.image=[UIImage imageNamed:@""];
    //titleLab.layer.borderColor = [UIColor greenColor].CGColor;
    //titleLab.layer.borderWidth = 2.0;
    //titleLab.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    titleLab.text = @"扫题";
    titleLab.shadowColor = [UIColor lightGrayColor];
    titleLab.shadowOffset = CGSizeMake(0, - 1);
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
}

- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 28, 60, 24)];
    [btn setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)initUI
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //设置preview图层的属性
    //preview.borderColor = [UIColor redColor].CGColor;
    //preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    preview.frame = self.view.layer.bounds;
    //[preview setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}

- (void)setOverlayPickerView
{
}


#pragma mark -
#pragma mark 输出代理方法

//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    UIAlertView *alert = [[UIAlertView alloc]init];
    if (metadataObjects.count > 0)
    {
        [self stopSYQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
        {
            if([self.scanType isEqual: @(DefaultInputType)]) {
                if(![RICodeManager.sharedInstance checkOneCodeByCodeType:self.chooseArray[0][self.codeType.integerValue] codeContent:obj.stringValue]) {
                    [RICodeManager.sharedInstance insertOneCodeByCodeType:self.chooseArray[0][self.codeType.integerValue] codeContent:obj.stringValue];
                    [alert initWithTitle:@"输入" message:obj.stringValue delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                }else {
                    [alert initWithTitle:@"输入" message:@"输入有误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                }
            } else {
                if ([RICodeManager.sharedInstance checkOneCodeByCodeType:self.chooseArray[0][self.codeType.integerValue] codeContent:obj.stringValue]) {
                     [alert initWithTitle:@"扫描成功" message:obj.stringValue delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                } else {
                    [alert initWithTitle:@"扫描失败" message:@"非法的输入卷" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
            }
        } else {
            if (self.SYQRCodeFailBlock) {
                self.SYQRCodeFailBlock(self);
            }
        }
    }
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@" buttonIndex === %ld", (long)buttonIndex);
    if(buttonIndex) {
        [RICodeManager.sharedInstance insertOneCodeByCodeType:self.chooseArray[0][self.codeType.integerValue] codeContent:alertView.message];
    }
    [self startSYQRCodeReading];
}


#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    [self.qrSession startRunning];
    
    NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [self.qrSession stopRunning];
    
    NSLog(@"stop reading");
}

//取消扫描
- (void)cancleSYQRCodeReading
{
    [self stopSYQRCodeReading];
    
    if (self.SYQRCodeCancleBlock)
    {
        self.SYQRCodeCancleBlock(self);
    }
    NSLog(@"cancle reading");
}


#pragma mark -
#pragma mark 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = self.codeLine.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = startFame.origin.y;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            self.codeLine.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (self.codeLine.frame.origin.y >= startFame.origin.y)
        {
            if (self.codeLine.frame.origin.y >= startFame.origin.y + 140)
            {
                frame.origin.y = startFame.origin.y;
                self.codeLine.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    self.codeLine.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    
    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"童大爷选了section:%ld ,index:%ld name %@",(long)section,(long)index, self.chooseArray[section][index]);
    if(section == 1) {
        self.scanType = @(index);
    } else {
        self.codeType = @(index);
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
