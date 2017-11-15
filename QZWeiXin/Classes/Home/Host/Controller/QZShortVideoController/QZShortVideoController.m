//
//  QZShortVideoController.m
//  QZWeiXin
//
//  Created by 000 on 17/11/14.
//  Copyright © 2017年 范庆忠. All rights reserved.
//

#import "QZShortVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import "QZShortVideoProgressView.h"

#define kMaxVideoLength 6
#define kProgressTimerTimeInterval 0.015

extern const CGFloat kHomeTableViewAnimationDuration;

typedef void (^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface QZShortVideoController () <AVCaptureFileOutputRecordingDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;//负责输入输出设备之间的数据传递

@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据

@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) UIButton *takeButton;//拍照按钮

@property (nonatomic, weak) UIButton *flashAutoButton;//自动闪光灯按钮
@property (nonatomic, weak) UIButton  *flashOnButton;//打开闪光灯按钮
@property (nonatomic, weak) UIButton *flashOffButton;//关闭闪光灯按钮
@property (nonatomic, weak) UIImageView *focusCursor;//聚光光标


@property (nonatomic, strong) QZShortVideoProgressView *progressView;
@property (nonatomic, strong) UIView *topBarView;

@property (nonatomic, strong) UILabel *cancleAlertLabel;

@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (nonatomic, assign) BOOL enableRotation;//是否允许旋转 （注意在视频录制过程中禁止视频旋转）
@property (nonatomic, assign) CGRect *lastBounds;//旋转的前大小
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识

@property (nonatomic, assign) CGFloat videoLength;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL shouldCancle;

@end

@implementation QZShortVideoController

- (UIView *)topBarView
{
    if (!_topBarView) {
        _topBarView = [UIView new];
        _topBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _topBarView.frame = CGRectMake(0, 0, self.view.width, 64);
        [self.view addSubview:_topBarView];
        
        UIButton *cancleButton = [UIButton new];
        [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        cancleButton.frame = CGRectMake(20, 20, 40, _topBarView.height - 20);
        
        [_topBarView addSubview:cancleButton];
    }
    return _topBarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [self setupCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupCaptureSession];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.captureSession stopRunning];
}

- (BOOL)isRecordingVideo
{
    return [self.captureMovieFileOutput isRecording];
}
- (void)dealloc
{
    [self removeNotification];
}
- (void)setupView
{
    //设置控件半透明而子控件不透明
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.pan = pan;
    
    CGRect rect = self.view.bounds;
    rect.size.height = 400;
    self.viewContainer = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.viewContainer];
    
    self.topBarView.hidden = NO;
    
    self.progressView = [QZShortVideoProgressView new];
    self.progressView.hidden = YES;
    [self.view addSubview:self.progressView];
    
    self.takeButton = [UIButton new];
    self.takeButton.hidden = YES;
    [self.takeButton setTitle:@"按住拍" forState:UIControlStateNormal];
    [self.takeButton addTarget:self action:@selector(startRecordingVideo) forControlEvents:UIControlEventTouchDown];
    [self.takeButton addTarget:self action:@selector(endRecordingVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.takeButton setTitleColor:Global_tintColor forState:UIControlStateNormal];
    [self.view addSubview:self.takeButton];
    self.takeButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.takeButton.layer.borderWidth = 1;
    
    
    self.cancleAlertLabel = [UILabel new];
    self.cancleAlertLabel.text = @"松手取消";
    self.cancleAlertLabel.textColor = [UIColor whiteColor];
    self.cancleAlertLabel.backgroundColor = [UIColor redColor];
    self.cancleAlertLabel.hidden = YES;
    [self.view addSubview:self.cancleAlertLabel];
    
    self.progressView.sd_layout
    .leftSpaceToView(self.view,0)
    .widthIs(self.view.width)
    .topSpaceToView(self.viewContainer,0)
    .heightIs(2);
    
    self.takeButton.sd_layout
    .topSpaceToView(self.viewContainer,60)
    .bottomSpaceToView(self.view, 60)
    .widthEqualToHeight()
    .centerXEqualToView(self.view);
    self.takeButton.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    self.cancleAlertLabel.sd_layout
    .centerXEqualToView(self.viewContainer)
    .topSpaceToView(self.viewContainer, -40)
    .heightIs(20);
    [self.cancleAlertLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    
    
}

- (void)panView:(UIPanGestureRecognizer *)pan
{
    if ([self.captureMovieFileOutput isRecording]) {
        CGPoint point = [pan locationInView:pan.view];
        
        CGRect touchRect = CGRectMake(point.x, point.y, 1, 1);
        
        BOOL isIn = CGRectIntersectsRect(self.takeButton.frame, touchRect);
        
        self.cancleAlertLabel.hidden = isIn;
        self.shouldCancle = !isIn;
        
        UIColor *tintColor = Global_tintColor;
        if (!isIn) {
            tintColor = [UIColor redColor];
        }
        
        [self.takeButton setTitleColor:tintColor forState:UIControlStateNormal];
        
        self.progressView.progressLine.backgroundColor = tintColor;
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed) {
            [self endRecordingVideo];
        }
        
    }
}

