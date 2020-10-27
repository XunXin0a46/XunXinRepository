//
//  YSUError.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/14.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSUError.h"
#import "YSUErrorCode.h"

@implementation YSUError
///初始化带有异常编码的异常类对象
- (instancetype)initWithCode:(NSInteger)code{
    self =[super init];
    if(self){
        self.code = code;
        self.reason = nil;
    }
    return self;
}

///初始化并返回无异常的异常类对象
+ (instancetype)ok {
    return [[YSUError alloc]initWithCode:YSU_ERROR_OK];
}

///初始化并返回未知错误类型的异常类对象
+ (instancetype)unknown {
    return [[YSUError alloc]initWithCode:YSU_ERROR_UNKNOWN_ERROR andReason:@"未知错误"];
}

///返回带有异常编码的异常类对象
+ (instancetype)errorWithCode:(NSInteger)code {
    return [[YSUError alloc]initWithCode:code];
}

///返回带有异常编码与异常原因的异常类对象
+ (instancetype)errorWithCode:(NSInteger)code andReason:(NSString *)reason {
    return [[YSUError alloc] initWithCode:code andReason:reason];
}

///初始化带有异常编码与异常原因的异常类对象
- (instancetype)initWithCode:(NSInteger)code andReason:(NSString *)reason {
    self =[super init];
    if(self){
        self.code = code;
        self.reason = reason;
    }
    return self;
}

@end
