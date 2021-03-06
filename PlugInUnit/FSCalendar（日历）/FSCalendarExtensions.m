//
//  FSCalendarExtensions.m
//  FSCalendar
//
//  Created by dingwenchao on 10/8/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "FSCalendarExtensions.h"
#import <objc/runtime.h>

@implementation UIView (FSCalendarExtensions)

- (CGFloat)fs_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setFs_width:(CGFloat)fs_width
{
    self.frame = CGRectMake(self.fs_left, self.fs_top, fs_width, self.fs_height);
}

- (CGFloat)fs_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setFs_height:(CGFloat)fs_height
{
    self.frame = CGRectMake(self.fs_left, self.fs_top, self.fs_width, fs_height);
}

- (CGFloat)fs_top
{
    return CGRectGetMinY(self.frame);
}

- (void)setFs_top:(CGFloat)fs_top
{
    self.frame = CGRectMake(self.fs_left, fs_top, self.fs_width, self.fs_height);
}

- (CGFloat)fs_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setFs_bottom:(CGFloat)fs_bottom
{
    self.fs_top = fs_bottom - self.fs_height;
}

- (CGFloat)fs_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setFs_left:(CGFloat)fs_left
{
    self.frame = CGRectMake(fs_left, self.fs_top, self.fs_width, self.fs_height);
}

- (CGFloat)fs_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setFs_right:(CGFloat)fs_right
{
    self.fs_left = self.fs_right - self.fs_width;
}

@end


@implementation CALayer (FSCalendarExtensions)

- (CGFloat)fs_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setFs_width:(CGFloat)fs_width
{
    self.frame = CGRectMake(self.fs_left, self.fs_top, fs_width, self.fs_height);
}

- (CGFloat)fs_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setFs_height:(CGFloat)fs_height
{
    self.frame = CGRectMake(self.fs_left, self.fs_top, self.fs_width, fs_height);
}

- (CGFloat)fs_top
{
    return CGRectGetMinY(self.frame);
}

- (void)setFs_top:(CGFloat)fs_top
{
    self.frame = CGRectMake(self.fs_left, fs_top, self.fs_width, self.fs_height);
}

- (CGFloat)fs_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setFs_bottom:(CGFloat)fs_bottom
{
    self.fs_top = fs_bottom - self.fs_height;
}

- (CGFloat)fs_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setFs_left:(CGFloat)fs_left
{
    self.frame = CGRectMake(fs_left, self.fs_top, self.fs_width, self.fs_height);
}

- (CGFloat)fs_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setFs_right:(CGFloat)fs_right
{
    self.fs_left = self.fs_right - self.fs_width;
}

@end

@interface NSCalendar (FSCalendarExtensionsPrivate)

@property (readonly, nonatomic) NSDateComponents *fs_privateComponents;

@end

@implementation NSCalendar (FSCalendarExtensions)

///当前月的第一天
- (nullable NSDate *)fs_firstDayOfMonth:(NSDate *)month
{
    if (!month) return nil;
    //初始化日期组件(组件为年、月、日、小时)
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    //设置补偿天数
    components.day = 1;
    //从给定组件计算的绝对时间
    return [self dateFromComponents:components];
}

///当前月的最后一天
- (nullable NSDate *)fs_lastDayOfMonth:(NSDate *)month
{
    month = [NSDate date];
    if (!month) return nil;
    //初始化日期组件(组件为年、月、日、小时)
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    //设置补偿月数
    components.month++;
    //设置补偿天数
    components.day = 0;
    //从给定组件计算的绝对时间
    return [self dateFromComponents:components];
}

- (nullable NSDate *)fs_firstDayOfWeek:(NSDate *)week
{
    week = [NSDate date];
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *components = self.fs_privateComponents;
    components.day = - (weekdayComponents.weekday - self.firstWeekday);
    components.day = (components.day-7) % 7;
    NSDate *firstDayOfWeek = [self dateByAddingComponents:components toDate:week options:0];
    firstDayOfWeek = [self dateBySettingHour:0 minute:0 second:0 ofDate:firstDayOfWeek options:0];
    components.day = NSIntegerMax;
    return firstDayOfWeek;
}

- (nullable NSDate *)fs_lastDayOfWeek:(NSDate *)week
{
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *components = self.fs_privateComponents;
    components.day = - (weekdayComponents.weekday - self.firstWeekday);
    components.day = (components.day-7) % 7 + 6;
    NSDate *lastDayOfWeek = [self dateByAddingComponents:components toDate:week options:0];
    lastDayOfWeek = [self dateBySettingHour:0 minute:0 second:0 ofDate:lastDayOfWeek options:0];
    components.day = NSIntegerMax;
    return lastDayOfWeek;
}

