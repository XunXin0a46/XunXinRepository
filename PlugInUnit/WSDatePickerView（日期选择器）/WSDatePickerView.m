//
//  WSDatePickerView.m
//  WSDatePicker
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "WSDatePickerView.h"
#import "UIView+Extension.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPickerSize self.datePicker.frame.size  //时间选择器视图大小
#define WSRGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define RGB(r, g, b) WSRGBA(r,g,b,1)


#define MAXYEAR 9999  //多大年份
#define MINYEAR 0  //最小年份

typedef void(^doneBlock)(NSDate *); //定义确定按钮回调

@interface WSDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    //日期存储数组
    NSMutableArray *_yearArray;//存放年份的数组
    NSMutableArray *_monthArray;//存放月份的数组
    NSMutableArray *_dayArray;//存放日的数组
    NSMutableArray *_hourArray;//存放小时的数组
    NSMutableArray *_minuteArray;//存放分钟的数组
    NSString *_dateFormatter; //日期格式字符串
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;

}
@property (weak, nonatomic) IBOutlet UIView *buttomView; //底部日期选取内容视图
@property (weak, nonatomic) IBOutlet UILabel *showYearView;//显示所选年份的背景标签
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;//日期选取器视图底部约束

- (IBAction)doneAction:(UIButton *)btn;


@property (nonatomic,strong)UIPickerView *datePicker;//时间选择器视图
@property (nonatomic, retain) NSDate *scrollToDate;//要滚到的指定日期
@property (nonatomic,strong)doneBlock doneBlock;//确定按钮回调
@property (nonatomic,assign)WSDateStyle datePickerStyle;//记录日期选择样式


@end

@implementation WSDatePickerView

///初始化时间选择器
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock {
    //调用父类初始化函数
    self = [super init];
    //判断初始化是否成功
    if (self) {
        //初始化成功
        //加载WSDatePickerView.xib
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        //记录日期选择样式
        self.datePickerStyle = datePickerStyle;
        //判断日期选择样式
        switch (datePickerStyle) {
            //显示年、月、日、时、分
            case DateStyleShowYearMonthDayHourMinute:
                //设置日期格式字符串
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            //显示月、日、时、分
            case DateStyleShowMonthDayHourMinute:
                //设置日期格式字符串
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            //显示年、月、日
            case DateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            //显示月、日
            case DateStyleShowMonthDay:
                //设置日期格式字符串
                _dateFormatter = @"yyyy-MM-dd";
                break;
            //显示时、分
            case DateStyleShowHourMinute:
                //设置日期格式字符串
                _dateFormatter = @"HH:mm";
                break;
            //默认
            default:
                //设置日期格式字符串
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        //设置视图
        [self setupUI];
        //默认配置
        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(NSDate *startDate) {
                completeBlock(startDate);
            };
        }
    }
    return self;
}

///设置视图
-(void)setupUI {
    
    //底部日期选取内容视图
    self.buttomView.layer.cornerRadius = 10;
    self.buttomView.layer.masksToBounds = YES;
    
    //确定按钮默认颜色
    self.doneButtonColor = RGB(247, 133, 51);
    
    //日期选取器框架矩形
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //背景点手势识别器
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //设置底部约束常数
    self.bottomConstraint.constant = -self.height;
    //日期选取器背景色
    self.backgroundColor = WSRGBA(0, 0, 0, 0);
    //日期选取器布局子视图
    [self layoutIfNeeded];
    //日期选择器显示在窗口同级视图顶部
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    //添加选择器视图到显示所选年份的背景标签
    [self.showYearView addSubview:self.datePicker];
    
}

