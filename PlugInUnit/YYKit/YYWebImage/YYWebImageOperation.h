//
//  YYWebImageOperation.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYImageCache.h>
#import <YYWebImage/YYWebImageManager.h>
#else
#import "YYImageCache.h"
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 YYWebImageOperation类是一个NSOperation子类，用于从URL请求中获取图像。
 
 @discussion 这是一个异步操作。您通常通过将其添加到操作队列来执行它，或者调用“start”手动执行它。当行动开始时，会:
 
     1. 从缓存中获取图像，如果存在，用“completion”块返回。
     2. 启动一个URL连接来从请求中获取图像，调用“progress”来通知请求的进度(如果通过渐进选项启用，调用“completion”块来返回渐进图像)。
     3. 通过调用“transform”块来处理图像。
     4. 把图像缓存，并返回它与'完成'块。
 
 */
@interface YYWebImageOperation : NSOperation

@property (nonatomic, strong, readonly)           NSURLRequest      *request;  ///< 图像URL request.
@property (nullable, nonatomic, strong, readonly) NSURLResponse     *response; ///< 请求的响应。
@property (nullable, nonatomic, strong, readonly) YYImageCache      *cache;    ///< 图像缓存。
@property (nonatomic, strong, readonly)           NSString          *cacheKey; ///< 图像缓存键。
@property (nonatomic, readonly)                   YYWebImageOptions options;   ///< 操作的选项。

/**
 URL连接是否应咨询凭据存储以验证连接。默认是YES。
 
 @discussion 这是在' NSURLConnectionDelegate '方法' -connectionShouldUseCredentialStorage: '中返回的值。
 */
@property (nonatomic) BOOL shouldUseCredentialStorage;

/**
 用于“-connection:didReceiveAuthenticationChallenge:”中的身份验证的凭据。
 
 @discussion 这将被请求URL的用户名或密码(如果存在)所存在的任何共享凭据覆盖。
 */
@property (nullable, nonatomic, strong) NSURLCredential *credential;

/**
 创建并返回一个新操作。
 
 您应该调用' start '来执行该操作，或者您可以将该操作添加到操作队列中。
 
 @param request    图像的请求。这个值不应该是nil。
 @param options    指定用于此操作的选项的掩码。
 @param cache      一个图像缓存。传递nil以避免图像缓存。
 @param cacheKey   个图像缓存键。传递nil以避免图像缓存。
 @param progress   在图像获取过程中调用的块。
                     块将在后台线程中调用。传递nil来避免它。
 @param transform  在图像获取完成之前调用的一个块，用于执行附加的图像处理。
                     块将在后台线程中调用。传递nil来避免它。
 @param completion 当图像获取完成或取消时调用的块。
                     块将在后台线程中调用。传递nil来避免它。
 
 @return 图像请求opeartion，如果发生错误则为nil。
 */
- (instancetype)initWithRequest:(NSURLRequest *)request
                        options:(YYWebImageOptions)options
                          cache:(nullable YYImageCache *)cache
                       cacheKey:(nullable NSString *)cacheKey
                       progress:(nullable YYWebImageProgressBlock)progress
                      transform:(nullable YYWebImageTransformBlock)transform
                     completion:(nullable YYWebImageCompletionBlock)completion NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
