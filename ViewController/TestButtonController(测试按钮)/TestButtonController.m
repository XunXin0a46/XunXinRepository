//
//  TestButtonController.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/9/12.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "TestButtonController.h"
#import "ButtonLinkageView.h"
#import "SearchImitateController.h"

@interface TestButtonController ()

@property (nonatomic, strong) NSTimer *timer;//定时器

@end

@implementation TestButtonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"测试按钮"];
    [self createUI];
}

- (void)createUI{
    
    ///控制连续点击的按钮
    UIButton *continuousClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:continuousClickButton];
    continuousClickButton.layer.cornerRadius = 22.0;
    continuousClickButton.layer.masksToBounds = YES;
    continuousClickButton.titleLabel.font = [UIFont systemFontOfSize:16];
    continuousClickButton.backgroundColor = HEXCOLOR(0xE5E5E5);
    [continuousClickButton setTitle:@"连续点击按钮" forState:UIControlStateNormal];
    [continuousClickButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [continuousClickButton addTarget:self action:@selector(continuousClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [continuousClickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(HEAD_BAR_HEIGHT);
        make.left.equalTo(self.view).offset(10 * 2.0);
        make.right.equalTo(self.view).offset(-10 * 2.0);
        make.height.mas_equalTo(44);
    }];
    
    ///按钮联动
    ButtonLinkageView *buttonLinkageView = [[ButtonLinkageView alloc]initWithFrame:CGRectZero];
    buttonLinkageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonLinkageView];
    [buttonLinkageView.agreeAfterButton addTarget:self action:@selector(openSearchImitateController) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonLinkageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
}

///控制连续点击按钮的事件
- (void)continuousClick:(UIButton *)btn {
    [self.timer invalidate];
    self.timer = nil;
    self.timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(requestData) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

///连续点击结束后触发
- (void)requestData{
    NSLog(@"我请求数据啦");
}

///搜索模拟控制器
- (void)openSearchImitateController{
    SearchImitateController *controller = [[SearchImitateController alloc]init];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

@end
