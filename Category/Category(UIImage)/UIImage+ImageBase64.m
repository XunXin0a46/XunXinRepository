//
//  UIImage+ImageBase64.m
//  YiShopCustomer
//
//  Created by 骆超然 on 2018/8/10.
//  Copyright © 2018年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "UIImage+ImageBase64.h"

@implementation UIImage (ImageBase64)

///对图片进行base64编码
- (NSString *)ysc_base64Encoding {
    //以JPEG格式返回包含指定图像的数据对象
    NSData *data = UIImageJPEGRepresentation(self, 0.5);
    //使用给定选项创建Base64编码字符串
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

///解析Base64编码字符串
+ (UIImage *)ysc_imageWithBase64EncodingString:(NSString *)string {
    //使用给定的Base64编码字符串初始化数据对象
    NSData *data =[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //返回使用指定图像数据创建的图像对象
    return [UIImage imageWithData:data];
}

///图像缩放和裁剪
+ (UIImage*)imageByScalingAndCroppingForSizeWithImage:(UIImage *)sourceImage maxWidth:(CGFloat)maxWidth {
    //声明新图像对象
    UIImage *newImage = nil;
    //获取参数图像的宽
    CGFloat width = sourceImage.size.width;
    //获取参数图像的高
    CGFloat height = sourceImage.size.height;
    //限制的最大值
    CGFloat max = 1280;
    //如果设置的图像宽度大于0并且图像的宽小于限制的最大值
    if (maxWidth > 0 && width < max) {
        //将限制的最大值设置为设置的图像宽度
        max = maxWidth;
    }
    //声明缩放宽度
    CGFloat scaledWidth = 0;
    //声明缩放高度
    CGFloat scaledHeight = 0;
    //声明缩略图点
    CGPoint thumbnailPoint = CGPointMake(0,0);
    //判断参数图像的宽是否大于参数图像的高
    if (width > height){
        //设置缩放宽度
        scaledWidth = max;
        //设置缩放高度
        scaledHeight = (scaledWidth * height) / width;
    } else{
        //设置缩放高度
        scaledHeight = max;
        //设置缩放宽度
        scaledWidth = (scaledHeight * width) / height;
    }
    
    //开启图像上下文
    //floorf 向下取整 解决白边的bug
    UIGraphicsBeginImageContext(CGSizeMake(floorf(scaledWidth), floorf(scaledHeight)));
    //缩略图矩形
    CGRect thumbnailRect = CGRectZero;
    //缩略图矩形原点
    thumbnailRect.origin = thumbnailPoint;
    //缩略图宽
    thumbnailRect.size.width = floorf(scaledWidth);
    //缩略图高
    thumbnailRect.size.height = floorf(scaledHeight);
    //绘制缩略图
    [sourceImage drawInRect:thumbnailRect];
    //获取当前基于位图的图形上下文的内容返回的图像
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //如果图像获取失败，打印错误
    if(newImage == nil)
        NSLog(@"could not scale image");
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //返回新的图像
    return newImage;
}

@end
