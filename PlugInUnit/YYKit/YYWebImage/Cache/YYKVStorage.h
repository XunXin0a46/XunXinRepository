//
//  YYKVStorage.h
//  YYCache <https://github.com/ibireme/YYCache>
//
//  Created by ibireme on 15/4/22.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YYKVStorageItem被“YYKVStorage”用来存储键值对和元数据。通常，您不应该直接使用该类。
 */
@interface YYKVStorageItem : NSObject
@property (nonatomic, strong) NSString *key;                ///< key
@property (nonatomic, strong) NSData *value;                ///< value
@property (nullable, nonatomic, strong) NSString *filename; ///< 文件名（内联时为零）
@property (nonatomic) int size;                             ///< 值的大小（字节）
@property (nonatomic) int modTime;                          ///< 修改Unix时间戳
@property (nonatomic) int accessTime;                       ///< 上次访问Unix时间戳
@property (nullable, nonatomic, strong) NSData *extendedData; ///< 扩展数据（如果没有扩展数据，则为nil）
@end

/**
 存储类型，指示“YYKVStorageItem.value”存储的位置。
 
 @discussion 通常，向sqlite写入数据比外部文件快，但读取性能取决于数据大小。在我的测试中（在iphone 6 64g上），当数据大于20kb时，从外部文件读取数据比从sqlite读取数据快。
 
 *如果要存储大量小数据（如联系人缓存），请使用YYKVStorageTypeSQLite以获得更好的性能。
 *如果要存储大文件（如图像缓存），请使用YYKVStorageTypeFile以获得更好的性能。
 *您可以使用YYKVStorageTypeMixed并为每个项目选择存储类型。
 
 有关详细信息，<http://www.sqlite.org/intern-v-extern-blob.html> 。
 */
typedef NS_ENUM(NSUInteger, YYKVStorageType) {
    
    /// “value”作为文件存储在文件系统中。
    YYKVStorageTypeFile = 0,
    
    /// “value”存储在blob类型的sqlite中。
    YYKVStorageTypeSQLite = 1,
    
    /// 根据您的选择，“value”存储在文件系统或sqlite中。
    YYKVStorageTypeMixed = 2,
};



/**
 YYKVStorage是一种基于sqlite和文件系统的键值存储。通常，您不应该直接使用该类。
 
 @discussion  为YYKVStorage指定的初始值设定项是“initwithpath:type:”。初始化后，将基于“path”创建一个目录来保存键值数据。初始化后，不应在没有实例的情况下读取或写入此目录。
 
 您可以编译最新版本的sqlite，而忽略ios系统中的libsqlite3.dylib，以获得2~4倍的速度。
 
 @warning 这个类的实例是线程*不*安全的，您需要确保只有一个线程可以同时访问该实例。如果您真的需要在多线程中处理大量数据，那么应该将数据分割到多个kvstorage实例（sharding）。
 */
@interface YYKVStorage : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

@property (nonatomic, readonly) NSString *path;        ///< 存储的路径。
@property (nonatomic, readonly) YYKVStorageType type;  ///< 存储的类型。
@property (nonatomic) BOOL errorLogsEnabled;           ///< 将“YES”设置为启用调试错误日志。

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 指定的初始值设定项。
 
 @param path  存储将在其中写入数据的目录的完整路径。如果目录不存在，它将尝试创建一个目录，否则将读取此目录中的数据。
 @param type  存储类型。首次初始化后，不应更改指定路径的类型。
 @return  一个新的存储对象，如果发生错误，则为nil。
 @warning 具有相同路径的多个实例将使存储不稳定。
 */
- (nullable instancetype)initWithPath:(NSString *)path type:(YYKVStorageType)type NS_DESIGNATED_INITIALIZER;


#pragma mark - Save Items
///=============================================================================
/// @name Save Items
///=============================================================================

/**
 保存项目或用“key”更新项目（如果已存在）。
 
 @discussion 此方法将保存item.key、item.value、item.filename和
 item.extendeddata到磁盘或sqlite，其他属性将被忽略。item.key和item.value不应为空（零或零长度）。
 
 如果“type”是YYKVStorageTypeFile，则item.filename不应为空。
 如果“type”是YYKVStorageTypeSQLite，则将忽略item.filename。
 如果“type”是YYKVStorageTypeMixed，则如果item.filename不为空，则item.value将保存到文件系统，否则将保存到sqlite。
 
 @param item  一个项目。
 @return 是否成功。
 */
- (BOOL)saveItem:(YYKVStorageItem *)item;

/**
 保存项目或用“key”更新项目（如果已存在）。
 
 @discussion 此方法将键-值对保存到sqlite。如果“type”是YYKVStorageTypeFile，则此方法将失败。
 
 
 @param key   键，不应为空（nil或零长度）。
 @param value 值，不应为空（nil或零长度）。
 @return Whether succeed.
 */
- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value;

