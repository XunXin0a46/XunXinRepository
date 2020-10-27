//
//  FSCalendarDelegationProxy.m
//  FSCalendar
//
//  Created by dingwenchao on 11/12/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "FSCalendarDelegationProxy.h"
#import <objc/runtime.h>

@implementation FSCalendarDelegationProxy

///初始化
- (instancetype)init
{
    return self;
}

///是否实现或继承可以响应指定消息的方法
- (BOOL)respondsToSelector:(SEL)selector
{
    //代理对象是否响应了函数
    BOOL responds = [self.delegation respondsToSelector:selector];
    //如果代理对象没有响应函数，判断代理对象是否响应了对应的不推荐的函数
    if (!responds) responds = [self.delegation respondsToSelector:[self deprecatedSelectorOfSelector:selector]];
    //如果代理对象没有响应函数，也没有响应对应的不推荐的函数，判断超类是否响应了函数
    if (!responds) responds = [super respondsToSelector:selector];
    //返回结果
    return responds;
}

///指示接收器是否符合给定协议
- (BOOL)conformsToProtocol:(Protocol *)protocol
{
    //返回一个布尔值，该值指示接收器是否符合给定协议
    return [self.delegation conformsToProtocol:protocol];
}

///将给定的调用传递给代理所表示的实际对象。NSProxy的实现只会引发NSInvalidArgumentException。在子类中重写此方法以适当地处理调用，至少通过设置其返回值。
- (void)forwardInvocation:(NSInvocation *)invocation
{
    //通过NSInvocation对象获取转发消息的选择器
    SEL selector = invocation.selector;
    //如果代理对象没有响应选择器
    if (![self.delegation respondsToSelector:selector]) {
        //获取不推荐的选择器
        selector = [self deprecatedSelectorOfSelector:selector];
        //设置转发消息的选择器
        invocation.selector = selector;
    }
    //如果代理对象响应了选择器
    if ([self.delegation respondsToSelector:selector]) {
        //设置接收方的目标，将接收方的消息（带参数）发送到该目标，并设置返回值。
        [invocation invokeWithTarget:self.delegation];
    }
}

///NSProxy提供的实现引发NSInvalidArgumentException。重写具体子类中的此方法，为给定选择器和代理对象所代表的类返回正确的NSMethodSignature对象。
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    //判断代理对象是否响应给定的选择器
    if ([self.delegation respondsToSelector:sel]) {
        //返回NSMethodSignature对象
        return [(NSObject *)self.delegation methodSignatureForSelector:sel];
    }
    //获取不推荐的选择器
    SEL selector = [self deprecatedSelectorOfSelector:sel];
    //如果代理对象响应了不推荐的选择器
    if ([self.delegation respondsToSelector:selector]) {
        //返回NSMethodSignature对象
        return [(NSObject *)self.delegation methodSignatureForSelector:selector];
    }
#if TARGET_INTERFACE_BUILDER
    //此处编译的代码，在IB中绘画中调用
    return [NSObject methodSignatureForSelector:@selector(init)];
#endif
    //此处编译的代码，在app运行调用
    //获取给定协议的指定方法的方法描述结构
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, sel, NO, YES);
    //获取方法参数的类型
    const char *types = desc.types;
    //如果方法存在参数的类型，返回给定Objective-C方法类型字符串的NSMethodSignature对象。如果如果方法不存在参数的类型，返回包含init方法的描述的NSMethodSignature对象
    return types?[NSMethodSignature signatureWithObjCTypes:types]:[NSObject methodSignatureForSelector:@selector(init)];
}

///与选择器对应的不推荐的选择器
- (SEL)deprecatedSelectorOfSelector:(SEL)selector
{
    //获取选择器名称
    NSString *selectorString = NSStringFromSelector(selector);
    //在deprecations字典中取出对应的Value，Key为推荐使用的选择器，Value为不推荐使用的选择器
    selectorString = self.deprecations[selectorString];
    //返回不推荐选择器的编号
    return NSSelectorFromString(selectorString);
}

@end
