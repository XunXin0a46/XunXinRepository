//
//  TestViewTransitionController.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/20.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "TestViewTransitionController.h"
#import "CustomNavigationBarViewS1.h"

@interface TestViewTransitionController ()

@end

@implementation TestViewTransitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    [self createUI];
}

- (void)createUI{
    CustomNavigationBarViewS1 *customNavigationBarViewS1 = [[CustomNavigationBarViewS1 alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    [self.view addSubview:customNavigationBarViewS1];
    customNavigationBarViewS1.backButtonBlock = ^{
        [self cancel];
    };
}

@end
