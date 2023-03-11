//
//  AnimationManager.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/25.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "AnimationManager.h"

@interface AnimationManager()<CAAnimationDelegate>

@property (nonatomic, weak) CALayer *animationLayer;//动画层对象
@property (nonatomic, weak) UIWindow *canvas;//窗口对象
@property (nonatomic,strong)NSMutableArray * layerArray;//存放动画层对象数组

@end

@implementation AnimationManager

///构造动画管理器单例对象
+ (instancetype)sharedManager {
    static AnimationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.canvas = [UIApplication sharedApplication].keyWindow;
        manager.layerArray = [NSMutableArray array];
    });
    return manager;
}

///视图抛物线动画
- (void)throwView:(UIView *)view fromRect:(CGRect)originRect toRect:(CGRect)endRect {
    //如果未传递视图或视图未设置框架矩形，结束函数
    if (!view || CGRectEqualToRect(view.frame, CGRectZero)) {
        return;
    }
    //动画开始原点位置
    CGPoint originPoint = CGPointMake(CGRectGetMinX(originRect) + CGRectGetWidth(originRect) * 0.5, CGRectGetMinY(originRect) + CGRectGetHeight(originRect) * 0.5);
    //动画结束点位置
    CGPoint endPoint = CGPointMake(CGRectGetMinX(endRect) + CGRectGetWidth(endRect) * 0.5, CGRectGetMinY(endRect) + CGRectGetHeight(endRect) * 0.5);
    //化动画层对象宽度
    CGFloat animationLayerWidth = 60.0;
    //化动画层对象高度
    CGFloat animationLayerHeight = animationLayerWidth;
    //初始化动画层对象
    CALayer *animationLayer = [[CALayer alloc] init];
    //获取视图层内容作为动画层对象内容
    animationLayer.contents = view.layer.contents;
    //动画层对象的内容在其边界内定位或缩放的方式
    animationLayer.contentsGravity = kCAGravityResizeAspectFill;
    //设置视图原始大小的高
    originRect.size.height = animationLayerHeight;
    //设置动画层对象框架矩形
    animationLayer.frame = CGRectMake(originPoint.x, originPoint.y, animationLayerWidth, animationLayerHeight);
    //设置动画层对象圆角
    animationLayer.cornerRadius = animationLayerWidth * 0.5;
    //设置动画层对象边界裁剪
    animationLayer.masksToBounds = YES;
    //添加动画层对象到存放动画层对象数组
    [self.layerArray addObject:animationLayer];
    //窗口层对象添加动画层对象
    [self.canvas.layer addSublayer:animationLayer];
    //记录动画层对象
    self.animationLayer = animationLayer;
    
    #pragma mark - Add animation(开始添加动画)
    //创建关键帧动画对象
    CAKeyframeAnimation *bezierAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //设置代理
    bezierAnimation.delegate = self;
    //动画路径
    CGFloat controlPointEY = 100.0f;
    CGFloat controlPointEX = (endPoint.x - originPoint.x) * 0.25f;
    CGFloat controlPointCX = (originPoint.x + endPoint.x) * 0.5f;
    CGFloat controlPointCY = originPoint.y < endPoint.y ? originPoint.y : endPoint.y;
    CGPoint controlPoint1 = CGPointMake(controlPointCX - controlPointEX, controlPointCY - controlPointEY);
    CGPoint controlPoint2 = CGPointMake(controlPointCX + controlPointEX, controlPointCY - controlPointEY);
    //初始化贝塞尔曲线对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    //将接收器的当前点移动到指定位置
    [path moveToPoint:originPoint];
    //使用三个点位置设置曲线
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    //将曲线设置为关键帧动画对象执行路径
    bezierAnimation.path = path.CGPath;
    
    //创建缩放动画对象
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //缩放起始值
    scaleAnimation.fromValue = @1.0;
    //缩放终止值
    scaleAnimation.toValue = @0.1;
    
    //创建分组动画对象
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //设置要执行的动画
    animationGroup.animations = @[scaleAnimation, bezierAnimation];
    //动画执行时间
    animationGroup.duration = 0.9;
    //设置代理
    animationGroup.delegate = self;
    //保持动画执行后的状态
    animationGroup.fillMode = kCAFillModeForwards;
    //动画完成不在目标层移除
    animationGroup.removedOnCompletion = NO;
    //执行动画
    [self.animationLayer addAnimation:animationGroup forKey:@"GroupAnimation"];
}

///返回缩放动画对象
- (CABasicAnimation*)scaleAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)tovalue {
    CABasicAnimation *animScale = [[CABasicAnimation alloc]init];
    animScale.keyPath = @"transform.scale";
    animScale.fromValue = @(fromValue);
    animScale.toValue = @(tovalue);
    animScale.duration = 1.0f;
    animScale.removedOnCompletion = NO;
    animScale.fillMode = kCAFillModeForwards;
    return animScale;
}

///返回平移动画对象
- (CABasicAnimation*)rotationAnimationFromValue:(CGPoint)fromValue toValue:(CGPoint)tovalue {
    CABasicAnimation *baseAnimation = [[CABasicAnimation alloc]init];
    baseAnimation.keyPath = @"position";
    baseAnimation.fromValue = @(fromValue);
    baseAnimation.toValue = @(tovalue);
    baseAnimation.duration = 1.0f;
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    return baseAnimation;
}

///执行分组动画
- (void)implementGroupAnimation:(UIView *)view withAnimations:(NSArray *)animations{
    CAAnimationGroup *Group = [[CAAnimationGroup alloc]init];
    Group.animations = animations;
    Group.duration = 1.5;
    Group.removedOnCompletion = NO;
    Group.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:Group forKey:@"Group"];
    [UIView animateWithDuration:1.5 animations:^{
        view.alpha = 0;
    }];
}

#pragma mark -- CAAnimationDelegate
///动画已结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //移除动画层对象
    [self.layerArray.firstObject removeFromSuperlayer];
    [self.layerArray removeObject:self.layerArray.firstObject];
}


@end
