//
//  NSString+Trim.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/18.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString(Trim)

///删除字符串两端的空字符
- (instancetype)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
