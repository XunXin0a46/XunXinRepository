//
//  YSUBasePatternModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//  URL路由匹配根模型

#import <Foundation/Foundation.h>

@interface YSUBasePatternModel : NSObject

@property (nonatomic, copy) NSString *pattern;//与控制器绑定的一条路由URL正则表达式

///初始化
- (instancetype)initWithPattern:(NSString *)pattern;

///匹配URL路由与视图控制器
- (BOOL)execute:(NSString *)target viewController:(UIViewController *)viewController;

///处理URL与视图控制器(需要重写，默认什么也不做)
- (BOOL)handleUrlWithViewController:(UIViewController *)controller andExpression:(NSRegularExpression *)expression andTarget:(NSString *)target;

@end

