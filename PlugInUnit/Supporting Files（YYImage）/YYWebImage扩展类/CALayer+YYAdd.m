//
//  CALayer+YYAdd.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "CALayer+YYAdd.h"



@implementation CALayer (YYAdd)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 shouldRasterize：光栅化，指示layer在合成之前是否被渲染为位图的布尔值，可动画。启用shouldRasterize属性会将图层绘制到一个屏幕之外的图像，然后这个图像将会被缓存起来。
 如果有很多的子图层或者有复杂的效果应用，开启shouldRasterize就会比重绘所有事务的所有帧划得来得多。但是光栅化原始图像需要时间，而且还会消耗额外的内存。所以需要根据实际情况取舍。单次使用或者视图有变动，shouldRasterize不会有任何用途，反而会牺牲内存。
 对一个层级复杂的视图做动画时，也可以启用shouldRasterize避免GPU每帧都重新合成。
 xcode开发工具提供的常用的测量方式：
 Xcode->Debug->View Debuging->Rendering->Color Offscrenn-rended Yellow可以为触发了离屏渲染的layer着黄色。
 Xcode->Debug->View Debuging->Rendering->Hits Green and Misses Red
 这个指标可以反映我们通过尝试开启shouldRasterize提升性能的时候是不是达到了预期效果。
 当使用shouldRasterize属性的时候，耗时的图层绘制会被缓存，然后当做一个简单的扁平图片呈现。当缓存再生的时候这个选项就用红色对栅格化图层进行了高亮，缓存被重复使用的话就会以绿色进行高亮。如果缓存频繁再生的话（红色太多），就意味着栅格化可能会有负面的性能影响了。
 
 */

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;       //阴影不透明度
    self.shouldRasterize = YES;   //光栅化
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setCenter:(CGPoint)center {
    CGRect frame = self.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}

- (void)setCenterX:(CGFloat)centerX {
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)setCenterY:(CGFloat)centerY {
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)transformRotation {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation"];
    return v.doubleValue;
}

- (void)setTransformRotation:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.rotation"];
}

- (CGFloat)transformRotationX {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.x"];
    return v.doubleValue;
}

- (void)setTransformRotationX:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.rotation.x"];
}

- (CGFloat)transformRotationY {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.y"];
    return v.doubleValue;
}

- (void)setTransformRotationY:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.rotation.y"];
}

- (CGFloat)transformRotationZ {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.z"];
    return v.doubleValue;
}

- (void)setTransformRotationZ:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.rotation.z"];
}

- (CGFloat)transformScaleX {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.x"];
    return v.doubleValue;
}

- (void)setTransformScaleX:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale.x"];
}

- (CGFloat)transformScaleY {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.y"];
    return v.doubleValue;
}

- (void)setTransformScaleY:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale.y"];
}

- (CGFloat)transformScaleZ {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.z"];
    return v.doubleValue;
}

- (void)setTransformScaleZ:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale.z"];
}

- (CGFloat)transformScale {
    NSNumber *v = [self valueForKeyPath:@"transform.scale"];
    return v.doubleValue;
}

- (void)setTransformScale:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale"];
}

- (CGFloat)transformTranslationX {
    NSNumber *v = [self valueForKeyPath:@"transform.translation.x"];
    return v.doubleValue;
}

- (void)setTransformTranslationX:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.translation.x"];
}

- (CGFloat)transformTranslationY {
    NSNumber *v = [self valueForKeyPath:@"transform.translation.y"];
    return v.doubleValue;
}

- (void)setTransformTranslationY:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.translation.y"];
}

- (CGFloat)transformTranslationZ {
    NSNumber *v = [self valueForKeyPath:@"transform.translation.z"];
    return v.doubleValue;
}

- (void)setTransformTranslationZ:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.translation.z"];
}

- (CGFloat)transformDepth {
    return self.transform.m34;
}

- (void)setTransformDepth:(CGFloat)v {
    CATransform3D d = self.transform;
    d.m34 = v;
    self.transform = d;
}

/**
 UIViewAnimationCurve：系统自带的动画曲线
 枚举定义：
 typedef NS_ENUM(NSInteger, UIViewAnimationCurve) {
 UIViewAnimationCurveEaseInOut,         // 开始和结尾慢，中间快
 UIViewAnimationCurveEaseIn,            // 先慢后快
 UIViewAnimationCurveEaseOut,           // 先快后慢
 UIViewAnimationCurveLinear,            // 匀速
 };
 
 CATransition又称转场动画，是CAAnimation的子类，可以直接使用，转场动画主要用于为图层提供移入/移出屏幕的动画效果，转场动画常见的应用是UINavigationController。
 
 常见转场动画的过渡方式：
 CA_EXTERN CATransitionType const kCATransitionFade       交叉淡化过渡，不支持过渡方向
 CA_EXTERN CATransitionType const kCATransitionMoveIn     新视图移到旧视图上面
 CA_EXTERN CATransitionType const kCATransitionPush       新视图把旧视图推出去
 CA_EXTERN CATransitionType const kCATransitionReveal     将旧视图移开显示下边的新视图
 
 */
- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
        default: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;//动画的持续时间
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];//设置动画的速度变化
    transition.type = kCATransitionFade;//转场动画的过渡方式
    [self addAnimation:transition forKey:@"yykit.fade"];//添加动画
}

- (void)removePreviousFadeAnimation {
    [self removeAnimationForKey:@"yykit.fade"];
}

@end
