//
//  YYAnimatedImageView.h
//  YYImage <https://github.com/ibireme/YYImage>
//
//  Created by ibireme on 14/10/19.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用于显示动画图像的图像视图。
 
 @discussion 它是完全兼容的“UIImageView”子类。如果“image”或“highlightedimage”属性采用“YYAnimatedImage”协议，则可以使用它来播放多帧动画。也可以使用UIImageView方法“-startAnimating”、“-stopAnimating”和“-isAnimating”来控制动画。
 
 此视图请求帧数据。当设备有足够的空闲内存时，此视图可能会将一些或所有未来帧缓存在内部缓冲区中，以降低CPU成本。缓冲区大小根据设备内存的当前状态动态调整。
 
 样例代码:
 
     // ani@3x.gif
     YYImage *image = [YYImage imageNamed:@"ani"];
     YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface YYAnimatedImageView : UIImageView

/**
 如果图像有多个帧，将此值设置为“YES”将在视图变为可见/不可见时自动播放/停止动画。
 
 默认值为“YES”。
 */
@property (nonatomic) BOOL autoPlayAnimatedImage;

/**
 当前显示帧的索引（从0开始索引）。
 
 设置此属性的新值将导致立即显示新帧。如果新值无效，则此方法无效。
 
 可以向该属性添加观察者以观察播放状态。
 */
@property (nonatomic) NSUInteger currentAnimatedImageIndex;

/**
 图像视图当前是否正在播放动画。
 
 可以向该属性添加观察者以观察播放状态。
 */
@property (nonatomic, readonly) BOOL currentIsPlayingAnimation;

/**
 动画计时器的运行循环模式，默认为“NSRunLoopCommonModes”。
 
 将此属性设置为“NSDefaultRunLoopMode”将使动画在UIScrollView滚动期间暂停。
 */
@property (nonatomic, copy) NSString *runloopMode;

/**
 内部帧缓冲区大小的最大大小（字节），默认为0（动态）。
 
 当设备有足够的空闲内存时，此视图将请求并将一些或所有未来帧图像解码到内部缓冲区中。如果此属性的值为0，则将根据设备可用内存的当前状态动态调整最大缓冲区大小。否则，缓冲区大小将受此值限制。
 
 当收到内存警告或应用程序进入后台时，缓冲区将立即释放，并可能在正确的时间增长回来。
 */
@property (nonatomic) NSUInteger maxBufferSize;

@end



/**
 YYAnimatedImage协议声明了使用YYAnimatedImageView显示动画图像所需的方法。
 
 子类化UIImage并实现此协议，以便可以将该类的实例设置为YYAnimatedImageView.image或YYAnimatedImageView.highlightedImage以显示动画。
 
 请参见“YYImage”和“YYFrameImage”示例。
 */
@protocol YYAnimatedImage <NSObject>
@required
/// 动画帧总数。
/// 如果帧计数小于1，则将忽略下面的方法。
- (NSUInteger)animatedImageFrameCount;

/// 动画循环计数，0表示无限循环。
- (NSUInteger)animatedImageLoopCount;

/// 每帧字节数（内存中）。它可用于优化内存缓冲区大小。
- (NSUInteger)animatedImageBytesPerFrame;

/// 从指定索引返回帧图像。
/// 此方法可以在后台线程上调用。
/// @param index  帧索引（基于零）。
- (nullable UIImage *)animatedImageFrameAtIndex:(NSUInteger)index;

/// 从指定索引返回帧的持续时间。
/// @param index  帧索引（基于零）。
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;

@optional
/// 图像坐标中的矩形，定义要显示的图像的子矩形。矩形不应超出图像的边界。它可用于显示单个图像的精灵动画（精灵工作表）。
- (CGRect)animatedImageContentsRectAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
