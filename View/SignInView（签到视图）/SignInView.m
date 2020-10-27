//
//  SignInView.m
//  YiShopCustomer
//
//  Created by 王刚 on 2019/10/24.
//  Copyright © 2019 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  签到页面

#import "SignInView.h"
#import "FSCalendarDynamicHeader.h"

static NSInteger const YSCCommonPadding = 10;
static NSInteger const YSCCommonTopBottomPadding = 15;

@interface SignInView()<FSCalendarDataSource,FSCalendarDelegate>

@property (nonatomic, strong) UIImageView *headerImageView;//头部背景图片视图
@property (nonatomic, strong) UIButton *signInButton;//签到按钮
@property (nonatomic, strong) UILabel *continuoussSignInLabel;//连续签到天数标签
@property (nonatomic, strong) UILabel *cumulativeSignInLabel;//累计签到天数标签
@property (nonatomic, strong) UILabel *everydaySignInRewardLabel;//每日签到奖励标签
@property (nonatomic, strong) FSCalendar *calendarView;//签到日历视图
@property (nonatomic, strong) UILabel *designatedDateSignInRewardLabel;//指定日期签到奖励标签
@property (nonatomic, strong) NSMutableArray<NSDate *> *calendarImageDataSource;//日历显示图片的数据源
@property (nonatomic, strong) NSMutableArray<NSDate *> *calendarAlreadyDataSource;//日历已经签到的数据源

@end

@implementation SignInView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0x4c1130);
        [self addShowImageDaysData];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    ///头部背景图片视图
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.headerImageView setImage:[UIImage imageNamed:@"bg_img_0"]];
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(294.5);
    }];
    
    ///头部包装视图
    UIView *headerwWrapingView = [[UIView alloc]initWithFrame:CGRectZero];
    headerwWrapingView.backgroundColor = [UIColor clearColor];
    [self addSubview:headerwWrapingView];
    [headerwWrapingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(36);
        make.right.equalTo(self.mas_right).offset(-36);
        make.height.mas_equalTo(200);
    }];
    
    ///签到按钮
    self.signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signInButton setImage:[UIImage imageNamed:@"btn_sign_in_now"] forState:UIControlStateNormal];
    self.signInButton.adjustsImageWhenHighlighted = NO;
    [self.signInButton addTarget:self action:@selector(signInButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerwWrapingView addSubview:self.signInButton];
    [self setupHeartbeatAnimationInView:self.signInButton];
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerwWrapingView);
        make.size.mas_equalTo(CGSizeMake(86, 86));
    }];
    
    ///每日签到奖励标签
    self.everydaySignInRewardLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.everydaySignInRewardLabel.font = [UIFont systemFontOfSize:14];
    self.everydaySignInRewardLabel.textColor = [UIColor whiteColor];
    self.everydaySignInRewardLabel.textAlignment = NSTextAlignmentCenter;
    self.everydaySignInRewardLabel.text = @"每日签到送3积分";
    [headerwWrapingView addSubview:self.everydaySignInRewardLabel];
    [self.everydaySignInRewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signInButton.mas_bottom).offset(YSCCommonPadding * 2);
        make.left.equalTo(headerwWrapingView.mas_left).offset(YSCCommonPadding);
        make.right.equalTo(headerwWrapingView.mas_right).offset(- YSCCommonPadding);
    }];
    
    ///连续签到图片视图
    UIImageView *continuoussSignInView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [continuoussSignInView setImage:[UIImage imageNamed:@"continuity-pic"]];
    [headerwWrapingView addSubview:continuoussSignInView];
    [continuoussSignInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerwWrapingView);
        make.left.equalTo(headerwWrapingView.mas_left);
        make.size.mas_equalTo(CGSizeMake(72, 86));
    }];
    
    ///连续签到天数标签
    self.continuoussSignInLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.continuoussSignInLabel.textAlignment = NSTextAlignmentCenter;
    self.continuoussSignInLabel.font = [UIFont systemFontOfSize:13];
    self.continuoussSignInLabel.attributedText = [self changeSignInLabelText:@"5天"];
    [headerwWrapingView addSubview:self.continuoussSignInLabel];
    [self.continuoussSignInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(continuoussSignInView);
        make.bottom.equalTo(continuoussSignInView.mas_bottom).offset(-YSCCommonTopBottomPadding);
        make.left.right.equalTo(continuoussSignInView);
    }];
    
    ///累计签到图片视图
    UIImageView *cumulativeSignInView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [cumulativeSignInView setImage:[UIImage imageNamed:@"cumulativec-pic"]];
    [headerwWrapingView addSubview:cumulativeSignInView];
    [cumulativeSignInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerwWrapingView);
        make.right.equalTo(headerwWrapingView.mas_right);
        make.size.mas_equalTo(CGSizeMake(72, 86));
    }];
    
    ///累计签到天数标签
    self.cumulativeSignInLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.cumulativeSignInLabel.textAlignment = NSTextAlignmentCenter;
    self.cumulativeSignInLabel.font = [UIFont systemFontOfSize:13];
    self.cumulativeSignInLabel.attributedText = [self changeSignInLabelText:@"5天"];
    [headerwWrapingView addSubview:self.cumulativeSignInLabel];
    [self.cumulativeSignInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cumulativeSignInView);
        make.bottom.equalTo(cumulativeSignInView.mas_bottom).offset(-YSCCommonTopBottomPadding);
        make.left.right.equalTo(cumulativeSignInView);
    }];
    
    ///签到日历视图
    self.calendarView = [[FSCalendar alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 40, 300)];
    self.calendarView.backgroundColor = [UIColor whiteColor];
    //日历语言为中文
    self.calendarView.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    //允许多选,可以选中多个日期
    self.calendarView.allowsMultipleSelection = YES;
    //如果值为1,那么周日就在第一列,如果为2,周日就在最后一列
    self.calendarView.firstWeekday = 1;
    //周一\二\三...或者头部的2017年11月的显示方式
    self.calendarView.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    //设置头部年月的显示格式
    self.calendarView.appearance.headerDateFormat = @"MM月yyyy年";
    //设置头部年月的显示颜色
    self.calendarView.appearance.headerTitleColor = [UIColor  blackColor];
    //设置工作日的显示颜色
    self.calendarView.appearance.weekdayTextColor = [UIColor greenColor];
    //今天背景填充色
    self.calendarView.appearance.todayColor = HEXCOLOR(0Xf56456);
    //图片偏移量
    self.calendarView.appearance.imageOffset = CGPointMake(0, -10);
    //今天的副标题文本颜色
    self.calendarView.appearance.subtitleTodayColor = HEXCOLOR(0Xf56456);
    //隐藏日历的所有占位符
    self.calendarView.placeholderType = FSCalendarPlaceholderTypeNone;
    //日期是否可以选择
    self.calendarView.allowsSelection = NO;
    //上月与下月标签静止时的透明度
    self.calendarView.appearance.headerMinimumDissolvedAlpha = 0;
    //隐藏底部分割线，需要引入FSCalendarDynamicHeader.h文件
    self.calendarView.bottomBorder.hidden = YES;
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    self.calendarView.layer.cornerRadius = 10.0;
    [self addShadowToView:self.calendarView withColor:[UIColor blackColor]];
    [self addSubview:self.calendarView];
    
    ///创建点击跳转显示上一月的Button
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarView addSubview:previousButton];
    [previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_top).offset(15);
        make.centerX.equalTo(self.calendarView.mas_centerX).offset(-60);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    ///创建点击跳转显示下一月的Button
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateNormal];
    nextButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarView.mas_top).offset(15);
        make.centerX.equalTo(self.calendarView.mas_centerX).offset(60);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    ///底部图片视图
    UIImageView *footerView = [[UIImageView alloc]initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor redColor];
    footerView.contentMode = UIViewContentModeScaleAspectFit;
    [footerView setImage:[UIImage imageNamed:@"mew_baseline"]];
    footerView.layer.cornerRadius = 10.0;
    [self addShadowToView:footerView withColor:[UIColor blackColor]];
    [self addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.calendarView);
        make.top.equalTo(self.calendarView.mas_bottom).offset(YSCCommonPadding * 2).priorityHigh();
        make.height.mas_equalTo(150);
        make.bottom.equalTo(self.mas_bottom).offset(- YSCCommonPadding * 2).priorityLow();
    }];
    
}

