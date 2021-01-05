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
    ///UIGraphicsBeginImageContextWithOptions()创建一个临时渲染上下文，在这上面绘制原始图片。第一个参数，size，是缩放图片的尺寸，第二个参数，isOpaque 是用来决定透明度是否被渲染。对没有透明度的图片设置这个参数为NO，可能导致图片有粉红色调。第三个参数scale是显示缩放系数。当设置成0.0，主屏幕的缩放系数将被使用，对视网膜屏显示是2.0或者更高（在iPhone6 Plus 上是 3.0）
    ///UIScreen对象定义了基于硬件显示的相关属性,用这个类来获取每一个设备显示屏幕的对象
    ///UIScreen.mainScreen.scale:计算屏幕分辨率
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    ///一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect area = {0, 0, self.size};
    ///坐标系X,Y缩放
    CGContextScaleCTM(context, 1.0, -1.0);
    ///坐标系平移
    CGContextTranslateCTM(context, 0, -area.size.height);
    ///压栈操作，保存一份当前图形上下文
    CGContextSaveGState(context);
    ///CGImage：是用来重绘图形，它们在应用时是按照图像的像素矩阵来绘制图片的
    ///CGContextClipToMask：裁剪的区域,第一个参数表示context的指针,第二个参数表示裁剪到context的区域,也就是mask图片映射到context的区域,第三个参数表示mask的图片,对于裁剪区域Rect中的点是否变化取决于mask图中的alpha值,若alpha为0,则对应裁剪Rect中的点为透明,若alpha为1,则对应裁剪Rect中的点无变化
    CGContextClipToMask(context, area, self.CGImage);
    ///将后续填充操作的颜色设置为接收器表示的颜色。
    [tintColor setFill];
    ///填充指定的矩形
    CGContextFillRect(context, area);
    ///在没有保存之前，用这个函数还原blend mode.
    CGContextRestoreGState(context);
    ///设置blend mode
    CGContextSetBlendMode(context, kCGBlendModeDestinationOver);
    ///CGContextDrawImage允许在制定的尺寸和位置上画图,允许在特定边缘或者适应一组图片特征比如faces,裁剪图片。
    CGContextDrawImage(context, area, self.CGImage);
    ///从当前环境当中得到重绘的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    ///关闭当前环境
    UIGraphicsEndImageContext();
    ///设置图片的渲染模式：始终绘制图片原始状态
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}

@end