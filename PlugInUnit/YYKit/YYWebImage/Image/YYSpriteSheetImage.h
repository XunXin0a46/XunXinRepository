//
//  YYSpriteImage.h
//  YYImage <https://github.com/ibireme/YYImage>
//
//  Created by ibireme on 15/4/21.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//  精灵片是一系列的图像（通常是动画帧）结合成一个更大的图像（或图像）。 例如，一个动画由八100x100图片可以合并成一个单一的400X200精灵表。使用SpriteSheet会使动画的运行效率更高，无需对每个纹理贴图进行渲染，直接对那个大image渲染一次即可。当然这个功能不仅仅是用来做动画的。当图片越多，优势就越明显。

#import <UIKit/UIKit.h>

#if __has_include(<YYImage/YYImage.h>)
#import <YYImage/YYAnimatedImageView.h>
#elif __has_include(<YYWebImage/YYImage.h>)
#import <YYWebImage/YYAnimatedImageView.h>
#else
#import "YYAnimatedImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 显示精灵工作表动画的图像。
 
 @discussion 它是完全兼容的“UIImage”子类。该动画可以由YYAnimatedImageView播放。
 
 样例代码:
  
    // 8*12单页图像中的精灵
    UIImage *spriteSheet = [UIImage imageNamed:@"sprite-sheet"];
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    for (int j = 0; j < 12; j++) {
        for (int i = 0; i < 8; i++) {
            CGRect rect;
            rect.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
            rect.origin.x = img.size.width / 8 * i;
            rect.origin.y = img.size.height / 12 * j;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [durations addObject:@(1 / 60.0)];
        }
    }
    YYSpriteSheetImage *sprite;
    sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:img
                                                     contentRects:contentRects
                                                   frameDurations:durations
                                                        loopCount:0];
    YYAnimatedImageView *imgView = [YYAnimatedImageView new];
    imgView.size = CGSizeMake(img.size.width / 8, img.size.height / 12);
    imgView.image = sprite;
 
 
 
 @discussion 它也可以用于显示精灵工作表图像中的单帧。
 样例代码:
 
    YYSpriteSheetImage *sheet = ...;
    UIImageView *imageView = ...;
    imageView.image = sheet;
    imageView.layer.contentsRect = [sheet contentsRectForCALayerAtIndex:6];
 
 */
@interface YYSpriteSheetImage : UIImage <YYAnimatedImage>

/**
 创建并返回图像对象。
 
 @param image          精灵工作表图像（包含所有帧）。
 
 @param contentRects   精灵工作表图像帧在图像坐标中是矩形的。矩形不应超出图像的边界。此数组中的对象应使用[NSValue valueWithCGRect:]创建。
 @param frameDurations 精灵工作表图像帧的持续时间（秒）。此数组中的对象应为NSNumber。
 
 @param loopCount      动画循环计数，0表示无限循环。
 
 @return 图像对象，如果发生错误则为nil。
 */
- (nullable instancetype)initWithSpriteSheetImage:(UIImage *)image
                                     contentRects:(NSArray<NSValue *> *)contentRects
                                   frameDurations:(NSArray<NSNumber *> *)frameDurations
                                        loopCount:(NSUInteger)loopCount;

@property (nonatomic, readonly) NSArray<NSValue *> *contentRects;
@property (nonatomic, readonly) NSArray<NSValue *> *frameDurations;
@property (nonatomic, readonly) NSUInteger loopCount;

/**
 获取CALayer的内容矩形。
 有关详细信息，请参阅CALayer中的“contentsRect”属性。
 
 @param index 帧索引。
 @return 内容矩形。
 */
- (CGRect)contentsRectForCALayerAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
