//
//  UserEntity+CoreDataProperties.m
//  FrameworksTest
//
//  Created by 王刚 on 2022/12/23.
//  Copyright © 2022 王刚. All rights reserved.
//
//

#import "UserEntity+CoreDataProperties.h"

@implementation UserEntity (CoreDataProperties)

/// 返回搜索条件描述对象
+ (NSFetchRequest<UserEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserEntity"];
}

@dynamic userID;
@dynamic userName;

@end
