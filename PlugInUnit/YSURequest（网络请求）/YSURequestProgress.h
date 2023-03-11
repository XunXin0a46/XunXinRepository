//
//  YSURequestProgress.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/15.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  请求进度

#import <Foundation/Foundation.h>

@interface YSURequestProgress : NSObject

@property (nonatomic,assign) double percent;//百分比
@property (nonatomic,strong) NSProgress*progress;//进度
@property (nonatomic,weak) id attach;//附加对象
///初始化请求进度函数
+ (instancetype)progressWithProgress:(NSProgress *)progress;
- (instancetype)initWithProgress:(NSProgress *)progress;

@end
