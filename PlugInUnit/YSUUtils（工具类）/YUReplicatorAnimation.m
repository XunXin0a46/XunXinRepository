//
//  YUReplicatorAnimation.m
//  YUAnimation
//
//  Created by administrator on 17/2/4.
//  Copyright © 2017年 animation.com. All rights reserved.
//

#import "YUReplicatorAnimation.h"

@implementation YUReplicatorAnimation

+ (CALayer *)replicatorLayerWithType:(YUReplicatorLayerType)type
{
    CALayer *layer = nil;
    
    switch (type) {
        //波纹
        case YUReplicatorLayerCircle:
        {
            layer = [self replicatorLayer_Circle];
        }
            break;
        //波浪
        case YUReplicatorLayerWave:
        {
            layer = [self replicatorLayer_Wave];
        }
            break;
        // 三角形
        case YUReplicatorLayerTriangle:
        {
            layer = [self replicatorLayer_Triangle];
        }
            break;
        //网格动画
        case YUReplicatorLayerGrid:
        {
            layer = [self replicatorLayer_Grid];
        }
            break;
        //震动条
        case YUReplicatorLayerShake:
        {
            layer = [self replicatorLayer_Shake];
        }
            break;
        case YUReplicatorLayerRound:
        {
            layer = [self replicatorLayer_Round];
        }
            break;
        case YUReplicatorLayerHeart:
        {
            layer = [self replicatorLayer_Heart];
        }
            break;
        case YUReplicatorLayerTurn:
        {
            layer = [self replicatorLayer_Turn];
        }
            break;
        default:
        {
            layer = [self replicatorLayer_Circle];
        }
            break;
    }
    
    return layer;
}

#pragma mark -----------------------  复制层

// 圆圈动画 波纹
+ (CALayer *)replicatorLayer_Circle{
    //初始化形状层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //形状层的框架矩形
    shapeLayer.frame = CGRectMake(0, 0, 80, 80);
    //形状层路径为根据矩形绘制的椭圆形路径
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)].CGPath;
    //填充形状路径的颜色
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    //形状层的透明度
    shapeLayer.opacity = 0.0;
    
    //初始化分组动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //设置动画组(透明度动画、缩放动画)
    animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
    //动画持续时间
    animationGroup.duration = 4.0;
    //动画结束时执行逆动画
    animationGroup.autoreverses = NO;
    //动画重复次数无限重复
    animationGroup.repeatCount = HUGE;
    //形状层添加分组动画
    [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
    
    //初始化复制层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    //复制层的框架矩形
    replicatorLayer.frame = CGRectMake(0, 0, 80, 80);
    //指定复制副本之间的延迟（秒）
    replicatorLayer.instanceDelay = 0.5;
    //要创建的副本数
    replicatorLayer.instanceCount = 8;
    //将形状层添加到复制层容器
    [replicatorLayer addSublayer:shapeLayer];
    //返回复制层
    return replicatorLayer;
}

// 波浪动画
+ (CALayer *)replicatorLayer_Wave{
    //间距
    CGFloat between = 5.0;
    //半径
    CGFloat radius = (100-2*between)/3;
    //初始化形状层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //设置形状层框架矩形
    shapeLayer.frame = CGRectMake(0, (100-radius)/2, radius, radius);
    //形状层路径为根据矩形绘制的椭圆形路径
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    //填充形状路径的颜色
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    //形状层添加缩放基本动画
    [shapeLayer addAnimation:[self scaleAnimation1] forKey:@"scaleAnimation"];
    
    //初始化复制层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    //设置复制层框架动画
    replicatorLayer.frame = CGRectMake(0, 0, 100, 100);
    //指定复制副本之间的延迟（秒）
    replicatorLayer.instanceDelay = 0.2;
    //要创建的副本数
    replicatorLayer.instanceCount = 3;
    //复制矩阵
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(between*2+radius,0,0);
    //将形状层添加到复制层容器
    [replicatorLayer addSublayer:shapeLayer];
    //返回复制层
    return replicatorLayer;
}

