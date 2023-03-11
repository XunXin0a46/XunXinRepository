//
//  TestCLLocationController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/3/25.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCLLocationController.h"
#import "CLLocation+YCLocation.h"

@interface TestCLLocationController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;//位置管理对象
@property (nonatomic, strong) CLLocation *location;//位置对象
@property (nonatomic, strong) UIImageView *headingRelatedImageView;//航向指示视图
@property (nonatomic, strong) UITextField *addressTextField;//地址文本输入框
@property (nonatomic, strong) UILabel *longitudeLabel;//经度值标签
@property (nonatomic, strong) UILabel *latitudeLabel;//纬度值标签
@property (nonatomic, strong) UITextField *longitudeTextField;//经度文本输入框
@property (nonatomic, strong) UITextField *latitudeTextField;//纬度文本输入框
@property (nonatomic, strong) UILabel *addressLabel;//具体地址标签
@property (nonatomic, strong) UILabel *regionMonitorLabel;//区域监视标签
@property (nonatomic, strong) UILabel *monitoringLabel;//正在区域监视标签
@property (nonatomic, strong) UILabel *locationUpdateLabel;//位置更新标签

@end

@implementation TestCLLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"CLLocation"];
    //请求定位权限
    [self requestLocationJurisdiction];
    //设置航向指示视图
    [self setHeadingRelatedView];
    //设置区域监听
    [self setAreaMonitoring];
    //设置视图
    [self createView];
    
}

///请求定位权限
- (void)requestLocationJurisdiction{
    //判断设备在设置中是否启用了位置服务
    if([CLLocationManager locationServicesEnabled]){
        //设备启用了位置服务，判断应用程序的位置权限
        switch ([CLLocationManager authorizationStatus]) {
            //用户尚未选择应用程序是否可以使用位置服务
            case kCLAuthorizationStatusNotDetermined:
                //启用定位
                [self enablePositioning];
                //请求在应用程序位于前台时使用定位服务的权限
                [self.locationManager requestWhenInUseAuthorization];
                break;
            //用户授权应用程序随时启动定位服务的权限
            //用户已授权仅在使用应用程序时有访问位置的权限
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                //启用定位
                [self enablePositioning];
                break;
            //拒绝对此应用程序的位置授权
            case kCLAuthorizationStatusDenied:
                //设备未启用位置服务，展示提示
                [self showPermissionSettingAlert:@"无法定位" withMessage:@"当前应用程序设置不支持定位"];
                break;
            default:
                break;
        }
        
    }else{
        //设备未启用位置服务，展示提示
        [self showPermissionSettingAlert:@"无法定位" withMessage:@"当前设备设置不支持定位"];
    }
}

///启用定位
- (void)enablePositioning{
    //初始化位置管理对象
    if(self.locationManager == nil){
        self.locationManager = [[CLLocationManager alloc]init];
    }
    //设置代理
    self.locationManager.delegate = self;
    //请求在应用程序位于前台时使用定位服务的权限
    [self.locationManager requestAlwaysAuthorization];
    //开始生成报告用户当前位置的更新
    [self.locationManager startUpdatingLocation];
    //判断位置管理器是否能够生成与导航方向相关的事件
    if ([CLLocationManager headingAvailable]) {
        //生成新航向事件所需的最小角度变化
        self.locationManager.headingFilter = kCLHeadingFilterNone;
        [self.locationManager startUpdatingHeading];
    }
}

///显示权限设置提示框
- (void)showPermissionSettingAlert:(NSString *)title withMessage:(NSString *)message{
    //初始化提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //YES操作项
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //打开设置页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]options:@{}completionHandler:nil];
    }];
    //NO操作项
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    [self presentViewController:alertController animated:true completion:nil];
}

///设置航向指示视图
- (void)setHeadingRelatedView{
    //航向指示视图
    self.headingRelatedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_navigation"]];
    self.headingRelatedImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.headingRelatedImageView];
    //Masonry布局
    [self.headingRelatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(HEAD_BAR_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(20, 30));
    }];
}