/**
 保存项目或用“key”更新项目（如果已存在）。
 
 @discussion
 如果“type”是YYKVStorageTypeFile，则“filename”不应为空。
 如果“type”是YYKVStorageTypeSQLite，则将忽略“filename”。
 如果“type”是YYKVStorageTypeMixed，则如果“filename”不为空，“value”将保存到文件系统，否则将保存到sqlite。
 
 @param key           键，不应为空（nil或零长度）。
 @param value         值，不应为空（nil或零长度）。
 @param filename      文件名。
 @param extendedData  此项的扩展数据（传递nil忽略它）。
 
 @return 是否成功。
 */
- (BOOL)saveItemWithKey:(NSString *)key
                  value:(NSData *)value
               filename:(nullable NSString *)filename
           extendedData:(nullable NSData *)extendedData;

#pragma mark - Remove Items
///=============================================================================
/// @name Remove Items
///=============================================================================

/**
 删除带有“key”的项。
 
 @param key 项目的键。
 @return 是否成功。
 */
- (BOOL)removeItemForKey:(NSString *)key;

/**
 使用键数组移除项。
 
 @param keys 指定键的数组。
 
 @return 是否成功。
 */
- (BOOL)removeItemForKeys:(NSArray<NSString *> *)keys;

/**
 删除“value”大于指定大小的所有项。
 
 @param size  以字节为单位的最大大小。
 @return 是否成功。
 */
- (BOOL)removeItemsLargerThanSize:(int)size;

/**
 删除上次访问时间早于指定时间戳的所有项。
 
 @param time  指定的Unix时间戳。
 @return 是否成功。
 */
- (BOOL)removeItemsEarlierThanTime:(int)time;

/**
 删除项以使总大小不大于指定大小。最近使用最少（LRU）的项目将首先删除。
 
 @param maxSize 以字节为单位的指定大小。
 @return 是否成功。
 */
- (BOOL)removeItemsToFitSize:(int)maxSize;

/**
 删除项以使总计数不大于指定的计数。最近使用最少（LRU）的项目将首先删除。
 
 @param maxCount 指定的项计数。
 @return 是否成功。
 */
- (BOOL)removeItemsToFitCount:(int)maxCount;

/**
 删除后台队列中的所有项。
 
 @discussion 此方法将文件和sqlite数据库删除到垃圾箱文件夹，然后清除后台队列中的文件夹。因此，此方法比“removeAllItemsWithProgressBlock:endBlock:”快得多。
 
 @return 是否成功。
 */
- (BOOL)removeAllItems;

/**
 删除所有项目。
 
 @warning 不应在这些块中向此实例发送消息。
 @param progress 此块将在删除期间调用，传递nil以忽略。
 @param end      此块将在最后调用，传递nil忽略。
 */
- (void)removeAllItemsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                               endBlock:(nullable void(^)(BOOL error))end;


#pragma mark - Get Items
///=============================================================================
/// @name Get Items
///=============================================================================

/**
 获取具有指定键的项。
 
 @param key 指定的键。
 @return 键的项，如果不存在则为零/发生错误。
 */
- (nullable YYKVStorageItem *)getItemForKey:(NSString *)key;

/**
 使用指定的键获取项目信息。
 此项中的“value”将被忽略。
 
 @param key 指定的键。
 @return 键的项信息，如果不存在则为零/发生错误。
 */
- (nullable YYKVStorageItem *)getItemInfoForKey:(NSString *)key;

/**
 使用指定的键获取项值。
 
 @param key  指定的键。
 @return 项的值，如果不存在则为零/发生错误。
 */
- (nullable NSData *)getItemValueForKey:(NSString *)key;

/**
 获取具有一个键数组的项。
 
 @param keys  指定键的数组。
 @return “YYKVStorageItem”数组，如果不存在则为零/出现错误。
 
 */
- (nullable NSArray<YYKVStorageItem *> *)getItemForKeys:(NSArray<NSString *> *)keys;

/**
 使用一组键获取项目信息
 将忽略项中的“value”。
 
 @param keys  指定键的数组。
 @return “YYKVStorageItem”数组，如果不存在则为零/出现错误。
 */
- (nullable NSArray<YYKVStorageItem *> *)getItemInfoForKeys:(NSArray<NSString *> *)keys;

/**
 使用键数组获取项值。
 
 @param keys  指定键的数组。
 @return 一种字典，其中键为“key”，值为“value”，如果不存在则为nil/发生错误。
 */
- (nullable NSDictionary<NSString *, NSData *> *)getItemValueForKeys:(NSArray<NSString *> *)keys;

#pragma mark - Get Storage Status
///=============================================================================
/// @name Get Storage Status
///=============================================================================

/**
 指定键的项是否存在。
 
 @param key  指定的键。
 
 @return `YES`如果密钥存在项，则为'NO'，如果不存在或发生错误。
 */
- (BOOL)itemExistsForKey:(NSString *)key;

/**
 获取项目总数。
 @return 发生错误时，项目总数为-1。
 */
- (int)getItemsCount;

/**
 获取项值的总大小（字节）。
 @return 发生错误时的总大小（字节）为-1。
 */
- (int)getItemsSize;

@end

NS_ASSUME_NONNULL_END
