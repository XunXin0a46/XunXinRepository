//
//  UIImage+YSCCodeImage.h
//  YiShopCustomer
//
//  Created by 孙晓松 on 2018/1/15.
//  Copyright © 2018年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  生成条形码、二维码的分类

#import <UIKit/UIKit.h>

@interface UIImage (YSCCodeImage)

///生成条形码
+ (UIImage *)barcodeImageWithContent:(NSString *)content
                       codeImageSize:(CGSize)size
                                 red:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue;
///生成二维码
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;


@end
