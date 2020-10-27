//
//  YYDiskCache.h
//  YYCache <https://github.com/ibireme/YYCache>
//
//  Created by ibireme on 15/2/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YYDiskCache是一种线程安全的缓存，它存储由sqlite和文件系统支持的键值对（类似于NSURLCache的磁盘缓存）。
 
 YYDiskCache 具有以下功能:
 
 * 它使用LRU（(least-recently-used)最近最少使用）来移除对象。
 * 它可以由开销、数量和时期来控制。
 * 它可以配置为在没有可用磁盘空间时自动收回对象。
 * 它可以自动决定每个对象的存储类型（sqlite/file），以获得更好的性能。
 
 您可以编译最新版本的sqlite，而忽略ios系统中的libsqlite3.dylib，以获得2~4倍的速度。
 */
@interface YYDiskCache : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

/** 缓存的名称。默认值为nil。 */
@property (nullable, copy) NSString *name;

/** 缓存的路径（只读）。 */
@property (readonly) NSString *path;

/**
 如果对象的数据大小（字节）大于此值，则对象将存储为文件，否则对象将存储在sqlite中。
 0表示所有对象都将存储为单独的文件，NSUIntegerMax表示所有对象都将存储在sqlite中。
 默认值为20480（20KB）。
 */
@property (readonly) NSUInteger inlineThreshold;

/**
 如果此块不是nil，则该块将用于存档对象，而不是NSKeyedArchiver。可以使用此块支持不符合“NSCoding”协议的对象。
 
 默认值为nil。
 */
@property (nullable, copy) NSData *(^customArchiveBlock)(id object);

/**
 如果此块不是nil，则该块将用于非archive对象，而不是NSKeyedUnarchiver。可以使用此块支持不符合“NSCoding”协议的对象。
 
 默认值为nil。
 */
@property (nullable, copy) id (^customUnarchiveBlock)(NSData *data);

/**
 当需要将对象另存为文件时，将调用此块为指定键生成文件名。如果块为nil，则缓存使用md5（key）作为默认文件名。
 
 默认值为nil。
 */
@property (nullable, copy) NSString *(^customFileNameBlock)(NSString *key);



#pragma mark - Limit
///=============================================================================
/// @name Limit
///=============================================================================

/**
 缓存应保留的最大对象数。
 
 @discussion 默认值是NSUIntegerMax，这意味着没有限制。这不是一个严格的限制-如果缓存超过该限制，则缓存中的某些对象可能稍后在后台队列中被移除。
 */
@property NSUInteger countLimit;

/**
 在开始移除对象之前，缓存可以容纳的最大总开销。
 
 @discussion 默认值是NSUIntegerMax，这意味着没有限制。这不是一个严格的限制-如果缓存超过该限制，则缓存中的某些对象可能稍后在后台队列中被移除。
 */
@property NSUInteger costLimit;

/**
 缓存中对象的最长到期时间.
 
 @discussion 默认值是DBL_MAX，这意味着没有限制。这不是一个严格的限制-如果某个对象超过了限制，则可能稍后在后台队列中移除这些对象。
 
 */
@property NSTimeInterval ageLimit;

/**
 缓存应保留的最小可用磁盘空间（字节）。
 @discussion 默认值为0，表示没有限制。如果可用磁盘空间低于此值，缓存将删除对象以释放一些磁盘空间。这不是一个严格的限制。如果可用磁盘空间超过该限制，则可以稍后在后台队列中移除对象。
 */
@property NSUInteger freeDiskSpaceLimit;

/**
 自动微调检查时间间隔（秒）。默认值为60（1分钟）。
 
 @discussion 缓存保存一个内部计时器，用于检查缓存是否达到其限制，如果达到该限制，则开始移除对象。
 */
@property NSTimeInterval autoTrimInterval;

/**
 将“YES”设置为启用调试错误日志。
 */
@property BOOL errorLogsEnabled;

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 基于指定的路径创建新缓存。
 
 @param path 缓存将在其中写入数据的目录的完整路径。一旦初始化，就不应读写此目录。
 
 @return  一个新的缓存对象，如果发生错误，则为nil。
 
 @warning 如果指定路径的缓存实例已存在于内存中，则此方法将直接返回该实例，而不是创建新实例。
 */
- (nullable instancetype)initWithPath:(NSString *)path;

/**
 指定的初始值设定项。
 
 @param path  缓存将在其中写入数据的目录的完整路径。初始化后，不应读写此目录。
 
 @param threshold  数据存储内联阈值（字节）。如果对象的数据大小（字节）大于此值，则对象将存储为文件，否则对象将存储在sqlite中。0表示所有对象都将存储为单独的文件，NSUIntegerMax表示所有对象都将存储在sqlite中。如果你不知道你的对象的大小，20480是一个不错的选择。首次初始化后，不应更改指定路径的此值。
 
 @return 一个新的缓存对象，如果发生错误，则为nil。
 
 @warning 如果指定路径的缓存实例已存在于内存中，则此方法将直接返回该实例，而不是创建新实例。
 */
- (nullable instancetype)initWithPath:(NSString *)path
                      inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;


