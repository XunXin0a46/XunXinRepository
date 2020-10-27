//
//  AlertBaseView.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertBaseView : UIView

//显示动画类型
typedef NS_ENUM(NSInteger, AlertShow)
{
    AlertShowNone,//无动画
    AlertShowFadeIn,//淡入
    AlertShowSlideInToCenter,//中心滑入
    AlertShowSlideInFromTop,// 顶部掉落
    AlertShowSlideInFromLeft// 从左侧滑入
};

//隐藏动画类型
typedef NS_ENUM(NSInteger,  AlertHide)
{
    AlertHideNone,//无动画
    AlertHideFadeOut,//淡出
    AlertHideSlideOutToCenter,
    AlertHideSlideOutToRight
};

@property(nonatomic,strong) UIView *backgroundView;//背景视图
@property(nonatomic,strong) UIView *alertView;//提示框视图
@property (nonatomic)  AlertShow showType;//显示动画类型
@property (nonatomic)  AlertHide hideType;//隐藏动画类型
@property (nonatomic,assign) CGFloat backgroundOpacity;//背景视图透明度

///显示提示视图
- (void) show;
///隐藏提示视图
- (void) hide;

- (void) refreshUI;

@end

