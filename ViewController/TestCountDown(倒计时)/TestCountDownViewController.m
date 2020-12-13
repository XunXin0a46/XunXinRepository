//
//  TestCountDownViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/11/14.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCountDownViewController.h"
#import "OYCountDownManager.h"

@interface TestCountDownViewController ()

@property (nonatomic, strong)UILabel *countDownLabel;//倒计时标签
@property (nonatomic, assign)double countDownTime;//倒计时时间

@property(nonatomic, strong) UILabel *day;//倒计时天数标签
@property(nonatomic, strong) UILabel *hour;//倒计时小时标签
@property(nonatomic, strong) UILabel *minute;//倒计时分钟标签
@property(nonatomic, strong) UILabel *second;//倒计时秒标签

@property (nonatomic, strong) UILabel *one;//分隔符
@property (nonatomic, strong) UILabel *two;//分隔符
@property (nonatomic, strong) UILabel *three;//分隔符

@end

@implementation TestCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"倒计时"];
    //创建视图
    [self createUI];
    //创建组合倒计时标签
    [self createCombinationCountDownLabelUI];
    //设置倒计时时间
    self.countDownTime = [[NSDate date]timeIntervalSince1970] + 60;
    //开始倒计时
    [kCountDownManager start];
    //监听倒计时通知
    [self monitoringCountDownNotification];
}

-(void)dealloc{
    // 废除定时器
    [kCountDownManager invalidate];
    // 清空时间差
    [kCountDownManager reload];
}

/// 监听倒计时通知
- (void)monitoringCountDownNotification{
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
}

- (void)createUI{
    ///倒计时标签
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.countDownLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth - 250)/2, 300, 250, 100)];
    self.countDownLabel.textColor = [UIColor greenColor];
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    self.countDownLabel.numberOfLines = 0;
    [self.view addSubview:self.countDownLabel];

}

///字符串时间戳转NSDate
-(NSDate *)DateFromTimeStamap:(NSString *)timeStamap{
    //传入的时间戳timeStamap如果是精确到毫秒要/1000
    NSTimeInterval timeInterval = [timeStamap doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}

///接收倒计时通知执行的事件
- (void)countDownNotification {
    //赋值给label
    self.countDownLabel.attributedText = [self getCountdownAttributStringWithStringOne:@"火箭还有" stringTwo:@"发射"];
    //赋值倒计时组合标签
    NSString *countDownStr = [NSString stringWithFormat:@"%f",(long)self.countDownTime - [[NSDate date]timeIntervalSince1970]];
    [self getCountDownTimeWithString:countDownStr];
}

///处理倒计时标签显示文本
- (NSMutableAttributedString *)getCountdownAttributStringWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo{
    NSString * str = [self convertTimeIntervalToFormatDate:self.countDownTime];
    //初始化可变富文本对象
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:stringOne];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithAttributedString:[self getNowTimeWithString:str]];
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:stringTwo];
    //拼接属性化字符串
    [string1 appendAttributedString:string2];
    [string1 appendAttributedString:string3];
    //初始化可变的段落样式，用于设置首行，行间距，对齐方式等
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //设置字体的行间距
    [style setLineSpacing:1];
    [string1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string1.length)];
    return string1;
}

///将时间间隔转换为格式日期
- (NSString *)convertTimeIntervalToFormatDate:(NSTimeInterval)timeInterval {
    //初始时间格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //时间戳转时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

///处理格式化字符串时间
- (NSAttributedString *)getNowTimeWithString:(NSString *)aTimeString {
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [formater dateFromString:aTimeString];
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    nowDate = [formater dateFromString:nowDateStr];
    //时间转时间戳
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    //倒计时的计算
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr = nil;
    NSString *hoursStr = nil;
    NSString *minutesStr = nil;
    NSString *secondsStr = nil;
    dayStr = [NSString stringWithFormat:@"%d",days];
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    
    if(minutes < 10) {
        minutesStr = [NSString stringWithFormat:@"0%d", minutes];
    } else {
        minutesStr = [NSString stringWithFormat:@"%d", minutes];
    }
    
    if(seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        secondsStr = [NSString stringWithFormat:@"%d", seconds];
    }
    
    if (hours <= 0 &&
        minutes <= 0 &&
        seconds <= 0) {
        //倒计时结束
        [kCountDownManager invalidate];
        NSString *nowTimeStr = @"0天0小时0分0秒";
         NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:nowTimeStr];
        return attributeString;
    }
    NSString *nowTimeStr = [NSString stringWithFormat:@"%@ 天%@ 小时%@ 分%@ 秒", dayStr, hoursStr, minutesStr, secondsStr];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:nowTimeStr];
    //设置富文本颜色
    [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, nowTimeStr.length)];
    return attributeString;
}


///创建组合倒计时标签
- (void)createCombinationCountDownLabelUI{
    ///倒计时天数标签
    self.day = [self createTimeLabel];
    self.day.lineBreakMode = NSLineBreakByClipping;
    [self.view addSubview:self.day];
    [self.day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countDownLabel.mas_bottom).offset(30);
        make.left.equalTo(self.countDownLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
    
    ///分隔符
    self.three = [self createColonLabel];
    [self.view addSubview:self.three];
    [self.three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.day.mas_centerY);
        make.left.equalTo(self.day.mas_right).offset(2.0f);
    }];
    
    ///倒计时小时标签
    self.hour = [self createTimeLabel];
    [self.view addSubview:self.hour];
    [self.hour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.three.mas_centerY);
        make.left.equalTo(self.three.mas_right).offset(2.0f);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    ///分隔符
    self.two = [self createColonLabel];
    [self.view addSubview:self.two];
    [self.two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hour.mas_centerY);
        make.left.equalTo(self.hour.mas_right).offset(2.0f);
    }];
    
    ///倒计时分钟标签
    self.minute = [self createTimeLabel];
    [self.view addSubview:self.minute];
    [self.minute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.two.mas_centerY);
        make.left.equalTo(self.two.mas_right).offset(2.0f);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    ///分隔符
    self.one = [self createColonLabel];
    [self.view addSubview:self.one];
    [self.one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.minute.mas_centerY);
        make.left.equalTo(self.minute.mas_right).offset(2.0f);
    }];
    
    ///倒计时秒标签
    self.second = [self createTimeLabel];
    [self.view addSubview:self.second];
    [self.second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.one.mas_centerY);
        make.left.equalTo(self.one.mas_right).offset(2.0f);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

///创建倒计时时间标签
- (UILabel *)createTimeLabel{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = HEXCOLOR(0xF56456);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3;
    return label;
}

///创建分隔符标签
- (UILabel *)createColonLabel{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = HEXCOLOR(0x583309);
    label.text = @":";
    label.font = [UIFont systemFontOfSize:11];
    return label;
}

///获取倒计时的字符串
- (void)getCountDownTimeWithString:(NSString *)aTimeString {
    
    NSInteger timeInterval = [aTimeString integerValue];
    //倒计时的计算
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = (int)timeInterval-days*24*3600-hours*3600-minutes*60;
    
    //倒计时结束
    if (hours <= 0 &&minutes <= 0 && seconds <= 0) {
        days = 0;
        hours =0;
        minutes = 0;
        seconds = 0;
    }
    //正在倒计时
    self.day.text = [NSString stringWithFormat:@"%02d",days];
    self.hour.text = [NSString stringWithFormat:@"%02d",hours];
    self.minute.text = [NSString stringWithFormat:@"%02d",minutes];
    self.second.text = [NSString stringWithFormat:@"%02d",seconds];
    
}

@end
