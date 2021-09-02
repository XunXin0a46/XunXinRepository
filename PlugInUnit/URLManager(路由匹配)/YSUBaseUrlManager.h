//
//  YSUBaseUrlManager.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSUBasePatternModel.h"

@protocol UrlManagerNoMatchDelegate <NSObject>

///URL路由与视图控制器不匹配时执行的代理函数
- (BOOL)noMatchesWithViewController:(UIViewController *)viewController andUrl:(NSString *)url;

@end


@interface YSUBaseUrlManager : NSObject

@property (nonatomic,strong) id<UrlManagerNoMatchDelegate> delegate;//代理
@property (nonatomic,strong) NSMutableArray *patterns;//存放路由正则与控制器绑定模型的数组

///添加路由正则与控制器绑定模型
- (void)addPattern:(YSUBasePatternModel *)pattern;

///根据URL路由匹配视图控制器
- (BOOL)beginProcessWithViewController:(UIViewController *)viewController andUrl:(NSString *)url;

@end

