//
//  YSCBaseURLManager.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/7/30.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "YSCBaseURLManager.h"
#import "YSCViewControllerPatternModel.h"

@implementation YSCBaseURLManager

///初始化
- (instancetype)init{
    self = [super init];
    if(self){
        ///测试代码
        [self addPattern:[[YSCViewControllerPatternModel modelWithPattern:PATTERN_GOODS_LIST_TWELVE andName:@"TestCodeController"].needGoToOtherViewController(YES) addReplacement:YSCKeyBoolean andValue:@"$1"]];
        ///webview
        [self addPattern:[[YSCViewControllerPatternModel modelWithPattern:PATTERN_WEBVIEW andName:@"BaseWebViewControlle"] addReplacement:BaseWebViewControlleURL andValue:[NSString stringWithFormat:@"%@", @"$0"]]];
    }
    return self;
}

@end
