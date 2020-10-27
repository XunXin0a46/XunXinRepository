//
//  YYImageCache.h
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@class YYMemoryCache, YYDiskCache;

NS_ASSUME_NONNULL_BEGIN

/// 图像缓存类型
typedef NS_OPTIONS(NSUInteger, YYImageCacheType) {
    /// 没有值。
    YYImageCacheTypeNone   = 0,
    
    /// 使用内存缓存获取/存储图像。
    YYImageCacheTypeMemory = 1 << 0,
    
    /// 使用磁盘缓存获取/存储图像。
    YYImageCacheTypeDisk   = 1 << 1,
    
    /// 使用内存缓存和磁盘缓存获取/存储图像。
    YYImageCacheTypeAll    = YYImageCacheTypeMemory | YYImageCacheTypeDisk,
};


/**
 YYImageCache是基于内存缓存和磁盘缓存存储UIImage和图像数据的缓存。
 @discussion 磁盘缓存将尝试保护原始图像数据:
 
 * 如果原始图像是静态图像，则根据alpha信息将其保存为png/jpeg文件。
 * 如果原始图像是动画gif、apng或webp，则将其保存为原始格式。
 * 如果原始图像的比例不是1，则比例值将保存为扩展数据。
 
 虽然可以使用NSCoding协议序列化uiimage，但这不是一个好主意：苹果实际上使用UIImagePNGRepresentation()对所有类型的图像进行编码，它可能会丢失原始的多帧数据。结果打包到plist文件中，无法使用photo viewer直接查看。如果图像没有alpha通道，使用jpeg代替png可以节省更多的磁盘大小和编码/解码时间。
 */
@interface YYImageCache : NSObject

#pragma mark - Attribute （属性）
///=============================================================================
/// @name Attribute
///=============================================================================

/** 缓存的名称。默认值为nil。 */
@property (nullable, copy) NSString *name;

/** 底层内存缓存。有关详细信息，请参见“YYMemoryCache”。*/
@property (strong, readonly) YYMemoryCache *memoryCache;

/** 底层磁盘缓存。有关详细信息，请参见“YYDiskCache”。*/
@property (strong, readonly) YYDiskCache *diskCache;

/**
 从磁盘缓存中获取图像时是否解码动画图像。默认为“YES”。
 
 @discussion  当从磁盘缓存中获取图像时，它将使用“YYImage”解码动画图像，如webp/apng/gif。设置为“否”可忽略动画图像。
 */
@property BOOL allowAnimatedImage;

/**
 是否将图像解码为内存位图。默认为“YES”。
 @discussion  如果该值为“YES”，则图像将被解码为内存位图以获得更好的显示性能，但可能需要更多内存。
 */
@property BOOL decodeForDisplay;


#pragma mark - Initializer （初始化）
///=============================================================================
/// @name Initializer
///=============================================================================
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 返回全局共享映像缓存实例。
 @return  单例YYImageCache实例。
 */
+ (instancetype)sharedCache;

/**
 指定的初始值设定项。具有相同路径的多个实例将使缓存不稳定。
 
 @param path 缓存将在其中写入数据的目录的完整路径。初始化后，不应读写此目录。
 @result 一个新的缓存对象，如果发生错误，则为nil。
 */
- (nullable instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;


#pragma mark - Access Methods （访问方法）
///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 使用缓存中的指定键（内存和磁盘）设置图像。
 此方法立即返回并在后台执行存储操作。
 
 @param image 要存储在缓存中的图像。如果为nil，则此方法无效。
 @param key   与图像关联的键。如果为nil，则此方法无效。
 */
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

/**
 使用缓存中的指定键设置图像。此方法立即返回并在后台执行存储操作。
 
 @discussion 如果“type”包含“YYImageCacheTypeMemory”，则“image”将
 存储在内存缓存中；如果“image”为nil，则将使用“imageData”。如果“type”包含“YYImageCacheTypeDisk”，则“imageData”将存储在磁盘缓存中；如果“imageData”为nil，则改用“image”。
 
 @param image     要存储在缓存中的图像。
 @param imageData 要存储在缓存中的图像数据。
 @param key       与图像关联的键。如果为nil，则此方法无效。
 @param type      要存储图像的缓存类型。
 */
- (void)setImage:(nullable UIImage *)image
       imageData:(nullable NSData *)imageData
          forKey:(NSString *)key
        withType:(YYImageCacheType)type;

/**
 删除缓存中指定密钥的图像（内存和磁盘）。
 此方法立即返回并在后台执行删除操作。
 
 @param key 识别要删除的图像的键。如果为nil，则此方法无效。
 */
- (void)removeImageForKey:(NSString *)key;

/**
 删除缓存中指定密钥的图像。
 此方法立即返回并在后台执行删除操作。
 
 @param key  识别要删除的图像的密钥。如果为nil，则此方法无效。
 @param type 要删除图像的缓存类型。
 */
- (void)removeImageForKey:(NSString *)key withType:(YYImageCacheType)type;

/**
 返回指示给定键是否在缓存中的布尔值。
 如果图像不在内存中，此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key 标识图像的字符串。如果没有，就返回NO。
 @return 图像是否在缓存中。
 */
- (BOOL)containsImageForKey:(NSString *)key;

/**
 返回指示给定键是否在缓存中的布尔值。
 如果图像不在内存中且“type”包含“YYImageCacheTypeDisk”，则此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key  标识图像的字符串。如果没有，就返回NO。
 @param type 缓存类型。
 @return 图像是否在缓存中。
 */
- (BOOL)containsImageForKey:(NSString *)key withType:(YYImageCacheType)type;

/**
 返回与给定键关联的图像。
 如果映像不在内存中，此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key 标识图像的字符串。如果没有，就返回nil。
 @return 与键关联的图像，如果没有与键关联的图像，则为nil。
 */
- (nullable UIImage *)getImageForKey:(NSString *)key;

/**
 返回与给定键关联的图像。
 如果图像不在内存中且“type”包含“YYImageCacheTypeDisk”，则此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key 标识图像的字符串。如果没有，就返回nil。
 @return 与键关联的图像，如果没有与键关联的图像，则为nil。
 */
- (nullable UIImage *)getImageForKey:(NSString *)key withType:(YYImageCacheType)type;

/**
 异步获取与给定密钥关联的图像。
 
 @param key   标识图像的字符串。如果没有，就返回nil。
 @param type  缓存类型。
 @param block 将在主线程上调用的完成块。
 */
- (void)getImageForKey:(NSString *)key
              withType:(YYImageCacheType)type
             withBlock:(void(^)(UIImage * _Nullable image, YYImageCacheType type))block;

/**
 返回与给定键关联的图像数据。
 此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key v标识图像的字符串。如果没有，就返回nil。
 @return 与键关联的图像数据，如果没有图像与键关联，则为nil。
 */
- (nullable NSData *)getImageDataForKey:(NSString *)key;

/**
 异步获取与给定键关联的图像数据。
 
 @param key   标识图像的字符串。如果没有，就返回nil。
 @param block 将在主线程上调用的完成块。
 */
- (void)getImageDataForKey:(NSString *)key
                 withBlock:(void(^)(NSData * _Nullable imageData))block;

@end

NS_ASSUME_NONNULL_END
