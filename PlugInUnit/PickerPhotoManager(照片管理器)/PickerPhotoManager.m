//
//  PickerPhotoManager.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "PickerPhotoManager.h"
#import <Photos/Photos.h>
#import "UIImage+ImageBase64.h"
#import "AlertView.h"
#import "AlertViewController.h"

@interface PickerPhotoManager()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) void (^callBack)(NSArray <UIImage *> *imgs,MediaSelectType type);
@property (nonatomic, weak) UIImagePickerController *picker;//图像选取器控制器对象
@property (nonatomic, assign) MediaSelectType  mediaType;

@end

@implementation PickerPhotoManager

///初始化照片选取器管理对象
+ (instancetype)sharedInstance {
    static PickerPhotoManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)showMediaSelect:(MediaSelectType)type
                   comp:(void (^)(NSArray <UIImage *> *imgs,MediaSelectType type))comp {
    
    switch (type) {
        //相机
        case MediaSelectType_Camera: {
            //显示相机
            [self showCamera:comp];
            break;
        }
        //相册
        case MediaSelectType_Photo: {
            //显示相册
            [self showPhoto:comp];
            break;
        }
        default:
            break;
    }
}

///打开图像选择器视图控制器
+ (void)openImagePickerViewController:(void (^)(NSArray <UIImage *> *imgs,MediaSelectType type))comp {
     YSC_WEAK_SELF;
    //初始化操作表样式的警告视图控制器
    AlertViewController *alertController = [AlertViewController sheetStyleAlertControllerWithFirstActionTtile:@"拍照" firstCompletion:^(UIAlertAction *action) {
        //以拍照的方式打开图像选择器控制器
        [weakSelf openImagePickerController:0 comp:comp];
       
    } secondActionTitle:@"从相册中选择" secondCompletion:^(UIAlertAction *action) {
        //以相册的方式打开图像选择器控制器
        [weakSelf openImagePickerController:1 comp:comp];
        
    }];
    //获取窗口的根视图控制器
    UIViewController *tab = [UIApplication sharedApplication].keyWindow.rootViewController;
    //获取根视图控制器的子级的视图控制器数组的第一个元素
    UIViewController *nav = tab.childViewControllers[0];
    //显示操作表样式的警告视图控制器
    [nav presentViewController:alertController animated:YES completion:NULL];
    //唤醒正在等待的CFRunLoop对象
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

///打开图像选择器控制器
+ (void)openImagePickerController:(int)type comp:(void (^)(NSArray <UIImage *> *imgs,MediaSelectType type))comp{
    //媒体选择类型
    MediaSelectType tmpType;
    //判断是相册或者相机
    tmpType = (type == 1) ? MediaSelectType_Photo : MediaSelectType_Camera;
    //记录媒体选择类型
    [PickerPhotoManager sharedInstance].mediaType = tmpType;
    //显示媒体选择
    [PickerPhotoManager showMediaSelect:tmpType comp:comp];

}

///显示相机
+ (void)showCamera:(void (^)(NSArray <UIImage *> *imgs,MediaSelectType type))comp {
    //判断应用程序是否具有录制指定媒体类型的权限
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //用户不允许访问媒体捕获设备或用户已明确拒绝媒体捕获的权限
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        //进行权限提示
        [self alert:@"开启相机权限后才能拍照"];
    }
    else {
        //指定设备的内置相机作为图像选择器控制器的源
        [self showPicker:UIImagePickerControllerSourceTypeCamera];
    }
    [PickerPhotoManager sharedInstance].callBack = comp;
}

