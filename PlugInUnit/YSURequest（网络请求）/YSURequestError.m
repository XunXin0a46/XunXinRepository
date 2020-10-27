//
//  YSURequestError.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSURequestError.h"

@implementation YSURequestError

///初始化带有异常编码与为止信息的请求异常类
- (instancetype)init {
    self =[super init];
    if(self){
        self.code = -1;
        self.message = @"未知错误";
    }
    return self;
}

///初始化带有异常信息的请求异常类
- (instancetype)initWithMessage:(NSString *)message {
    self =[super init];
    if(self){
        self.code = -1;
        self.message = message;
    }
    return self;
}

///初始化带有异常编码与异常信息的请求异常类
- (instancetype)initWithCode:(NSInteger)code WithMessage:(NSString *)message{
    self =[super init];
    if(self){
        self.code = code;
        self.message = message;
    }
    return self;
}

@end
