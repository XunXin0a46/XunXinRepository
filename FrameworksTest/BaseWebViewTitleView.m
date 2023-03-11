//
//  YSCBaseWebViewTitleView.m
//  YiShopCustomer
//
//  Created by 骆超然 on 2017/5/24.
//  Copyright © 2017年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "BaseWebViewTitleView.h"
#import "Masonry.h"

@interface BaseWebViewTitleView ()

@property (nonatomic, strong) UIView *titleDividerView;

@end

@implementation BaseWebViewTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.adjustsFontSizeToFitWidth = NO;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.left.equalTo(self).offset(15.0);
        }];
    }
    return self;
}

@end
