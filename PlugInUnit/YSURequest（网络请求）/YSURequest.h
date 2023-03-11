//
//  YSURequest.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  网络请求

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const KEY_REQUEST_ATTACH;//附加对象标识
FOUNDATION_EXTERN NSString *const REQUEST_METHOD_GET;//Get请求标识
FOUNDATION_EXTERN NSString *const REQUEST_METHOD_POST;//POST请求标识

@interface NSDictionary(YSUAttach)

///设置附加对象
- (void)setAttach:(id)attach;
///获取附加对象
- (id)getAttach;

@end

@interface YSURequest : NSObject

@property (nonatomic, weak)id attach;//附加对象
@property (nonatomic, copy) NSString *url;//路径
@property (nonatomic, copy) NSString *method;//请求方式
@property (nonatomic, assign) BOOL isAjax;//是否异步
@property (nonatomic, strong) NSMutableDictionary *paramters;//参数
@property (nonatomic, copy) NSNumber *alarm; //是否显示加载图标 Default is @(1)
@property (nonatomic, strong) NSString *message;//消息
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, assign) NSInteger what;//区分多个请求标识
@property (nonatomic, copy) NSString *version;//版本
@property (nonatomic, strong) NSMutableDictionary *headers;//请求头

///添加请求头信息
- (YSURequest *)addHeader:(NSString *)value forKey:(NSString *)key;
///设置请求头参数
- (void)setReqHeaders:(NSDictionary *)parameters;
///添加版本
- (void)addVersion;
///设置参数列表
- (void)setParameters:(NSDictionary *)parameters;
///获取参数不含图片列表
- (NSDictionary *)getParameters;
///获取参数列表
- (NSDictionary *)parameters;
///获取参数列表中的图片
- (NSDictionary *)getImages;
///初始化请求，默认请求方式GET
- (instancetype)initWithUrl:(NSString *)url andWhat:(NSInteger)what;
///初始化请求，需传入请求方式
- (instancetype)initWithUrl:(NSString *)url andWhat:(NSInteger)what andMethod:(NSString *)method;
///设请求置异步
- (void)setAjax:(BOOL)isAjax;
///是否是异步请求
- (BOOL)isAjax;
///设置附加对象
- (void)setAttach:(id)attach;
///获取附加对象
- (id)getAttach;
///初始化请求，默认请求方式GET
+ (instancetype)requestWithUrl:(NSString *)url andWhat:(NSInteger)what;
///初始化请求，需传入请求方式
+ (instancetype)requestWithUrl:(NSString *)url andWhat:(NSInteger)what andMethod:(NSString*)method;

@end
