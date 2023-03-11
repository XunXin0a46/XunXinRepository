//
//  YSUBrowserPatternModel.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSUBrowserPatternModel.h"

@implementation YSUBrowserPatternModel

///匹配URL路由使用浏览器打开(重写函数)
- (BOOL)execute:(NSString *)target viewController:(UIViewController *)viewController {
    NSURL*url = [NSURL URLWithString:target];
    if(url){
        //使用浏览器打开指定的路径
        [YSUUtils openBrowser:target];
        return YES;
    }
    else{
        return NO;
    }
}

@end
