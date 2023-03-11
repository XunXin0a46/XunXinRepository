//
//  TestArchiverModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2023/1/30.
//  Copyright © 2023 王刚. All rights reserved.
//

#import "TestArchiverModel.h"

@implementation TestArchiverModel

/// 一个布尔值，指示类是否支持安全编码
+ (BOOL)supportsSecureCoding {
    return YES;
}

/// 使用给定的存档对接收器进行编码(归档时调用)。
/// - Parameter coder: 存档对象
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.age ?: NSNull.null forKey:@"age"];
    [coder encodeObject:self.name ?: NSNull.null forKey:@"name"];
}

/// 返回从给定的unarchiver(反归档)中的数据初始化的对象。
/// - Parameter coder: unarchiver(反归档)对象。
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self) {
        id age = [coder decodeObjectForKey:@"age"];
        self.age = [age isKindOfClass:NSNumber.class] ? age : nil;
        
        id name = [coder decodeObjectForKey:@"name"];
        self.name = [name isKindOfClass:NSString.class] ? name : nil;
    }
    return self;
}

@end
