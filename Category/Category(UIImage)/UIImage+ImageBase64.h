//
//  UIImage+ImageBase64.h
//  YiShopCustomer
//
//  Created by 骆超然 on 2018/8/10.
//  Copyright © 2018年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageBase64)

///对图片进行base64编码
- (NSString *)ysc_base64Encoding;

///解析Base64编码字符串
+ (UIImage *)ysc_imageWithBase64EncodingString:(NSString *)string;

///图像缩放和裁剪
+ (UIImage*)imageByScalingAndCroppingForSizeWithImage:(UIImage *)sourceImage maxWidth:(CGFloat)maxWidth;

@end
