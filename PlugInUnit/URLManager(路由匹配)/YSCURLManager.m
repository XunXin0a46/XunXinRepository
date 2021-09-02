//
//  YSCURLManager.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSCURLManager.h"
#import "YSCViewControllerPatternModel.h"
#import "YSUBrowserPatternModel.h"

@implementation YSCURLManager

///初始化
- (instancetype)init {
    self = [super init];
    if(self){
        //匹配URL路由使用浏览器打开
        [self addPattern:[[YSUBrowserPatternModel alloc] init]];
    }
    return self;
}

@end