#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 返回指示给定键是否在缓存中的布尔值。此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key 标识值的字符串。如果没有，就返回NO。
 @return 键是否在缓存中。
 */
- (BOOL)containsObjectForKey:(NSString *)key;

/**
 返回一个布尔值，其中包含指示给定键是否在缓存中的块。此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param key   标识值的字符串。如果没有，就返回NO。
 @param block 完成后将在后台队列中调用的块。
 */
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL contains))block;

/**
 返回与给定键关联的值。
 此方法可能会阻塞调用线程，直到文件读取完成。
 
 @param key 标识值的字符串。如果没有，就返回nil。
 @return 与键关联的值，如果没有与键关联的值，则为nil。
 */
- (nullable id<NSCoding>)objectForKey:(NSString *)key;

/**
 返回与给定键关联的值。
 此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param key 标识值的字符串。如果没有，就返回零。
 @param block 完成后将在后台队列中调用的块。
 */
- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> _Nullable object))block;

/**
 设置缓存中指定键的值。
 此方法可能会阻塞调用线程，直到文件写入完成。
 
 @param object 要存储在缓存中的对象。如果为nil，则调用“removeObjectForKey:”。
 @param key    与值关联的键。如果为nil，则此方法无效。
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

/**
 设置缓存中指定键的值。
 此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param object 要存储在缓存中的对象。如果为nil，则调用“removeObjectForKey:”。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block;

/**
 删除缓存中指定键的值。
 此方法可能会阻塞调用线程，直到文件删除完成。
 
 @param key 标识要删除的值的键。如果为nil，则此方法无效。
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 删除缓存中指定键的值。
 此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param key 标识要删除的值的键。如果为零，则此方法无效。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block;

/**
 清空缓存。
 此方法可能会阻塞调用线程，直到文件删除完成。
 */
- (void)removeAllObjects;

/**
 清空缓存。
 此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param block  完成后将在后台队列中调用的块。
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block;

/**
 用block清空缓存。
 此方法立即返回并在后台执行块清除操作。
 
 @warning 不应在这些块中向此实例发送消息。
 @param progress 此块将在删除期间调用，传递nil以忽略。
 @param end      此块将在最后调用，传递nil忽略。
 */
- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;


/**
 返回此缓存中的对象数。
 此方法可能会阻塞调用线程，直到文件读取完成。
 
 @return 总对象数。
 */
- (NSInteger)totalCount;

/**
 获取此缓存中的对象数。
 此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param block  完成后将在后台队列中调用的块。
 */
- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block;

/**
 返回此缓存中对象的总开销（字节）。
 此方法可能会阻塞调用线程，直到文件读取完成。
 
 @return 对象的总开销（字节）。
 */
- (NSInteger)totalCost;

/**
 获取此缓存中对象的总开销（字节）。
 此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param block  完成后将在后台队列中调用的块。
 */
- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block;


#pragma mark - Trim
///=============================================================================
/// @name Trim
///=============================================================================

/**
 使用LRU从缓存中删除对象，直到“totalCount”低于指定值。此方法可能会阻塞调用线程，直到操作完成。
 
 @param count  清除缓存后允许保留的总数。
 */
- (void)trimToCount:(NSUInteger)count;

/**
 使用LRU从缓存中删除对象，直到“totalCount”低于指定值。此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param count  清除缓存后允许保留的总数。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block;

/**
 使用LRU从缓存中删除对象，直到“totalCost”低于指定值。此方法可能会阻塞调用线程，直到操作完成。
 
 @param cost 清除缓存后允许保留的总成本。
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 使用LRU从缓存中删除对象，直到“totalCost”低于指定值。此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param cost 清除缓存后允许保留的总成本。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block;

/**
 使用LRU从缓存中移除对象，直到指定值移除所有到期对象。此方法可能会阻塞调用线程，直到操作完成。
 
 @param age  对象的最大到期时间。
 */
- (void)trimToAge:(NSTimeInterval)age;

/**
 使用LRU从缓存中移除对象，直到指定值移除所有到期对象。此方法立即返回，并在操作完成时调用后台队列中传递的块。
 
 @param age  对象的最大到期时间。
 @param block  完成后将在后台队列中调用的块。
 */
- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block;


#pragma mark - Extended Data
///=============================================================================
/// @name Extended Data
///=============================================================================

/**
 从对象获取扩展数据。
 
 @discussion 有关详细信息，请参阅“setExtendedData:toObject:”。
 
 @param object 对象。
 @return 扩展数据。
 */
+ (nullable NSData *)getExtendedDataFromObject:(id)object;

/**
 将扩展数据设置为对象。
 
 @discussion 在将对象保存到磁盘缓存之前，可以将任何扩展数据设置为对象。扩展数据也将与此对象一起保存。以后可以使用“getExtendedDataFromObject:”获取扩展数据。
 
 @param extendedData 扩展数据（传递nil以删除）。
 @param object       对象。
 */
+ (void)setExtendedData:(nullable NSData *)extendedData toObject:(id)object;

@end

NS_ASSUME_NONNULL_END
