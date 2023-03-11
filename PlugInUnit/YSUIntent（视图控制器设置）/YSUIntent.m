//
//  YSUIntent.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/14.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSUIntent.h"

@interface YSUIntent()

@property (nonatomic,strong) NSMutableDictionary *data;//存储数据的字典

@end

@implementation YSUIntent

///初始化函数
- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if(self){
        self.data = [[NSMutableDictionary alloc]init];
        self.method = OPEN_METHOD_PUSH;
        self.animated = YES;
        self.className = className;
    }
    
    return self;
}

///初始化函数
+ (instancetype)intentWithClassName:(NSString *)className {
    return  [[YSUIntent alloc]initWithClassName:className];
}

///初始化函数
- (instancetype)init {
    self = [super init];
    if(self){
        self.data = [[NSMutableDictionary alloc]init];
        self.method = OPEN_METHOD_PUSH;
        self.animated = YES;
    }
    return self;
}

///为存储数据的字典设置键值
- (void)setObject:(id)object forKey:(NSString *)key {
    [self.data setObject:object forKey:key];
}

///获取存储数据的字典对象
- (NSDictionary *)getIntentData{
    return self.data;
}

///根据键获取存储在字典的数据
- (id)objectForKey:(NSString *)key {
    return [self.data objectForKey:key];
}

@end
