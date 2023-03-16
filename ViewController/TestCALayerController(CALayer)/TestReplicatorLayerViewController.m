//
//  TestReplicatorLayerViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/23.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestReplicatorLayerViewController.h"
#import "YUReplicatorAnimation.h"
#import "TestSpringAnimationViewController.h"

@interface TestReplicatorLayerViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TestReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"复制层动画";
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1500);
    [self.view addSubview:self.scrollView];
    //波纹
    [self replicatorLayerCircle];
    //波浪
    [self replicatorLayerWave];
    //三角形
    [self replicatorLayerTriangle];
    //网格
    [self replicatorLayerGrid];
    //震动条
    [self replicatorLayerShake];
    //转圈
    [self replicatorLayerRound];
    //心动画
    [self replicatorLayerHeart];
    //设置导航栏右侧按钮
    [self setrightBarButton];
}

///设置导航栏右侧按钮
- (void)setrightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"弹簧动画" style:UIBarButtonItemStylePlain target:self action:@selector(testSpringAnimation)];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

/// 前往弹簧动画
- (void)testSpringAnimation {
    TestSpringAnimationViewController *springAnimationViewController = [[TestSpringAnimationViewController alloc]init];
    [self.navigationController pushViewController:springAnimationViewController animated:YES];
}

//波纹
- (void)replicatorLayerCircle{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT, 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerCircle]];
}

//波浪
- (void)replicatorLayerWave{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 90, 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerWave]];
}

//三角形
- (void)replicatorLayerTriangle{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 230, 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerTriangle]];
}

//网格
- (void)replicatorLayerGrid{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 380, 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerGrid]];
}

//震动条
- (void)replicatorLayerShake{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 520 , 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerShake]];
}

//转圈动画
- (void)replicatorLayerRound{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 600 , 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerRound]];
}

//心动画
- (void)replicatorLayerHeart{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 650 , 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerHeart]];
}

@end
