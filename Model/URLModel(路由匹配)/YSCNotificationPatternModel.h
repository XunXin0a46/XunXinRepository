//
//  YSCNotificationPatternModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/2.
//  Copyright © 2021 王刚. All rights reserved.
//  URL路由匹配通知模型

#import "YSUBasePatternModel.h"

@interface YSCNotificationPatternModel : YSUBasePatternModel

@property (nonatomic,strong) NSString *notificationName;//通知名称

///初始化
-(instancetype)initWithPattern:(NSString*)pattern andNotificationName:(NSString*)name;

///查询URL
- (BOOL)query:(NSString *)target;

@end