- (void)cancleButtonClicked
{
    if (self.cancleOperationBlock) {
        self.cancleOperationBlock();
    }
}

- (void)setupCaptureSession
{
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        //设置fenbianl
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    NSError *error = nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptuireDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptuireDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到回话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    CALayer *layer = self.viewContainer.layer;
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    _enableRotation = YES;
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGestureRecognizer];
    
    
}

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  return 摄像头设备
 */

- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}
/**
 *  给输入设备添加通知
 *
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice
{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
- (void)removeNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */

- (void)areaChange:(NSNotification *)notification
{
    NSLog(@"捕获区域改变...");
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 *
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration：调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
        
    }
}


/**
 *  添加点按手势，点按时聚焦
 */
- (void)addGestureRecognizer
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}
- (void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.viewContainer];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置聚焦光标位置
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
    }];
}

/**
 *  设置聚焦点
 *  @param point 聚焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

#pragma mark - UI方法

- (void)show
{
    if (!_captureDeviceInput) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法获取到后置摄像头" message:@"请退出操作" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:nil];
        [alert show];
    }
    self.pan.enabled = YES;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.viewContainer.hidden = NO;
    self.takeButton.hidden = self.viewContainer.hidden;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHomeTableViewAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.captureSession startRunning];
    });
    [self.view layoutSubviews];
}

- (void)hidde
{
    self.pan.enabled = NO;
    self.view.height = 300;
    self.viewContainer.hidden = YES;
    self.takeButton.hidden = self.viewContainer.hidden;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHomeTableViewAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.captureSession stopRunning];
    });
}
#pragma mark 自动闪光灯开启
- (void)flashAutoClick:(UIButton *)sender
{
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}

/**
 *  设置闪光灯按钮状态
 */
- (void)setFlashModeButtonStatus
{
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    AVCaptureFlashMode flashMoce = captureDevice.flashMode;
    if ([captureDevice isFlashAvailable]) {
        self.flashAutoButton.hidden = NO;
        self.flashOnButton.hidden = NO;
        self.flashOffButton.hidden = NO;
        self.flashAutoButton.enabled = YES;
        self.flashOffButton.enabled = YES;
        self.flashOnButton.enabled = YES;
        switch (flashMoce) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled = NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOnButton.enabled = NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashOffButton.enabled = NO;
                break;
                
            default:
                break;
        }
    }else {
        self.flashAutoButton.hidden = YES;
        self.flashOnButton.hidden = YES;
        self.flashOffButton.hidden = YES;
    }
}

/**
 *  设置闪光灯模式
 *  @param flashMode 闪光灯模式
 */
- (void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

#pragma mark 视频录制

- (void)startRecordingVideo
{
    [self setupTimer];
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (![self.captureMovieFileOutput isRecording]) {
        self.enableRotation = NO;
        //如果支持多任务则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            //在没有使用GCD时，当app被按home键退出后，app仅有最多5秒钟的时候做一些保存或清理资源的工作。但是在使用GCD后，app最多有10分钟的时间在后台长久运行。这个时间可以用来做清理本地缓存，发送统计数据等工作。
            self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
        NSLog(@"save path is :%@",outputFilePath);
        
        NSURL *fileUrl = [NSURL fileURLWithPath:outputFilePath];
        [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
}

- (void)endRecordingVideo
{
    [self removeTimer];
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}

- (void)setupTimer
{
    self.progressView.hidden = NO;
    self.videoLength = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimerTimeInterval target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)removeTimer
{
    self.progressView.progress = 0 ;
    self.progressView.hidden = YES;
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgress
{
    if (self.videoLength >= kMaxVideoLength) {
        [self removeTimer];
        [self endRecordingVideo];
        return;
    }
    self.videoLength += kProgressTimerTimeInterval;
    CGFloat progress = self.videoLength / kMaxVideoLength;
    self.progressView.progress = progress;
}

- (BOOL)shouldAutorotate
{
    return self.enableRotation;
}
//屏幕旋转时调整视频预览图层的方向
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AVCaptureConnection *captureConnection = [self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation = (AVCaptureVideoOrientation)toInterfaceOrientation;
}
//旋转后重新设置大小
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _captureVideoPreviewLayer.frame = self.viewContainer.bounds;
}
@end
