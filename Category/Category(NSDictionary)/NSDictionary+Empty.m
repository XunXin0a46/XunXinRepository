//
//  NSDictionary+Empty.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/12/6.
//  Copyright © 2019 王刚. All rights reserved.
//  处理字典添加属性为空的分类

#import "NSDictionary+Empty.h"
#import <objc/runtime.h>



@implementation NSDictionary (Empty)

+ (void)load{
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(em_setObject:forkey:));
    method_exchangeImplementations(fromMethod, toMethod);
}

///可变字典对 - (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey函数anObject为空的处理，避免程序中断
- (void)em_setObject:(id)emObject forkey:(NSString *)key {
    if (emObject == nil) {
        @try {

        }
        @catch (NSException *exception) {
            YSCLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            YSCLog(@"%@", [exception callStackSymbols]);
            emObject = [NSString stringWithFormat:@""];
            [self em_setObject:emObject forkey:key];
        }
        @finally {}
    }else {
        [self em_setObject:emObject forkey:key];
    }
}


@end
