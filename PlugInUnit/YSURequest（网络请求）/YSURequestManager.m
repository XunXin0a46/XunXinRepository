//
//  YSURequestManager.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSURequestManager.h"
#import "YSUErrorCode.h"
#import <AFNetworking/AFNetworking.h>

static NSTimeInterval const YSURequestTimeoutInterval = 60.0;//请求超时时间间隔

@interface YSURequestManager()

@property (nonatomic, strong) AFHTTPSessionManager *manager;//提供了方便的方法来发出HTTP请求的类
@property (nonatomic, strong) NSMutableDictionary *tasks;//任务字典
@property (nonatomic, strong) NSMutableArray *requests;//请求对象数组

@property (nonatomic, copy) void (^requestSucceed)(id<YSURequestDelegate>delegate, NSInteger what, NSString *url,YSURequest *request, id responseObject,id attach);//设置请求成功函数的执行条件的回调函数

@property (nonatomic, copy) void (^requestFailed)(id<YSURequestDelegate>delegate, NSInteger what, NSString *url,YSURequest *request, NSError *error, id attach);//设置请求失败函数的执行条件的回调函数

@property (nonatomic, copy) void (^requestProgress)(id<YSURequestDelegate>delegate, NSInteger what, NSString *url,YSURequest *request ,NSProgress *progress, id attach);//设置请求进度函数的执行条件的回调函数

@end

@implementation YSURequestManager

///初始化请求管理器
- (instancetype)init {
    self = [super init];
    //初始化成功
    if(self){
        //初始化任务字典
        self.tasks = [[NSMutableDictionary alloc] init];
        //初始化请求对象数组
        self.requests = [[NSMutableArray alloc] init];
        //初始化AFHTTPSessionManager对象
        self.manager = [AFHTTPSessionManager manager];
        //设置对函数的弱引用
        __weak typeof(self) _weak_self = self;
        //执行设置请求成功函数的执行条件的回调函数
        self.requestSucceed = ^void(id<YSURequestDelegate>delegate, NSInteger what, NSString *url,YSURequest *request,id responseObject, id attach) {
            //在任务字典中移除对应的任务
            [_weak_self.tasks removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)what]];
            //在请求对象数组中移除对应的请求对象
            [_weak_self.requests removeObject:request];
            //如果代理对象存在，并且实现了onRequestFinished:函数
            if(delegate && [delegate respondsToSelector:@selector(onRequestFinished:)]){
                //执行请求发送之后，接受响应之前执行的函数
                [delegate onRequestFinished:request];
            }
            //设置请求成功函数的执行条件
            [_weak_self requestSucceedOfDelegate:delegate ofWhat:what withResponse:responseObject andAttach:(id) attach];
        };
        //执行设置请求失败函数的执行条件的回调函数
        self.requestFailed = ^void(id<YSURequestDelegate>delegate, NSInteger what,NSString *url, YSURequest *request, NSError *error, id attach) {
            //在任务字典中移除对应的任务
            [_weak_self.tasks removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)what]];
            //在请求对象数组中移除对应的请求对象
            [_weak_self.requests removeObject:request];
            //如果代理对象存在，并且实现了onRequestFinished:函数
            if(delegate && [delegate respondsToSelector:@selector(onRequestFinished:)]){
                //执行请求发送之后，接受响应之前执行的函数
                [delegate onRequestFinished:request];
            }
            //执行设置请求失败函数的执行条件的回调函数
            [_weak_self requestFailedOfDelegate:delegate ofWhat:what withError:error andAttach:(id) attach];
        };
        //执行设置请求进度函数的执行条件的回调函数
        self.requestProgress = ^void(id<YSURequestDelegate>delegate, NSInteger what, NSString *url, YSURequest *request, NSProgress *progress, id attach) {
            [_weak_self requestProgressOfDelegate:delegate ofWhat:what withProgress:progress andAttach:(id) attach];
        };
    }
    return self;
}

/**
 设置请求成功函数的执行条件的函数
 参数列表 ：
 delegate ：代理对象
 what ：任务标识
 responseObject ：响应对象
 attach ：附加信息对象
 */
