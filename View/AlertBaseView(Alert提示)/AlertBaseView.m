//
//  AlertBaseView.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "AlertBaseView.h"

@implementation AlertBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    //背景视图透明度
    _backgroundOpacity=0.7f;
}

- (void) setupUI
{
}

- (void)refreshUI{
    
}

///显示提示视图
-(void) show
{
    //对象弱引用
    YSC_WEAK_SELF
    //获取主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
        if(weakSelf.showType == AlertShowFadeIn){
            // 淡入显示
            [self fadeIn];
            return;
        }
        if(weakSelf.showType == AlertShowSlideInFromTop){
            // 从顶部掉落
            [self slideInFromTop];
            return;
        }
        if(weakSelf.showType == AlertShowSlideInToCenter){
            // 从中心点滑入
            [self slideInToCenter];
            return;
        }
        if(weakSelf.showType == AlertShowSlideInFromLeft){
            // 从左侧滑入
            [self slideInFromLeft];
        }
    });
}

///隐藏提示视图
- (void) hide
{
    if(_hideType == AlertHideNone){
        //无动画
        [self removeFromSuperview];
        return;
    }
    if(_hideType == AlertHideFadeOut){
        //淡出
        [self fadeOut];
        return;
    }
    if(_hideType == AlertHideSlideOutToCenter){
        //从中心点滑出
        [self slideOutToCenter];
        return;
    }
    if(_hideType == AlertHideSlideOutToRight){
        // 滑出到右侧
        [self slideOutToRight];
    }
}

#pragma mark - 显示动画

/// 淡入
- (void)fadeIn
{
    //背景视图透明度
    _backgroundView.alpha=0.0f;
    //提示框视图透明度
    _alertView.alpha = 0.0f;
    //对象弱引用
    YSC_WEAK_SELF;
    //设置动画
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //更改背景视图透明度
                         weakSelf.backgroundView.alpha=weakSelf.backgroundOpacity;
                         //更改提示框视图透明度
                         weakSelf.alertView.alpha = 1.0f;
                     }
                     completion:nil];
}

/// 从顶部掉落
- (void) slideInFromTop
{
    //获取提示框视图的框架矩形
    CGRect frame = _alertView.frame;
    //设置提示框视图初始位置的框架矩形
    _alertView.frame=CGRectMake(frame.origin.x,-frame.size.height,frame.size.width,frame.size.height);
    //对象弱引用
    YSC_WEAK_SELF;
    //设置动画
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.5f options:0 animations:^{
        //动画设置提示框视图的框架矩形
        weakSelf.alertView.frame=frame;
    } completion:^(BOOL finished) {
    }];
}

//// 从中心点滑入
- (void)slideInToCenter
{
    //设置提示框视图边界相对其中心的转换(矩阵缩放转换)
    _alertView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                   CGAffineTransformMakeScale(0.1f, 0.1f));
    //设置提示框视图透明度
    _alertView.alpha = 0.0f;
    //对象弱引用
    YSC_WEAK_SELF;
    //设置动画
    [UIView animateWithDuration:0.3f animations:^{
        //设置提示框视图边界相对其中心的转换(矩阵缩放转换)
        weakSelf.alertView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                               CGAffineTransformMakeScale(1.0f, 1.0f));
        //设置提示框视图透明度
        weakSelf.alertView.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            //动画结束设置提示视图的中心点
            weakSelf.alertView.center = weakSelf.backgroundView.center;
        }];
    }];
}

/// 从左侧滑入
- (void)slideInFromLeft
{
    //获取提示框视图框架矩形
    CGRect frame = _alertView.frame;
    //设置提示视图起点的X轴坐标
    frame.origin.x = -_alertView.frame.size.width;
    //设置提示框视图初始位置框架矩形
    _alertView.frame = frame;
    //对象弱引用
    YSC_WEAK_SELF;
    //设置动画
    [UIView animateWithDuration:0.3f animations:^{
        //获取提示框视图框架矩形
        CGRect frame = weakSelf.alertView.frame;
        //设置提示框视图原点的X轴坐标
        frame.origin.x = 0.0f;
        //设置提示框视图框架矩形
        weakSelf.alertView.frame = frame;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            //动画结束设置视图中心位置
            weakSelf.alertView.center = weakSelf.backgroundView.center;
        }];
    }];
}

#pragma mark - 隐藏动画

/// 淡出
- (void)fadeOut
{
    [self fadeOutWithDuration:0.3f];
}

/// 淡出动画
- (void)fadeOutWithDuration:(NSTimeInterval)duration
{
    YSC_WEAK_SELF;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundView.alpha = 0.0f;
        weakSelf.alertView.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [self removeFromSuperview];
    }];
}

/// 从中心点滑出
- (void)slideOutToCenter
{
    YSC_WEAK_SELF;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.alertView.transform =
        CGAffineTransformConcat(CGAffineTransformIdentity,
                                CGAffineTransformMakeScale(0.1f, 0.1f));
        weakSelf.alertView.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [weakSelf fadeOut];
    }];
}

/// 滑出到右侧
- (void) slideOutToRight
{
    CGRect frame = _alertView.frame;
    frame.origin.x= SCREEN_MIN_LENGTH;
    YSC_WEAK_SELF;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.alertView.frame = frame;
    } completion:^(BOOL completed) {
        [weakSelf fadeOut];
    }];
}


@end
