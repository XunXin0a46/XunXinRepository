//
//  UIButton+YYWebImage.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 UIButton的web图像方法。
 */
@interface UIButton (YYWebImage)

#pragma mark - image

/**
 指定状态的当前图像URL。
 @return 图像url，或nil。
 */
- (nullable NSURL *)yy_imageURLForState:(UIControlState)state;

/**
 使用指定状态的指定URL设置按钮的图像。
 
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder;

/**
 使用指定状态的指定URL设置按钮的图像。
 
 @param imageURL 图像URL（远程或本地文件路径）。
 @param state    使用指定映像的状态。
 @param options  请求图像时使用的选项。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
                   options:(YYWebImageOptions)options;

/**
使用指定状态的指定URL设置按钮的图像。
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
使用指定状态的指定URL设置按钮的图像。
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param progress    在映像请求期间调用的块（在主线程上）。
 @param transform   调用块（在后台线程上）来执行其他图像处理。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
使用指定状态的指定URL设置按钮的图像。
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param manager     创建映像请求操作的管理器。
 @param progress    在映像请求期间调用的块（在主线程上）。
 @param transform   调用块（在后台线程上）来执行其他图像处理。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setImageWithURL:(nullable NSURL *)imageURL
                  forState:(UIControlState)state
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/**
 取消指定状态的当前映像请求。
 @param state 使用指定映像的状态。
 */
- (void)yy_cancelImageRequestForState:(UIControlState)state;



#pragma mark - background image

/**
 指定状态的当前背景图像URL。
 @return 图像url，或nil。
 */
- (nullable NSURL *)yy_backgroundImageURLForState:(UIControlState)state;

/**
使用指定状态的指定URL设置按钮的背景图像。
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder;

/**
使用指定状态的指定URL设置按钮的背景图像。
 @param imageURL 图像URL（远程或本地文件路径）
 @param state    使用指定映像的状态。
 @param options  请求图像时使用的选项。
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                             options:(YYWebImageOptions)options;

/**
使用指定状态的指定URL设置按钮的背景图像。
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                          completion:(nullable YYWebImageCompletionBlock)completion;

/**
使用指定状态的指定URL设置按钮的背景图像。
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param progress    在映像请求期间调用的块（在主线程上）。
 @param transform   调用块（在后台线程上）来执行其他图像处理。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion;

/**
 使用指定状态的指定URL设置按钮的背景图像。
 
 @param imageURL    图像URL（远程或本地文件路径）。
 @param state       使用指定映像的状态。
 @param placeholder 初始设置的图像，直到图像请求完成。
 @param options     请求图像时使用的选项。
 @param manager     创建映像请求操作的管理器。
 @param progress    在映像请求期间调用的块（在主线程上）。
 @param transform   调用块（在后台线程上）来执行其他图像处理。
 @param completion  映像请求完成时调用的块（在主线程上）。
 */
- (void)yy_setBackgroundImageWithURL:(nullable NSURL *)imageURL
                            forState:(UIControlState)state
                         placeholder:(nullable UIImage *)placeholder
                             options:(YYWebImageOptions)options
                             manager:(nullable YYWebImageManager *)manager
                            progress:(nullable YYWebImageProgressBlock)progress
                           transform:(nullable YYWebImageTransformBlock)transform
                          completion:(nullable YYWebImageCompletionBlock)completion;

/**
 为指定的状态取消当前背景图像请求。
 @param state 使用指定映像的状态。
 */
- (void)yy_cancelBackgroundImageRequestForState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
