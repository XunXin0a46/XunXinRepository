//
//  UserEntity+CoreDataProperties.h
//  FrameworksTest
//
//  Created by 王刚 on 2022/12/23.
//  Copyright © 2022 王刚. All rights reserved.
//
//

#import "UserEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserEntity (CoreDataProperties)

/// 返回搜索条件描述对象
+ (NSFetchRequest<UserEntity *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int64_t userID;
@property (nullable, nonatomic, copy) NSString *userName;

@end

NS_ASSUME_NONNULL_END
