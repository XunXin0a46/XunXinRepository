//
//  YSUUtils.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSUUtils.h"
#import "NSString+Extention.h"

id isNil(id obj) {
    if (!obj){
        return [NSNull null];
    }else {
        return obj;
    }        
}

@implementation YSUUtils

///3.7英寸的设备
+ (BOOL)isThreeSevenInchDevice {
    return (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 480) || (SCREEN_WIDTH == 480 && SCREEN_HEIGHT == 320);
}

///4.0英寸的设备
+ (BOOL)isFourZeroInchDevice {
    return (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 568) || (SCREEN_WIDTH == 568 && SCREEN_HEIGHT == 320);
}

///4.7英寸的设备
+ (BOOL)isFourSevenInchDevice {
    return (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667) || (SCREEN_WIDTH == 667 && SCREEN_HEIGHT == 375);
}

///5.5英寸的设备
+ (BOOL)isFiveFiveInchDevice {
    return (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736) || (SCREEN_WIDTH == 736 && SCREEN_HEIGHT == 414);
}

///5.8英寸的设备
+ (BOOL)isFiveEightInchDevice {
    return (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812) || (SCREEN_WIDTH == 812 && SCREEN_HEIGHT == 375);
}

///是空的字符串
+ (BOOL)isNullString:(NSString*)string {
    return !string || !string.length || string.length == 0 || [string trim].length == 0;
}

///将16进制的颜色字符串转换为颜色
+ (UIColor*)colorOfHexString:(NSString*)hexString {
    //获取描给定字符串的NSScanner对象
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    //如果给定的字符串以#开头
    if ([hexString hasPrefix:@"#"]) {
        //设置开始下一次扫描操作的字符位置
        [scanner setScanLocation:1];
    }
    //声明无符号整型
    //unsigned若省略后一个关键字，大多数编译器都会认为是unsigned int
    unsigned hexNum;
    //如果接收器找到有效的十六进制整数表示形式，则返回YES，否则返回NO
    if (![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    
    int r = (hexNum >> 16) & 0xFF;
    int g = (hexNum >> 8) & 0xFF;
    int b = (hexNum)&0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

///将键值写入default文件
+ (BOOL)writeToFileWithKey:(NSString*)key AndValue:(NSString*)value {
    return [YSUUtils writeToFile:@"default" withKey:key andValue:value];
}

///将键值写入指定的文件
+ (BOOL)writeToFile:(NSString*)fileName withKey:(NSString*)key andValue:(NSString*)value{
    //在用户的主目录安装用户个人项目（~）的位置创建文档目录搜索路径列表，如果expandTilde为YES，则将按照stringByExpandingTildeInPath中的说明展开波浪号
    NSArray* paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //判断是否有路径列表
    if ([paths count] > 0) {
        //将文件名称附加到路径列表中的第一个路径
        NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        //使用给定路径指定的文件中的键和值创建字典，如果存在文件错误或文件内容是字典的无效表示，则为nil
        NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        //如果使用给定路径指定的文件中的键和值创建字典为nil
        if (dictionary == nil) {
            //使用指定的键和值集构造的条目初始化新分配的字典
            dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:value, key, nil];
        } else {
            //在字典中设置键值对
            [dictionary setValue:value forKey:key];
        }
        //将字典内容的属性列表表示形式写入给定路径，如果文件写入成功，则为YES，否则为NO。
        //属性列表对象即 NSData, NSDate, NSNumber, NSString, NSArray，或NSDictionary的实例
        return [dictionary writeToFile:path atomically:YES];
    } else {
        //返回NO
        return NO;
    }
}

///读取default文件的键值
+ (id)readFileWithKey:(NSString *)key {
    return [YSUUtils readFile:@"default" withKey:key];
}

///读取指定文件的键值
+ (id)readFile:(NSString *)fileName withKey:(NSString *)key {
    //在用户的主目录安装用户个人项目（~）的位置创建文档目录搜索路径列表，如果expandTilde为YES，则将按照stringByExpandingTildeInPath中的说明展开波浪号
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //判断是否有路径列表
    if ([paths count] > 0) {
        //将文件名称附加到路径列表中的第一个路径
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        //使用给定路径指定的文件中的键和值创建字典，如果存在文件错误或文件内容是字典的无效表示，则为nil
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        //如果使用给定路径指定的文件中的键和值创建字典为nil
        if (dictionary == nil) {
            //返回nil
            return nil;
        } else {
            //返回字典中key对应的值
            return [dictionary objectForKey:key];
        }
    } else {
        //返回nil
        return nil;
    }
}

///缩放图片
+ (UIImage *)shrinkImage:(UIImage *)image maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
    //如果图片的宽和高小于要设置的宽和高
    if (image.size.width < maxWidth && image.size.height < maxHeight) {
        //直接返回图片
        return image;
    }
    //获取宽度比例或高度比例中较大的值
    float scaleFactor = MAX (image.size.width / maxWidth, image.size.height / maxHeight);
    //设置图片新的大小
    CGSize newSize = CGSizeMake (image.size.width * scaleFactor, image.size.height * scaleFactor);
    //创建基于位图的图形上下文并使其成为当前上下文。此函数相当于调用UIGraphicsBeginImageContextWithOptions函数，不透明参数设置为NO，比例因子为1.0。
    UIGraphicsBeginImageContext (newSize);
    // 绘制图片
    [image drawInRect:CGRectMake (0, 0, newSize.width, newSize.height)];
    //返回基于当前基于位图的图形上下文的内容的图像
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //堆栈顶部移除当前基于位图的图形上下文
    UIGraphicsEndImageContext ();
    //返回新的图像
    return newImage;
}

///使用浏览器打开指定的路径
+ (BOOL)openBrowser:(NSString *)urlString {
    //将路径字符串转为URL
    NSURL* url = [NSURL URLWithString:urlString];
    //如果URL转换失败，返回NO
    if (!url) {
        return NO;
    }
    //判断浏览器是否能打开URL
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        //使用浏览器打开URL
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
        //返回YES
        return YES;
    } else {
        //返回NO
        return NO;
    }
}

