//
//  CustomNavigationBarViewS1.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/20.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "CustomNavigationBarViewS1.h"

@interface CustomNavigationBarViewS1()

@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图片视图
@property (nonatomic, strong) UIImageView *logoImageView;//logo图片视图
@property (nonatomic, strong) UIButton *backButton;//返回按钮
@property (nonatomic, strong) UIButton *signUpButton;//签到按钮

@end

@implementation CustomNavigationBarViewS1

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    self.backgroundColor = [UIColor orangeColor];
    return self;
}

-(instancetype)createUI{
    
    ///背景图片视图
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backgroundImageView.image = [UIImage imageNamed:@"宇宙"];
    [self addSubview:self.backgroundImageView];
    
    ///logo图片视图
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.logoImageView];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.image = [UIImage imageNamed:@"tian_kong_long"];
    
    ///返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.backButton];
    [self.backButton setImage:[UIImage imageNamed:@"btn_close_login"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    ///签到按钮
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.signUpButton];
    self.signUpButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.signUpButton setTitle:@"签到" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置约束
    [self setupConstraints];
    
    return self;
}

///设置约束
- (void)setupConstraints {
    
    //获取状态栏高度
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    ///背景图片视图
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    ///logo图片视图
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300.0, 57.5));
    }];
    
    ///返回按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(statusBarHeight);
        make.left.equalTo(self).offset(15);
    }];
    
    ///签到按钮
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(- 15);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.backButton);
    }];
}

///返回按钮点击事件
- (void)backButtonClick{
    self.backButtonBlock();
}

@end
