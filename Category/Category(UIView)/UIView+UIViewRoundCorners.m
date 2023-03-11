//
//  UIView+UIViewRoundCorners.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "UIView+UIViewRoundCorners.h"

@implementation UIView (UIViewRoundCorners)

///为视图添加指定位置圆角
- (void)viewAddCornerRadius:(UIView *)view applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius{
    //初始化一个圆角矩形贝塞尔路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    //初始化形状层
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    //设置形状层框架矩形
    maskLayer.frame = view.bounds;
    //设置要渲染的形状的路径
    maskLayer.path = maskPath.CGPath;
    //设置参数视图遮罩层
    view.layer.mask = maskLayer;
}

///绘制指定圆角的边框
- (void)applyRoundCornersBorder:(UIRectCorner)corners radius:(CGFloat)radius{
    //初始化一个圆角矩形贝塞尔路径
    UIBezierPath *outerBorderPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    //初始化形状层
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    //设置要渲染的形状的路径
    borderLayer.path = outerBorderPath.CGPath;
    //指定形状路径的线宽
    borderLayer.lineWidth = 2.0;
    //设置形状层的框架矩形
    borderLayer.frame = self.bounds;
    //用于填充形状路径的颜色
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    // 用于绘制形状路径的颜色
    borderLayer.strokeColor = [UIColor greenColor].CGColor;
    //添加形状层到接收器视图
    [self.layer addSublayer:borderLayer];
}

/// 添加四边阴影效果
- (void)addShadowWithColor:(UIColor *)theColor{
    // 阴影颜色
    self.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.15;
    // 阴影半径，默认3
    self.layer.shadowRadius = 3;
}

///移除四边阴影效果
-(void)removeShadow{
    // 阴影颜色
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0;
    // 阴影半径，默认3
    self.layer.shadowRadius = 0;
}

@end
