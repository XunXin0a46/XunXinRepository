//
//  UIViewController+Intent.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/14.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YSUIntent.h"
#import "YSUError.h"

FOUNDATION_EXTERN NSInteger const RESULT_OK;
FOUNDATION_EXTERN NSInteger const RESULT_CANCELED;
FOUNDATION_EXTERN NSInteger const RESULT_QUICK_BUY;

@interface UIViewController(Intent)<UIViewControllerIntentDelegate>

///根据类名打开视图控制器
- (YSUError *)openClass:(NSString *)className;
///打开目标控制器
- (YSUError *)openIntent:(YSUIntent *)intent;
///打开目标控制器，并传递申请码
- (YSUError *)openIntent:(YSUIntent *)intent withRequestCode:(NSInteger)requestCode;
///关闭当前控制器，并传回申请码RESULT_CANCELED
- (void)cancel;
///当前控制器完成了所有操作，关闭控制器，内部调用了cancel函数
- (void)finish;
///当前控制器完成了所有操作，关闭控制器，并传递完成码
- (void)finishWithResultCode:(NSInteger)resultCode;
///当前控制器完成了所有操作，关闭控制器，并传递完成码与一个存储数据的字典
- (void)finishWithResultCode:(NSInteger)resultCode andResultData:(NSDictionary *)resultData;
///设置YSUIntent对象
- (void)setIntent:(YSUIntent *)intent;
///获取YSUIntent对象
- (YSUIntent *)getIntent;
///设置关闭
- (void)setClosed:(BOOL)closed;
///是否已经关闭
- (BOOL)isClosed;

@end
