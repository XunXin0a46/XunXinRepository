//
//  WSDatePickerView.h
//  WSDatePicker
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Extension.h"

typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0, //显示年、月、日、时、分
    DateStyleShowMonthDayHourMinute, //显示月、日、时、分
    DateStyleShowYearMonthDay, //显示年、月、日
    DateStyleShowMonthDay, //显示月、日
    DateStyleShowHourMinute //显示时、分
}WSDateStyle;//日期选择样式


@interface WSDatePickerView : UIView

@property (nonatomic,strong)UIColor *doneButtonColor;//确定按钮颜色

@property (nonatomic, retain) NSDate *maxLimitDate;//限制最大时间（没有设置默认9999）
@property (nonatomic, retain) NSDate *minLimitDate;//限制最小时间（没有设置默认0）

///初始化时间选择器
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock;

///显示时间选择器
-(void)show;

///滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated;

@end