- (void)requestSucceedOfDelegate:(id<YSURequestDelegate>)delegate ofWhat:(NSInteger)what withResponse:(id)responseObject andAttach:(id) attach {
    //初始化异常对象
    NSError *error = nil;
    //解析响应对象
    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
    //如果解析响应对象发生了异常
    if (error) {
        //设置对函数的弱引用
        __weak typeof(self) _weak_self = self;
        //执行设置请求失败函数的执行条件的回调函数，并设置异常消息为格式解析Json失败，并结束函数
        [_weak_self requestFailedOfDelegate:delegate ofWhat:what withErrorMessage:LOCALIZE_FORMAT(@"formatFailedToParseJson", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding], [error localizedDescription]) andAttach:(id) attach];
        return;
    }
    //如果响应对象不是字典或其子类
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        //设置对函数的弱引用
        __weak typeof(self) _weak_self = self;
        //执行设置请求失败函数的执行条件的回调函数，并设置异常消息为格式解析Json失败，并结束函数
        [_weak_self requestFailedOfDelegate:delegate ofWhat:what withErrorMessage:LOCALIZE_FORMAT(@"formatFailedToParseJson", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding], [error localizedDescription]) andAttach:(id) attach];
        return;
    }
    //初始化响应数据字典的可变字典
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
    //设置附加信息对象
    [responseDictionary setAttach:attach];
    //  判断返回的字典code值是否为 YSU_ERROR_CLOSE
    if ([[NSString stringWithFormat:@"%@", responseDictionary[@"code"]] integerValue] == YSU_ERROR_CLOSE) {
        //打开重新加载视图控制器
        YSUIntent *intent = [[YSUIntent alloc] initWithClassName:@"YSUCloseViewController"];
        intent.method = OPEN_METHOD_POP;
        [[UIApplication sharedApplication].keyWindow.rootViewController openIntent:intent];
        
    } else {
        //判断返回的字典code值是否为YSU_ERROR_TRIAL
        if ([[NSString stringWithFormat:@"%@", responseDictionary[@"code"]] integerValue] == YSU_ERROR_TRIAL) {
            //打开试用版已到期视图控制器
            YSUIntent *intent = [[YSUIntent alloc] initWithClassName:@"YSUTrailViewController"];
            intent.method = OPEN_METHOD_POP;
            [[UIApplication sharedApplication].keyWindow.rootViewController openIntent:intent];
        }
        //如果代理对象存在，并且实现了onRequestSucceed:ofWhat:函数
        if(delegate && [delegate respondsToSelector:@selector(onRequestSucceed:ofWhat:)]) {
            //执行请求成功，接受到响应数据时执行的函数
            [delegate onRequestSucceed:responseDictionary ofWhat:what];
        }
    }
}

/**
设置请求失败函数的执行条件的回调函数
参数列表 ：
delegate ：代理对象
what ：任务标识
error ：异常类对象
attach ：附加信息对象
*/
- (void)requestFailedOfDelegate:(id<YSURequestDelegate>)delegate ofWhat:(NSInteger)what withError:(NSError *)error andAttach:(id) attach {
    if (delegate && [delegate respondsToSelector:@selector(onRequestFailed:ofWhat:)]) {
        //初始化请求异常类，并传入异常码与异常信息
        YSURequestError *requestError = [[YSURequestError alloc] initWithCode:YSU_ERROR_TIMEOUT WithMessage:[NSString stringWithFormat:@"请求失败，错误为“%@", [error localizedDescription]]];
        //设置附加信息对象
        [requestError setAttach:attach];
        //代理执行请求失败的函数
        [delegate onRequestFailed:requestError ofWhat:what];
    }
}

/**
 设置请求失败函数的执行条件的回调函数
 参数列表 ：
 delegate ：代理对象
 what ：任务标识
 errorMessage ：异常信息
 attach ：附加信息对象
 */
