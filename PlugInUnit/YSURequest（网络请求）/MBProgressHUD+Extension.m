//
//  MBProgressHUD+Extension.m
//  YiShop
//
//  Created by 宗仁 on 2016/12/7.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD(Extension)

+ (instancetype)showHUDAddedTo:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated {
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}

+ (instancetype)showCustomHUDAddedTo:(UIView *)view withTitle:(NSString *)title image:(UIImage *)image animated:(BOOL)animated {
    //初始化图片视图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //初始化HUD
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    //设置活动指示器下面可选的短消息
    hud.label.text = title;
    //设置包含标签和指示器的视图背景样式为纯色背景
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置包含标签和指示器的视图背景颜色
    hud.bezelView.backgroundColor = [UIColor clearColor];
    //MBProgressHUD操作模式为显示自定义视图
    hud.mode = MBProgressHUDModeCustomView;
    //当HUD在MBProgressHUDModeCustomView时显示的UIView(例如UIImageView)。
    hud.customView = imageView;
    //隐藏时从父视图中移除HUD。默认为NO
    hud.removeFromSuperViewOnHide = YES;
    //添加HUD到视图中
    [view addSubview:hud];
    //HUD是否显示动画
    [hud showAnimated:animated];
    //旋转视图动画
    [hud rotateSpinningView];
    return hud;
}

///旋转视图动画
- (void)rotateSpinningView {
    //初始化单关键帧动画功能对象
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //定义接收器用于结束插值的值
    rotationAnimation.toValue = @(M_PI * 2.0);
    //设置对象的基本持续时间，默认为0
    rotationAnimation.duration = 1;
    //设置上一个重复周期结束时的值加上当前重复周期的值
    rotationAnimation.cumulative = YES;
    //设置对象的重复计数为无限重复
    rotationAnimation.repeatCount = HUGE_VALF;
    //添加动画到层对象
    [self.customView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