///设置区域监听
- (void)setAreaMonitoring{
    //判断设备是否支持区域监听
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        return;
    }
    //指定区域类型,一般是圆形区域
    //区域的中点坐标
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.909502, 119.511151);
    //区域半径(米)
    CLLocationDistance distance = 170.0;
    //半径限制
    if (distance > self.locationManager.maximumRegionMonitoringDistance) {
        distance = self.locationManager.maximumRegionMonitoringDistance;
    }
    //初始化圆形地理区域，指定为中心点和半径。
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:distance identifier:@"MyLocation"];
    //开始监视指定区域，对于要监视的每个区域，必须调用此方法一次
    [self.locationManager startMonitoringForRegion:region];
    //延迟2秒执行，以防止概率出现的Domain=kCLErrorDomain Code=5错误
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //异步检索区域的状态
        [self.locationManager requestStateForRegion:region];
    });
    
}

///设置视图
- (void)createView{
    //初始化地址提示标签
    UILabel *addressTipsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    addressTipsLabel.text = @"地址:";
    addressTipsLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:addressTipsLabel];
    //Masonry布局
    [addressTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headingRelatedImageView.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    //初始化地址文本输入框
    self.addressTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.addressTextField.placeholder = @" 请输入地址";
    self.addressTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.addressTextField.layer.borderWidth = 0.5;
    [self.view addSubview:self.addressTextField];
    //Masonry布局
    [self.addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressTipsLabel);
        make.left.equalTo(addressTipsLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 35));
    }];
    
    //初始化查询按钮
    UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryButton setTitle:@"查询" forState:UIControlStateNormal];
    [queryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryButton setBackgroundColor:[UIColor blueColor]];
    [queryButton setTag:1000];
    [self.view addSubview:queryButton];
    [queryButton addTarget:self action:@selector(queryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //Masonry布局
    [queryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressTextField);
        make.left.equalTo(self.addressTextField.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 35));
    }];
    
    //初始化经度值标签
    self.longitudeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.longitudeLabel.font = [UIFont systemFontOfSize:15];
    self.longitudeLabel.textColor = [UIColor redColor];
    self.longitudeLabel.textAlignment = NSTextAlignmentCenter;
    self.longitudeLabel.text = @"当前经度";
    self.longitudeLabel.layer.borderWidth = 0.5;
    self.longitudeLabel.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.longitudeLabel];
    [self.longitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTipsLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    //初始化纬度值标签
    self.latitudeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.latitudeLabel.font = [UIFont systemFontOfSize:15];
    self.latitudeLabel.textColor = [UIColor greenColor];
    self.latitudeLabel.text = @"当前纬度";
    self.latitudeLabel.textAlignment = NSTextAlignmentCenter;
    self.latitudeLabel.layer.borderWidth = 0.5;
    self.latitudeLabel.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:self.latitudeLabel];
    [self.latitudeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.longitudeLabel);
        make.right.equalTo(queryButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    //初始化经度提示标签
    UILabel *longitudeTipsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    longitudeTipsLabel.text = @"经度:";
    longitudeTipsLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:longitudeTipsLabel];
    //Masonry布局
    [longitudeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.longitudeLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    //初始化经度文本输入框
    self.longitudeTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.longitudeTextField.placeholder = @" 请输入经度";
    self.longitudeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.longitudeTextField.layer.borderWidth = 0.5;
    [self.view addSubview:self.longitudeTextField];
    //Masonry布局
    [self.longitudeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(longitudeTipsLabel);
        make.left.equalTo(addressTipsLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(105, 35));
    }];
    
    //初始化纬度提示标签
    UILabel *latitudeTipsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    latitudeTipsLabel.text = @"纬度:";
    latitudeTipsLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:latitudeTipsLabel];
    //Masonry布局
    [latitudeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(longitudeTipsLabel);
        make.left.equalTo(self.latitudeLabel.mas_left);
    }];
    
    //初始化经度文本输入框
    self.latitudeTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    self.latitudeTextField.placeholder = @" 请输入纬度";
    self.latitudeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.latitudeTextField.layer.borderWidth = 0.5;
    [self.view addSubview:self.latitudeTextField];
    //Masonry布局
    [self.latitudeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(latitudeTipsLabel);
        make.left.equalTo(latitudeTipsLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(105, 35));
    }];
    
    //初始化查询按钮
    UIButton *queryButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryButton2 setTitle:@"查询" forState:UIControlStateNormal];
    [queryButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryButton2 setBackgroundColor:[UIColor blueColor]];
    [queryButton2 setTag:1001];
    [self.view addSubview:queryButton2];
    [queryButton2 addTarget:self action:@selector(queryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //Masonry布局
    [queryButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.longitudeTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 35));
    }];
    
    //初始化具体地址标签
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.addressLabel.font = [UIFont systemFontOfSize:15];
    self.addressLabel.textColor = [UIColor redColor];
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.text = @"当前位置:";
    self.addressLabel.layer.borderWidth = 0.5;
    self.addressLabel.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.addressLabel];
    //Masonry布局
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(queryButton2.mas_bottom).offset(20);
        make.left.equalTo(self.longitudeLabel.mas_left);
        make.right.equalTo(self.latitudeLabel.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    //初始化区域监视标签
    self.regionMonitorLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.regionMonitorLabel.font = [UIFont systemFontOfSize:15];
    self.regionMonitorLabel.textColor = [UIColor blackColor];
    self.regionMonitorLabel.textAlignment = NSTextAlignmentCenter;
    self.regionMonitorLabel.numberOfLines = 0;
    self.regionMonitorLabel.layer.borderWidth = 0.5;
    self.regionMonitorLabel.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.regionMonitorLabel];
    //Masonry布局
    [self.regionMonitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(30);
        make.left.equalTo(self.longitudeLabel.mas_left);
        make.right.equalTo(self.view.mas_right).offset(- 20);
    }];
    
    //初始化正在区域监视标签
    self.monitoringLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.monitoringLabel.font = [UIFont systemFontOfSize:15];
    self.monitoringLabel.textColor = [UIColor blackColor];
    self.monitoringLabel.textAlignment = NSTextAlignmentCenter;
    self.monitoringLabel.numberOfLines = 0;
    self.monitoringLabel.layer.borderWidth = 0.5;
    self.monitoringLabel.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.monitoringLabel];
    //Masonry布局
    [self.monitoringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.regionMonitorLabel.mas_bottom).offset(30);
        make.left.equalTo(self.longitudeLabel.mas_left);
        make.right.equalTo(self.view.mas_right).offset(- 20);
    }];
    
    //初始化位置更新标签
    self.locationUpdateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.locationUpdateLabel.font = [UIFont systemFontOfSize:15];
    self.locationUpdateLabel.textColor = [UIColor blackColor];
    self.locationUpdateLabel.textAlignment = NSTextAlignmentCenter;
    self.locationUpdateLabel.numberOfLines = 0;
    self.locationUpdateLabel.layer.borderWidth = 0.5;
    self.locationUpdateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.locationUpdateLabel];
    //Masonry布局
    [self.locationUpdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monitoringLabel.mas_bottom).offset(30);
        make.left.equalTo(self.longitudeLabel.mas_left);
        make.right.equalTo(self.view.mas_right).offset(- 20);
    }];
}

