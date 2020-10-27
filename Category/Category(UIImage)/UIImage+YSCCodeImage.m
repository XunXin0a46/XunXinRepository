//
//  UIImage+YSCCodeImage.m
//  YiShopCustomer
//
//  Created by 孙晓松 on 2018/1/15.
//  Copyright © 2018年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "UIImage+YSCCodeImage.h"

@implementation UIImage (YSCCodeImage)

///生成条形码
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    //改变条形码尺寸大小
    UIImage *image = [self barcodeImageWithContent:content codeImageSize:size];
    //获取图像宽高
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    //设置内存大小字节数
    size_t bytesPerRow = imageWidth * 4;
    //分配的内存大小至少为size参数所指定的字节数
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    //创建用于设备相关的RGB颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //创建位图图形上下文
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
    //将图像绘制到图形上下文中
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    //遍历像素, 改变像素点颜色
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i<pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255;
            ptr[2] = green*255;
            ptr[1] = blue*255;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    //读取数据块
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    //创建位图图像
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    //释放读取的数据对象
    CGDataProviderRelease(dataProvider);
    //创建并返回表示指定Quartz 2D图像的图像对象
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    //减少位图图像的保留计数
    CGImageRelease(imageRef);
    //释放位图上下文对象
    CGContextRelease(context);
    //减少颜色空间的保留计数
    CGColorSpaceRelease(colorSpaceRef);
    //返回图像对象
    return resultImage;
}

///改变条形码尺寸大小
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size{
    //生成最原始的条形码
    CIImage *image = [self barcodeImageWithContent:content];
    //获取将源矩形值转换为整数所得的最小矩形
    CGRect integralRect = CGRectIntegral(image.extent);
    //获取宽度或高度比中较小的比例
    CGFloat scale = MIN(size.width/CGRectGetWidth(integralRect), size.height/CGRectGetHeight(integralRect));
    //重新计算宽度和高度
    size_t width = CGRectGetWidth(integralRect)*scale;
    size_t height = CGRectGetHeight(integralRect)*scale;
    //创建灰度色彩空间的对象，各种设备对待颜色的方式都不同，颜色必须有一个相关的色彩空间，否则图像上下文将不知道如何解释相关的颜色值
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    //创建位图图形上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    //使用指定的选项初始化没有特定呈现目标的上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //根据图像对象及图像渲染区域创建Quartz 2D图像
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    //设置图形上下文的插值质量级别
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    //更改上下文中坐标系的比例
    CGContextScaleCTM(bitmapRef, scale, scale);
    //将图像绘制到图形上下文中
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    //从位图图形上下文中的像素数据创建并返回CGImage
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //释放位图上下文对象
    CGContextRelease(bitmapRef);
    //减少位图图像的保留计数
    CGImageRelease(bitmapImage);
    //减少颜色空间的保留计数
    CGColorSpaceRelease(colorSpaceRef);
    //创建并返回表示指定Quartz 2D图像的图像对象
    return [UIImage imageWithCGImage:scaledImage];
}

//生成最原始的条形码
+ (CIImage *)barcodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@(0.00) forKey:@"inputQuietSpace"];
    CIImage *image = qrFilter.outputImage;
    return image;
}

#pragma mark - 生成二维码
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue{
    //改变二维码颜色
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:size red:red green:green blue:blue];
    //有 logo 则绘制 logo
    if (logo != nil) {
        //创建一个基于位图的图形上下文，并使其成为当前上下文
        UIGraphicsBeginImageContext(image.size);
        //在指定的矩形中绘制整个图像，并根据需要缩放以适应（绘制二维码）
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        //在指定的矩形中绘制整个图像，并根据需要缩放以适应（绘制LOGO）
        [logo drawInRect:logoFrame];
        //返回基于当前基于位图的图形上下文的内容的图像。
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        //堆栈顶部移除当前基于位图的图形上下文。
        UIGraphicsEndImageContext();
        //返回绘制的图像
        return resultImage;
    }else{
        return image;
    }
    
}

///改变二维码颜色
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    //改变二维码尺寸大小
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:size];
    //获取图像宽高
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    //设置内存大小字节数
    size_t bytesPerRow = imageWidth * 4;
    //分配的内存大小至少为size参数所指定的字节数
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    //创建用于设备相关的RGB颜色空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //创建位图图形上下文
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
    //将图像绘制到图形上下文中
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    //遍历像素, 改变像素点颜色
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i<pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255;
            ptr[2] = green*255;
            ptr[1] = blue*255;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    //取出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    //创建位图图像
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    //创建并返回表示指定Quartz 2D图像的图像对象
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    //减少位图图像的保留计数
    CGImageRelease(imageRef);
    //释放位图上下文对象
    CGContextRelease(context);
    //减少颜色空间的保留计数
    CGColorSpaceRelease(colorSpaceRef);
    //返回创建的位图图像
    return resultImage;
}

///改变二维码尺寸大小
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size{
    //生成最原始的二维码
    CIImage *image = [self qrCodeImageWithContent:content];
    //获取将源矩形值转换为整数所得的最小矩形
    CGRect integralRect = CGRectIntegral(image.extent);
    //获取宽度或高度比中较小的比例
    CGFloat scale = MIN(size/CGRectGetWidth(integralRect), size/CGRectGetHeight(integralRect));
    //重新计算宽度和高度
    size_t width = CGRectGetWidth(integralRect)*scale;
    size_t height = CGRectGetHeight(integralRect)*scale;
    //创建灰度色彩空间的对象，各种设备对待颜色的方式都不同，颜色必须有一个相关的色彩空间，否则图像上下文将不知道如何解释相关的颜色值
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    //创建位图图形上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    //使用指定的选项初始化没有特定呈现目标的上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //根据图像对象及图像渲染区域创建Quartz 2D图像
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    //设置图形上下文的插值质量级别
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    //更改上下文中坐标系的比例
    CGContextScaleCTM(bitmapRef, scale, scale);
    //将图像绘制到图形上下文中
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    //从位图图形上下文中的像素数据创建并返回CGImage
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //释放位图上下文对象
    CGContextRelease(bitmapRef);
    //减少位图图像的保留计数
    CGImageRelease(bitmapImage);
    //减少颜色空间的保留计数
    CGColorSpaceRelease(colorSpaceRef);
    //创建并返回表示指定Quartz 2D图像的图像对象
    return [UIImage imageWithCGImage:scaledImage];
}

///生成最原始的二维码
+ (CIImage *)qrCodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *image = qrFilter.outputImage;
    return image;
}


/** 遍历 、 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

@end