///默认配置
-(void)defaultConfig {
    //判断是否设置了要滚到的指定日期
    if (!_scrollToDate) {
        //没有设置，滚动到当前的日期
        _scrollToDate = [NSDate date];
    }

    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    //设置年月日时分数据
    //初始化存放年份的数组
    _yearArray = [self setArray:_yearArray];
    //初始化存放月份的数组
    _monthArray = [self setArray:_monthArray];
    //初始化存放日的数组
    _dayArray = [self setArray:_dayArray];
    //初始化存放小时的数组
    _hourArray = [self setArray:_hourArray];
    //初始化存放分钟的数组
    _minuteArray = [self setArray:_minuteArray];
    //填充月、小时、分钟数组
    for (int i=0; i<60; i++) {
        //两位整数，不足补零
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            //填充存放月份的数组
            [_monthArray addObject:num];
        if (i<24)
            //填充存放小时的数组
            [_hourArray addObject:num];
        //填充存放分钟的数组
        [_minuteArray addObject:num];
    }
    //填充存放年的数组
    for (NSInteger i=MINYEAR; i<MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //设置默认最大最小限制
    if (!self.maxLimitDate) {
        //将格式化的日期字符串按照给定格式转换为NSDate
        self.maxLimitDate = [NSDate date:@"9999-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //设置默认最小限制
    if (!self.minLimitDate) {
        //将格式化的日期字符串按照给定格式转换为NSDate
        self.minLimitDate = [NSDate date:@"0000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

///创建年、月、日、时、分的组合标签
-(void)addLabelWithName:(NSArray *)nameArr {
    //遍历添加到显示所选年份的背景标签上的所有子视图
    for (id subView in self.showYearView.subviews) {
        //如果该子视图是标签类或其子类
        if ([subView isKindOfClass:[UILabel class]]) {
            //将该子视图在父视图中移除
            [subView removeFromSuperview];
        }
    }
    //遍历参数数组，创建年、月、日、时、分进行组合的标签
    for (int i=0; i<nameArr.count; i++) {
        //标签在父视图中X轴的位置
        CGFloat labelX = kPickerSize.width/(nameArr.count*2)+18+kPickerSize.width/nameArr.count*i;
        //初始化标签
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.showYearView.frame.size.height/2-15/2.0, 15, 15)];
        //设置标签文本
        label.text = nameArr[i];
        //设置标签文本对齐方式
        label.textAlignment = NSTextAlignmentCenter;
        //设置标签自提大小
        label.font = [UIFont systemFontOfSize:14];
        //设置标签文本颜色
        label.textColor =  RGB(247, 133, 51);
        //设置标签背景色
        label.backgroundColor = [UIColor clearColor];
        //添加标签到显示所选年份的背景标签
        [self.showYearView addSubview:label];
    }
}

///初始化数组
- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

///当选择器视图需要组件数量时调用，返回选择器视图要显示的组件数(数据列数)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.datePickerStyle) {
        //显示年、月、日、时、分
        case DateStyleShowYearMonthDayHourMinute:
            //创建年、月、日、时、分的组合标签
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            //返回5列数据
            return 5;
        //显示年、月、日
        case DateStyleShowYearMonthDay:
            //创建年、月、日、时、分、秒的组合标签
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            //返回3列数据
            return 3;
        //显示月、日、时、分
        case DateStyleShowMonthDayHourMinute:
            //创建年、月、日、时、分、秒的组合标签
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            //返回4列数据
            return 4;
        //显示月、日
        case DateStyleShowMonthDay:
            //创建年、月、日、时、分、秒的组合标签
            [self addLabelWithName:@[@"月",@"日"]];
            //返回2列数据
            return 2;
        //显示时、分
        case DateStyleShowHourMinute:
            //创建年、月、日、时、分、秒的组合标签
            [self addLabelWithName:@[@"时",@"分"]];
            //返回2列数据
            return 2;
        default:
            //默认返回0列数据
            return 0;
    }
}

///当选择器视图需要指定组件的行数时调用，返回每个组件中的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //获取每个组件中的行数数组
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    //返回当前组件行数
    return [numberArr[component] integerValue];
}

///获取每个组件中的行数数组
-(NSArray *)getNumberOfRowsInComponent {
    //获取存放年份的数组长度
    NSInteger yearNum = _yearArray.count;
    //获取存放月份的数组长度
    NSInteger monthNum = _monthArray.count;
    //通过年月求每月天数
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    //获取存放小时的数组长度
    NSInteger hourNum = _hourArray.count;
    //获取存放分钟的数组长度
    NSInteger minuteNUm = _minuteArray.count;
    //最大与最小年份时间差(月份的数据总数与公有多少年有关)
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    //判断日期选择样式
    switch (self.datePickerStyle) {
        //显示年、月、日、时、分
        case DateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        //显示月、日、时、分
        case DateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        //显示年、月、日
        case DateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        //显示月、日
        case DateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        //显示时、分
        case DateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
    
}

///当选择器视图需要用于绘制行内容的行高时调用
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

///当选择器视图需要用于给定组件中给定行的视图时调用
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //获取自定义标签
    UILabel *customLabel = (UILabel *)view;
    //如果获取的自定义标签为空
    if (!customLabel) {
        //初始化自定义标签
        customLabel = [[UILabel alloc] init];
        //设置自定义标签文本对齐方式
        customLabel.textAlignment = NSTextAlignmentCenter;
        //设置自定义标签字体大小
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSString *title;
    //判断日期选择样式
    switch (self.datePickerStyle) {
        //显示年、月、日、时、分
        case DateStyleShowYearMonthDayHourMinute:
            //判断pickerView组件的索引
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            if (component==3) {
                title = _hourArray[row];
            }
            if (component==4) {
                title = _minuteArray[row];
            }
            break;
        //显示年、月、日
        case DateStyleShowYearMonthDay:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            break;
        //显示月、日、时、分
        case DateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            if (component==2) {
                title = _hourArray[row];
            }
            if (component==3) {
                title = _minuteArray[row];
            }
            break;
        //显示月、日
        case DateStyleShowMonthDay:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            break;
        //显示时、分
        case DateStyleShowHourMinute:
            if (component==0) {
                title = _hourArray[row];
            }
            if (component==1) {
                title = _minuteArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    //设置自定义标签文本
    customLabel.text = title;
    //设置自定义标签文本颜色
    customLabel.textColor = [UIColor blackColor];
    //返回自定义标签
    return customLabel;
    
}

///当用户选择组件中的行时，由选择器视图调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (self.datePickerStyle) {
        //显示年、月、日、时、分
        case DateStyleShowYearMonthDayHourMinute:{
            
            if (component == 0) {
                yearIndex = row;
                
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
                
            }
        }
            break;
            
        //显示年、月、日
        case DateStyleShowYearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
        //显示月、日、时、分
        case DateStyleShowMonthDayHourMinute:{
            
            
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            
            if (component == 0) {
                
                [self yearChange:row];
                
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
        //显示月、日
        case DateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                
                [self yearChange:row];
                
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
        //显示时、分
        case DateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    
    self.scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm"] dateWithFormatter:_dateFormatter];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    _startDate = self.scrollToDate;
    
}

-(void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    
    self.showYearView.text = _yearArray[yearIndex];
    
    preRow = row;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}



#pragma mark - Action

///显示时间选择器
-(void)show {
    //在当前窗口添加时间选择器视图
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //动画块
    [UIView animateWithDuration:.3 animations:^{
        //设置底部约束常数
        self.bottomConstraint.constant = 10;
        //设置背景色
        self.backgroundColor = WSRGBA(0, 0, 0, 0.4);
        //立即布局子视图
        [self layoutIfNeeded];
    }];
}

///点击背景是否影藏
-(void)dismiss {
    //动画块
    [UIView animateWithDuration:.3 animations:^{
        //设置底部约束常数
        self.bottomConstraint.constant = -self.height;
        //设置背景色
        self.backgroundColor = WSRGBA(0, 0, 0, 0);
        //立即布局子视图
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //移除显示时间选择器视图
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

///确定按钮点击事件
- (IBAction)doneAction:(UIButton *)btn {
    
    _startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    
    self.doneBlock(_startDate);
    //隐藏时间选择器视图
    [self dismiss];
}

#pragma mark - tools

///通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    //记录年份
    NSInteger num_year  = year;
    //记录月份
    NSInteger num_month = month;
    //判断是否是闰年
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    //判断月份
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            //设置每月的天数数组
            [self setdayArray:31];
            //返回该月天数
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            //设置每月的天数数组
            [self setdayArray:30];
            //返回该月天数
            return 30;
        }
        case 2:{
            //判断是否是闰年
            if (isrunNian) {
                //设置每月的天数数组
                [self setdayArray:29];
                //返回该月天数
                return 29;
            }else{
                //设置每月的天数数组
                [self setdayArray:28];
                //返回该月天数
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

///设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

///滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year-MINYEAR;
    monthIndex = date.month-1;
    dayIndex = date.day-1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    //显示年、月、日、时、分
    if (self.datePickerStyle == DateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    //显示年、月、日
    if (self.datePickerStyle == DateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    //显示月、日、时、分
    if (self.datePickerStyle == DateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    //显示月、日
    if (self.datePickerStyle == DateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    //显示时、分
    if (self.datePickerStyle == DateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    
    self.showYearView.text = _yearArray[yearIndex];
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        //显示月、日、时、分或者显示月、日
        if ((self.datePickerStyle == DateStyleShowMonthDayHourMinute || self.datePickerStyle == DateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
        
    }
}


#pragma mark - getter / setter

///懒加载选择器视图
-(UIPickerView *)datePicker {
    if (!_datePicker) {
        //显示所选年份的标签更新布局
        [self.showYearView layoutIfNeeded];
        //初始化选择器视图
        _datePicker = [[UIPickerView alloc] initWithFrame:self.showYearView.bounds];
        //是否显示选中指示符
        _datePicker.showsSelectionIndicator = YES;
        //设置代理
        _datePicker.delegate = self;
        //设置数据源
        _datePicker.dataSource = self;
    }
    //返回选择器视图
    return _datePicker;
}

///设置限制最小时间（没有设置默认0）
-(void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    //判断要滚动到的指定日期是否早于限制的最小时间
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        //将限制的最小时间设置为要滚动到的指定日期
        _scrollToDate = self.minLimitDate;
    }
    //滚动到指定的时间位置
    [self getNowDate:self.scrollToDate animated:NO];
}

///设置确定按钮颜色
-(void)setDoneButtonColor:(UIColor *)doneButtonColor {
    _doneButtonColor = doneButtonColor;
    self.doneBtn.backgroundColor = doneButtonColor;
}

@end