///查询按钮点击事件
- (void)queryButtonClick:(UIButton *)sender{
    
    if(sender.tag == 1000 ){
        
        //初始化地理编码器对象
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        //提交指定位置的正向地理编码请求
        [geoCoder geocodeAddressString:self.addressTextField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count >0) {
                
                CLPlacemark *placeMark = placemarks[0];
                CLLocation *location = placeMark.location;
                //设置经度值标签的经度
                self.longitudeLabel.text = [NSString stringWithFormat:@"当前经度:%f",location.coordinate.longitude];
                //设置维度值标签的纬度
                self.latitudeLabel.text = [NSString stringWithFormat:@"当前纬度:%f",location.coordinate.latitude];
                
            }else if(error == nil && placemarks.count){
                
                NSLog(@"无位置和错误返回");
                self.longitudeLabel.text = @"未找到";
                self.latitudeLabel.text = @"未找到";
                
            }else if(error){
                
                NSLog(@"loction error:%@",error);
                self.longitudeLabel.text = @"未找到";
                self.latitudeLabel.text = @"未找到";
                
            }
        }];

        
    }else if(sender.tag == 1001){
        
        if(IS_NOT_EMPTY(self.longitudeTextField.text) && IS_NOT_EMPTY(self.latitudeTextField.text)){
            CLLocationDegrees latitude = self.latitudeTextField.text.doubleValue;
            CLLocationDegrees longitude = self.longitudeTextField.text.doubleValue;
            self.location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        }
        //初始化地理编码器对象
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        //提交指定位置的反向地理编码请求
        [geoCoder reverseGeocodeLocation:self.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count >0) {

                CLPlacemark *placeMark = placemarks[0];
                NSLog(@"当前国家 - %@",placeMark.country);//当前国家
                NSLog(@"当前城市 - %@",placeMark.locality);//当前城市
                NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
                NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
                NSLog(@"具体地址 - %@",placeMark.name);//具体地址
                self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@,%@",IS_NOT_EMPTY(placeMark.locality)? placeMark.locality : @"",IS_NOT_EMPTY(placeMark.subLocality)? placeMark.subLocality : @"" ,IS_NOT_EMPTY(placeMark.thoroughfare)? placeMark.thoroughfare : @"",IS_NOT_EMPTY(placeMark.name)? placeMark.name : @""];

            }else if(error == nil && placemarks.count){

                NSLog(@"无位置和错误返回");

            }else if(error){

                NSLog(@"loction error:%@",error);

            }

        }];
    }
    
}

