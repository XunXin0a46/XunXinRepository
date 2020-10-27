//
//  TestRegularViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/5/29.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestRegularViewController.h"

@interface TestRegularViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *regularWrapperView;//正则表达式包装视图
@property (nonatomic, strong) UILabel *regularNameLabel;//正则表达式指示标签
@property (nonatomic, strong) UITextField *regularTextField;//正则表达式输入框
@property (nonatomic, copy) NSString *regularString;//记录正则表达式内容
@property (nonatomic, strong) UIView *verificationContentWrapperView;//验证内容包装视图
@property (nonatomic, strong) UILabel *verificationContentNameLabel;//验证内容指示标签
@property (nonatomic, strong) UITextField *verificationContentTextField;//验证内容输入框
@property (nonatomic, copy) NSString *verificationContentString;//记录验证内容
@property (nonatomic, strong) UIButton *verificationButton;//验证按钮
@property (nonatomic, strong) UILabel *verificationResultLabel;//验证结果标签


@end

@implementation TestRegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"测试正则"];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self createUI];
    [self testNSRegularExpression];
    [self testNSRegularExpressionII];
}

- (void)createUI{
    
    ///正则表达式包装视图
    self.regularWrapperView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.regularWrapperView];
    self.regularWrapperView.backgroundColor = [UIColor whiteColor];
    
    [self.regularWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(- 50);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    ///正则表达式指示标签
    self.regularNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.regularWrapperView addSubview:self.regularNameLabel];
    self.regularNameLabel.font = [UIFont systemFontOfSize:14];
    self.regularNameLabel.text = @"正则表达式：";
    
    [self.regularNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.regularWrapperView).offset(20);
        make.centerY.equalTo(self.regularWrapperView);
        make.width.mas_equalTo(100.0);
    }];
    
    ///正则表达式输入框
    self.regularTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.regularWrapperView addSubview:self.regularTextField];
    self.regularTextField.delegate = self;
    //与文本对象关联的键盘样式为指定数字和标点键盘
    self.regularTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //文本对象的自动大写样式为不自动文本大写
    self.regularTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //控件边界内内容的垂直对齐方式为居中对齐
    self.regularTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //文本的字体
    self.regularTextField.font = [UIFont systemFontOfSize:14];
    //控制标准清除按钮只有在文本字段中编辑文本时显示在文本字段中
    self.regularTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //当文本字段中没有其他文本时显示的字符串
    self.regularTextField.placeholder = @"请输入正则表达式";
    [self.regularTextField addTarget:self action:@selector(textFieldOnEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.regularTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.regularNameLabel.mas_right);
        make.right.equalTo(self.regularWrapperView.mas_right).offset(-15);
        make.centerY.equalTo(self.regularNameLabel.mas_centerY);
    }];
    
    ///验证内容包装视图
    self.verificationContentWrapperView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.verificationContentWrapperView];
    self.verificationContentWrapperView.backgroundColor = [UIColor whiteColor];
    
    [self.verificationContentWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.regularWrapperView.mas_bottom).offset(1);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    ///验证内容指示标签
    self.verificationContentNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.verificationContentWrapperView addSubview:self.verificationContentNameLabel];
    self.verificationContentNameLabel.text = @"验证内容：";
    self.verificationContentNameLabel.font = [UIFont systemFontOfSize:14];
    
    [self.verificationContentNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationContentWrapperView).offset(20);
        make.centerY.equalTo(self.verificationContentWrapperView);
        make.width.mas_equalTo(100.0);
    }];
    
    ///验证内容输入框
    self.verificationContentTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.verificationContentWrapperView addSubview:self.verificationContentTextField];
    self.verificationContentTextField.placeholder = @"请输入验证内容";
    self.verificationContentTextField.delegate = self;
    self.verificationContentTextField.font = [UIFont systemFontOfSize:14];
    self.verificationContentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.verificationContentTextField addTarget:self action:@selector(textFieldOnEditing:) forControlEvents:UIControlEventEditingChanged];
    
    [self.verificationContentTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationContentNameLabel.mas_right);
        make.right.equalTo(self.verificationContentWrapperView.mas_right).offset(-15);
        make.centerY.equalTo(self.verificationContentNameLabel.mas_centerY);
    }];
    
    ///验证按钮
    self.verificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.verificationButton];
    self.verificationButton.layer.cornerRadius = 5.0;
    self.verificationButton.backgroundColor = [UIColor grayColor];
    self.verificationButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.verificationButton setTitle:@"验证" forState:UIControlStateNormal];
    [self.verificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.verificationButton.layer.cornerRadius = 5.0;
    self.verificationButton.enabled = NO;
    [self.verificationButton addTarget:self action:@selector(verificationRegular) forControlEvents:UIControlEventTouchUpInside];
    
    [self.verificationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationContentWrapperView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    self.verificationResultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.verificationResultLabel];
    self.verificationResultLabel.font = [UIFont boldSystemFontOfSize:25];
    self.verificationResultLabel.textAlignment = NSTextAlignmentCenter;
    self.verificationResultLabel.numberOfLines = 1;
    
    [self.verificationResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.verificationButton);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
}

///输入框内容改变时调用
- (void)textFieldOnEditing:(UITextField *)sender {
    
    if([sender isEqual:self.regularTextField]){
        self.regularString = sender.text;
    }else{
        self.verificationContentString = sender.text;
    }
    
    if (self.regularString.length > 0 &&
        self.verificationContentString.length > 0) {
        
        self.verificationButton.enabled = YES;
        self.verificationButton.backgroundColor = [UIColor greenColor];
        
    } else {
        
        self.verificationButton.enabled = NO;
        self.verificationButton.backgroundColor = [UIColor grayColor];
    }
}

