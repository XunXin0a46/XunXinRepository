//
//  TestUtils.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/7.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TestUtils : NSObject

/// 获取当前视图控制器
+ (UIViewController *)getCurrentVC;

///返回单个字符的大小
+ (CGSize)singleCharactorSizeWithFont:(UIFont *)font;

///修改图片大小后返回图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

///根据描述Url字符串配置资源
+ (NSString *)configResource:(NSString *)resource DescUrlString:(NSString *)string;

///图片路径字符串转为Url
+ (NSURL *)urlOfRealImage:(NSString *)imageUrl;

///yyyy-MM-dd格式化字符串
+ (NSString *)getDateStringWithTimeInterval:(NSInteger)timeInterval;

///yyyy-MM-dd HH:mm:ss格式化字符串
+ (NSString *)getDateDetailStringWithTimeInterval:(NSInteger)timeInterval;

///MM-dd HH:mm格式化字符串
+ (NSString *)getMonthDateStringWithTimeInterval:(NSInteger)timeInterval;

///XX天XX小时XX分钟XX秒 格式化字符串
+ (NSString *)getTimeStringWithTimeInterval:(NSInteger)timeInterval;

@end


