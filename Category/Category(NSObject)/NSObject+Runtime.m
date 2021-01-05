//
//  NSObject+Runtime.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/12/6.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>


@implementation NSObject (Runtime)

+ (void)getProtocolList {
    //获取协议成员
    unsigned int count;
    __unsafe_unretained Protocol **protocoList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *pro = protocoList[i];
        const char *proName = protocol_getName(pro);
        YSCLog(@"proName = %@",[NSString stringWithUTF8String:proName]);
    }
}

//交换实例方法
- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    //源方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //交换方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
