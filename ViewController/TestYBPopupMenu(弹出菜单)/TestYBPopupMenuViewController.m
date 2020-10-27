//
//  TestYBPopupMenuViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/7/23.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestYBPopupMenuViewController.h"
#import "YBPopupMenu.h"

@interface TestYBPopupMenuViewController ()<YBPopupMenuDelegate>

@end

@implementation TestYBPopupMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"弹出菜单"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)createUI{
    UIButton *testCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testCodeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 75 / 2, CGRectGetMaxY(self.view.frame) / 2 - 30 / 2, 75, 30);
    testCodeButton.backgroundColor = [UIColor blueColor];
    testCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [testCodeButton setTitle:@"弹出菜单" forState:UIControlStateNormal];
    [testCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testCodeButton addTarget:self action:@selector(popMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testCodeButton];
}

- (void)popMenu:(UIButton *)sender{
    YBPopupMenu *menuView = [[YBPopupMenu alloc]initWithTitles:@[@"首页", @"消息", @"购物车",@"我的"] icons:@[@"ic_menu_home", @"ic_menu_message",@"ic_menu_cart",@"ic_menu_user"] menuWidth:140.0 menuHeight:34.0 delegate:self];
    menuView.arrowDirection = YBArrowDirectionBottom;
    menuView.arrowLocation = YBArrowLocationCentre;
    menuView.bgViewBackgroundColor = [UIColor clearColor];
    menuView.frameShadowOpacity = 0.2;
    [menuView showRelyOnView:sender];
}

@end
