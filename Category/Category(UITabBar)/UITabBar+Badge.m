//
//  UITabBar+Badge.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/1/31.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "UITabBar+Badge.h"
#import "BadgeView.h"
#import <objc/runtime.h>

@interface UITabBar ()

@property (nonatomic, strong) NSMutableDictionary *badgeDict;//存储标签栏自定义角标的字典

@end

@implementation UITabBar (Badge)

///懒加载存储标签栏自定义角标的字典
- (NSMutableDictionary *)badgeDict {
    //判断字典是否存在
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        //不存在，初始化字典
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
        //设置字典与self关联
        objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN);
    }
    //返回字典
    return dict;
}

- (BadgeView *)badgeViewAtIndex:(NSInteger)index {
    //判断字典中保存的签栏自定义角标视图对象是否大于1个(保证只有一个自定义角标显示在标签栏中)
    if(self.badgeDict.allValues.count > 1){
        //遍历存储自定义角标视图对象的字典
        [self.badgeDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            //将key转为NSNumber类型，key为自定义角标所在的标签项所在标签栏的索引
            NSNumber *temp = (NSNumber *)key;
            //如果在字典中获取的对象是自定义角标视图对象，且其索引不等于设置的自定义角标需要显示的在导航栏中的索引
            if ([self.badgeDict[key] isKindOfClass:[BadgeView class]] && ![temp isEqualToNumber:@(index)]) {
                //将自定义角标视图在父视图中移除
                [self.badgeDict[key] removeFromSuperview];
            }else{
                //添加自定义角标视图到导航栏
                [self addSubview:self.badgeDict[key]];
            }
        }];
    }
    //获取字典中保存的自定义角标视图
    BadgeView *badgeView =  [self.badgeDict objectForKey:@(index)];
    //如果在字典中没有获取到保存的自定义角标视图并且导航栏中存在导航项
    if (!badgeView && self.items.count > 0) {
        //初始化自定义角标视图
        badgeView = [[BadgeView alloc] init];
        //调整视图的大小，使其只包含它的子视图
        [badgeView sizeToFit];
        //获取导航栏每个导航项的宽度
        CGFloat tabItemWidth = self.bounds.size.width / self.items.count;
        //获取自定义角标视图的框架矩形
        CGRect frame = badgeView.frame;
        //设置自定义角标视图的框架矩形的原点
        frame.origin = CGPointMake(tabItemWidth * index + tabItemWidth / 2 + 2, 5);
        //设置自定义角标视图的框架矩形
        badgeView.frame = frame;
        //添加自定义角标视图到导航栏中
        [self addSubview:badgeView];
        //自定义角标视图显示在其同级视图的顶部
        [self bringSubviewToFront:badgeView];
        //存储添加自定义角标视图对象到字典中
        [self.badgeDict setObject:badgeView forKey:@(index)];
    }
    //返回添加的自定义角标视图
    return badgeView;
}

///更新BadgeView标签文本和背景颜色
- (void)updateBadge:(NSString *)badgeValue bgColor:(UIColor *)bgColor atIndex:(NSInteger)index {
    if (index >= 0 && index < self.items.count) {
        BadgeView *badgeView = [self badgeViewAtIndex:index];
        
        if (badgeView) {
            //设置背景颜色
            badgeView.bgColor = bgColor;
            //设置标签显示文本
            badgeView.badgeValue = badgeValue;
        }
    }
}


/// 更新BadgeView标签文本
- (void)updateBadge:(NSString *)badgeValue atIndex:(NSInteger)index {
    if (index >= 0 && index < self.items.count) {
        BadgeView *badgeView = [self badgeViewAtIndex:index];
        
        if (badgeView) {
            //设置标签显示文本
            badgeView.badgeValue = badgeValue;
        }
    }
}

/// 更新购物车商品数量角标视图文本颜色
- (void)updateBadgeTextColor:(UIColor *)textColor atIndex:(NSInteger)index {
    if (index >= 0 && index < self.items.count) {
        BadgeView *badgeView = [self badgeViewAtIndex:index];

        if (badgeView) {
            badgeView.textColor = textColor;
        }
    }
}

/// 更新购物车商品数量角标视图背景色
- (void)updateBadgeBgColor:(UIColor *)bgColor atIndex:(NSInteger)index {
    if (index >= 0 && index < self.items.count) {
        BadgeView *badgeView = [self badgeViewAtIndex:index];

        if (badgeView) {
            badgeView.bgColor = bgColor;
        }
    }
}

/// 更新购物车商品数量角标视图文本字体
- (void)updateBadgeTextFont:(UIFont *)textFont atIndex:(NSInteger)index {
    if (index >= 0 && index < self.items.count) {
        BadgeView *badgeView = [self badgeViewAtIndex:index];

        if (badgeView) {
            badgeView.textFont = textFont;
        }
    }
}

///显示购物车角标数量视图
- (void)showBadgeViewAtIndex:(NSUInteger)index {
    //获取物车商品数量角标视图(如果购物车商品数量角标视图存在)
    BadgeView *badgeView = [self badgeViewAtIndex:index];
    //设置购物车商品数量角标视图显示
    badgeView.hidden = NO;
    //添加购物车商品数量角标视图到工具栏
    [self addSubview:badgeView];
    //购物车商品数量角标视图显示在同级视图的顶部
    [self bringSubviewToFront:badgeView];
}

///隐藏购物车商品数量角标视图
- (void)hideBadgeViewAtIndex:(NSUInteger)index {
    //获取购物车商品数量角标视图(如果购物车商品数量角标视图存在)
    BadgeView *badgeView = [self badgeViewAtIndex:index];
    //在工具栏中移除购物车商品数量角标视图
    [badgeView removeFromSuperview];
    //设置购物车商品数量角标视图隐藏
    badgeView.hidden = YES;
}


@end
