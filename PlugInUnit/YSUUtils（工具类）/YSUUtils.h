//
//  YSUUtils.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

id isNil(id obj);

@interface YSUUtils : NSObject

///是否是3.7英寸的设备
+ (BOOL)isThreeSevenInchDevice;
///是否是4.0英寸的设备
+ (BOOL)isFourZeroInchDevice;
///是否是4.7英寸的设备
+ (BOOL)isFourSevenInchDevice;
///是否是5.5英寸的设备
+ (BOOL)isFiveFiveInchDevice;
///是否是5.8英寸的设备
+ (BOOL)isFiveEightInchDevice;
///是否是空的字符串
+ (BOOL)isNullString:(NSString *)string;
///将16进制的颜色字符串转换为颜色
+ (UIColor *)colorOfHexString:(NSString *)hexString;
///将键值写入default文件
+ (BOOL)writeToFileWithKey:(NSString *)key AndValue:(id)value;
///将键值写入指定的文件
+ (BOOL)writeToFile:(NSString *)fileName withKey:(NSString *)key andValue:(id)value;
///读取default文件的键值
+ (id)readFileWithKey:(NSString *)key;
///读取指定文件的键值
+ (id)readFile:(NSString *)fileName withKey:(NSString *)key;
///缩放图片
+ (UIImage *)shrinkImage:(UIImage *)image maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
///使用浏览器打开指定的路径 例如@"https://www.baidu.com"
+ (BOOL)openBrowser:(NSString *)urlString;
///删除Url的额外斜杠
+ (NSString *)removeExtraSlashOfUrl:(NSString *)url;
///获取域名 例如@"http://www.test.68mall.com"获取@"test.68mall.com"
+ (NSString *)getDomain:(NSString *)url;
///生成二维码图片
+ (UIImage *)QRCodeImageWithContent:(NSString *)content imageSize:(CGSize)imageSize logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize;
///修改导航栏和底部Tabbar分割线颜色用到的方法(返回制定大小与颜色的UIImage对象)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
