//
//  TextCodeController.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/10/17.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "TestCodeController.h"
#import "TestKVCModel.h"
#import "LabelWithCopy.h"
#import <UserNotifications/UserNotifications.h>

@interface TestCodeController ()

@end

@implementation TestCodeController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"测试代码"];
    //测试按钮
    UIButton *testCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testCodeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 75 / 2, CGRectGetMinY(self.view.frame) + HEAD_BAR_HEIGHT, 75, 30);
    testCodeButton.backgroundColor = [UIColor blueColor];
    testCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [testCodeButton setTitle:@"测试代码" forState:UIControlStateNormal];
    [testCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testCodeButton addTarget:self action:@selector(testCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testCodeButton];
    
}

///测试按钮点击
- (void)testCode{
    NSLog(@"测试开始");
    //使用初始值创建新的计数信号量。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //开辟子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"我输出后线程就被阻塞了");
        //等待（减少）信号量。阻塞线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"我需等待3秒才能输出");
    });
    //延迟3秒执行函数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //信号量（递增）,唤醒线程
        dispatch_semaphore_signal(semaphore);
    });
    
}


///----------------------------------- 二维码开始 ---------------------------------------------

- (void)showQrCode{
    //二维码的宽
    CGFloat QrCodeWidth = SCREEN_WIDTH - 120;
    //初始化二纬码视图
    UIImageView *qrCodeImageView = [[UIImageView alloc] init];
    qrCodeImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self.view).offset (((QrCodeWidth - 80) / 2 ) + 20);
        make.centerX.equalTo (self.view);
        make.size.mas_equalTo (CGSizeMake(QrCodeWidth - 80, QrCodeWidth - 80));
    }];
    //设置二维码
    UIImage *qrCodeImage = [YSUUtils QRCodeImageWithContent:@"361599980595002151" imageSize:CGSizeMake(QrCodeWidth - 80, QrCodeWidth - 80) logoImage:[UIImage imageNamed:@"ic_gift"] logoImageSize:CGSizeMake(30, 30)];
    qrCodeImageView.image = qrCodeImage;
}

///----------------------------------- 二维码结束 ---------------------------------------------

///----------------------------------- MBProgressHUD 开始 ------------------------------------

- (void)showMBProgressHUD{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    hud.label.text = @"医生问诊排队中...";
    hud.minSize = CGSizeMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2 * 0.8);
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

///----------------------------------- MBProgressHUD 结束 ------------------------------------

///----------------------------------- KVC开始 -----------------------------------------------

- (void)testKVC{
    TestKVCModel *testMoodel = [[TestKVCModel alloc]initWithPersonalHobbiesModel];
    [testMoodel setValue:@"小明" forKey:@"name"];
    [testMoodel setValue:@"25" forKey:@"age"];
    [testMoodel setValue:@"英雄联盟" forKeyPath:@"hobbiesModel.playGame"];
    [testMoodel setValue:@"中国通史" forKeyPath:@"hobbiesModel.read"];
    [testMoodel setValue:@"这个key不存在的" forKey:@"unknownKey"];
    [testMoodel setValue:@"明" forKey:@"nickName"];
    
    NSLog(@"%@",[testMoodel valueForKey:@"name"]);
    NSLog(@"%@",[testMoodel valueForKey:@"age"]);
    NSLog(@"%@",[testMoodel valueForKeyPath:@"hobbiesModel.playGame"]);
    NSLog(@"%@",[testMoodel valueForKeyPath:@"hobbiesModel.read"]);
    NSLog(@"%@",[testMoodel valueForUndefinedKey:@"unknownKey"]);
    [testMoodel logMemberVariable];
}

///----------------------------------- KVC结束 -----------------------------------------------

///----------------------------------- UITextField 开始 --------------------------------------

- (void)textFieldTextAlignmentRight{
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 200 / 2, CGRectGetMaxY(self.view.frame) / 2 - 30 / 2 , 200, 30)];
    textField.backgroundColor = HEXCOLOR(0xE5E5E5);
    textField.textColor = [UIColor redColor];
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholder = @"光标会固定的";
    [self.view addSubview:textField];
}

///----------------------------------- UITextField 结束 --------------------------------------

///----------------------------------- NSUserDefaults开始 -------------------------------------