- (void)requestFailedOfDelegate:(id<YSURequestDelegate>)delegate ofWhat:(NSInteger)what withErrorMessage:(NSString*)errorMessage andAttach:(id) attach {
    //如果代理对象存在并且代理对象实现了onRequestFailed:ofWhat:函数
    if (delegate && [delegate respondsToSelector:@selector(onRequestFailed:ofWhat:)]) {
        //初始化请求异常类，并传入异常码与异常信息
        YSURequestError *error = [[YSURequestError alloc] initWithCode:-1 WithMessage:errorMessage];
        //设置附加信息对象
        [error setAttach:attach];
        //代理执行请求失败的函数
        [delegate onRequestFailed:error ofWhat:what];
    }
}

/**
 设置请求进度函数的执行条件的回调函数
 delegate ：代理对象
 what ：任务标识
 progress ：请求进度对象
 attach ：附加信息对象
 */
- (void)requestProgressOfDelegate:(id<YSURequestDelegate>)delegate ofWhat:(NSInteger)what withProgress:(NSProgress *)progress andAttach:(id) attach {
    //如果代理对象存在并且实现了onProgress:ofWhat:函数
    if (delegate && [delegate respondsToSelector:@selector(onProgress:ofWhat:)]) {
        //初始化请求进度对象
        YSURequestProgress *requestProgress = [YSURequestProgress progressWithProgress:progress];
        //设置附加信息对象
        [requestProgress setAttach:attach];
        //代理执行请求进度的函数
        [delegate onProgress:requestProgress ofWhat:what];
    }
}

///添加请求对象与代理
- (void)addRequest:(YSURequest *)request withDelegate:(id<YSURequestDelegate>)delegate {
    
#if DEBUG
    NSLog(@"Common DEBUG mode = 1");
#else
    NSLog(@"Common DEBUG mode = 0");
#endif
    //获取请求路径
    NSString *url = request.url;
    //获取附加信息对象
    id attach = [request getAttach];
    //获取请求方式
    NSString *method = request.method;
    //获取请求参数列表
    NSDictionary *parameters = request.paramters;
    //获取请求头
    NSDictionary *headers = request.headers;
    //获取参数列表中的图片
    NSDictionary *images = [request getImages];
    //获取任务标识
    NSInteger what = request.what;
    //获取是否异步请求
    BOOL isAjax = [request isAjax];
    //设置请求序列化
    self.manager.requestSerializer = [self requestSerializerWithUserAgent:request.userAgent version:request.version];
    //设置响应序列化
    self.manager.responseSerializer = [self responseSerializer];
    //设置对代理对象的弱引用
    __weak __typeof(delegate) weakDelegate = delegate;
    //如果是异步请求
    if(isAjax) {
        //设置由HTTP客户端生成的请求对象中设置的HTTP头的值
        [self.manager.requestSerializer setValue:@"XMLHttpRequest"
                              forHTTPHeaderField:@"X-Requested-With"];
    }
    //如果请求头字典存在
    if(headers) {
        for(NSString *key in headers)
        {   //设置由HTTP客户端生成的请求对象中设置的HTTP头的值
            [self.manager.requestSerializer setValue:headers[key]
                                  forHTTPHeaderField:key];
        }
    }
    //会话任务对象
    NSURLSessionTask *task;
    //如果是GET请求
    if ([method isEqualToString:REQUEST_METHOD_GET]) {
        //创建并运行带有GET请求的NSURLSessionDataTask
        task = [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            //执行设置请求进度函数的执行条件的回调函数
            self.requestProgress(weakDelegate, what, url, request, downloadProgress, attach);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //执行设置请求成功函数的执行条件的回调函数
            self.requestSucceed(weakDelegate, what, url, request, responseObject, attach);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //任务完成失败或成功完成但在分析响应数据时遇到错误时获取描述错误的附加信息
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            //响应对象
            id responseObject;
            //如果有错误信息
            if (data) {
                //将异常解析赋予响应对象
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                //在异常的响应对象中取出异常码
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                //如果异常码为403
                if ([@"403" isEqualToString:code]) {
                    //执行设置请求成功函数的执行条件的回调函数
                    self.requestSucceed(weakDelegate, what, url, request, data, attach);
                }else{
                    //执行设置请求失败函数的执行条件的回调函数
                    self.requestFailed(weakDelegate, what, url, request, error, attach);
                }
            }else{
                //执行设置请求失败函数的执行条件的回调函数
                self.requestFailed(weakDelegate, what, url, request, error, attach);
            }
        }];
    }
    //如果是POST请求
    else if ([method isEqualToString:REQUEST_METHOD_POST]) {
        //创建并运行一个' NSURLSessionDataTask '与一个多部分' POST '请求。
        task = [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //接受单个参数并将数据追加到HTTP主体的块
            [images enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.5)
                                            name:key
                                        fileName:@"image.jpg"
                                        mimeType:@"image/jpeg"];
            }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //执行设置请求进度函数的执行条件的回调函数
            self.requestProgress(weakDelegate, what, url, request, uploadProgress, attach);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //执行设置请求成功函数的执行条件的回调函数
            self.requestSucceed(weakDelegate, what, url, request, responseObject, attach);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //任务完成失败或成功完成但在分析响应数据时遇到错误时获取描述错误的附加信息
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            //响应对象
            id responseObject;
            //如果有错误信息
            if (data) {
                //将异常解析赋予响应对象
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                //在异常的响应对象中取出异常码
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                //如果异常码为403
                if ([@"403" isEqualToString:code]) {
                    //执行设置请求成功函数的执行条件的回调函数
                    self.requestSucceed(weakDelegate, what, url, request, data, attach);
                }else{
                    //执行设置请求失败函数的执行条件的回调函数
                    self.requestFailed(weakDelegate, what, url, request, error, attach);
                }
            }else{
                //执行设置请求失败函数的执行条件的回调函数
                self.requestFailed(weakDelegate, what, url, request, error, attach);
            }
        }];
    }
    //会话任务对象创建成功
    if (task) {
        [self.tasks setObject:task forKey:[NSString stringWithFormat:@"%ld",(long)what]];
    }
    //添加请求
    [self.requests addObject:request];
    //如果代理对象实现了请求开始发送执行的函数
    if (delegate && [weakDelegate respondsToSelector:@selector(onRequestStart:)]) {
        //执行请求开始发送执行的函数
        [delegate onRequestStart:request];
    }
}

