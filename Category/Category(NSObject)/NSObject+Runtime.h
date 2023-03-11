//
//  NSObject+Runtime.h
//  FrameworksTest
//
//  Created by 王刚 on 2019/12/6.
//  Copyright © 2019 王刚. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSObject (Runtime)

///获取协议成员
+ (void)getProtocolList;

///交换方法
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end


