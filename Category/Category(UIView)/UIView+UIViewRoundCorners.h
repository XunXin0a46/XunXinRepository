//
//  UIView+UIViewRoundCorners.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (UIViewRoundCorners)

///为视图添加指定位置圆角
- (void)viewAddCornerRadius:(UIView *)view applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

///绘制指定圆角的边框
- (void)applyRoundCornersBorder:(UIRectCorner)corners radius:(CGFloat)radius;

///添加四边阴影效果
- (void)addShadowWithColor:(UIColor *)theColor;

///移除四边阴影效果
-(void)removeShadow;

@end

