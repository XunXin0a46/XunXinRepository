//
//  BadgeView.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/1/31.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView () {
    
    UILabel *_label;//文本标签
}

@end

@implementation BadgeView

///初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self commonInit];
    }
    return self;
}

///初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonInit];
    }
    return self;
}

///初始化
- (void)commonInit {
    //超出边界裁剪
    self.clipsToBounds = YES;
    //设置背景颜色
    self.bgColor = HEXCOLOR(0xF56456);
    //不与用户交互
    self.userInteractionEnabled = NO;
    
    //初始化文本标签
    _label = [[UILabel alloc] init];
    //设置文本标签文本颜色
    _label.textColor = [UIColor whiteColor];
    //设置文本标签文本字体
    _label.font = [UIFont systemFontOfSize:8];
    //设置文本标签文本内容
    _label.text = self.badgeValue;
    //添加文本标签到视图
    [self addSubview:_label];
}

///设置背景颜色
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    
    self.backgroundColor = bgColor;
    [self setNeedsLayout];
}

///设置文本标签文本颜色
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    _label.textColor = textColor;
    [self setNeedsLayout];
}

///设置文本标签显示文本
- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    _label.text = badgeValue;
    [self setNeedsLayout];
}

///设置为文本标签文本字体
- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;

    _label.font = textFont;
    [self setNeedsLayout];
}

///调整视图的大小，使其只包含它的子视图
- (void)sizeToFit {
    [super sizeToFit];
    
    CGRect frame = self.frame;
    frame.size = [self size];
    self.frame = frame;
}

///计算视图大小
- (CGSize)size {
    [_label sizeToFit];
    //计算文本标签内容大小
    CGSize size = [@"#" sizeWithAttributes:@{NSFontAttributeName: _label.font}];
    CGFloat width = _label.bounds.size.width + size.width * 1.5 - 1;
    CGFloat height = _label.bounds.size.height + 1;
    //根据文本标签显示的数字进行宽高调整
    if(![_label.text isEqualToString:@"99+"]){
        if([_label.text integerValue] < 10){
            if (width < height) {
                width = height;
            }
        }else {
            width = _label.bounds.size.width + size.width;
            height = width;
        }
    }else{
        width = _label.bounds.size.width;
        height = width;
    }
    
    return CGSizeMake(width, height);
}

///视图的期望大小
- (CGSize)intrinsicContentSize {
    
    return [self size];
}

///布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    //调整文本标签的大小，使其只包含它的子视图
    [_label sizeToFit];
    //调整视图的大小，使其只包含它的子视图
    [self sizeToFit];
    //设置文本标签位置
    _label.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    //设置视图圆角
    self.layer.cornerRadius = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width / 2 : self.bounds.size.height / 2;
}

@end