// 三角形动画
+ (CALayer *)replicatorLayer_Triangle{
    //半径
    CGFloat radius = 100/4;
    //X周转换向量
    CGFloat transX = 100;
    //初始化形状层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //形状层框架矩形
    shapeLayer.frame = CGRectMake(0, 0, radius, radius);
    //形状层路径为根据矩形绘制的椭圆形路径
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    //用于绘制形状路径的颜色
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    //填充形状路径的颜色
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    //指定形状路径的线宽
    shapeLayer.lineWidth = 1;
    //形状层添加旋转动画
    [shapeLayer addAnimation:[self rotationAnimation:transX] forKey:@"rotateAnimation"];
    
    //初始化复制层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    //复制层矩形
    replicatorLayer.frame = CGRectMake(0, 0, radius, radius);
    //指定复制副本之间的延迟（秒）
    replicatorLayer.instanceDelay = 0.0;
    //要创建的副本数
    replicatorLayer.instanceCount = 3;
    //初始化标准变换矩阵
    CATransform3D trans3D = CATransform3DIdentity;
    //将t转换为（tx，ty，tz）并返回结果
    trans3D = CATransform3DTranslate(trans3D, transX, 0, 0);
    //围绕向量（x，y，z）按角度弧度旋转t并返回结果，如果向量的长度为零，则行为未定义
    trans3D = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    //复制矩阵
    replicatorLayer.instanceTransform = trans3D;
    //添加形状层到复制层容器
    [replicatorLayer addSublayer:shapeLayer];
    //返回复制层
    return replicatorLayer;
}

// 网格动画
+ (CALayer *)replicatorLayer_Grid{
    //矩阵行数
    NSInteger column = 3;
    //间距
    CGFloat between = 5.0;
    //半径
    CGFloat radius = (100 - between * (column - 1))/column;
    //初始化形状层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //形状层框架矩形
    shapeLayer.frame = CGRectMake(0, 0, radius, radius);
    //形状层路径为根据矩形绘制的椭圆形路径
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    //填充形状路径的颜色
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    
    //初始化分组动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //设置动画组(缩放动画、透明度动画)
    animationGroup.animations = @[[self scaleAnimation1], [self alphaAnimation]];
    //动画持续时间
    animationGroup.duration = 1.0;
    //动画结束是否执行逆动画
    animationGroup.autoreverses = YES;
    //动画重复次数为无限重复
    animationGroup.repeatCount = HUGE;
    //形状层添加分组动画
    [shapeLayer addAnimation:animationGroup forKey:@"groupAnimation"];
    
    //初始化X轴向复制层
    CAReplicatorLayer *replicatorLayerX = [CAReplicatorLayer layer];
    //X轴向复制层框架矩形
    replicatorLayerX.frame = CGRectMake(0, 0, 100, 100);
    //指定复制副本之间的延迟（秒）
    replicatorLayerX.instanceDelay = 0.3;
    //要创建的副本数
    replicatorLayerX.instanceCount = column;
    //复制矩阵
    replicatorLayerX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, radius+between, 0, 0);
    //将形状层添加到X轴向复制层容器
    [replicatorLayerX addSublayer:shapeLayer];
    
    //初始化Y轴向复制层
    CAReplicatorLayer *replicatorLayerY = [CAReplicatorLayer layer];
    //Y轴向复制层框架矩形
    replicatorLayerY.frame = CGRectMake(0, 0, 100, 100);
    //指定复制副本之间的延迟（秒）
    replicatorLayerY.instanceDelay = 0.3;
    //要创建的副本数
    replicatorLayerY.instanceCount = column;
    //复制矩阵
    replicatorLayerY.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, radius+between, 0);
    //将X轴向复制层容器添加到Y轴向复制层容器
    [replicatorLayerY addSublayer:replicatorLayerX];
    //返回Y轴向复制层容器
    return replicatorLayerY;
}

