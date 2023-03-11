//
//  UITabBar+Badge.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/1/31.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UITabBar (Badge)

/// 更新购物车商品数量角标视图文本和背景色
- (void)updateBadge:(NSString *)badge bgColor:(UIColor *)bgColor atIndex:(NSInteger)index;

/// 更新购物车商品数量角标视图文本
- (void)updateBadge:(NSString *)badge atIndex:(NSInteger)index;

/// 更新购物车商品数量角标视图文本颜色
- (void)updateBadgeTextColor:(UIColor *)textColor atIndex:(NSInteger)index;

/// 更新购物车商品数量角标视图背景色
- (void)updateBadgeBgColor:(UIColor *)bgColor atIndex:(NSInteger)index;

/// 更新购物车商品数量角标视图文本字体
- (void)updateBadgeTextFont:(UIFont *)textFont atIndex:(NSInteger)index;

/// 显示购物车商品数量角标视图
- (void)showBadgeViewAtIndex:(NSUInteger)index;

/// 隐藏购物车商品数量角标视图
- (void)hideBadgeViewAtIndex:(NSUInteger)index;


@end


