//
//  YSCViewControllerPatternModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSCViewControllerPatternModel.h"
#import "YSUErrorCode.h"

@interface YSCViewControllerPatternModel ()

@property (nonatomic, assign) BOOL isNeedGoToOtherViewController;//是否需要前往其他视图控制器

@end

@implementation YSCViewControllerPatternModel

///创建路由URL正则与视图控制器绑定的对象
YSCViewControllerPatternModel * YSCMakeViewControllerPatternModel(NSString * pattern, NSString * name) {
    return [[YSCViewControllerPatternModel alloc] initWithPattern:pattern andViewControllerName:name];
}

///类初始化函数
+ (instancetype)modelWithPattern:(NSString *)pattern andName:(NSString *)name {
    YSCViewControllerPatternModel *model = [[YSCViewControllerPatternModel alloc] initWithPattern:pattern andViewControllerName:name];
    return model;
}

///实例初始化函数
- (instancetype)initWithPattern:(NSString *)pattern andViewControllerName:(NSString *)name {
    self = [super initWithPattern:pattern];
    if(self){
        self.viewControllerName = name;
        self.replacements = [[NSMutableDictionary alloc]init];
    }
    return self;
}

///添加替换参数
- (instancetype)addReplacement:(NSString *)key andValue:(NSString *)value {
    [self.replacements setObject:value forKey:key];
    return self;
}

///需要前往其他控制器
- (YSCViewControllerPatternModel * (^)(BOOL))needGoToOtherViewController {
    return ^YSCViewControllerPatternModel * (BOOL isNeedGoToOtherViewController) {
        [self setIsNeedGoToOtherViewController:isNeedGoToOtherViewController];
        return self;
    };
}

///处理URL与视图控制器(重写函数)
- (BOOL)handleUrlWithViewController:(UIViewController *)controller andExpression:(NSRegularExpression *)expression andTarget:(NSString *)target {
    //初始化要前往的视图控制器
    YSUIntent *intent = [YSUIntent intentWithClassName:self.viewControllerName];
    //设置链接
    [intent setObject:target forKey:@"nav_link"];
    //遍历存储替换参数的字典
    [self.replacements enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull replacement, BOOL * _Nonnull stop) {
        //将URL路由中符合正则表达式符号的值设置为参数
        [intent setObject:[expression stringByReplacingMatchesInString:target options:NSMatchingReportProgress range:NSMakeRange(0, target.length) withTemplate:replacement] forKey:key];
    }];
    
    if(self.isNeedGoToOtherViewController){
        NSLog(@"需要前往其他视图控制器");
    }
    
    intent.hidesBottomBarWhenPushed = YES;
    YSUError *error = [controller openIntent:intent];
    return error.code == YSU_ERROR_OK ? YES : NO;
}

@end