// 震动条动画
+ (CALayer *)replicatorLayer_Shake{
    //初始化层对象
    CALayer *layer = [[CALayer alloc]init];
    //层对象框架矩形
    layer.frame = CGRectMake(0, 0, 2, 12);
    //设置圆角
    layer.cornerRadius = 1.f;
    //设置层背景色
    layer.backgroundColor = [UIColor redColor].CGColor;
    //定义层边界矩形的定位点，可设置动画
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    // 添加一个对Y方向进行缩放的基本动画
    [layer addAnimation:[self scaleYAnimation] forKey:@"scaleAnimation"];
    
    //初始化复制层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    //复制层框架矩形
    replicatorLayer.frame = CGRectMake(0, 0, 80, 80);
    //要创建的副本数
    replicatorLayer.instanceCount = 3;
    //复制矩阵
    replicatorLayer.instanceTransform =  CATransform3DMakeTranslation(4, 0, 0);
    //指定复制副本之间的延迟（秒）
    replicatorLayer.instanceDelay = 0.2;
    //为每个复制的实例定义添加到组件的颜色的绿色偏移量，可设置动画
    replicatorLayer.instanceGreenOffset = 10;
    //将层对象添加到复制层容器
    [replicatorLayer addSublayer:layer];
    //返回复制层容器
    return replicatorLayer;
}

// 转圈动画
+ (CALayer *)replicatorLayer_Round{
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(0, 0, 12, 12);
    layer.cornerRadius = 6;
    layer.masksToBounds = YES;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    layer.backgroundColor = [UIColor purpleColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [layer addAnimation:animation forKey:nil];
    
    NSInteger instanceCount = 9;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, 50, 50);
    replicatorLayer.preservesDepth = YES;
    replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;
    replicatorLayer.instanceRedOffset = 0.1;
    replicatorLayer.instanceGreenOffset = 0.1;
    replicatorLayer.instanceBlueOffset = 0.1;
    replicatorLayer.instanceAlphaOffset = 0.1;
    replicatorLayer.instanceCount = instanceCount;
    replicatorLayer.instanceDelay = 1.0/instanceCount;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) /instanceCount, 0, 0, 1);
    [replicatorLayer addSublayer:layer];
    
    return replicatorLayer;
}

// 心动画
+ (CALayer *)replicatorLayer_Heart{
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer new];
    replicatorLayer.frame = CGRectMake(0, 0, 200, 200);
    //    replicatorLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
    
    CALayer *subLayer = [CALayer new];
    subLayer.bounds = CGRectMake(60, 105, 10, 10);
    subLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    subLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    subLayer.borderWidth = 1.0;
    subLayer.cornerRadius = 5.0;
    subLayer.shouldRasterize = YES;
    subLayer.rasterizationScale = [UIScreen mainScreen].scale;
    [replicatorLayer addSublayer:subLayer];
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    move.path = [self heartPath];
    move.repeatCount = INFINITY;
    move.duration = 6.0;
    //    move.autoreverses = YES;
    [subLayer addAnimation:move forKey:nil];
    
    replicatorLayer.instanceDelay = 6/50.0;
    replicatorLayer.instanceCount = 50;
    replicatorLayer.instanceColor = [UIColor orangeColor].CGColor;
    replicatorLayer.instanceGreenOffset = -0.03;
    
    return replicatorLayer;
}

// 翻转动画
+ (CALayer *)replicatorLayer_Turn
{
    CGFloat margin = 8.0;
    CGFloat width = 80;
    CGFloat dotW = (width - 2 * margin) / 3;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, (width - dotW) * 0.5, dotW, dotW);
    shapeLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, dotW, dotW)].CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, width, width);
    replicatorLayer.instanceDelay = 0.1;
    replicatorLayer.instanceCount = 3;
    CATransform3D transform = CATransform3DMakeTranslation(margin + dotW, 0, 0);
    
    replicatorLayer.instanceTransform = transform;
    [replicatorLayer addSublayer:shapeLayer];
    
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, 0, 0, 1.0, 0)];
    basicAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1.0, 0)];
    basicAnima.repeatCount = HUGE;
    basicAnima.duration = 0.6;
    
    [shapeLayer addAnimation:basicAnima forKey:nil];
    
    return replicatorLayer;
}

