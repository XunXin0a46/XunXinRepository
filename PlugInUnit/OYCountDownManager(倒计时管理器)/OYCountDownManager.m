//
//  CountDownManager.m
//  CellCountDown
//
//  Created by herobin on 16/9/11.
//  Copyright © 2016年 herobin. All rights reserved.
//

#import "OYCountDownManager.h"
#import <UIKit/UIKit.h>

@interface OYTimeInterval ()

@property (nonatomic, assign) NSInteger timeInterval;

+ (instancetype)timeInterval:(NSInteger)timeInterval;

@end

@implementation OYTimeInterval

+ (instancetype)timeInterval:(NSInteger)timeInterval {
    OYTimeInterval *object = [OYTimeInterval new];
    object.timeInterval = timeInterval;
    return object;
}

@end



@interface OYCountDownManager ()

@property (nonatomic, strong) NSTimer *timer;

/// 时间差字典(单位:秒)(使用字典来存放, 支持多列表或多页面使用)
@property (nonatomic, strong) NSMutableDictionary<NSString *, OYTimeInterval *> *timeIntervalDict;

/// 后台模式使用, 记录进入后台的绝对时间
@property (nonatomic, assign) BOOL backgroudRecord;
@property (nonatomic, assign) CFAbsoluteTime lastTime;

@end

@implementation OYCountDownManager

///单例初始化倒计时管理器
+ (instancetype)manager {
    static OYCountDownManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OYCountDownManager alloc]init];
    });
    return manager;
}

///初始化函数
- (instancetype)init {
    self = [super init];
    if (self) {
        // 监听进入前台与进入后台的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

///开始倒计时
- (void)start {
    // 启动定时器
    [self timer];
}

///刷新倒计时
- (void)reload {
    // 刷新只要让时间差为0即可
    _timeInterval = 0;
}

///停止倒计时
- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerAction {
    // 定时器每次加1
    [self timerActionWithTimeInterval:1];
}

- (void)timerActionWithTimeInterval:(NSInteger)timeInterval {
    // 时间差+
    self.timeInterval += timeInterval;
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, OYTimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval += timeInterval;
    }];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:OYCountDownNotification object:nil userInfo:nil];
}

///添加倒计时源
- (void)addSourceWithIdentifier:(NSString *)identifier {
    OYTimeInterval *timeInterval = self.timeIntervalDict[identifier];
    if (timeInterval) {
        timeInterval.timeInterval = 0;
    }else {
        [self.timeIntervalDict setObject:[OYTimeInterval timeInterval:0] forKey:identifier];
    }
}

///获取时间差
- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier {
    return self.timeIntervalDict[identifier].timeInterval;
}

///刷新倒计时源
- (void)reloadSourceWithIdentifier:(NSString *)identifier {
    self.timeIntervalDict[identifier].timeInterval = 0;
}

///刷新所有倒计时源
- (void)reloadAllSource {
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, OYTimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}

///清除倒计时源
- (void)removeSourceWithIdentifier:(NSString *)identifier {
    [self.timeIntervalDict removeObjectForKey:identifier];
}

///清除所有倒计时源
- (void)removeAllSource {
    [self.timeIntervalDict removeAllObjects];
}

///接收到程序进入后台的回调方法
- (void)applicationDidEnterBackgroundNotification {
    self.backgroudRecord = (_timer != nil);
    if (self.backgroudRecord) {
        self.lastTime = CFAbsoluteTimeGetCurrent();
        [self invalidate];
    }
}

///接收到程序回到前台的回调方法
- (void)applicationWillEnterForegroundNotification {
    if (self.backgroudRecord) {
        CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lastTime;
        // 取整
        [self timerActionWithTimeInterval:(NSInteger)timeInterval];
        [self start];
    }
}

///初始化定时器
- (NSTimer *)timer {
    if (_timer == nil) {
        //创建计时器，每经过1秒，触发计时器函数
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

///可变字典懒加载
- (NSMutableDictionary *)timeIntervalDict {
    if (!_timeIntervalDict) {
        _timeIntervalDict = [NSMutableDictionary dictionary];
    }
    return _timeIntervalDict;
}

NSString *const OYCountDownNotification = @"OYCountDownNotification";

@end

