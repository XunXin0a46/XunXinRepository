//
//  ShoppingCartIconView.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/25.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartIconView : UIView

@property (assign, readonly, nonatomic) NSInteger cartCount;//返回购物车当前角标显示数值

- (void)setCartNumber:(NSString *)cartNumber;//设置购物车角标

@end

