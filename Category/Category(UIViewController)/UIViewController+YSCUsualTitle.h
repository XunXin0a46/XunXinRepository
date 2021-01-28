//
//  UIViewController+YSCUsualTitle.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(YSCUsualTitle) 

///设置导航栏通用的返回按钮
- (void)setUpCommonHeader;

///设置导航栏标题视图
- (void)createNavigationTitleView:(NSString *)text;

///返回安全区的高度
CGFloat bottomPadding(void);

@end

@interface UIViewController()

@end