///向NSUserDefaults存储值
- (void)saveUserDefaults{

    [[NSUserDefaults standardUserDefaults] setDouble:YES forKey:@"又吃成长快乐了"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    double Study = [[NSUserDefaults standardUserDefaults] doubleForKey:@"又吃成长快乐了"];
    NSLog(@"%f",Study);

    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSLog(@"path : %@", pathArray.lastObject);
}
///----------------------------------- NSUserDefaults结束 -------------------------------------

///---------------------------------- NSLayoutConstraint开始 ----------------------------------

//给视图添加一个简单的约束，使其等于控制器视图大小
- (void)setLayoutConstraint1{

    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor greenColor];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view2];

    NSLayoutConstraint *LayoutConstraintCenterX = [self equallyRelatedConstraintWithView:view2 attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *LayoutConstraintCenterY = [self equallyRelatedConstraintWithView:view2 attribute:NSLayoutAttributeCenterY];
    NSLayoutConstraint *LayoutConstraintWidth = [self equallyRelatedConstraintWithView:view2 attribute:NSLayoutAttributeWidth];
    NSLayoutConstraint *LayoutConstraintHeight = [self equallyRelatedConstraintWithView:view2 attribute:NSLayoutAttributeHeight];
    [self.view addConstraint:LayoutConstraintCenterX];
    [self.view addConstraint:LayoutConstraintCenterY];
    [self.view addConstraint:LayoutConstraintWidth];
    [self.view addConstraint:LayoutConstraintHeight];
}

//给视图添加一个简单的约束，使其居中，宽高各为200
- (void)setLayoutConstraint2{
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor greenColor];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view2];

    NSLayoutConstraint *LayoutConstraintCenterX = [self equallyRelatedConstraintWithView:view2 attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *LayoutConstraintCenterY = [self equallyRelatedConstraintWithView:view2 attribute:NSLayoutAttributeCenterY];

    [self.view addConstraint:LayoutConstraintCenterX];
    [self.view addConstraint:LayoutConstraintCenterY];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[view2(200)]" options:0 metrics:nil views:@{@"view2": view2}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view2(200.0)]" options:0 metrics:nil views:@{@"view2": view2}]];
}

///与视图同等相关的约束
- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

///---------------------------------- NSLayoutConstraint结束 ---------------------------------

///--------------------------------- NSJSONSerialization代码测试区 ----------------------------

//JSON字符串转化为字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    //返回一个NSData对象，该对象包含使用给定编码编码的接收器的表示形式
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;

    //从给定的JSON数据返回一个Foundation对象
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 字典转json字符串方法
-(NSString *)convertToJsonData:(NSDictionary *)dict{

    NSError *error;

    //从基础对象返回JSON数据
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}

///-------------------------------- NSJSONSerialization代码测试区结束 ---------------------------

///---------------------------------------- UIApplication代码测试区 ----------------------------

///拨打电话
- (void)makePhoneCall{
    NSString *tel = [NSString stringWithFormat:@"telprompt://%@", @"13483361922"];
    NSURL *url = [NSURL URLWithString:tel];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    }
}

///设置应用程序图标右上角的红色提醒数字
- (void)setAppUpperRightCornerNumber{

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功！！");
        }
    }];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 10;
}

///联网指示器的可见性
- (void)setVisibilityOfNetworkedIndicators{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

///---------------------------------------- UIApplication代码测试区结束 ----------------------------


///------------------------------------- NSDate代码测试区 ------------------------------------------

///为Date时间加上一个月
- (NSDate *)PlusOneMonth:(NSDate *)currentDate{
    //以公历标识初始化日历对象
    NSCalendar *calender2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置第一个工作日的索引
    [calender2 setFirstWeekday:2];// 国外是从周日开始算的,我们是周一,所以写了2
    //初始化日期组件对象
    NSDateComponents *adcomps = [[NSDateComponents alloc]init];
    //设置补偿年
    [adcomps setYear:0];
    //设置补偿月
    [adcomps setMonth:+1];
    //设置补偿天
    [adcomps setDay:0];
    //将日期组件加到给定日期
    NSDate *newdate = [calender2 dateByAddingComponents:adcomps toDate:currentDate options:0];
    //返回新的NSDate对象
    return newdate;
}


///字符串转Date时间
- (NSDate *)nsstringConversionNSDate:(NSString *)dateStr {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;

}

///处理时区差
- (NSDate *)handlingTimeZoneDifferences:(NSDate *)date{

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

///------------------------------------- NSDate代码测试区结束 -------------------------------------


///--------------------------------------- UILabel代码测试区 --------------------------------------
- (void)UILabelCodeTestArea{

    //标签自动调整大小以适应一定的宽度的测试
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"测试标签";
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.minimumScaleFactor = 0.0;
    label.enabled = YES;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(20, 50));
    }];

    //allowsDefaultTighteningForTruncation属性测试
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectZero];
    label2.text = @"测试标签";
    label2.textColor = [UIColor redColor];
    label2.font = [UIFont systemFontOfSize:18.0];
    label2.numberOfLines = 0;
    label2.allowsDefaultTighteningForTruncation = NO;
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(CGSizeMake(70, 45));
    }];

    //可以复制的标签
    UILabel *copyLabel = [[LabelWithCopy alloc]initWithMakeToastTilte:@"复制成功"];
    copyLabel.text = @"测试标签";
    copyLabel.textColor = [UIColor redColor];
    copyLabel.font = [UIFont systemFontOfSize:18.0];
    copyLabel.numberOfLines = 0;
    copyLabel.allowsDefaultTighteningForTruncation = NO;
    [self.view addSubview:copyLabel];
    [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(CGSizeMake(70, 45));
    }];

}
///---------------------------------------- UILabel代码测试区结束 -------------------------------


