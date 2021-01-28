//
//  UIImage+YSCTintColor.h
//  YiShopCustomer
//
//  Created by 骆超然 on 2018/3/30.
//  Copyright © 2018年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YSCTintColor)

///修改纯色图片颜色
- (UIImage *)imageWithTintTheColor:(UIColor *)tintColor;

///绘制带有文本、颜色、圆角的图片(静态函数)
+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font fillColor:(CGColorRef)fillColor cornerRadius:(CGFloat)cornerRadius;

///设置图片圆角
- (UIImage *)setCornerRadius:(CGFloat)cornerRadius;

///绘制指定字体的文本到图片中
- (UIImage *)addText:(NSString *)text withFont:(UIFont *)font;

///绘制指定字体、颜色的文本到图片中
- (UIImage *)addText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)textColor;

@end
