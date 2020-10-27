//
//  NavigationItemTitleView.m
//  YiShopCustomer
//
//  Created by 王刚 on 2020/5/7.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//  订单汇总自定义navigationItem.titleView

#import "NavigationItemTitleView.h"

@implementation NavigationItemTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //标题标签
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.text = @"控制器名称";
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = HEXCOLOR(0x353535);;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10 * 2.3);
    }];
    
    //控制器列表展示选择按钮
    self.orderTypeSelectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderTypeSelectionButton setImage:[UIImage imageNamed:@"btn_back_circled_black"] forState:UIControlStateNormal];
    self.orderTypeSelectionButton.imageView.transform = CGAffineTransformMakeRotation(- M_PI_2);
    [self addSubview:self.orderTypeSelectionButton];
    [self.orderTypeSelectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10 / 2);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    //标题标签遮罩按钮
    self.labelMakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.labelMakeButton];
    [self.labelMakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.orderTypeSelectionButton.mas_right);
    }];
    
}


@end