///-------------------------------------- 按大小缩放图片代码测试区 --------------------------------

- (void)scalePictureCodeTestAreaBySize{

    UIButton *WeiXinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [WeiXinButton setImage:[UIImage imageNamed:@"ic_wechat"] forState:UIControlStateNormal];
    [WeiXinButton setTitle:@"微信支付" forState:UIControlStateNormal];
    [WeiXinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    WeiXinButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    WeiXinButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    WeiXinButton.layer.cornerRadius = 22.0f;
    WeiXinButton.layer.masksToBounds = YES;
    WeiXinButton.layer.borderColor = [UIColor blackColor].CGColor;
    WeiXinButton.layer.borderWidth = 0.6;

    [self.view addSubview:WeiXinButton];
    [WeiXinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(- 44);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(- 10);
        make.height.mas_equalTo(44);
    }];

    UIButton *WeiXinButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [WeiXinButton2 setImage:[self scaleToSize:[UIImage imageNamed:@"ic_wechat"] size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [WeiXinButton2 setTitle:@"微信支付" forState:UIControlStateNormal];
    [WeiXinButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    WeiXinButton2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    WeiXinButton2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    WeiXinButton2.layer.cornerRadius = 22.0f;
    WeiXinButton2.layer.masksToBounds = YES;
    WeiXinButton2.layer.borderColor = [UIColor blackColor].CGColor;
    WeiXinButton2.layer.borderWidth = 0.6;

    [self.view addSubview:WeiXinButton2];
    [WeiXinButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(44);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(- 10);
        make.height.mas_equalTo(44);
    }];

}

/////按大小缩放
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{

    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
///-------------------------------- 按大小缩放图片代码测试区结束 --------------------------------

///-------------------------------- 返回虚线image的方法 ---------------------------------------

- (void)setDashLine{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imageView setImage:[self drawDashLineWithImageView:imageView]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(1);
    }];
}

- (UIImage *)drawDashLineWithImageView:(UIImageView *)imageView {

    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH, 4.0)); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, SCREEN_WIDTH, 4.0)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
    CGFloat lengths[] = {3.0, 3.0};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
    CGContextSetLineDash(line, 4, lengths, 2);
    CGContextMoveToPoint(line, 4.0, 4.0); //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH, 4.0);
    CGContextStrokePath(line);
    return UIGraphicsGetImageFromCurrentImageContext();
}

///-------------------------------- 返回虚线image的方法结束 ------------------------------------

///-------------------------------- NSArray代码测试区 -----------------------------------------

- (void)testArray{

    //不会越界
    NSMutableArray *array = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
    NSArray *newAdditions = [NSArray arrayWithObjects: @"a", @"b", nil];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:5];
    [indexes addIndex:4];
    [array insertObjects:newAdditions atIndexes:indexes];
    NSLog(@"array: %@", array);

    //不会越界
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
    NSArray *newAdditions2 = [NSArray arrayWithObjects: @"a", @"b", @"c", nil];
    NSMutableIndexSet *indexes2 = [NSMutableIndexSet indexSetWithIndex:1];
    [indexes2 addIndex:2];
    [indexes2 addIndex:6];
    [array2 insertObjects:newAdditions2 atIndexes:indexes2];
    NSLog(@"array: %@", array2);

    //会越界
    NSMutableArray *array3 = [NSMutableArray arrayWithObjects: @"one", @"two", @"three", @"four", nil];
    NSArray *newAdditions3 = [NSArray arrayWithObjects: @"a", @"b", nil];
    NSMutableIndexSet *indexes3 = [NSMutableIndexSet indexSetWithIndex:6];
    [indexes3 addIndex:4];
    [array3 insertObjects:newAdditions3 atIndexes:indexes2];
    NSLog(@"array: %@", array3);

    NSMutableArray *tableArray = [[NSMutableArray alloc]initWithObjects:@"3",@"2",@"5",@"2",@"7", nil];
    [tableArray sortUsingComparator:^NSComparisonResult(NSString  *_Nonnull str1, NSString * _Nonnull str2) {

            if ([str1 longLongValue] < [str2 longLongValue]){

                return NSOrderedDescending;
            }
            else if ([str1 longLongValue] == [str2 longLongValue]){

                return NSOrderedSame;
            }else{

                return NSOrderedAscending;
            }
     }];

}

