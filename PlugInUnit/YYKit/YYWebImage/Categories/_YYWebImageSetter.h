//
//  _YYWebImageSetter.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/7/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//
#import <UIKit/UIKit.h>
#import <pthread.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 提交块以在主队列上执行，并等待块完成。
 */
static inline void _yy_dispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

extern NSString *const _YYWebImageFadeAnimationKey;
extern const NSTimeInterval _YYWebImageFadeTime;
extern const NSTimeInterval _YYWebImageProgressiveFadeTime;

/**
 Web图像类别使用的私有类。通常，您不应该直接使用该类。
 */
@interface _YYWebImageSetter : NSObject
/// 当前图像URL。
@property (nullable, nonatomic, readonly) NSURL *imageURL;
/// 当前标记。
@property (nonatomic, readonly) int32_t sentinel;

/// 为web图像创建新操作并返回一个标记值。
- (int32_t)setOperationWithSentinel:(int32_t)sentinel
                                url:(nullable NSURL *)imageURL
                            options:(YYWebImageOptions)options
                            manager:(YYWebImageManager *)manager
                           progress:(nullable YYWebImageProgressBlock)progress
                          transform:(nullable YYWebImageTransformBlock)transform
                         completion:(nullable YYWebImageCompletionBlock)completion;

/// 取消并返回一个标记值。imageURL将被设置为nil。
- (int32_t)cancel;

/// 取消并返回一个标记值。imageURL将被设置为新值。
- (int32_t)cancelWithNewURL:(nullable NSURL *)imageURL;

/// 要设置操作的队列。
+ (dispatch_queue_t)setterQueue;

@end

NS_ASSUME_NONNULL_END