#pragma mark -----------------------  基础动画

+ (CGPathRef)heartPath
{
    CGFloat W = 25;
    CGFloat marginX = 10;
    CGFloat marginY = 15/25.0 * W;
    CGFloat space = 5/25.0 * W;
    
    UIBezierPath *bezierPath = [UIBezierPath new];
    
    [bezierPath moveToPoint:(CGPointMake(marginX + W * 2, W * 4 + space))];
    [bezierPath addQuadCurveToPoint:CGPointMake(marginX, W * 2) controlPoint:CGPointMake(W, W * 4 - space)];
    [bezierPath addCurveToPoint:CGPointMake(marginX + W * 2, W * 2) controlPoint1:CGPointMake(marginX, marginY) controlPoint2:CGPointMake(marginX + W * 2, marginY)];
    [bezierPath addCurveToPoint:CGPointMake(marginX + W * 4, W * 2) controlPoint1:CGPointMake(marginX + W * 2, marginY) controlPoint2:CGPointMake(marginX + W * 4, marginY)];
    [bezierPath addQuadCurveToPoint:CGPointMake(marginX + W * 2, W * 4 + space) controlPoint:CGPointMake(marginX * 2 + W * 3, W * 4 - space)];
    
    [bezierPath closePath];
    
    CGAffineTransform T = CGAffineTransformMakeScale(3.0, 3.0);
    return CGPathCreateCopyByTransformingPath(bezierPath.CGPath, &T);
}


+ (CABasicAnimation *)scaleYAnimation{
    //对Y方向进行缩放的基本动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    //缩放结束值
    anim.toValue = @0.1;
    //动画持续时间
    anim.duration = 0.4;
    //动画完成后是否在层中移除
    anim.removedOnCompletion = NO;
    //动画结束是否执行逆动画
    anim.autoreverses = YES;
    //动画重复次数为无限重复
    anim.repeatCount = MAXFLOAT;
    //返回/对Y方向进行缩放的基本动画
    return anim;
}

///透明度动画
+ (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    return alpha;
}

///缩放动画
+ (CABasicAnimation *)scaleAnimation{
    //初始化缩放基本动画
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    //缩放起始值
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    //缩放结束值
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    //返回缩放基本动画
    return scale;
}

///缩放动画
+ (CABasicAnimation *)scaleAnimation1{
    //初始化缩放基本动画
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    //缩放起始值
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    //缩放结束值
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0)];
    //动画结束时执行逆动画
    scale.autoreverses = YES;
    //动画重复次数无限重复
    scale.repeatCount = HUGE;
    //动画持续时间
    scale.duration = 0.6;
    //返回缩放基本动画
    return scale;
}

///旋转动画
+ (CABasicAnimation *)rotationAnimation:(CGFloat)transX{
    //初始化旋转基本动画
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    //围绕向量（x，y，z）按角度弧度旋转t并返回结果，如果向量的长度为零，则行为未定义
    CATransform3D fromValue = CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0);
    //旋转起始值
    scale.fromValue = [NSValue valueWithCATransform3D:fromValue];
    //将t转换为（tx，ty，tz）并返回结果
    CATransform3D toValue = CATransform3DTranslate(CATransform3DIdentity, transX, 0.0, 0.0);
    //围绕向量（x，y，z）按角度弧度旋转t并返回结果
    toValue = CATransform3DRotate(toValue,120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    //旋转结束值
    scale.toValue = [NSValue valueWithCATransform3D:toValue];
    //动画结束时执行逆动画
    scale.autoreverses = NO;
    //动画重复次数无限重复
    scale.repeatCount = HUGE;
    //定义动画速度的可选计时函数为缓入缓出
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画持续时间
    scale.duration = 0.8;
    //返回旋转动画
    return scale;
}

@end
