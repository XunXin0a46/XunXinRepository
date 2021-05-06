//
//  DateCountdown.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/4/27.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCountdown : NSObject

///用NSDate日期倒计时
- (void)countDownWithStratDate:(NSDate *)startDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;

///用时间戳倒计时
- (void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;

///每秒走一次，回调block
- (void)countDownWithPER_SECBlock:(void (^)(void))PER_SECBlock;

///主动销毁定时器
- (void)destoryTimer;

///时间戳转NSDate
-(NSDate *)dateWithLongLong:(long long)longlongValue;

@end

