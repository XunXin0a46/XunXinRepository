//
//  UIImage+YSCTintColor.m
//  YiShopCustomer
//
//  Created by 骆超然 on 2018/3/30.
//  Copyright © 2018年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "UIImage+YSCTintColor.h"

@implementation UIImage (YSCTintColor)

///修改纯色图片颜色
- (UIImage *)imageWithTintTheColor:(UIColor *)tintColor {
     //UIGraphicsBeginImageContextWithOptions()创建一个临时渲染上下文，在这上面绘制原始图片。第一个参数，size，是缩放图片的尺寸，第二个参数，isOpaque 是用来决定透明度是否被渲染。对没有透明度的图片设置这个参数为NO，可能导致图片有粉红色调。第三个参数scale是显示缩放系数。当设置成0.0，主屏幕的缩放系数将被使用，对视网膜屏显示是2.0或者更高（在iPhone6 Plus 上是 3.0）
    //UIScreen对象定义了基于硬件显示的相关属性,用这个类来获取每一个设备显示屏幕的对象
    //UIScreen.mainScreen.scale:计算屏幕分辨率
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    //框架矩形
    CGRect area = {0, 0, self.size};
    //坐标系X,Y缩放
    CGContextScaleCTM(context, 1.0, -1.0);
    //坐标系平移
    CGContextTranslateCTM(context, 0, -area.size.height);
    //压栈操作，保存一份当前图形上下文
    CGContextSaveGState(context);
    //CGImage：是用来重绘图形，它们在应用时是按照图像的像素矩阵来绘制图片的
    //CGContextClipToMask：裁剪的区域,第一个参数表示context的指针,第二个参数表示裁剪到context的区域,也就是mask图片映射到context的区域,第三个参数表示mask的图片,对于裁剪区域Rect中的点是否变化取决于mask图中的alpha值,若alpha为0,则对应裁剪Rect中的点为透明,若alpha为1,则对应裁剪Rect中的点无变化
    CGContextClipToMask(context, area, self.CGImage);
    //将后续填充操作的颜色设置为接收器表示的颜色。
    [tintColor setFill];
    //填充指定的矩形
    CGContextFillRect(context, area);
    //在没有保存之前，用这个函数还原blend mode.
    CGContextRestoreGState(context);
    //设置blend mode
    CGContextSetBlendMode(context, kCGBlendModeDestinationOver);
    //CGContextDrawImage允许在制定的尺寸和位置上画图,允许在特定边缘或者适应一组图片特征比如faces,裁剪图片。
    CGContextDrawImage(context, area, self.CGImage);
    //从当前环境当中得到重绘的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭当前环境
    UIGraphicsEndImageContext();
    //设置图片的渲染模式：始终绘制图片原始状态
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}

///绘制带有文本、颜色、圆角的图片
+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font fillColor:(CGColorRef)fillColor cornerRadius:(CGFloat)cornerRadius{
    //返回使用指定字体所需要的边框大小
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    //设置图片的框架矩形
    textSize.width = 8.0 + ceil(textSize.width);
    textSize.height = 2.0 + ceil(textSize.height) ;
    CGRect imageFrame = {0, 0, textSize};
    //创建基于位图的图形上下文并使其成为当前上下文。
    UIGraphicsBeginImageContext(imageFrame.size);
    //返回当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使用CGColor设置图形上下文中的当前填充颜色
    CGContextSetFillColorWithColor(context, fillColor);
    //使用当前图形状态中的填充颜色绘制所提供矩形中包含的区域。
    CGContextFillRect(context, imageFrame);
    //根据当前基于位图的图形上下文的内容返回图像。
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //从堆栈顶部移除当前基于位图的图形上下文。
    UIGraphicsEndImageContext();
    //设置图片圆角
    UIImage *circleImage = [image setCornerRadius:cornerRadius];
    
    UIImage *textImage = [circleImage addText:text withFont:font];

    return textImage;
}

///设置图片圆角
- (UIImage *)setCornerRadius:(CGFloat)cornerRadius {
    //创建一个临时渲染上下文，在这上面绘制原始图片
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    //图片的框架矩形
    CGRect imageRect = {0, 0, self.size};
    //创建并返回用圆角矩形路径初始化的新UIBezierPath对象
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:cornerRadius];
    //将Path添加到上下文中
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    //裁剪上下文
    CGContextClip(UIGraphicsGetCurrentContext());
    //在指定的矩形中绘制整个图像，并根据需要进行缩放
    [self drawInRect:imageRect];
    //从当前环境当中得到重绘的图片
    UIImage *circleImag = UIGraphicsGetImageFromCurrentImageContext();
    //从堆栈顶部移除当前基于位图的图形上下文。
    UIGraphicsEndImageContext();
    //返回绘制的图片
    return circleImag;
}

///绘制指定字体的文本到图片中
- (UIImage *)addText:(NSString *)text withFont:(UIFont *)font {
    //  1.获取上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    //  2.绘制图片
    CGRect imageRect = {0, 0, self.size};
    //  在指定的矩形中绘制整个图像，并根据需要进行缩放
    [self drawInRect:imageRect];
    //  3.绘制文字
    CGRect textRect = CGRectInset(imageRect, 2.0, 1.0);
    //  段落样式布局对象
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //  文字对齐方式
    style.alignment = NSTextAlignmentCenter;
    //  文字的属性
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName:style,
                                 NSForegroundColorAttributeName:[UIColor whiteColor]};
    //  将文字绘制上去
    [text drawInRect:textRect withAttributes:attributes];
    //  获取绘制到得图片
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    //  结束图片的绘制
    UIGraphicsEndImageContext();
    //  返回绘制的图片
    return textImage;
}

///绘制指定字体、颜色的文本到图片中
- (UIImage *)addText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)textColor{
    //  1.获取上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    //  2.绘制图片
    CGRect imageRect = {0, 0, self.size};
    //  在指定的矩形中绘制整个图像，并根据需要进行缩放
    [self drawInRect:imageRect];
    //  3.绘制文字
    CGRect textRect = CGRectInset(imageRect, 2.0, 1.0);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //  文字的属性
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName:style,
                                 NSForegroundColorAttributeName:textColor};
    //  将文字绘制上去
    [text drawInRect:textRect withAttributes:attributes];
    //  获取绘制到得图片
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    //  结束图片的绘制
    UIGraphicsEndImageContext();
    //  返回绘制的图片
    return textImage;
}

@end