#pragma mark - CLLocationManagerDelegate

///通知代理新的位置数据可用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.location = [locations lastObject];
    if (self.location.coordinate.latitude <= 0 || self.location.coordinate.longitude <= 0) {
        return;
    }
    CLLocationCoordinate2D locationCoordinate = self.location.coordinate;
    //设置经度值标签的经度
    self.longitudeLabel.text = [NSString stringWithFormat:@"当前经度:%f",locationCoordinate.longitude];
    //设置维度值标签的纬度
    self.latitudeLabel.text = [NSString stringWithFormat:@"当前纬度:%f",locationCoordinate.latitude];
    //停止生成位置更新
    [manager stopUpdatingLocation];
    
}

///通知代理位置管理器接收到更新的航向信息
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    CGAffineTransform transform =CGAffineTransformMakeRotation((newHeading.magneticHeading) * M_PI / 180.f );
    self.headingRelatedImageView.transform = transform;
}

///当此应用程序的授权状态更改时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status API_AVAILABLE(ios(4.2), macos(10.7)){
    NSLog(@"当此应用程序的授权状态更改时调用");
    switch (status) {
        //用户授权应用程序随时启动定位服务的权限
        //用户已授权仅在使用应用程序时有访问位置的权限
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            //启用定位
            [self enablePositioning];
            break;
        default:
            break;
    }
}

///询问代理是否应显示航向校准警报
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return YES;
}

///通知代理位置管理器无法检索位置值
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"发生异常了");
    if(error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法检索位置");
    }
    else if(error.code == kCLErrorNetwork) {
        NSLog(@"网络问题");
    }
    else if(error.code == kCLErrorDenied) {
        NSLog(@"定位权限的问题");
    }
}

///通知代理用户已进入指定区域
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region API_AVAILABLE(ios(4.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos){
    //异步检索区域的状态
    [self.locationManager requestStateForRegion:region];
    NSLog(@"以进入指定区域");
    self.regionMonitorLabel.text = @"以进入指定区域";
}

///通知代理用户已离开指定区域
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region API_AVAILABLE(ios(4.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos){
    //异步检索区域的状态
    [self.locationManager requestStateForRegion:region];
    NSLog(@"以离开指定区域");
    self.regionMonitorLabel.text = @"以离开指定区域";
}

///通知代理指定区域的状态
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    if (state == CLRegionStateInside) {
        NSLog(@"以进入指定区域");
        self.regionMonitorLabel.text = @"以进入指定区域";
    } else if (state == CLRegionStateOutside) {
        NSLog(@"以离开指定区域");
        self.regionMonitorLabel.text = @"以离开指定区域";
    } else {
        NSLog(@"未知状态");
        self.regionMonitorLabel.text = @"未知状态";
    }
    
}

///通知代理发生区域监视错误
- (void)locationManager:(CLLocationManager *)manager
    monitoringDidFailForRegion:(nullable CLRegion *)region
              withError:(NSError *)error API_AVAILABLE(ios(4.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos){
    //停止区域监视
    [self.locationManager stopMonitoringForRegion:region];
    //CLCircularRegion类定义圆形地理区域的位置和边界
    CLCircularRegion  *circularRegion = (CLCircularRegion *)region;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:circularRegion.center.latitude longitude:circularRegion.center.longitude];
    
    //初始化地理编码器对象
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //提交指定位置的反向地理编码请求
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count >0) {

                CLPlacemark *placeMark = placemarks[0];
                NSLog(@"当前国家 - %@",placeMark.country);//当前国家
                NSLog(@"当前城市 - %@",placeMark.locality);//当前城市
                NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
                NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
                NSLog(@"具体地址 - %@",placeMark.name);//具体地址
                NSString *errorGeocoder = [NSString stringWithFormat:@"%@%@%@,%@",IS_NOT_EMPTY(placeMark.locality)? placeMark.locality : @"",IS_NOT_EMPTY(placeMark.subLocality)? placeMark.subLocality : @"" ,IS_NOT_EMPTY(placeMark.thoroughfare)? placeMark.thoroughfare : @"",IS_NOT_EMPTY(placeMark.name)? placeMark.name : @""];
            
                NSLog(@"%@区域监听发生错误",errorGeocoder);

            }else if(error == nil && placemarks.count){

                NSLog(@"无位置和错误返回");

            }else if(error){

                NSLog(@"loction error:%@",error);

            }

        }];
    //输出包含错误的本地化描述的字符串
    NSLog(@"区域监控失败 %@ %@",region, error.localizedDescription);
    self.regionMonitorLabel.text = error.localizedDescription;
    
    for (CLRegion *monitoredRegion in manager.monitoredRegions) {
        NSLog(@"monitoredRegion: %@", monitoredRegion);
    }
    if ((error.domain != kCLErrorDomain || error.code != 5) &&
        [manager.monitoredRegions containsObject:region]) {
        NSString *message = [NSString stringWithFormat:@"%@ %@",
            region, error.localizedDescription];
        NSLog(@"%@",message);
    }
}

