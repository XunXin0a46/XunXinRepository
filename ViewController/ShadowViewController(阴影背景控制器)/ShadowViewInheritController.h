//
//  ShadowViewInheritController.h
//  YiShopCustomer
//
//  Created by 骆超然 on 2017/5/15.
//  Copyright © 2017年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShadowViewInheritController : UIViewController

@property (nonatomic, copy)NSString * _Nullable toastMsg;
@property (nonatomic, assign) BOOL shadowAble;//点击阴影部分不关闭控制器 YES不关闭 NO关闭

- (void)touchesBegan:(NSSet<UITouch *> *_Nullable)touches withEvent:(UIEvent *_Nullable)event;

- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil message:(NSString *_Nullable)message;

@end
