//
//  YSUBaseUrlManager.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSUBaseUrlManager.h"

@interface YSUBaseUrlManager() <UrlManagerNoMatchDelegate>

@end

@implementation YSUBaseUrlManager

///初始化
- (instancetype)init {
    self = [super init];
    if(self){
        //初始化存放路由正则与控制器绑定模型的数组
        self.patterns = [[NSMutableArray alloc] init];
        //设置代理
        self.delegate = self;
    }
    return self;
}

///根据路由匹配视图控制器
- (BOOL)beginProcessWithViewController:(UIViewController *)viewController andUrl:(NSString *)url {
    //判断URL路由是否为空
    if([YSUUtils isNullString:url]) {
        return NO;
    }
    //判断是否有传递的父控制器
    if(!viewController){
        return NO;
    }
    
    //是否有与URL路由匹配的视图控制器
    __block BOOL consumed = NO;
    //遍历路由正则与控制器绑定模型的数组
    [self.patterns enumerateObjectsUsingBlock:^(YSUBasePatternModel *  _Nonnull patternModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //匹配URL路由与视图控制器
        consumed = [patternModel execute:url viewController:viewController];
        //设置是否结束循环
        *stop = consumed;
    }];
    //判断是否有与URL路由匹配的视图控制器
    if (!consumed) {
        //没有找到匹配项目
        //判断是否设置了代理
        if (self.delegate) {
            //执行URL路由与视图控制器不匹配时执行的代理函数
            return [self.delegate noMatchesWithViewController:viewController andUrl:url];
        } else {
            return NO;
        }
    } else {
        //有匹配项
        return YES;
    }
}

///添加路由正则与控制器绑定模型
- (void)addPattern:(YSUBasePatternModel *)pattern {
    [self.patterns addObject:pattern];
}

///执行URL路由与视图控制器不匹配时执行的代理函数
- (BOOL)noMatchesWithViewController:(UIViewController *)viewController andUrl:(NSString *)url {
    return YES;
}


@end
