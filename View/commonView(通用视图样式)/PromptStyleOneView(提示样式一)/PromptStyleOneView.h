//
//  PromptStyleOneView.h
//  YiShopCustomer
//
//  Created by 王刚 on 2020/12/18.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptStyleOneView : UIView

@property (nonatomic, strong) NSURL *imageURL;//图片链接
@property (nonatomic, strong) UIImage *image;//显示的图片
@property (nonatomic, copy) NSString *operationButtonTitle;//操作按钮标题
@property (nonatomic, copy) void (^operationButtonClickBlock)(void);//操作按钮回调函数

///设置显示标题与消息
- (void)setTitle:(NSString *)title WithTitleFont:(UIFont *)titleFont WithMessage:(NSString *)message
 WithMessageFont:(UIFont *)messageFont;

@end

