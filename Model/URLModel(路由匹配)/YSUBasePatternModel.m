//
//  YSUBasePatternModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSUBasePatternModel.h"

@implementation YSUBasePatternModel

///初始化
- (instancetype)initWithPattern:(NSString *)pattern {
    self = [super init];
    if(self){
        //设置与控制器绑定的一条路由URL正则表达式
        _pattern = [pattern copy];
    }
    return self;
}

///匹配URL路由与视图控制器
- (BOOL)execute:(NSString *)target viewController:(UIViewController *)viewController {
    //初始化异常对象
    NSError *error = nil;
    //初始化正则表达式实例
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:self.pattern options:0 error:&error];
    //匹配URL路由
    if(!error && [expression matchesInString:target options:0 range:NSMakeRange(0, target.length)].count > 0) {
        //处理URL与视图控制器
        return [self handleUrlWithViewController:viewController andExpression:expression andTarget:target];
    }
    else{
        return NO;
    }
}

///处理URL与视图控制器(需要重写，默认什么也不做)
- (BOOL)handleUrlWithViewController:(UIViewController *)controller andExpression:(NSRegularExpression *)expression andTarget:(NSString *)target {
    
    return NO;
}

@end
