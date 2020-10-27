//
//  YYWebImageManager.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/19.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYImageCache.h>
#else
#import "YYImageCache.h"
#endif

@class YYWebImageOperation;

NS_ASSUME_NONNULL_BEGIN

/// 控制图像操作的选项。
typedef NS_OPTIONS(NSUInteger, YYWebImageOptions) {
    
    /// 下载图像时在状态栏上显示网络活动。
    YYWebImageOptionShowNetworkActivity = 1 << 0,
    
    /// 下载期间显示渐进/隔行扫描/基线图像（与Web浏览器相同）。
    YYWebImageOptionProgressive = 1 << 1,
    
    /// 下载时显示模糊的渐进式JPEG或隔行PNG图像。
    /// 这将忽略基线图像以获得更好的用户体验。
    YYWebImageOptionProgressiveBlur = 1 << 2,
    
    /// 使用NSURLCache而不是YYImageCache。
    YYWebImageOptionUseNSURLCache = 1 << 3,
    
    /// 允许不受信任的SSL证书。
    YYWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
    
    /// 允许后台任务在应用程序处于后台时下载图像。
    YYWebImageOptionAllowBackgroundTask = 1 << 5,
    
    /// 处理存储在NSHTTPCookieStore中的cookie。
    YYWebImageOptionHandleCookies = 1 << 6,
    
    /// 从远程加载图像并刷新图像缓存。
    YYWebImageOptionRefreshImageCache = 1 << 7,
    
    /// 不要将图像从/加载到磁盘缓存。
    YYWebImageOptionIgnoreDiskCache = 1 << 8,
    
    /// 在为视图设置新的url之前，不要更改视图的图像。
    YYWebImageOptionIgnorePlaceHolder = 1 << 9,
    
    /// 忽略图像解码。
    /// 这可用于无显示的图像下载。
    YYWebImageOptionIgnoreImageDecoding = 1 << 10,
    
    /// 忽略多帧图像解码。
    /// 这将把gif/apng/webp/ico图像处理为单帧图像。
    YYWebImageOptionIgnoreAnimatedImage = 1 << 11,
    
    /// 将图像设置为使用渐变动画查看。
    /// 这将在图像视图的图层上添加“淡入淡出”动画，以获得更好的用户体验。
    YYWebImageOptionSetImageWithFadeAnimation = 1 << 12,
    
    /// 当图像获取完成时，不要将图像设置为视图。
    /// 您可以手动设置图像。
    YYWebImageOptionAvoidSetImage = 1 << 13,
    
    /// 当url下载失败时，此标志将把url添加到黑名单（内存中），因此库不会继续尝试。
    YYWebImageOptionIgnoreFailedURL = 1 << 14,
};

/// 指示图像的来源。
typedef NS_ENUM(NSUInteger, YYWebImageFromType) {
    
    /// 没有值。
    YYWebImageFromNone = 0,
    
    /// 立即从内存缓存中提取。如果您调用了“setImageWithURL:…”，并且图像已经在内存中，那么您将在同一调用中获得此值。
    YYWebImageFromMemoryCacheFast,
    
    /// 从内存缓存中获取。
    YYWebImageFromMemoryCache,
    
    /// 从磁盘缓存中提取。
    YYWebImageFromDiskCache,
    
    /// 从远程（Web或文件路径）获取。
    YYWebImageFromRemote,
};

/// 指示图像获取完成阶段。
typedef NS_ENUM(NSInteger, YYWebImageStage) {
    
    /// 不完整，渐进的图像。
    YYWebImageStageProgress  = -1,
    
    /// 取消。
    YYWebImageStageCancelled = 0,
    
    /// 完成（成功或失败）。
    YYWebImageStageFinished  = 1,
};


/**
 在远程映像获取过程中调用的块。
 
 @param receivedSize 当前接收的字节大小。
 @param expectedSize 预期的总大小（字节）（1表示未知）。
 */
