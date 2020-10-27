//
//  YSUError.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/14.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSUError : NSObject

@property (nonatomic, assign) NSInteger code;//异常编码
@property (nonatomic, strong) NSString *reason;//异常原因

///初始化带有异常编码的异常类对象
- (instancetype)initWithCode:(NSInteger)code;
///初始化带有异常编码与异常原因的异常类对象
- (instancetype)initWithCode:(NSInteger)code andReason:(NSString *)reason;
///初始化并返回无异常的异常类对象
+ (instancetype)ok;
///初始化并返回未知错误类型的异常类对象
+ (instancetype)unknown;
///返回带有异常编码的异常类对象
+ (instancetype)errorWithCode:(NSInteger)code;
///返回带有异常编码与异常原因的异常类对象
+ (instancetype)errorWithCode:(NSInteger)code andReason:(NSString *)reason;

@end
