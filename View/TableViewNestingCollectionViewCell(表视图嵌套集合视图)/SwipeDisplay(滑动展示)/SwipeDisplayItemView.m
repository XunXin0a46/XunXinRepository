//
//  SwipeDisplayItemView.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/4/24.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "SwipeDisplayItemView.h"

static CGFloat const EdgeViewHeight = 55;
static CGFloat const headImageHeight = 50;

@interface SwipeDisplayItemView()

@property (nonatomic, strong)UIImageView *headImage;//头像图片视图
@property (nonatomic, strong)UILabel *userNameLabel;//用户名称标签
@property (nonatomic, strong)UILabel *describeLabel;//描述标签
@property (nonatomic, strong)UILabel *takeActivityButton;//去凑团按钮

@end

@implementation SwipeDisplayItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self ctrateUI];
    }
    return self;
}

- (void)ctrateUI{
    
    ///头像图片视图
    self.headImage = [[UIImageView alloc]init];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = headImageHeight / 2;
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(headImageHeight, headImageHeight));
    }];
    
    ///用户名称标签
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.textColor = [UIColor blackColor];
    self.userNameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.userNameLabel];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).offset(10 / 2);
        make.top.equalTo(self.headImage.mas_top);
        make.height.mas_equalTo(headImageHeight / 2);
        make.width.mas_equalTo(SCREEN_WIDTH - 200);
    }];
    
    ///成团所差人数标签
    self.describeLabel = [[UILabel alloc]init];
    self.describeLabel.textColor = [UIColor blackColor];
    self.describeLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.describeLabel];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).offset(10 / 2);
        make.bottom.equalTo(self.headImage.mas_bottom);
        make.height.mas_equalTo(headImageHeight / 2);
    }];

    ///倒计时标签
    self.countdownTime = [[UILabel alloc]init];
    self.countdownTime.textColor = [UIColor blackColor];
    self.countdownTime.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.countdownTime];
    
    [self.countdownTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.describeLabel.mas_right).offset(10 / 2);
        make.centerY.equalTo(self.describeLabel.mas_centerY);
        
    }];
    
    ///去凑团按钮
    self.takeActivityButton = [[UILabel alloc]init];
    self.takeActivityButton.text = @"去凑团";
    self.takeActivityButton.layer.masksToBounds = YES;
    self.takeActivityButton.layer.cornerRadius = SCREEN_WIDTH / 5 / 2.5 / 2;
    self.takeActivityButton.textAlignment = NSTextAlignmentCenter;
    self.takeActivityButton.textColor = [UIColor whiteColor];
    self.takeActivityButton.font = [UIFont systemFontOfSize:10];
    self.takeActivityButton.backgroundColor = HEXCOLOR(0xF56456);
    [self addSubview:self.takeActivityButton];
    
    [self.takeActivityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(- 10);
        make.centerY.equalTo(self.headImage.mas_centerY);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH / 5 / 2.5));
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor blackColor];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(0.5 + 0.3);
    }];
}

- (void)setModel:(SwipeDisplayItemModel *)model{
    //用户头像
    [self.headImage setImage:model.headerImage];
    //用户名
    self.userNameLabel.text = model.name;
    //成团所差人数
    self.describeLabel.text = @"畏惧虚空吧";
}

+ (CGFloat)calculateViewHeight{
    return EdgeViewHeight + 10 * 2;
}

@end
