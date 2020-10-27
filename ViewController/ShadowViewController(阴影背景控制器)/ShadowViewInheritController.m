//
//  ShadowViewInheritController.m
//  YiShopCustomer
//
//  Created by 骆超然 on 2017/5/15.
//  Copyright © 2017年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "ShadowViewInheritController.h"

@interface ShadowViewInheritController ()

@end

@implementation ShadowViewInheritController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.definesPresentationContext = NO;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.definesPresentationContext = NO;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil message:(NSString *)msg{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.toastMsg = msg;
        self.definesPresentationContext = NO;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

}

///发生新的触摸事件时调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //如果此控制器以模态方式显示
    if (self.presentingViewController) {
        //获取触摸对象
        UITouch *touch = [touches anyObject];
        if ([touch.view isEqual:self.view] && self.shadowAble == NO) {
            [self.view endEditing:YES];
            [self cancel];
        }
    }
}

@end
