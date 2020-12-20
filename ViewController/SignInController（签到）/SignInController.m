//
//  SignInController.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/10/30.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "SignInController.h"
#import "SignInView.h"

@interface SignInController ()

@end

@implementation SignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"签到"];
    [self createUI];
}

///初始化签到视图
- (void)createUI{
    
    ///滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 690 + HEAD_BAR_HEIGHT);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.bounces = NO;
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = NO;
    [self.view addSubview:scrollView];
    
    /**
     签到页面，690为YSCSignInView内部控件总高度，用来设置滚动范围，分别为头部包装视图200，日历视图300，底部包装视图150，底部包装视图与日历视图与视图最底侧间距和40。
     */
    SignInView *signInView = [[SignInView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 690 + HEAD_BAR_HEIGHT)];
    [scrollView addSubview:signInView];
   
    
}

@end
