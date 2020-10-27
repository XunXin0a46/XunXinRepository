//
//  YSURequestError.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  请求错误

#import <Foundation/Foundation.h>

@interface YSURequestError : NSObject

@property (nonatomic,assign) NSInteger code;//请求异常编码
@property (nonatomic,strong) NSString *message;//请求异常信息
@property (nonatomic,weak) id attach;//附加信息对象
///初始化带有异常信息的请求异常类
- (instancetype)initWithMessage:(NSString *)message;
///初始化带有异常编码与异常信息的请求异常类
- (instancetype)initWithCode:(NSInteger)code WithMessage:(NSString *)message;
@end
