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

@end

@implementation TestCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"倒计时"];
    [self createUI];
}

- (void)createUI{
    ///倒计时标签
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.countDownLabel = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth - 300)/2, 300, 300, 100)];
    self.countDownLabel.textColor = [UIColor greenColor];
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    self.countDownLabel.numberOfLines = 0;
    [self.view addSubview:self.countDownLabel];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
}

- (NSString *)convertTimeIntervalToFormatDate:(NSTimeInterval)timeInterval {
    //初始时间格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //时间戳转时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

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
}

///处理倒计时标签显示文本
- (NSMutableAttributedString *)getCountdownAttributStringWithStringOne:(NSString *)stringOne stringTwo:(NSString *)stringTwo{
    NSString * str = [self convertTimeIntervalToFormatDate:1557973398];
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


-(void)dealloc{
    // 废除定时器
    [kCountDownManager invalidate];
    // 清空时间差
    [kCountDownManager reload];
}

@end