- (nullable NSDate *)fs_middleDayOfWeek:(NSDate *)week
{
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *componentsToSubtract = self.fs_privateComponents;
    componentsToSubtract.day = - (weekdayComponents.weekday - self.firstWeekday) + 3;
    NSDate *middleDayOfWeek = [self dateByAddingComponents:componentsToSubtract toDate:week options:0];
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:middleDayOfWeek];
    middleDayOfWeek = [self dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    return middleDayOfWeek;
}

- (NSInteger)fs_numberOfDaysInMonth:(NSDate *)month
{
    if (!month) return 0;
    NSRange days = [self rangeOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitMonth
                                       forDate:month];
    return days.length;
}

- (NSDateComponents *)fs_privateComponents
{
    NSDateComponents *components = objc_getAssociatedObject(self, _cmd);
    if (!components) {
        components = [[NSDateComponents alloc] init];
        objc_setAssociatedObject(self, _cmd, components, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return components;
}

@end

@implementation NSMapTable (FSCalendarExtensions)

- (void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) return;
    
    if (obj) {
        [self setObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key
{
    return [self objectForKey:key];
}

@end

@implementation NSCache (FSCalendarExtensions)

- (void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) return;
    
    if (obj) {
        [self setObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key
{
    return [self objectForKey:key];
}

@end

@implementation NSObject (FSCalendarExtensions)

#define IVAR_IMP(SET,GET,TYPE) \
- (void)fs_set##SET##Variable:(TYPE)value forKey:(NSString *)key \
{ \
    Ivar ivar = class_getInstanceVariable([self class], key.UTF8String); \
    ((void (*)(id, Ivar, TYPE))object_setIvar)(self, ivar, value); \
} \
- (TYPE)fs_##GET##VariableForKey:(NSString *)key \
{ \
    Ivar ivar = class_getInstanceVariable([self class], key.UTF8String); \
    ptrdiff_t offset = ivar_getOffset(ivar); \
    unsigned char *bytes = (unsigned char *)(__bridge void *)self; \
    TYPE value = *((TYPE *)(bytes+offset)); \
    return value; \
}
IVAR_IMP(Bool,bool,BOOL)
IVAR_IMP(Float,float,CGFloat)
IVAR_IMP(Integer,integer,NSInteger)
IVAR_IMP(UnsignedInteger,unsignedInteger,NSUInteger)
#undef IVAR_IMP

- (void)fs_setVariable:(id)variable forKey:(NSString *)key
{
    Ivar ivar = class_getInstanceVariable(self.class, key.UTF8String);
    object_setIvar(self, ivar, variable);
}

- (id)fs_variableForKey:(NSString *)key
{
    Ivar ivar = class_getInstanceVariable(self.class, key.UTF8String);
    id variable = object_getIvar(self, ivar);
    return variable;
}

///将指定的函数消息发送到接收器并返回消息的结果
- (id)fs_performSelector:(SEL)selector withObjects:(nullable id)firstObject, ...
{
    //如果没有获取到函数编号，返回nil
    if (!selector) return nil;
    //获取NSMethodSignature(方法签名)对象，记录方法的返回值和参数的类型信息
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    //如果没有获取到方法签名对象，返回nil
    if (!signature) return nil;
    //创建能够使用给定方法签名构造消息的NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    //如果没有获取到NSInvocation(调用)对象，返回nil
    if (!invocation) return nil;
    //设置由invoke发送的消息的接收者
    invocation.target = self;
    //设置由invoke发送的消息
    invocation.selector = selector;
    
    // Parameters 为invoke设置参数
    if (firstObject) {
        int index = 2;
        va_list args;
        va_start(args, firstObject);
        if (firstObject) {
            id obj = firstObject;
            do {
                const char *argType = [signature getArgumentTypeAtIndex:index];
                if(!strcmp(argType, @encode(id))){
                    // object
                    [invocation setArgument:&obj atIndex:index++];
                } else {
                    NSString *argTypeString = [NSString stringWithUTF8String:argType];
                    if ([argTypeString hasPrefix:@"{"] && [argTypeString hasSuffix:@"}"]) {
                        // struct
#define PARAM_STRUCT_TYPES(_type,_getter,_default) \
if (!strcmp(argType, @encode(_type))) { \
    _type value = [obj respondsToSelector:@selector(_getter)]?[obj _getter]:_default; \
    [invocation setArgument:&value atIndex:index]; \
}
                        PARAM_STRUCT_TYPES(CGPoint, CGPointValue, CGPointZero)
                        PARAM_STRUCT_TYPES(CGSize, CGSizeValue, CGSizeZero)
                        PARAM_STRUCT_TYPES(CGRect, CGRectValue, CGRectZero)
                        PARAM_STRUCT_TYPES(CGAffineTransform, CGAffineTransformValue, CGAffineTransformIdentity)
                        PARAM_STRUCT_TYPES(CATransform3D, CATransform3DValue, CATransform3DIdentity)
                        PARAM_STRUCT_TYPES(CGVector, CGVectorValue, CGVectorMake(0, 0))
                        PARAM_STRUCT_TYPES(UIEdgeInsets, UIEdgeInsetsValue, UIEdgeInsetsZero)
                        PARAM_STRUCT_TYPES(UIOffset, UIOffsetValue, UIOffsetZero)
                        PARAM_STRUCT_TYPES(NSRange, rangeValue, NSMakeRange(NSNotFound, 0))
                        
#undef PARAM_STRUCT_TYPES
                        index++;
                    } else {
                        // basic type
#define PARAM_BASIC_TYPES(_type,_getter) \
if (!strcmp(argType, @encode(_type))) { \
    _type value = [obj respondsToSelector:@selector(_getter)]?[obj _getter]:0; \
    [invocation setArgument:&value atIndex:index]; \
}
                        PARAM_BASIC_TYPES(BOOL, boolValue)
                        PARAM_BASIC_TYPES(int, intValue)
                        PARAM_BASIC_TYPES(unsigned int, unsignedIntValue)
                        PARAM_BASIC_TYPES(char, charValue)
                        PARAM_BASIC_TYPES(unsigned char, unsignedCharValue)
                        PARAM_BASIC_TYPES(long, longValue)
                        PARAM_BASIC_TYPES(unsigned long, unsignedLongValue)
                        PARAM_BASIC_TYPES(long long, longLongValue)
                        PARAM_BASIC_TYPES(unsigned long long, unsignedLongLongValue)
                        PARAM_BASIC_TYPES(float, floatValue)
                        PARAM_BASIC_TYPES(double, doubleValue)
                        
#undef PARAM_BASIC_TYPES
                        index++;
                    }
                }
            } while((obj = va_arg(args, id)));
            
        }
        va_end(args);
        [invocation retainArguments];
    }
    
    // Execute 执行
    //将接收器的消息（带参数）发送到其目标并设置返回值
    [invocation invoke];
    
    // Return
    const char *returnType = signature.methodReturnType;
    NSUInteger length = [signature methodReturnLength];
    id returnValue;
    if (!strcmp(returnType, @encode(void))){
        // void
        returnValue = nil;
    } else if(!strcmp(returnType, @encode(id))){
        // id
        void *value;
        [invocation getReturnValue:&value];
        returnValue = (__bridge id)(value);
        return returnValue;
    } else {
        NSString *returnTypeString = [NSString stringWithUTF8String:returnType];
        if ([returnTypeString hasPrefix:@"{"] && [returnTypeString hasSuffix:@"}"]) {
            // struct
#define RETURN_STRUCT_TYPES(_type) \
if (!strcmp(returnType, @encode(_type))) { \
    _type value; \
    [invocation getReturnValue:&value]; \
    returnValue = [NSValue value:&value withObjCType:@encode(_type)]; \
}
            RETURN_STRUCT_TYPES(CGPoint)
            RETURN_STRUCT_TYPES(CGSize)
            RETURN_STRUCT_TYPES(CGRect)
            RETURN_STRUCT_TYPES(CGAffineTransform)
            RETURN_STRUCT_TYPES(CATransform3D)
            RETURN_STRUCT_TYPES(CGVector)
            RETURN_STRUCT_TYPES(UIEdgeInsets)
            RETURN_STRUCT_TYPES(UIOffset)
            RETURN_STRUCT_TYPES(NSRange)
            
#undef RETURN_STRUCT_TYPES
        } else {
            // basic
            void *buffer = (void *)malloc(length);
            [invocation getReturnValue:buffer];
#define RETURN_BASIC_TYPES(_type) \
    if (!strcmp(returnType, @encode(_type))) { \
    returnValue = @(*((_type*)buffer)); \
}
            RETURN_BASIC_TYPES(BOOL)
            RETURN_BASIC_TYPES(int)
            RETURN_BASIC_TYPES(unsigned int)
            RETURN_BASIC_TYPES(char)
            RETURN_BASIC_TYPES(unsigned char)
            RETURN_BASIC_TYPES(long)
            RETURN_BASIC_TYPES(unsigned long)
            RETURN_BASIC_TYPES(long long)
            RETURN_BASIC_TYPES(unsigned long long)
            RETURN_BASIC_TYPES(float)
            RETURN_BASIC_TYPES(double)
            
#undef RETURN_BASIC_TYPES
            free(buffer);
        }
    }
    return returnValue;
}

@end


