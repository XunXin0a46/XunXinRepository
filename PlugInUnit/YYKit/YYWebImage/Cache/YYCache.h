//
//  YYCache.h
//  YYCache <https://github.com/ibireme/YYCache>
//
//  Created by ibireme on 15/2/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<YYCache/YYCache.h>)
FOUNDATION_EXPORT double YYCacheVersionNumber;
FOUNDATION_EXPORT const unsigned char YYCacheVersionString[];
#import <YYCache/YYMemoryCache.h>
#import <YYCache/YYDiskCache.h>
#import <YYCache/YYKVStorage.h>
#elif __has_include(<YYWebImage/YYCache.h>)
#import <YYWebImage/YYMemoryCache.h>
#import <YYWebImage/YYDiskCache.h>
#import <YYWebImage/YYKVStorage.h>
#else
#import "YYMemoryCache.h"
#import "YYDiskCache.h"
#import "YYKVStorage.h"
#endif

NS_ASSUME_NONNULL_BEGIN


/**
 `YYCache` 是线程安全的键值缓存。
 
 它使用“YYMemoryCache”将对象存储在小而快的内存缓存中，并使用“YYDiskCache”将对象持久化到大而慢的磁盘缓存中。有关详细信息，请参见“YYMemoryCache”和“YYDiskCache”。
 */
@interface YYCache : NSObject

/** 缓存的名称，只读。 */
@property (copy, readonly) NSString *name;

/** 底层内存缓存。有关详细信息，请参见“YYMemoryCache”。*/
@property (strong, readonly) YYMemoryCache *memoryCache;

/** 底层磁盘缓存。有关详细信息，请参见“YYDiskCache”*/
@property (strong, readonly) YYDiskCache *diskCache;

/**
 使用指定的名称创建新实例。
 多个同名实例将使缓存不稳定。
 
 @param name  缓存的名称。它将在应用程序的缓存字典中创建一个字典，用于磁盘缓存。初始化后，不应读写此目录。
 
 @result 一个新的缓存对象，如果发生错误则为nil。
 */
- (nullable instancetype)initWithName:(NSString *)name;

/**
 创建具有指定路径的新实例。
 具有相同名称的多个实例将使缓存不稳定。
 
 @param path  缓存将在其中写入数据的目录的完整路径。初始化后，不应该对该目录进行读写。
 @result 一个新的缓存对象，如果发生错误则为nil。
 */
- (nullable instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

/**
 方便的初始化
 创建具有指定名称的新实例。
 具有相同名称的多个实例将使缓存不稳定。
 
 @param name  缓存的名称。它将在应用程序的缓存字典中创建一个字典，用于磁盘缓存。初始化后，不应该对该目录进行读写。
 @result 一个新的缓存对象，如果发生错误则为nil。
 */
+ (nullable instancetype)cacheWithName:(NSString *)name;

/**
 方便的初始化
 创建具有指定路径的新实例。
 具有相同名称的多个实例将使缓存不稳定。
 
 @param path  缓存将在其中写入数据的目录的完整路径。初始化后，不应该对该目录进行读写。
 @result 一个新的缓存对象，如果发生错误则为nil。
 */
+ (nullable instancetype)cacheWithPath:(NSString *)path;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 返回一个布尔值，该值指示给定键是否在缓存中。
 此方法可能会阻塞调用线程，直到读取完文件为止。
 
 @param key 标识值的字符串。如果是nil，返回NO。
 @return 键是否在缓存中。
 */
- (BOOL)containsObjectForKey:(NSString *)key;

/**
 返回一个布尔值，该值带有指示给定键是否在缓存中的块。
 此方法立即返回并在操作完成时调用后台队列中传递的块。
 
 @param key   标识值的字符串。如果是nil，返回NO。
 @param block 完成后将在后台队列中调用的块。
 */
- (void)containsObjectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key, BOOL contains))block;

/**
 返回与给定键关联的值。
 此方法可能会阻塞调用线程，直到读取完文件为止。
 
 @param key 标识值的字符串。如果是nil，返回nil。
 @return 与key关联的值，如果没有与key关联的值，则为nil。
 */
- (nullable id<NSCoding>)objectForKey:(NSString *)key;

/**
 返回与给定键关联的值。
 此方法立即返回并在操作完成时调用后台队列中传递的块。
 
 @param key 标识值的字符串。如果是nil，返回nil。
 @param block 块完成后将在后台队列中调用的块。
 */
- (void)objectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key, id<NSCoding> object))block;

/**
 设置缓存中指定键的值。
 此方法可能会阻塞调用线程，直到文件写入完成。
 
 @param object 要存储在缓存中的对象。如果为nil，它调用' removeObjectForKey: '。
 @param key    用来关联值的键。如果为空，则此方法无效。
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

/**
 设置缓存中指定键的值。
 此方法立即返回并在操作完成时调用后台队列中传递的块。
 
 @param object 要存储在缓存中的对象。如果为nil，它调用' removeObjectForKey: '。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key withBlock:(nullable void(^)(void))block;

/**
 删除缓存中指定键的值。
 此方法可能会阻塞调用线程，直到文件删除完成。
 
 @param key 标识要删除的值的键。如果为空，则此方法无效。
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 删除缓存中指定键的值。
 此方法立即返回并在操作完成时调用后台队列中传递的块。
 
 @param key 标识要删除的值的键。如果为空，则此方法无效。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(nullable void(^)(NSString *key))block;

/**
 清空缓存。
 此方法可能会阻塞调用线程，直到文件删除完成。
 */
- (void)removeAllObjects;

/**
 清空缓存。
 此方法立即返回并在操作完成时调用后台队列中传递的块。
 
 @param block  完成后将在后台队列中调用的块。
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block;

/**
 用块清空缓存。
 方法立即返回并在后台使用block执行clear操作。
 
 @warning 您不应该在这些块中向这个实例发送消息。
 @param progress 此块将在删除期间调用，传递nil以忽略。
 @param end      此块将在最后调用，传递nil以忽略。
 */
- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;

@end

NS_ASSUME_NONNULL_END