typedef void(^YYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

/**
 在远程图像获取完成之前调用的块，以执行其他图像处理。
 
 @discussion  此块将在“YYWebImageCompletionBlock”之前调用，以便您有机会执行其他图像处理（如调整大小或裁剪）。如果不需要转换图像，只需返回“image”参数。
 
 @例子 你可以剪辑图像，模糊它并用这些代码添加圆角:
    ^(UIImage *image, NSURL *url) {
        // Maybe you need to create an @autoreleasepool to limit memory cost.
        image = [image yy_imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeScaleAspectFill];
        image = [image yy_imageByBlurRadius:20 tintColor:nil tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];
        image = [image yy_imageByRoundCornerRadius:5];
        return image;
    }
 
 @param image 从url获取的图像。
 @param url   图像URL（远程或本地文件路径）。
 @return 转换后的图像。
 */
typedef UIImage * _Nullable (^YYWebImageTransformBlock)(UIImage *image, NSURL *url);

/**
 图像提取完成或取消时调用的块。
 
 @param image       图像。
 @param url         图像URL（远程或本地文件路径）。
 @param from        图像的来源。
 @param error       获取图像时出错。
 @param stage       如果取消操作，则此值为“否”，否则为“是”。
 */
typedef void (^YYWebImageCompletionBlock)(UIImage * _Nullable image,
                                          NSURL *url,
                                          YYWebImageFromType from,
                                          YYWebImageStage stage,
                                          NSError * _Nullable error);




/**
 用于创建和管理Web映像操作的管理器。
 */
@interface YYWebImageManager : NSObject

/**
 返回全局YYWebImageManager实例。
 
 @return YYWebImageManager共享实例。
 */
+ (instancetype)sharedManager;

/**
 创建具有图像缓存和操作队列的管理器。
 
 @param cache  管理器使用的图像缓存（传递nil以避免图像缓存）。
 @param queue  调度和运行图像操作的操作队列（通过nil使新操作立即启动而不使用队列）。
 @return 管理器。
 */
- (instancetype)initWithCache:(nullable YYImageCache *)cache
                        queue:(nullable NSOperationQueue *)queue NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 创建并返回一个新的图像操作，该操作将立即启动。
 
 @param url        图像URL（远程或本地文件路径）。
 @param options    控制图像操作的选项。
 @param progress   将在后台线程上调用的进度块（传递nil以避免）。
 @param transform  将在后台线程上调用的转换块（传递nil以避免）。
 @param completion 将在后台线程上调用的完成块（传递nil以避免）。
 @return 新的图像操作。
 */
- (nullable YYWebImageOperation *)requestImageWithURL:(NSURL *)url
                                              options:(YYWebImageOptions)options
                                             progress:(nullable YYWebImageProgressBlock)progress
                                            transform:(nullable YYWebImageTransformBlock)transform
                                           completion:(nullable YYWebImageCompletionBlock)completion;

/**
 图像操作使用的图像缓存。
 可以将其设置为nil以避免图像缓存。
 */
@property (nullable, nonatomic, strong) YYImageCache *cache;

/**
 调度和运行图像操作的操作队列。
 您可以将其设置为nil，使新操作立即启动而不排队。
 
 您可以使用此队列来控制最大并发操作数、获取当前操作的状态或取消此管理器中的所有操作。
 */
@property (nullable, nonatomic, strong) NSOperationQueue *queue;

/**
 用于处理图像的共享变换块。默认值为nil。
 
 调用“requestimagewithurl:options:progress:transform:completion”和
 “transform”为nil，将使用此块。
 */
@property (nullable, nonatomic, copy) YYWebImageTransformBlock sharedTransformBlock;

/**
 图像请求超时间隔（秒）。默认值为15。
 */
@property (nonatomic) NSTimeInterval timeout;

/**
 NSURLCredential使用的用户名，默认为nil。
 */
@property (nullable, nonatomic, copy) NSString *username;

/**
 NSURLCredential使用的密码，默认为nil。
 */
@property (nullable, nonatomic, copy) NSString *password;

/**
 图像HTTP请求头。默认值为 "Accept:image/webp,image/\*;q=0.8".
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, NSString *> *headers;

/**
 将为每个图像HTTP请求调用的块，以执行额外的HTTP头处理。默认值为nil。
 
 使用此块可以添加或删除指定URL的HTTP头字段。
 */
@property (nullable, nonatomic, copy) NSDictionary<NSString *, NSString *> *(^headersFilter)(NSURL *url, NSDictionary<NSString *, NSString *> * _Nullable header);

/**
 为每个图像操作调用的块。默认值为零。
 
 使用此块为指定的URL提供自定义图像缓存密钥。
 */
@property (nullable, nonatomic, copy) NSString *(^cacheKeyFilter)(NSURL *url);

/**
 返回指定URL的HTTP头。
 
 @param url 指定的URL。
 @return HTTP头。
 */
- (nullable NSDictionary<NSString *, NSString *> *)headersForURL:(NSURL *)url;

/**
 返回指定URL的缓存键。
 
 @param url 指定的URL
 @return 在YYImageCache中使用的缓存密钥。
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;


/**
 增加活动网络请求数。
 如果在递增前该数字为零，则将开始设置状态栏“网络活动”指示器的动画。
 
 此方法是线程安全的。
 
 此方法对应用程序扩展无效。
 */
+ (void)incrementNetworkActivityCount;

/**
 减少活动网络请求的数量。
 如果递减后此数字变为零，则将停止设置状态栏“网络活动”指示器的动画。
 
 此方法是线程安全的。
 
 此方法对应用程序扩展无效。
 */
+ (void)decrementNetworkActivityCount;

/**
 获取当前活动网络请求数。
 
 此方法是线程安全的。
 
 此方法对应用程序扩展无效。
 */
+ (NSInteger)currentNetworkActivityCount;

@end

NS_ASSUME_NONNULL_END
