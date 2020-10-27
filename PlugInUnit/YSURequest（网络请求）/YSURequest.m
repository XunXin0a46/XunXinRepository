//
//  YSURequest.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSURequest.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static void * KEY_REQUEST_ATTACH_OF_OBJC_RUNTIME = &KEY_REQUEST_ATTACH_OF_OBJC_RUNTIME;//关联者的key
NSString *const KEY_REQUEST_ATTACH = @"KEY_REQUEST_ATTACH";//附加对象标识
NSString *const REQUEST_METHOD_GET = @"GET";//Get请求标识
NSString *const REQUEST_METHOD_POST = @"POST";//POST请求标识

@interface YSURequest()

@end

@implementation NSDictionary(YSUAttach)
///设置附加对象关联
- (void)setAttach:(id)attach {
    objc_setAssociatedObject(self, KEY_REQUEST_ATTACH_OF_OBJC_RUNTIME, attach, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
///获取关联附加对象
- (id)getAttach {
    return objc_getAssociatedObject(self, KEY_REQUEST_ATTACH_OF_OBJC_RUNTIME);
}

@end

@implementation YSURequest
///初始化请求，需传入请求方式
+ (instancetype)requestWithUrl:(NSString *)url andWhat:(NSInteger)what andMethod:(NSString *)method {
    return [[YSURequest alloc]initWithUrl:url andWhat:what andMethod:method];
}
///初始化请求，默认请求方式GET
+ (instancetype)requestWithUrl:(NSString *)url andWhat:(NSInteger)what {
    return [[YSURequest alloc]initWithUrl:url andWhat:what];
}
///设置附加对象
- (void)setAttach:(id)attach {
    _attach = attach;
}
///获取附加对象
- (id)getAttach{
    return _attach;
}
///初始化请求，默认请求方式GET
- (instancetype)initWithUrl:(NSString *)url andWhat:(NSInteger)what {
    return [self initWithUrl:url andWhat:what andMethod:REQUEST_METHOD_GET];
}
///初始化请求，需传入请求方式
- (instancetype)initWithUrl:(NSString *)url andWhat:(NSInteger)what andMethod:(NSString *)method {
    self= [super init];
    if(self){
        self.url = url;
        self.what = what;
        self.method = method;
        self.paramters = [[NSMutableDictionary alloc] init];
        self.headers = [[NSMutableDictionary alloc] init];
        self.alarm = @1;
        self.userAgent = @"szyapp/ios";
        [self addVersion];
    }
    return self;
}
///添加版本
- (void)addVersion{
    self.version = nil;
}
///设请求置异步
- (void)setAjax:(BOOL)isAjax {
    _isAjax = isAjax;
}
///是否是异步请求
- (BOOL)isAjax {
    return _isAjax;
}
///添加请求头信息
- (YSURequest *)addHeader:(NSString *)value forKey:(NSString *)key{
    if(_headers) {
        [_headers setObject:value forKey:key];
    }
    return self;
}
///设置请求头参数列表
- (void)setReqHeaders:(NSDictionary *)headers {
    _headers = [NSMutableDictionary dictionaryWithDictionary:headers];
}
///设置参数列表
- (void)setParameters:(NSDictionary *)parameters {
    _paramters = [NSMutableDictionary dictionaryWithDictionary:parameters];
}
///获取不含图片的参数列表
- (NSDictionary *)getParameters {
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [self.paramters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[UIImage class]]){
            [temp setObject:obj forKey:key];
        }
    }];
    return temp;
}
///获取参数列表
- (NSDictionary *)parameters {
    return [self getParameters];
}
///获取参数列表中的图片
- (NSDictionary *)getImages {
    NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
    [self.paramters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImage class]]) {
            [temp setObject:obj forKey:key];
        }
    }];
    return temp;
}
///设置参数列表中的一个键值对参数
- (void)setValue:(id)value forKey:(NSString *)key {
    [self.paramters setObject:value forKey:key];
}

@end
