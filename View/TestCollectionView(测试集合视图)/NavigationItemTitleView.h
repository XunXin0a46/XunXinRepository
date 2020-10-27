//
//  NavigationItemTitleView.h
//  YiShopCustomer
//
//  Created by 王刚 on 2020/5/7.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavigationItemTitleView : UIView

@property(nonatomic, assign) CGSize intrinsicContentSize; //重写intrinsicContentSize属性
@property(nonatomic, strong) UILabel *titleLabel; //标题标签
@property(nonatomic, strong) UIButton *orderTypeSelectionButton; //订单类型选择按钮
@property(nonatomic, strong) UIButton *labelMakeButton;//标题标签遮罩按钮

@end

