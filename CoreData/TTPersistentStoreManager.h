//
//  TTPersistentStoreManager.h
//  test
//
//  Created by 王刚 on 2022/12/14.
//

#import <Foundation/Foundation.h>
#import "UserEntity+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPersistentStoreManager : NSObject

/// 单例
+ (instancetype)sharedManager;

/// 保存上下文，对save:方法的封装，方便获取NSError
- (NSError *)saveContext;

/// 根据用户ID插入用户
/// - Parameter userID: 用户ID
/// - Parameter userName: 用户名
- (UserEntity *)insertUserWithUserID:(int64_t)userID userName:(NSString *)userName;

/// 根据用户ID查询用户
/// - Parameter userID: 用户ID
- (nullable UserEntity *)queryqueryWithUserID:(int64_t)userID;

/// 根据用户ID删除用户
/// - Parameter userID: 用户ID
- (void)deleteUserWithUserID:(int64_t)userID;

@end

NS_ASSUME_NONNULL_END
