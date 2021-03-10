//
//  ShoppingCartIconView.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/25.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "ShoppingCartIconView.h"

CGSize const ShoppingCartIconViewSize = {45.0, 45.0};

static CGFloat const LABEL_WIDTH = 22.0;

@interface ShoppingCartIconView()

@property (nonatomic, strong) UIButton *cartButton;//购物车按钮
@property (nonatomic, strong) UILabel *label;//购物车角标标签

@end

@implementation ShoppingCartIconView

///初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //购物车按钮
        self.cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cartButton.userInteractionEnabled = NO;
        [self.cartButton setImage:[UIImage imageNamed:@"btn_cart_category"] forState:UIControlStateNormal];
        //购物车角标标签
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor redColor];
        self.label.layer.masksToBounds = YES;
        self.label.layer.cornerRadius = LABEL_WIDTH / 2.0;
        self.label.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:11.0];
        self.label.text = @"0";
        
        [self addSubview:self.cartButton];
        [self addSubview:self.label];
        
        [self.cartButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo (self);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(self.cartButton).offset(LABEL_WIDTH / 2);
            make.centerY.equalTo(self.cartButton).offset(-LABEL_WIDTH / 2);
            make.height.mas_equalTo(LABEL_WIDTH);
            make.width.mas_equalTo(LABEL_WIDTH);
        }];
    }
    return self;
}

///设置购物车角标
- (void)setCartNumber:(NSString *)cartNumber {
    
    if (cartNumber.integerValue > 99) {
        cartNumber = @"99+";
    }
    self.label.text = cartNumber;
    if (CGRectGetWidth(self.label.frame) <= LABEL_WIDTH) {
        CGRect rect = self.label.frame;
        rect.size.width = LABEL_WIDTH;
        self.label.frame = rect;
    }
}

///返回购物车当前角标显示数值
- (NSInteger)cartCount {
    NSInteger result = 0;
    if (self.label.text.integerValue < 0) {
        result = 0;
    } else {
        result = self.label.text.integerValue;
    }
    return result;
}

@end
