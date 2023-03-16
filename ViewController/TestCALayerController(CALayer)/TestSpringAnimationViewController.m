//
//  TestSpringAnimationViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2023/3/11.
//  Copyright © 2023 王刚. All rights reserved.
//

#import "TestSpringAnimationViewController.h"

@interface TestSpringAnimationViewController ()<CAAnimationDelegate> 

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) NSLayoutConstraint *myViewYConstraint;

@end

@implementation TestSpringAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
    // 设置视图
    self.myView = [[UIView alloc]initWithFrame:CGRectZero];
    self.myView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myView];
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClickEvent)];
    [self.myView addGestureRecognizer:singleClick];
    self.myView.translatesAutoresizingMaskIntoConstraints = NO;
    self.myViewYConstraint = [self.myView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor];
    [NSLayoutConstraint activateConstraints:@[
        [self.myView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        self.myViewYConstraint,
        [self.myView.widthAnchor constraintEqualToConstant:100],
        [self.myView.heightAnchor constraintEqualToConstant:100],
    ]];
    
}

/// 按钮点击事件
- (void)buttonClick:(UIButton *)button {
    // 设置动画为旋转
    CASpringAnimation * animation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    animation.delegate = self;
    // 动画持续时间
    animation.duration = 2.0f;
    // 结束时的位置
    animation.toValue = @(CGRectGetMidY(self.view.frame));
    // 附着在弹簧上的物体质量
    animation.mass = 3;
    // 弹簧刚度
    animation.stiffness = 300;
    // 弹簧弹力的阻尼
    animation.damping = 9;
    // 使视图停留在动画结束的位置
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.myView.layer addAnimation:animation forKey:nil];
}

/// 视图点击事件
- (void)singleClickEvent {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"点击了" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - CAAnimationDelegate

/// 动画结束
/// @param anim 结束的动画对象
/// @param flag 指示动画是否因为达到其活动持续时间后而结束的标志
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        self.myViewYConstraint.active = NO;
        self.myViewYConstraint = [self.myView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
        self.myViewYConstraint.active = YES;
    }
}

@end
