//
//  YYFrameImage.h
//  YYImage <https://github.com/ibireme/YYImage>
//
//  Created by ibireme on 14/12/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

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
 显示基于帧的动画的图像。
 
 @discussion 它是完全兼容的“UIImage”子类。它只支持系统图像格式，如png和jpeg。动画可以由YYAnimatedImageView播放。
 
 样例代码:
     
     NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
     NSArray *times = @[@0.1, @0.2, @0.1];
     YYFrameImage *image = [YYFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
     YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface YYFrameImage : UIImage <YYAnimatedImage>

/**
 从文件创建帧动画图像。
 
 @param paths NSString对象数组，包含每个图像文件的完整或部分路径。例如@[@/ani/1.png“，@/ani/2.png”，@/ani/3.png“]
 
 @param oneFrameDuration 每帧的持续时间（秒）。
 
 @param loopCount        动画循环计数，0表示无限。
 
 @return 初始化的YYFrameImage对象，或在发生错误时为nil。
 */
- (nullable instancetype)initWithImagePaths:(NSArray<NSString *> *)paths
                           oneFrameDuration:(NSTimeInterval)oneFrameDuration
                                  loopCount:(NSUInteger)loopCount;

/**
 从文件创建帧动画图像。
 
 @param paths  NSString对象数组，包含每个图像文件的完整或部分路径。例如@[@“/ani/frame1.png”、@“/ani/frame2.png”、@“/ani/frame3.png”]
 
 @param frameDurations NSNumber对象数组，包含每帧的持续时间（秒）。例如@[@0.1，@0.2，@0.3]；
 
 @param loopCount      动画循环计数，0表示无限。
 
 @return 初始化的YYFrameImage对象，或在发生错误时为nil。
 */
- (nullable instancetype)initWithImagePaths:(NSArray<NSString *> *)paths
                             frameDurations:(NSArray<NSNumber *> *)frameDurations
                                  loopCount:(NSUInteger)loopCount;

/**
 从数据数组创建帧动画图像。
 
 @param dataArray        NSData对象的数组。
 
 @param oneFrameDuration 每帧的持续时间（秒）。
 
 @param loopCount        动画循环计数，0表示无限。
 
 @return 初始化的YYFrameImage对象，或在发生错误时为nil。
 */
- (nullable instancetype)initWithImageDataArray:(NSArray<NSData *> *)dataArray
                               oneFrameDuration:(NSTimeInterval)oneFrameDuration
                                      loopCount:(NSUInteger)loopCount;

/**
 从数据数组创建帧动画图像。
 
 @param dataArray      NSData对象的数组。
 
 @param frameDurations NSNumber对象数组，包含每帧的持续时间（秒）。例如@[@0.1，@0.2，@0.3]；
 
 @param loopCount      动画循环计数，0表示无限。
 
 @return 初始化的YYFrameImage对象，或在发生错误时为nil。
 */
- (nullable instancetype)initWithImageDataArray:(NSArray<NSData *> *)dataArray
                                 frameDurations:(NSArray *)frameDurations
                                      loopCount:(NSUInteger)loopCount;

@end

NS_ASSUME_NONNULL_END