///-------------------------------- NSArray代码测试区结束 --------------------------------------

///------------------------------ 冒泡排序代码测试区开始 -----------------------------------------

- (void)testBubbleSort{

    NSDictionary *step_price = @{@"40-299" : @"5.00",@"≥300" : @"1.00",@"5-39" : @"6.00"};

    UILabel *goodsDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    goodsDescLabel.textColor = [UIColor blackColor];
    goodsDescLabel.numberOfLines = 0;
    goodsDescLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:goodsDescLabel];
    [goodsDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    __block NSString * goodsDescStr = @"";
    __block NSMutableArray * valueArray = [NSMutableArray array];

    //获取字典中所有的key
    NSArray *keyArray = step_price.allKeys;
    //对key进行排序
    NSMutableArray *sortedArray = [self sortKeyArray:keyArray];

    for (int i = 0; i < sortedArray.count; i++) {
        goodsDescStr = [goodsDescStr stringByAppendingString:sortedArray[i]];
        goodsDescStr = [goodsDescStr stringByAppendingString:@" 件"];
        NSString * valueStr = [NSString stringWithFormat:@"%@元",[step_price objectForKey:sortedArray[i]]];
        [valueArray addObject:valueStr];
        goodsDescStr = [goodsDescStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",valueStr]];
    }

    goodsDescStr = [goodsDescStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    NSMutableAttributedString *goodsDescString = [[NSMutableAttributedString alloc] initWithString:goodsDescStr];
    for (NSString * valueStr in valueArray) {
    [goodsDescString addAttribute:NSForegroundColorAttributeName value: [UIColor redColor] range:[goodsDescStr rangeOfString:valueStr]];
    }
    goodsDescLabel.attributedText = goodsDescString;

}

///model.step_price中的key进行排序(冒泡排序)
- (NSMutableArray *)sortKeyArray:(NSArray *)keyArray{
    BOOL flag = YES;
    NSMutableArray * arr = keyArray.mutableCopy;

    for (int i = 0; i < arr.count && flag; i++) {
        flag = NO;
        for (int j = (int)arr.count-2; j >= i; j--) {
            if ([self handleKey:arr[j]] > [self handleKey:arr[j+1]]) {
                [arr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                flag = YES;
            }
        }
    }
    return arr;
}

///处理key
- (NSInteger)handleKey:(NSString *)key{
    NSString *newKey = nil;
    __block NSMutableString *mutableNewKey = [[NSMutableString alloc]init];
    if([key rangeOfString:@"-"].length){
        newKey = [key substringFromIndex:[key rangeOfString:@"-"].location + 1];
    }else{
        [key enumerateSubstringsInRange:NSMakeRange(0, key.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            //使用正则表达式匹配数字
            NSError *error = nil;
            NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:@"(\\d+)" options:0 error:&error];
            if(!error && [expression matchesInString:substring options:0 range:NSMakeRange(0, substring.length)].count > 0) {
                [mutableNewKey appendString:substring];
            }
        }];
        newKey = [NSString stringWithFormat:@"%@",mutableNewKey];
    }
    return newKey.integerValue;
}

///------------------------------ 冒泡排序代码测试区结束 ----------------------------------------

///-------------------------------- NSString测试区开始 ----------------------------------------

//替换路径的某一部分
- (void)usedTestStringFunction{
    NSString *Url = @"https://www.baidu.com/index/index/home?visiter_name=HYK1909171645525&avatar=http://www.baidu.com/images/746/&domain=http://www.baidu.com";

    NSString *avatarUrl = @"http://www.qq.com";

    [self handleUrl:Url withReplaceAvatarUrl:avatarUrl];
}

- (void)handleUrl:(NSString *)Url withReplaceAvatarUrl:(NSString *)avatarUrl{
    //获取&avatar=与&domain位置
    NSRange startRange = [Url rangeOfString:@"&avatar="];
    NSRange endRange = [Url rangeOfString:@"&domain"];
    //如果&avatar=与&domain字段都是存在的
    if(startRange.length && endRange.length){
        //截取&avatar=与&domain字段中间的字符
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [Url substringWithRange:range];
        //如果截取的result不等于avatarUrl且avatarUrl有内容，进行替换
        if(![result isEqualToString:avatarUrl] && avatarUrl.length){
            //将avatarUrl替换Url中avatar字段对应的值
            NSString *newURL = [Url stringByReplacingCharactersInRange:NSMakeRange(startRange.location + startRange.length, result.length) withString:avatarUrl];
            NSLog(@"%@",newURL);
        }
    }
}

//测试字符串排序
- (void)testCompare{

    NSString *str1 = @"52";
    NSString *str2 = @"33";
    NSComparisonResult result = [str1 compare:str2 options:NSAnchoredSearch | NSBackwardsSearch];
    if(result == NSOrderedAscending){
        NSLog(@"后面一个字符串大于前面一个 升序");
    }else if(result == NSOrderedSame){
        NSLog(@"等于");
    }else if(result == NSOrderedDescending){
        NSLog(@"后面一个字符串小于前面一个 降序");
    }
}

//测试从末尾删除字符或追加字符到给定的数量
- (void)testStringByPaddingToLength{
    NSString *str = @"123456789";
    NSString *newStr = [str stringByPaddingToLength:12 withString:@"ABCDE" startingAtIndex:2];
    NSLog(@"%@",newStr);
}

//携带间距计算文本高度
- (void)carryLineSpacingCalculationHeight{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 10;
    
    CGSize size = [@"测试标签,内容也挺多的，最起码要能换个行吧，要不怎么测试行间距呢，没办法测试的啊" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 200, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
                                                  NSParagraphStyleAttributeName : paragraphStyle,
                                                  NSKernAttributeName:@(10),
                                                }
                                              context:nil].size;
    NSLog(@"%f",size.height);
}

/**
 调整文本间距
 @parameter string 要调整的文本
 @parameter lineSpace 行间距
 @parameter kern 字符间距
 @parameter font 字体
 */
- (NSAttributedString *)getAttributedWithString:(NSString *)string WithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}