///带有用户代理与版本的请求序列化
- (AFHTTPRequestSerializer *)requestSerializerWithUserAgent:(NSString *)userAgent version:(NSString *)version{
    //如果没有用户代理就设置用户代理
    if(!userAgent){
        userAgent = @"szyapp/ios";
    }
    //提供查询字符串/URL表单编码参数序列化和默认请求头的具体实现，以及响应状态代码和内容类型验证的对象
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    //设置已创建请求的缓存策略为不应使用任何现有缓存数据来满足URL加载请求
    serializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    //设置由HTTP客户端生成的请求对象中设置的HTTP头的值
    [serializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [serializer setValue:version forHTTPHeaderField:@"szy_version"];
    //已创建请求的超时间隔（秒），默认超时间隔为60秒
    serializer.timeoutInterval = YSURequestTimeoutInterval;
    return serializer;
}

///设置响应序列化
- (AFHTTPResponseSerializer *)responseSerializer {
    //初始化响应序列化对象
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    //可接受的响应MIME类型。当非“nil”时，具有“Content Type”且MIME类型与集合不相交的响应将在验证期间导致错误。
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    return serializer;
}

///获取请求对象数组
- (NSArray<YSURequest *> *)getAlarmRequests {
    NSMutableArray *alarmRequests = [[NSMutableArray alloc] init];
    [self.requests enumerateObjectsUsingBlock:^(YSURequest *  _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
        if (request.alarm &&
            request.alarm.integerValue) {
            [alarmRequests addObject:request];
        }
    }];
    return alarmRequests;
}

///取消请求
- (void)cancelRequestWithWhat:(NSInteger)what {
    for (YSURequest *request in self.requests) {
        if (request.what == what) {
            
            
            break;
        }
    }
}

@end
