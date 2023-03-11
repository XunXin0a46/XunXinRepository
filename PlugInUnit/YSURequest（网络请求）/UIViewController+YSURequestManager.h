//
//  UIViewController+YSURequestManager.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSURequestManager.h"

@interface UIViewController(YSURequestManager)<YSURequestDelegate>

///设置请求管理器
- (void)setRequestManager:(YSURequestManager *)manager;
///添加请求
- (void)addRequest:(YSURequest *)request;

@end
