//
//  NSObject+Swizzling.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/12.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Swizzling)

///函数交换
+ (void)swizzlingMethod:(SEL)originalSelector toMethod:(SEL)swizzledSelector;

@end
