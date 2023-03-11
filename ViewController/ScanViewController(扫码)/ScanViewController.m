//
//  ScanViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/2/6.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@property (nonatomic, strong) UIColor *backBarTintColor;
@property (nonatomic, copy) NSDictionary *backTitleAttributes;
@property (nonatomic, strong) UIImage *backShadowImage;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"扫码"];
    if([self showCameraScanning]){
        [self startScan];
    }
    [self setupScanView];
    //监听应用程序将进入前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(applicationWillEnterForeground:)
        name:UIApplicationWillEnterForegroundNotification
      object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航栏是否隐藏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //返回按钮
    UIButton *leftButton = self.navigationItem.leftBarButtonItem.customView;
    [leftButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateHighlighted];
    //备份导航栏属性
    [self backupNavigationBarAttributes];
    //设置导航栏属性
    [self setNavigationBarAttributes];
    //扫描框的宽度
    CGFloat scanHoleWidth = SCREEN_WIDTH - 60.0 * 2.0;
    //扫描框的高度
    CGFloat scanHoleHeight = scanHoleWidth;
    //扫描框矩形
    CGRect scanRect = RectAroundCenter(self.scanView.scanCenter, CGSizeMake(scanHoleWidth, scanHoleHeight));
    //将预览层坐标系中的矩形转换为用于元数据输出的坐标系中的矩形
    CGRect rect = [self.previewLayer metadataOutputRectOfInterestForRect:scanRect];
    self.output.rectOfInterest = rect;
    if (self.session.isRunning == NO) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_session.isRunning) {
        [_session stopRunning];
    }
    [self resetNavigationBarAttributes];
    UIButton *leftButton = self.navigationItem.leftBarButtonItem.customView;
    [leftButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateHighlighted];
}

///设置扫描视图
- (void)setupScanView {
    self.scanView = [[StandardScanView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scanView];
}

///应用程序将进入前台执行的函数
- (void)applicationWillEnterForeground:(NSNotification *)notification {
    
    if (self.session.isRunning == NO) {
        [self.session startRunning];
    }
}

///设置导航栏属性
- (void)setNavigationBarAttributes {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:54.0f/255.0f green:53.0f/255.0f blue:58.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}

///重置导航栏属性
- (void)resetNavigationBarAttributes {
    //栏标题文本的属性
    self.navigationController.navigationBar.titleTextAttributes = self.backTitleAttributes;
    //导航栏背景的色调颜色
    self.navigationController.navigationBar.barTintColor = self.backBarTintColor;
    //导航栏的阴影图像
    self.navigationController.navigationBar.shadowImage = self.backShadowImage;
    //导航栏是否半透明
    self.navigationController.navigationBar.translucent = NO;
}

///备份导航栏属性
- (void)backupNavigationBarAttributes {
    _backBarTintColor = self.navigationController.navigationBar.barTintColor;
    _backTitleAttributes = self.navigationController.navigationBar.titleTextAttributes;
    _backShadowImage = self.navigationController.navigationBar.shadowImage;
}

///扫描框矩形
static CGRect RectAroundCenter(CGPoint center, CGSize size) {

    CGFloat halfWidth = size.width * 0.5;
    CGFloat halfHeight = size.height * 0.5;
    return CGRectMake(center.x - halfWidth,center.y - halfHeight, size.width, size.height);
}

- (BOOL)showCameraScanning {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限" message:@"开启相机权限才能扫码" preferredStyle:UIAlertControllerStyleAlert];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    else {
        return YES;
    }
}

///解析扫描码
- (void)parseScanCode:(NSString *)code {
    NSLog(@"这里已经执行了");
    NSLog(@"%@",code);
}

#pragma mark - Scan

///开始扫描
- (void)startScan {
    
    //获取摄像设备
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *deviceInputError = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&deviceInputError];
    //判断输入流是否可用
    if (deviceInput) {
        //创建输出流
        AVCaptureMetadataOutput *deviceOutput = [[AVCaptureMetadataOutput alloc] init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [deviceOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        self.session = [[AVCaptureSession alloc] init];
        [self.session addInput:deviceInput];
        [self.session addOutput:deviceOutput];
        self.output = deviceOutput;
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        deviceOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                             AVMetadataObjectTypeEAN13Code,
                                             AVMetadataObjectTypeEAN8Code,
                                             AVMetadataObjectTypeCode128Code];
        
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        self.previewLayer = layer;
        [self.view.layer addSublayer:layer];
        //开始捕获图像:
        [self.session startRunning];
    } else {
        YSCLog(@"%@", deviceInputError);
#if DEBUG
        
#endif
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

/**
 通知委托捕获输出对象发出了新的元数据对象。
 @Parameters :
 
 captureOutput : 捕获并发出元数据对象的AVCaptureMetadataOutput对象。
 
 metadataObjects : 表示新发出的元数据的AVMetadataObject实例的数组。因为AVMetadataObject是一个抽象类，所以这个数组中的对象总是一个具体子类的实例。
 
 connection : 发射对象所通过的捕获连接。
 
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        [self parseScanCode:metadataObject.stringValue];
        [self.session stopRunning];
    }
}

@end
