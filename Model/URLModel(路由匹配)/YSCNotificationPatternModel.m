//
//  YSCNotificationPatternModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/2.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSCNotificationPatternModel.h"

@implementation YSCNotificationPatternModel

///初始化
-(instancetype)initWithPattern:(NSString*)pattern andNotificationName:(NSString*)name{
    self= [super initWithPattern:pattern];
    if(self){
        self.notificationName = name;
    }
    return self;
}

///处理URL与通知(重写函数)
- (BOOL)handleUrlWithViewController:(UIViewController*)controller andExpression:(NSRegularExpression*)expression andTarget:(NSString*)target{
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil];
    return YES;
}

///查询URL
- (BOOL)query:(NSString *)target {
    NSError *error = nil;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:self.pattern options:0 error:&error];
    
    if(!error && [expression matchesInString:target options:0 range:NSMakeRange(0, target.length)].count > 0) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
