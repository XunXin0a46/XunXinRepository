//
//  YYImage.h
//  YYImage <https://github.com/ibireme/YYImage>
//
//  Created by ibireme on 14/10/20.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYImage/YYImage.h>)
FOUNDATION_EXPORT double YYImageVersionNumber;
FOUNDATION_EXPORT const unsigned char YYImageVersionString[];
#import <YYImage/YYFrameImage.h>
#import <YYImage/YYSpriteSheetImage.h>
#import <YYImage/YYImageCoder.h>
#import <YYImage/YYAnimatedImageView.h>
#elif __has_include(<YYWebImage/YYImage.h>)
#import <YYWebImage/YYFrameImage.h>
#import <YYWebImage/YYSpriteSheetImage.h>
#import <YYWebImage/YYImageCoder.h>
#import <YYWebImage/YYAnimatedImageView.h>
#else
#import "YYFrameImage.h"
#import "YYSpriteSheetImage.h"
#import "YYImageCoder.h"
#import "YYAnimatedImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN


/**
    YYImage对象是显示动画图像数据的高级方法。
 
 @discussion 它是完全兼容的“UIImage”子类。它扩展了uiimage以支持动画webp、apng和gif格式的图像数据解码。它还支持NSCoding协议来归档和非归档多帧图像数据。
 
 如果图像是从多帧图像数据创建的，并且要播放动画，请尝试将UIImageView替换为“YYAnimatedImageView”。
 
 样例代码:
 
     // animation@3x.webp
     YYImage *image = [YYImage imageNamed:@"animation.webp"];
     YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
    
 */
@interface YYImage : UIImage <YYAnimatedImage>

+ (nullable YYImage *)imageNamed:(NSString *)name; // 无缓存!
+ (nullable YYImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable YYImage *)imageWithData:(NSData *)data;
+ (nullable YYImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;

/**
 如果图像是从数据或文件创建的，则该值指示数据类型。
 */
@property (nonatomic, readonly) YYImageType animatedImageType;

/**
 如果图像是从动画图像数据（多帧gif/apng/webp）创建的，则此属性存储原始图像数据。
 */
@property (nullable, nonatomic, readonly) NSData *animatedImageData;

/**
 如果所有帧图像都加载到内存中，则总内存使用量（字节）。如果图像不是从多帧图像数据创建的，则该值为0。
 */
@property (nonatomic, readonly) NSUInteger animatedImageMemorySize;

/**
 将所有帧图像预加载到内存中。
 
 @discussion 将此属性设置为“是”将阻止调用线程将所有动画帧图像解码为内存，设置为“否”将释放预加载的帧。如果图像被许多图像视图（如图释）共享，则预加载所有帧将降低CPU成本。
 
 有关内存开销，请参见“animatedImageMemorySize”。
 */
@property (nonatomic) BOOL preloadAllAnimatedImageFrames;

@end

NS_ASSUME_NONNULL_END