///通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

///处理加载图片URL
+ (NSString *)urlStringOfImage:(NSString *)imageUrl {
    //删除字符串两端的空格字符
    imageUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //如果传递的图片URL不是以@"http://"开头或@"https://"开头
    if (![imageUrl hasPrefix:@"http://"] && ![imageUrl hasPrefix:@"https://"]) {
        //拼接网络图片基URL
        imageUrl = [NSString stringWithFormat:@"%@%@", [TestSharedInstance sharedInstance].imageBaseURL, imageUrl];
        //如果传递的图片URL不是以@".gif"结尾
        if (![imageUrl hasSuffix:@".gif"]) {
            //判断传递的图片URL是否以@".jpg"结尾
            if([imageUrl hasSuffix:@".jpg"]){
                //以@".jpg"结尾
                //判断传递的图片URL是否包含@"x-oss-process"
                if ([imageUrl containsString:@"x-oss-process"]) {
                    //jpg格式
                    imageUrl = [imageUrl stringByAppendingString:@"/format,jpg"];
                } else {
                    //不包含时需要先拼接@"x-oss-process"
                    imageUrl = [imageUrl stringByAppendingString:@"?x-oss-process=image/format,jpg"];
                }
            }else{
                //判断传递的图片URL是否包含@"x-oss-process"
                if ([imageUrl containsString:@"x-oss-process"]) {
                    //WebP格式，设置图片的绝对质量，将原图质量压缩至q%
                    imageUrl = [imageUrl stringByAppendingString:@"/format,webp/quality,q_75"];
                } else {
                    //不包含时需要先拼接@"x-oss-process"
                    imageUrl = [imageUrl stringByAppendingString:@"?x-oss-process=image/format,webp/quality,q_75"];
                }
            }
        }
    }
    //删除Url的额外斜杠
    return [YSUUtils removeExtraSlashOfUrl:imageUrl];
}


///删除Url的额外斜杠
+ (NSString *)removeExtraSlashOfUrl:(NSString *)url {
    //如果URL字符串为空
    if (!url || url.length == 0) {
        //直接返回
        return url;
    }
    //匹配Url的正则
    //(?<!pattern)反向否定查询，如：(?<!7 |8 |8.1 |10)Windows能匹配xpWindows中的Windows，但不能匹配7Windows中的Windows。
    NSString *pattern = @"(?<!(http:|https:))/+";
    NSRegularExpression *expression = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //返回包含替换为模板字符串的匹配正则表达式的新字符串
    return [expression stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, url.length) withTemplate:@"/"];
}

