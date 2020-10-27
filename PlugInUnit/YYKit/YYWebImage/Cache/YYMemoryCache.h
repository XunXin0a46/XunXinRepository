//
//  YYMemoryCache.h
//  YYCache <https://github.com/ibireme/YYCache>
//
//  Created by ibireme on 15/2/7.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YYMemoryCache 是一种存储键值对的快速内存缓存。
 与NSDictionary相反，密钥是保留的，而不是复制的。
 API和性能类似于NSCache，所有方法都是线程安全的。
 
 YYMemoryCache对象与NSCache有几个不同之处：
 
 * 它使用LRU（least-recently-used（最近最少使用））来移除对象；NSCache's的移除方法是不确定的。
 * 它可以由成本、计数和时期来控制；NSCache的限制是不精确的。
 * 它可以配置为在接收内存警告或应用程序进入后台时自动收回对象。
 
 YYMemoryCache中“Access Methods”的时间通常为常数时间（O（1））。
 */
@interface YYMemoryCache : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

/** 缓存的名称。默认值为nil。 */
@property (nullable, copy) NSString *name;

/** 缓存中的对象数（只读） */
@property (readonly) NSUInteger totalCount;

/** 缓存中对象的总开销（只读）。 */
@property (readonly) NSUInteger totalCost;


#pragma mark - Limit
///=============================================================================
/// @name Limit
///=============================================================================

/**
 缓存应保留的最大对象数。
 
 @discussion 默认值是NSUIntegerMax，这意味着没有限制。这不是一个严格的限制如果缓存超过了限制，缓存中的某些对象可能会在稍后的后台线程中被移除。
 */
@property NSUInteger countLimit;

/**
 在开始移除对象之前，缓存可以容纳的最大总开销。
 
 @discussion 默认值是NSUIntegerMax，这意味着没有限制。这不是一个严格的限制如果缓存超过了限制，缓存中的某些对象可能会在稍后的后台线程中被移除。
 */
@property NSUInteger costLimit;

/**
 缓存中对象的最长到期时间。
 
 @discussion 默认值是DBL_MAX，这意味着没有限制。这不是一个严格的限制如果一个对象超过了这个限制，那么这个对象可能会在稍后的后台线程中被移除逐出。
 */
@property NSTimeInterval ageLimit;

/**
 自动微调检查时间间隔（秒）。默认值为5.0。
 
 @discussion 缓存保存一个内部计时器，用于检查缓存是否达到其限制，如果达到该限制，则开始移除对象。
 */
@property NSTimeInterval autoTrimInterval;

/**
 如果“YES”，则当应用程序收到内存警告时，缓存将删除所有对象。默认值为“YES”。
 */
@property BOOL shouldRemoveAllObjectsOnMemoryWarning;

/**
 如果“YES”，则当应用程序进入后台时，缓存将删除所有对象。默认值为“YES”。
 */
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;

/**
 当应用程序收到内存警告时要执行的块。默认值为nil。
 */
@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(YYMemoryCache *cache);

/**
 应用程序进入后台时要执行的块。默认值为nil。
 */
@property (nullable, copy) void(^didEnterBackgroundBlock)(YYMemoryCache *cache);

/**
 如果'YES'，键值对将在主线程上释放，否则在后台线程上释放。默认为NO。
 
 @discussion 如果键值对象包含应在主线程（如UIView/CALayer）中释放的实例，则可以将此值设置为“yes”。
 */
@property BOOL releaseOnMainThread;

/**
 如果“YES”，则将异步释放键值对，以避免阻塞访问方法，否则将在访问方法中释放它（例如removeObjectForKey:）。默认为“YES”。
 */
@property BOOL releaseAsynchronously;


#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 返回指示给定键是否在缓存中的布尔值。
 
 @param key 标识值的对象。如果没有，就返回“NO”。
 @return 键是否在缓存中。
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 返回与给定键关联的值。
 
 @param key 标识值的对象。如果没有，就返回nil。
 @return 与键关联的值，如果没有与键关联的值，则为nil。
 */
- (nullable id)objectForKey:(id)key;

/**
 设置缓存中指定密钥的值（0开销）。
 
 @param object 要存储在缓存中的对象。如果为nil，则调用“removeObjectForKey:”。
 @param key    与值关联的键。如果为nil，则此方法无效。
 @discussion   与NSMutableDictionary对象不同，缓存不会复制键
 放入其中的对象。
 */
- (void)setObject:(nullable id)object forKey:(id)key;

/**
 设置缓存中指定键的值，并将该密钥-值对与指定开销关联。
 
 @param object 要存储在缓存中的对象。如果为nil，则调用“removeObjectForKey”。
 @param key    与值关联的键。如果为nil，则此方法无效。
 @param cost   与键值对关联的开销。
 @discussion   与NSMutableDictionary对象不同，缓存不会复制放入其中的键对象。
 */
- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost;

/**
 删除缓存中指定键的值。
 
 @param key 标识要删除的值的键。如果为nil，则此方法无效。
 */
- (void)removeObjectForKey:(id)key;

/**
 立即清空缓存。
 */
- (void)removeAllObjects;


#pragma mark - Trim
///=============================================================================
/// @name Trim
///=============================================================================

/**
 使用LRU从缓存中删除对象，直到“totalCount”低于或等于指定值。
 @param count  清除缓存后允许保留的总数。
 */
- (void)trimToCount:(NSUInteger)count;

/**
 使用LRU从缓存中删除对象，直到“totalCost”等于指定值。
 @param cost 清除缓存后允许保留的总成本。
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 使用LRU从缓存中移除对象，直到指定值移除所有到期对象。
 @param age  对象的最大到期时间（秒）。
 */
- (void)trimToAge:(NSTimeInterval)age;

@end

NS_ASSUME_NONNULL_END
