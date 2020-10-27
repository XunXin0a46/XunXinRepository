//
//  YSURequestProgress.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/15.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSURequestProgress.h"

@implementation YSURequestProgress

+ (instancetype)progressWithProgress:(NSProgress *)progress {
    return [[YSURequestProgress alloc]initWithProgress:progress];
}

- (instancetype)initWithProgress:(NSProgress *)progress {
    self = [super init];
    if(self){
        self.progress = progress;
        self.percent = progress.fractionCompleted;
    }
    return self;
}
@end
