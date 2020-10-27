//
//  MKAnnotationView+YYWebImage.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 MKAnnotationView的web图像方法。.
 */
@interface MKAnnotationView (YYWebImage)

/**
 当前图像URL。
 
 @discussion 为此属性设置新值将取消上一个请求操作，并创建新的请求操作以获取图像。设置nil清除图像和图像url。
 */
@property (nullable, nonatomic, strong) NSURL *yy_imageURL;

/**
 使用指定的url设置视图的“image”。
 
 @param imageURL    图像URL（远程或本地文件路径）。
 @param placeholder 初始设置的图像，直到图像请求完成。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/**
 使用指定的url设置视图的“image”。
 @param imageURL 图像URL（远程或本地文件路径）。
 @param options  请求图像时使用的选项。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;

/**
 使用指定的url设置视图的“image”。
 
 @param imageURL    图像URL（远程或本地文件路径）。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 使用指定的url设置视图的“image”。
 
 @param imageURL    图像URL（远程或本地文件路径）。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param progress    在映像请求期间调用的块（在主线程上）。
 @param transform   调用块（在后台线程上）来执行其他图像处理。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 使用指定的url设置视图的“image”。
 
 @param imageURL    图像URL（远程或本地文件路径）。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param manager     创建映像请求操作的管理器。
 @param progress    在映像请求期间调用的块（在主线程上）。
 @param transform   调用块（在后台线程上）来执行其他图像处理。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 取消当前图像请求。
 */
- (void)yy_cancelCurrentImageRequest;

@end

NS_ASSUME_NONNULL_END