///验证正则
- (void)verificationRegular{
    NSError *error = nil;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:self.regularString options:0 error:&error];
    
    if(!error && [expression matchesInString:self.verificationContentString options:0 range:NSMakeRange(0, self.verificationContentString.length)].count > 0) {
        self.verificationResultLabel.text = @"验证通过";
        self.verificationResultLabel.textColor = [UIColor greenColor];
    }else{
        self.verificationResultLabel.text = @"验证未通过";
        self.verificationResultLabel.textColor = [UIColor redColor];
    }
}



///--------------------------------- NSRegularExpression 开始 --------------------------------------------
- (void)testNSRegularExpression{
    
    //路径匹配
    NSString *regularStr = @"^/integralmall(?:\\.html){0,1}(?:\\?id=(\\d+)){0,1}(?:\\?cls_id=(\\d+)){0,1}";
    NSString *urlStr = @"/integralmall?cls_id=72$";
    
    NSError *error2 = nil;
    NSRegularExpression *expression2 = [[NSRegularExpression alloc] initWithPattern:regularStr options:0 error:&error2];
    
    if(!error2 && [expression2 matchesInString:urlStr options:0 range:NSMakeRange(0, urlStr.length)].count > 0) {
        NSLog(@"匹配了路径");
    }else{
        NSLog(@"没有匹配路径");
    }
    
    //正则去除标签
    NSString *newString = [self removeHtmlWithString:@"<a href=https://music.163.com/#/song?id=4900975>城南花已开</a>"];
    NSLog(@"%@",newString);
    
    //参数拆出
    [self testNSRegularExpressionII];
}

///正则去除标签
- (NSString *)removeHtmlWithString:(NSString *)htmlString{
    NSRegularExpression * regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    htmlString = [regularExpretion stringByReplacingMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, htmlString.length) withTemplate:@""];
    return htmlString;
}

- (void)testNSRegularExpressionII{
    
    //示例1
    NSString *url = @"http://m.dm.iywdf.com/goods-2052.html?user_id=5?car_id=100";
    
    NSString *goodsPattern = @"^(?:https://|http://){0,1}(?:www\\.|m\\.|mkt\\.){0,1}dm.iywdf.com/goods\\-(\\d+)\\.html\\?user_id=(\\d+)\\?car_id=(\\d+)";
    
    NSRegularExpression *goodsExpression = [[NSRegularExpression alloc]initWithPattern:goodsPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    if([goodsExpression matchesInString:url options:0 range:NSMakeRange(0, url.length)].count > 0){
        
        NSString*goodsId = [goodsExpression stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, url.length) withTemplate:@"$1"];
        NSString*userId = [goodsExpression stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, url.length) withTemplate:@"$2"];
        NSString*carID = [goodsExpression stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, url.length) withTemplate:@"$3"];
        
        NSLog(@"%@",goodsId);
        NSLog(@"%@",userId);
        NSLog(@"%@",carID);
    }
    
    //示例2
    NSString *bonusUrl = @"http://m.test.68mall.com/mjg0u2l/bonus-list-19.html";
       
    NSString *bonusPattern = [NSString stringWithFormat:@"%@(?:%@){0,1}/(\\w)*/bonus-list-(\\d+)%@",@"^(?:https://|http://){0,1}(?:www\\.|m\\.|mkt\\.){0,1}(?:[A-Z_a-z]+\\.){0,1}",[YSUUtils getDomain:@"http://www.test.68mall.com"],@"(?:\\.html){0,1}"];

    
    NSRegularExpression *bonusExpression = [[NSRegularExpression alloc]initWithPattern:bonusPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    if([bonusExpression matchesInString:bonusUrl options:0 range:NSMakeRange(0, bonusUrl.length)].count > 0){
        NSString*bonusId = [bonusExpression stringByReplacingMatchesInString:bonusUrl options:0 range:NSMakeRange(0, bonusUrl.length) withTemplate:@"$2"];
         NSLog(@"%@",bonusId);
    }
    
    //示例3
    NSString *str = @"http://m.kh.test.68mall.com/user/order/info?id=237";
    
    NSString *orderInfoPattern = @"^(?:https://|http://){0,1}(?:www\\.|m\\.|mkt\\.){0,1}kh.test.68mall.com/user/order/info\\?id=(\\d+)$";
    NSRegularExpression *orderInfoExpression = [[NSRegularExpression alloc]initWithPattern:orderInfoPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    if([orderInfoExpression matchesInString:str options:0 range:NSMakeRange(0, str.length)].count > 0){
        NSLog(@"匹配成功");
    }
    
    //示例4
        NSString *code = @"http://m.kh.test.68mall.com/checkout/qrcode-buy.html?data=289_qrcode_buy_data";
    
    NSString *bakeStr = [NSString stringWithFormat:@"%@%@%@\\?data=(\\d+)_qrcode_buy_data",[NSString stringWithFormat:@"%@(?:%@){0,1}/",@"^(?:https://|http://){0,1}(?:[A-Z_a-z]+\\.){0,1}",@"http://m.kh.test.68mall.com"],@"checkout/qrcode-buy",@"(?:\\.html){0,1}"];
    
    NSError *error = nil;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:bakeStr options:0 error:&error];
        
    if(!error && [expression matchesInString:code options:0 range:NSMakeRange(0, code.length)].count > 0) {
        //八客定制，PC端处方药订单通过扫码进入app确认订单页
        NSLog(@"八客定制");
    }
    
    if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@",bakeStr] evaluateWithObject:code]){
        //八客定制，PC端处方药订单通过扫码进入app确认订单页
        NSLog(@"八客定制");
    }
}
///--------------------------------- NSRegularExpression 结束 --------------------------------------------

@end
