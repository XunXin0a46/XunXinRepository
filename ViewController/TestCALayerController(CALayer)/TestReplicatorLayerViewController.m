//
//  TestReplicatorLayerViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/23.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestReplicatorLayerViewController.h"
#import "YUReplicatorAnimation.h"

@interface TestReplicatorLayerViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TestReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"复制层动画";
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
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
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_BAR_HEIGHT + 450 , 2, 12)];
    [self.scrollView addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerShake]];
}

//转圈动画
- (void)replicatorLayerRound{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, HEAD_BAR_HEIGHT + 90 , 2, 12)];
    [self.view addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerRound]];
}

//心动画
- (void)replicatorLayerHeart{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5, HEAD_BAR_HEIGHT + 380 , 2, 12)];
    [self.view addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerHeart]];
}

@end
