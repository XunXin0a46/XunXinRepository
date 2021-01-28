//
//  TestUtils.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/7.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestUtils.h"
#import "YSUUtils.h"

@implementation TestUtils

#pragma mark - 获取当前视图控制器

+ (UIViewController *)getCurrentVC {
    //获取窗口对象
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //窗口在z轴上的位置不是默认级别
    if (window.windowLevel != UIWindowLevelNormal){
        //获取应用程序的可见和隐藏窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        //遍历应用程序的可见和隐藏窗口
        for(UIWindow * tmpWin in windows){
            //如果窗口在z轴上的位置是默认级别
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                //设置窗口对象
                window = tmpWin;
                
                break;
                
            }
            
        }
        
    }
    //获取窗口的根视图控制器
    UIViewController *result = window.rootViewController;
    
    //寻找根视图控制器模态显示的控制器
    while (result.presentedViewController) {
        
        result = result.presentedViewController;
        
    }
    //如果视图控制器是工具栏控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        //返回与当前选定的工具项关联的视图控制器。
        result = [(UITabBarController *)result selectedViewController];
        
    }
    //如果视图控制器是导航视图控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        //返回位于导航堆栈顶部的视图控制器
        result = [(UINavigationController *)result topViewController];
        
    }
    //返回视图控制器
    return result;
    
}

#pragma mark -  返回单个字符的大小
//参数font : 字体
+ (CGSize)singleCharactorSizeWithFont:(UIFont *)font {
    NSString *text = @"C";
    return [text sizeWithAttributes:@{NSFontAttributeName: font}];
}

#pragma mark - 修改图片大小后返回图片
//参数img : 图片
//参数size : 修改后的图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    //创建一个临时渲染上下文，在这上面绘制原始图片
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    //在指定的矩形中绘制整个图像，并根据需要缩放。
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //根据当前基于位图的图形上下文的内容返回图像
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    //从堆栈顶部移除当前基于位图的图形上下文
    UIGraphicsEndImageContext();
    //返回缩放图像
    return scaledImage;
}

#pragma mark - 根据描述Url字符串配置资源
//参数resource : html文件名称
//参数string : html文本
+ (NSString *)configResource:(NSString *)resource DescUrlString:(NSString *)string {
    //初始化异常
    NSError *error = nil;
    //读取正在运行的应用程序的捆绑目录中对应resource名称的文件，并使用给定的编码格式解析为字符串
    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resource ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    
    NSString *replacedString;
    if (string) {
        //将读取解析的字符串中所有的default替换为给定的参数文本
        replacedString = [htmlString stringByReplacingOccurrencesOfString:@"default"withString:string];
    }
    
    return replacedString;
}

#pragma mark - 图片路径字符串转为Url
//参数imageUrl : 图片路径字符串
+ (NSURL *)urlOfRealImage:(NSString *)imageUrl {
    //清除图片路径字符串两端所有的空白字符
    imageUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //如果图片路径字符串不以@"http://"开头并且不以@"https://"开头
    if (![imageUrl hasPrefix:@"http://"] && ![imageUrl hasPrefix:@"https://"]) {
        //格式化拼接图片路径字符串
        imageUrl = [NSString stringWithFormat:@"%@%@", @"http://oss.azmbk.com/images/", imageUrl];
    }
    //去除图片路径字符串中多余的/后，将图片路径字符串转为NSURL对象返回
    return [NSURL URLWithString:[YSUUtils removeExtraSlashOfUrl:imageUrl]];
}

#pragma mark -- 日期格式化相关

///yyyy-MM-dd格式化字符串
+ (NSString *)getDateStringWithTimeInterval:(NSInteger)timeInterval{
    //初始化日期格式对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置日期格式
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    //创建从1970年1月1日的00:00:00经过给定秒数的UTC时间的NSDate对象(负数为1970年1月1日的00:00:00之前)
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //将NSDate对象字符串化
    return [dateFormatter stringFromDate:date];
}

///yyyy-MM-dd HH:mm:ss格式化字符串
+ (NSString *)getDateDetailStringWithTimeInterval:(NSInteger)timeInterval{
    //初始化日期格式对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置日期格式
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //创建从1970年1月1日的00:00:00经过给定秒数的UTC时间的NSDate对象(负数为1970年1月1日的00:00:00之前)
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //将NSDate对象字符串化
    return [dateFormatter stringFromDate:date];
}

///MM-dd HH:mm格式化字符串
+ (NSString *)getMonthDateStringWithTimeInterval:(NSInteger)timeInterval{
    //初始化日期格式对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置日期格式
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    //创建从1970年1月1日的00:00:00经过给定秒数的UTC时间的NSDate对象(负数为1970年1月1日的00:00:00之前)
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //将NSDate对象字符串化
    return [dateFormatter stringFromDate:date];
}


@end