///通知代理正在监视新区域
- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region API_AVAILABLE(ios(5.0), macos(10.8)) API_UNAVAILABLE(watchos, tvos){
    
    //CLCircularRegion类定义圆形地理区域的位置和边界
    CLCircularRegion  *circularRegion = (CLCircularRegion *)region;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:circularRegion.center.latitude longitude:circularRegion.center.longitude];
    
    //初始化地理编码器对象
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //提交指定位置的反向地理编码请求
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count >0) {

                CLPlacemark *placeMark = placemarks[0];
                NSLog(@"当前国家 - %@",placeMark.country);//当前国家
                NSLog(@"当前城市 - %@",placeMark.locality);//当前城市
                NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
                NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
                NSLog(@"具体地址 - %@",placeMark.name);//具体地址
                NSString *errorGeocoder = [NSString stringWithFormat:@"%@%@%@,%@",IS_NOT_EMPTY(placeMark.locality)? placeMark.locality : @"",IS_NOT_EMPTY(placeMark.subLocality)? placeMark.subLocality : @"" ,IS_NOT_EMPTY(placeMark.thoroughfare)? placeMark.thoroughfare : @"",IS_NOT_EMPTY(placeMark.name)? placeMark.name : @""];
            
                self.monitoringLabel.text = [NSString stringWithFormat:@"在监视新区域:%@",errorGeocoder];

            }else if(error == nil && placemarks.count){

                NSLog(@"无位置和错误返回");

            }else if(error){

                NSLog(@"loction error:%@",error);

            }

        }];
}

///通知代理位置更新已暂停
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager API_AVAILABLE(ios(6.0)) API_UNAVAILABLE(watchos, tvos, macos){
    self.locationUpdateLabel.text = @"位置更新已暂停";
}

///通知代理位置更新的传递已恢复
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager API_AVAILABLE(ios(6.0)) API_UNAVAILABLE(watchos, tvos, macos){
    self.locationUpdateLabel.text = @"位置更新的传递已恢复";
}

///通知代理不再延迟更新
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(nullable NSError *)error API_AVAILABLE(ios(6.0), macos(10.9)) API_UNAVAILABLE(watchos, tvos){
    self.locationUpdateLabel.text = @"不再延迟更新";
}

///通知代理一个或多个信标在范围内。
- (void)locationManager:(CLLocationManager *)manager
didRangeBeacons:(NSArray<CLBeacon *> *)beacons
               inRegion:(CLBeaconRegion *)region{
    
}

///通知代理检测到满足约束的信标。
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)beacons
   satisfyingConstraint:(CLBeaconIdentityConstraint *)beaconConstraint API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos, macos){
    
}

///通知代理未检测到满足约束的信标。
- (void)locationManager:(CLLocationManager *)manager
didFailRangingBeaconsForConstraint:(CLBeaconIdentityConstraint *)beaconConstraint
                  error:(NSError *)error API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, tvos, macos){
    
}

///通知代理收到了新的与访问相关的事件
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit API_AVAILABLE(ios(8.0)) API_UNAVAILABLE(watchos, tvos, macos){
    
}

@end
