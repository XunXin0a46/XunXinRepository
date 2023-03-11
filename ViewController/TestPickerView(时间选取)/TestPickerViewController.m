//
//  TestPickerViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/6/10.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "TestPickerViewController.h"
#import "WSDatePickerView.h"

@interface TestPickerViewController ()

@end

@implementation TestPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"时间选取"];
    //创建视图
    [self createUI];
}

- (void)createUI{
    //测试按钮
    UIButton *testCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testCodeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 75 / 2, CGRectGetMinY(self.view.frame) + HEAD_BAR_HEIGHT, 75, 30);
    testCodeButton.backgroundColor = [UIColor blueColor];
    testCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [testCodeButton setTitle:@"召唤术" forState:UIControlStateNormal];
    [testCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testCodeButton addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testCodeButton];
}

///显示时间选取器
- (void)showPickerView{
    //初始化时间选取器
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
        //选择时间回调
        NSString *date = [startDate stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"%@",date);
    }];
    //确定按钮的颜色
    datepicker.doneButtonColor = [UIColor redColor];
    //显示时间选取器
    [datepicker show];
}

@end