///-------------------------------- NSString测试区结束 ----------------------------------------

///-------------------------------- 网络请求代码测试区开始 --------------------------------------

- (void)testRequest{
    YSURequest *request = [[YSURequest alloc]initWithUrl:@"http://baidu.com" andWhat:0];
    [self addRequest:request];
}

- (void)onRequestSucceed:(NSDictionary *)response ofWhat:(NSInteger)what{
    NSLog(@"请求成功了");
}

- (void)onRequestFailed:(YSURequestError *)error ofWhat:(NSInteger)what{
    NSLog(@"请求失败了");
}

///原生请求
- (void)testNSURLSession{
    //初始化Url
    NSURL *url = [[NSURL alloc]initWithString:@"https://www.test.68mall.com/index"];
    //可变URL加载请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    //设置请求方式(默认也是GET)
    [request setHTTPMethod:@"GET"];
    //设置请求头
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/x-www-form-urlencoded",@"User-Agent":@"szyapp/ios"};
    //通过单例初始化网络数据传输任务对象
    NSURLSession *session = [NSURLSession sharedSession];
    //通过基于请求对象创建请求任务
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            //请求成功
            NSLog(@"%@",response.textEncodingName);
            //返回与给定IANA注册表“字符集”名称最接近的映射的CoreFoundation编码常量。如果名称无法识别，则返回kCFStringEncodingInvalidId常量。
            CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)
                                [response textEncodingName]);
            //返回与给定的CoreFoundation编码常量最接近的Cocoa编码常量。
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
            //通过使用编码将数据中的字节转换为UTF-16代码单元而初始化的NSString对象
            NSString *text = [[NSString alloc] initWithData:data encoding:encoding];
            NSLog(@"%@",text);
            //将响应数据转换为字典
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",jsonDict);
            //请求状态码
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            //响应编码
            NSLog(@"%ld",(long)HTTPURLResponse.statusCode);
            NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:HTTPURLResponse.statusCode]);
        }else{
            NSLog(@"%@",error);
        }
    }]resume];
}

///-------------------------------- 网络请求代码测试区结束 --------------------------------------

@end