///获取域名
+ (NSString *)getDomain:(NSString *)urlString {
    //将URL字符串转为URL
    NSURL *url =[NSURL URLWithString:urlString];
    //如果URL转换失败，返回nil
    if(!url){
        return nil;
    }
    //获取主机，例如，在URL中http://www.example.com/index.html，主机是www.example.com。
    NSString *host = url.host;
    //根据"."字符拆分字符串
    NSArray *array = [host componentsSeparatedByString:@"."];
    //如果拆分结果数组长度小于2
    if (array.count < 2) {
        //返回nil
        return nil;
    }
    //将拆分结果数组转换为可变数组
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    //移除可变数组的第一个元素
    [mutableArray removeObjectAtIndex:0];
    //在可变数组元素之间插入"."字符
    NSString *domain = [mutableArray componentsJoinedByString:@"."];
    //返回域名字符串
    return domain;
}

///生成二维码图片
+ (UIImage *)QRCodeImageWithContent:(NSString *)content imageSize:(CGSize)imageSize logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize {
    //为二维码类型的筛选器创建CIFilter图像生成对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //将筛选器的所有输入值设置为默认值
    [filter setDefaults];
    //如果存在用于生成二维码的内容字符串
    if (content) {
        //对用于生成二维码的内容字符串进行编码并返回编码后的NSData对象
        NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
        // 设置输入的内容
        [filter setValue:contentData forKey:@"inputMessage"];
        // 设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
        [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
        // 获取输出的CIImage对象，拿到二维码图片
        CIImage *outPutImage = [filter outputImage];
        return [self createNonInterpolatedImageForCIImage:outPutImage imageSize:imageSize logoImage:logoImage logoImageSize:logoImageSize];
    } else {
        //返回nil
        return nil;
    }
}

///为CIImage创建插入Logo的图像
+ (UIImage *)createNonInterpolatedImageForCIImage:(CIImage *)image imageSize:(CGSize)imageSize logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize {
    //返回将二维码图像范围的矩形值转换为整数所得的最小矩形
    CGRect extent = CGRectIntegral(image.extent);
    //获取二维码图像大小与设置的二维码图像大小的宽高比中较小的值
    CGFloat scale = MIN(imageSize.width / CGRectGetWidth(extent), imageSize.height / CGRectGetHeight(extent));
    //计算二维码图像的显示宽度
    size_t width = CGRectGetWidth(extent) * scale;
    //计算二维码图像的显示高度
    size_t height = CGRectGetHeight(extent) * scale;
    
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // 1.创建bitmap;
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    //初始化没有特定呈现目标的上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    //修改图形上下文的插值质量级别
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    //更改上下文坐标空间x轴与y轴的比例因子
    CGContextScaleCTM(bitmapRef, scale, scale);
    //将图像绘制到图形上下文中
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //减少图形上下文的保留计数
    CGContextRelease(bitmapRef);
    //减少位图图像的保留计数
    CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //判断是否有logo图像
    if (logoImage) {
        //为Logo图片设置圆角
        logoImage = [self createRoundedImageWithImage:logoImage cornerRadius:15.0];
        
        //给二维码加 logo 图
        CGRect logoImageRect = CGRectMake((imageSize.width - logoImageSize.width) / 2.0, (imageSize.height - logoImageSize.height)/2.0, logoImageSize.width, logoImageSize.height);
        // 开始一个Image的上下文
        UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
        //在指定的矩形中绘制整个图像，并根据需要缩放。
        [outputImage drawInRect:CGRectMake(0,0 , imageSize.width, imageSize.height)];
        
        //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
        [logoImage drawInRect:logoImageRect];
        //根据当前基于位图的图形上下文的内容返回图像
        outputImage = UIGraphicsGetImageFromCurrentImageContext();
        //从堆栈顶部移除当前基于位图的图形上下文
        UIGraphicsEndImageContext();
    }
    //返回二维码图像
    return outputImage;
}

///创建带圆角的图像
+ (UIImage *)createRoundedImageWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius {
    
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius] addClip];
    // 绘制图片
    [image drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //从堆栈顶部移除当前基于位图的图形上下文
    UIGraphicsEndImageContext();
    //返回处理后的新图像
    return newImage;
}

////修改导航栏和底部Tabbar分割线颜色用到的方法(返回制定大小与颜色的UIImage对象)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    //如果没有设置颜色或图像的宽度或高度小于等于0，返回nil
    if (!color ||
        size.width <= 0 ||
        size.height <= 0){
        return nil;
    }
    //初始化矩形
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    //获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使用CGColor设置图形上下文中的当前填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    //使用当前图形状态下的填充颜色绘制所提供矩形内包含的区域
    CGContextFillRect(context, rect);
    //返回基于当前基于位图的图形上下文的内容的图像。
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    //堆栈顶部移除当前基于位图的图形上下文
    UIGraphicsEndImageContext();
    //返回生成的图片
    return image;
}

///根据路径获取图片的大小
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}


@end
