//
//  YSCViewControllerPatternModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//  URL路由匹配视图控制器模型

#import "YSUBasePatternModel.h"



@interface YSCViewControllerPatternModel : YSUBasePatternModel

FOUNDATION_EXTERN YSCViewControllerPatternModel * YSCMakeViewControllerPatternModel(NSString *pattern, NSString *name);//创建路由URL正则与视图控制器绑定的对象

@property (nonatomic, copy) NSString *viewControllerName;//视图控制器名称
@property (nonatomic, strong) NSMutableDictionary *replacements;//存储替换参数的字典

@property (nonatomic, copy) YSCViewControllerPatternModel *(^addReplacement)(NSString *key,NSString *value);//添加替换参数
@property (nonatomic, copy) YSCViewControllerPatternModel *(^needGoToOtherViewController)(BOOL isNeedGoToOtherViewController);//需要前往其他控制器

///类初始化函数
+ (instancetype)modelWithPattern:(NSString *)pattern andName:(NSString *)name;

///实例初始化函数
- (instancetype)initWithPattern:(NSString *)pattern andViewControllerName:(NSString *)name;

///添加替换参数
- (instancetype)addReplacement:(NSString *)key andValue:(NSString *)value;

@end