///显示相册
+ (void)showPhoto:(void (^)(NSArray <UIImage *> *imgs,MediaSelectType type))comp {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [self alert:@""];
    }
    else {
        //指定设备的照片库作为图像选取器控制器的源。
        [self showPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [PickerPhotoManager sharedInstance].callBack = comp;
}

///未能获取权限提示
+ (void)alert:(NSString *)title {
    //初始化提示视图
    AlertView * warnAlert =  [[AlertView alloc] init];
    //获取bundle的信息列表文件
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //获取app名称
    NSString * app_name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    //设置提示视图标题
    warnAlert.title = [NSString stringWithFormat:@"已禁止”%@“使用摄像头",app_name];
    //设置提示视图内容
    warnAlert.content =[NSString stringWithFormat:@"可在“设置-隐私-相机”中将“%@”修改为允许",app_name];
    //如果传递的标题参数字符串是空字符
    if([title isEqualToString:@""]){
        //相册
        //设置提示视图标题
        warnAlert.title = [NSString stringWithFormat:@"已禁止”%@“使用照片",app_name];
        //设置提示视图内容
        warnAlert.content =[NSString stringWithFormat:@"可在“设置-隐私-照片”中将“%@”修改为允许",app_name];
    }
    //设置提示视图内容展示位置
    warnAlert.contentAlign = NSTextAlignmentCenter;
    //设置提示视图标题展示位置
    warnAlert.titleAlign = NSTextAlignmentCenter;
    //设置提示视图左边按钮标题
    warnAlert.leftBtnTitle = @"取消";
    //设置提示视图左边按钮标题颜色
    warnAlert.leftBtnColor = HEXCOLOR(0xF56456) ;
    //设置提示视图左边按钮点击事件
    warnAlert.leftBtnBlock = ^{};
    //设置提示视图右边按钮标题
    warnAlert.rightBtnTitle = @"前往设置";
    //设置提示视图右边按钮标题颜色
    warnAlert.rightBtnColor = HEXCOLOR(0xF56456) ;
    //设置提示视图右边按钮点击事件
    warnAlert.rightBtnBlock = ^{
        //打开设置相机权限页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    };
    //显示提示视图
    warnAlert.showType = AlertShowSlideInFromLeft;
    warnAlert.placeholder = @"提示";
    [warnAlert show];
}

///根据type显示相机或相册
+ (void)showPicker:(UIImagePickerControllerSourceType)type {
    UIViewController *tab = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *nav = tab.childViewControllers[0];
    UIImagePickerController *vc =  [[UIImagePickerController alloc] init];
    vc.delegate = [PickerPhotoManager sharedInstance];
    vc.sourceType = type;
    [nav presentViewController:vc animated:YES completion:nil];
}


+ (BOOL)showCameraScanning {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        [self alert:@"开启相机权限后才能拍照"];
        return NO;
    }
    else {
        return YES;
    }
}
+ (void)showVoiceAlert{
    AlertView * warnAlert =  [[AlertView alloc] init];
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    warnAlert.title = [NSString stringWithFormat:@"已禁止”%@“录音或通话录音",app_name];
    warnAlert.content =[NSString stringWithFormat:@"可在“设置-隐私-麦克风”中将“%@”修改为允许",app_name]; ;
    warnAlert.contentAlign = NSTextAlignmentCenter;
    warnAlert.titleAlign = NSTextAlignmentCenter;
    warnAlert.leftBtnTitle = @"取消";
    warnAlert.leftBtnColor = HEXCOLOR(0xF56456) ;
    warnAlert.leftBtnBlock = ^{};
    warnAlert.rightBtnTitle = @"前往设置";
    warnAlert.rightBtnColor = HEXCOLOR(0xF56456) ;
    warnAlert.rightBtnBlock = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    };
    [warnAlert show];
}
//*****************************************************************
// MARK: - delegates
//*****************************************************************

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self writeImages:@[image]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.callBack(nil,self.mediaType);
}
/**
 写入本地
 
 // images 图片集合
 // imageNames 图片命名集合（目前以时间为命名）
 */
- (void)writeImages:(NSArray <UIImage *>*)images{
    if (images) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (UIImage * image in images) {
                UIImage *newImg = [UIImage imageByScalingAndCroppingForSizeWithImage:image maxWidth:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PickerPhotoManager sharedInstance].callBack(@[newImg],self.mediaType);
                });
            }
        });
    }
}

@end
