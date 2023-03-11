//
//  ButtonLinkageView.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/17.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "ButtonLinkageView.h"
#import "UIImage+YSCTintColor.h"

@interface ButtonLinkageView()

@end

@implementation ButtonLinkageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    ///同意后按钮
    self.agreeAfterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.agreeAfterButton];
    self.agreeAfterButton.enabled = NO;
    self.agreeAfterButton.layer.cornerRadius = 22.0;
    self.agreeAfterButton.layer.masksToBounds = YES;
    self.agreeAfterButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.agreeAfterButton.backgroundColor = HEXCOLOR(0xE5E5E5);
    [self.agreeAfterButton setTitle:@"我需要同意才能点击" forState:UIControlStateNormal];
    [self.agreeAfterButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    
    [self.agreeAfterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(- 10);
        make.left.equalTo(self).offset(10 * 2.0);
        make.right.equalTo(self).offset(-10 * 2.0);
        make.height.mas_equalTo(44);
    }];
    
    ///同意说明按钮
    self.agreeExplainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.agreeExplainButton];
    self.agreeExplainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.agreeExplainButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.agreeExplainButton setTitle:@"同意下面那个家伙可以点击" forState:UIControlStateNormal];
    
    [self.agreeExplainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.agreeAfterButton.mas_top).offset(- 10);
        make.centerX.equalTo(self);
    }];
    
    ///同意图标按钮
    self.agreeImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.agreeImageButton];
    self.agreeImageButton.selected = NO;
    [self.agreeImageButton setImage:[UIImage imageNamed:@"bg_check_normal"] forState:UIControlStateNormal];
    [self.agreeImageButton setImage:[[UIImage imageNamed:@"bg_check_selected"]imageWithTintTheColor:HEXCOLOR(0xF56456)]  forState:UIControlStateSelected];
    [self.agreeImageButton addTarget:self action:@selector(agreeButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];

    [self.agreeImageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreeExplainButton);
        make.right.equalTo(self.agreeExplainButton.mas_left).offset(- 10);
        make.size.mas_equalTo(CGSizeMake(20.0, 20.0));
    }];
}

- (void)agreeButtonOnclick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    [self changeNextStepButtonStatusIfNeeded];
}

- (void)changeNextStepButtonStatusIfNeeded {
    
    if (self.agreeImageButton.isSelected) {
        self.agreeAfterButton.enabled = YES;
        self.agreeAfterButton.backgroundColor = HEXCOLOR(0xF56456);
        [self.agreeAfterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    } else {
        self.agreeAfterButton.enabled = NO;
        self.agreeAfterButton.backgroundColor = HEXCOLOR(0xE5E5E5);
        [self.agreeAfterButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    }
}


@end