///添加显示图片的天数数据
- (void)addShowImageDaysData{
    //当前时间
    NSString *oneTime = [self nsdateConversionNSString:[NSDate date]];
    //当前时间6天后
    NSString *twoTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 6]];
    //当前时间8天后
    NSString *threeTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 8]];
    //当前时间14天后
    NSString *fourTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 14]];
    
    [self.calendarImageDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:oneTime]]];
    [self.calendarImageDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:twoTime]]];
    [self.calendarImageDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:threeTime]]];
    [self.calendarImageDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:fourTime]]];
    
}

///添加显示选中的天数数据
- (void)addShowSelectDaysData{
    
    //当前时间1天前
    NSString *oneTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:- 24 * 60 * 60]];
    //当前时间6天前
    NSString *twoTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:- 24 * 60 * 60 * 6]];
    //当前时间8天前
    NSString *threeTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:- 24 * 60 * 60 * 8]];
    //当前时间14天前
    NSString *fourTime = [self nsdateConversionNSString:[NSDate dateWithTimeIntervalSinceNow:- 24 * 60 * 60 * 14]];
    
    [self.calendarAlreadyDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:oneTime]]];
    [self.calendarAlreadyDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:twoTime]]];
    [self.calendarAlreadyDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:threeTime ]]];
    [self.calendarAlreadyDataSource addObject:[self handlingTimeZoneDifferences:[self nsstringConversionNSDate:fourTime]]];
}

