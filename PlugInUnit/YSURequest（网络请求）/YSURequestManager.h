//
//  YSURequestManager.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  请求管理器

#import <Foundation/Foundation.h>
#import "YSURequest.h"
#import "YSURequestError.h"
#import "YSURequestProgress.h"

//请求管理器代理函数
@protocol YSURequestDelegate<NSObject>

//必须实现的
@required
///请求成功，接受到响应数据时执行的函数
- (void)onRequestSucceed:(NSDictionary *)response ofWhat:(NSInteger)what;
///请求失败，接受到响应数据时执行的函数
- (void)onRequestFailed:(YSURequestError *)error ofWhat:(NSInteger)what;

//可选择实现的
@optional
///请求开始发送执行的函数
- (void)onRequestStart:(YSURequest *)request;
///请求发送之后，接受响应之前执行的函数
- (void)onRequestFinished:(YSURequest *)request;
///请求进度
- (void)onProgress:(YSURequestProgress *)progress ofWhat:(NSInteger)what;

@end

@interface YSURequestManager : NSObject

@property (nonatomic, copy) NSString *version;//版本

///添加请求对象与代理
- (void)addRequest:(YSURequest *)request withDelegate:(id<YSURequestDelegate>)delegate;

///获取请求对象
- (NSArray<YSURequest *> *)getAlarmRequests;

///取消请求
- (void)cancelRequestWithWhat:(NSInteger)what;

@end