///更改签到天数的颜色与字体大小
- (NSMutableAttributedString *)changeSignInLabelText:(NSString *)labelText{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:labelText];
    [attributedString addAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor redColor],
                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                      NSKernAttributeName:@(3),
                                      } range:NSMakeRange(0, labelText.length - 1)];
    return attributedString;
}

/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.15;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
}


///设置签到按钮动画
-(void)setupHeartbeatAnimationInView:(UIView *)view{
    // 设定为缩放
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.1]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layer"];
}

///处理签到按钮点击的方法
- (void)signInButtonClick{
    
    [self.signInButton setImage:[UIImage imageNamed:@"btn_sign_in_success"] forState:UIControlStateNormal];
    [self.signInButton.layer removeAnimationForKey:@"scale-layer"];
    self.signInButton.userInteractionEnabled = NO;
    [self addShowSelectDaysData];
    [self.calendarView reloadData];
    
}

///Date时间转字符串
- (NSString *)nsdateConversionNSString:(NSDate *)date{
    //返回当前时间的时间戳
    double timeStamp = [date timeIntervalSince1970];
    //NSTimeInterval 时间间隔，double类型
    NSTimeInterval time = timeStamp;
    //得到Date类型的时间，这个时间是1970-1-1 00:00:00经过你时间戳的秒数之后的时间
    NSDate * detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //转换成字符串
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    //输出一下
    NSLog(@"%@", currentDateStr);
    return currentDateStr;
}

///字符串转Date时间
- (NSDate *)nsstringConversionNSDate:(NSString *)dateStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
    
}

///懒加载日历显示图片的数据源
- (NSMutableArray *)calendarImageDataSource{
    
    if(_calendarImageDataSource == nil){
        
        _calendarImageDataSource = [[NSMutableArray alloc]init];
       
    }
    return _calendarImageDataSource;
    
}

///懒加载日历显示选中的数据源
- (NSMutableArray *)calendarAlreadyDataSource{
    
    if(_calendarAlreadyDataSource == nil){
        
        _calendarAlreadyDataSource = [[NSMutableArray alloc]init];
       
    }
    return _calendarAlreadyDataSource;
    
}

///Date数据源是否包含指定的Date
- (BOOL)didDataDource:(NSMutableArray<NSDate *> *)dataSource contains:(NSDate *)date{
    
    //处理时区差
    NSDate *localeDate = [self handlingTimeZoneDifferences:date];
    //如果数据源包含date，这一天要显示小礼盒
    if([dataSource containsObject:localeDate]){
        //如果今天和小礼盒要显示的天数相等，显示小礼盒，隐藏填充色
        if([self compareOneDay:localeDate withAnotherDay:[self handlingTimeZoneDifferences:[NSDate date]]]){
            self.calendarView.appearance.todayColor = [UIColor clearColor];
        }
        return YES;
        
    }
    return NO;
}

///处理时区差
- (NSDate *)handlingTimeZoneDifferences:(NSDate *)date{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

///忽略时分秒进行Date比较，相等返回yes
- (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    if([oneDayStr isEqualToString:anotherDayStr]){
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

///上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
    NSDate *currentMonth = self.calendarView.currentPage;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDate *previousMonth = [gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:previousMonth animated:YES];
}

///下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *currentMonth = self.calendarView.currentPage;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDate *nextMonth = [gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendarView setCurrentPage:nextMonth animated:YES];
}

///按大小缩放图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma make -- FSCalendarDataSource
// 向数据源查询特定日期的图像。
- (nullable UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date{
    
    if([self didDataDource:self.calendarImageDataSource contains:date]){
        //缩放一下图片
        UIImage *image = [self scaleToSize:[UIImage imageNamed:@"ic_gift"] size:CGSizeMake(20, 20)];
        return image;
        
    }
    return nil;
    
}

//向代理询问未选定状态下的具体日期的填充颜色。
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    
    if([self didDataDource:self.calendarAlreadyDataSource contains:date]){
        return HEXCOLOR(0Xf56456);
    }
    return [UIColor clearColor];
}

//向代理询问未选定状态下的日期文本颜色。
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    
    if([self didDataDource:self.calendarAlreadyDataSource contains:date]){
        return [UIColor whiteColor];
    }
    return [UIColor blackColor];
}

//在日期文本下向数据源请求特定日期的副标题
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    
    if ([self.calendarView.today isEqualToDate:date]){
    
        return @"今天";
        
    }
    
    return nil;
    
}

//向代理询为特定日期的日期文本提供偏移量。
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date{
    
    if ([self.calendarView.today isEqualToDate:date]){
        
        return CGPointMake(0, 7);
        
    }
    return CGPointMake(0,0);

}

//向代理询问特定日期副标题的偏移量。
- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleOffsetForDate:(NSDate *)date{
    
    if ([self.calendarView.today isEqualToDate:date]){
        
        return CGPointMake(0, 18);
        
    }
    return CGPointMake(0, 0);
    
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{
    
}
@end


