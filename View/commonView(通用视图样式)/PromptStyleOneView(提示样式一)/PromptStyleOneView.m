//
//  PromptStyleOneView.m
//  YiShopCustomer
//
//  Created by 王刚 on 2020/12/18.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "PromptStyleOneView.h"

@interface PromptStyleOneView()

@property (nonatomic, strong) UIView *contentView;//内容视图
@property (nonatomic, strong) UILabel *titleLabel;//消息标签
@property (nonatomic, strong) UILabel *messageLabel;//消息标签
@property (nonatomic, strong) YYAnimatedImageView *imageView;//图片视图
@property (nonatomic, strong) UIButton *operationButton;//操作按钮

@end

@implementation PromptStyleOneView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    ///内容视图
    self.contentView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    ///图片视图
    self.imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.frame) * 2 / 3, CGRectGetWidth(self.frame) * 2 / 3));
    }];
    
    ///标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = HEXCOLOR(0x666666);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"";
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10 * 2.0);
        make.left.equalTo(self.contentView).offset(10 * 2.0).priorityHigh();
        make.right.equalTo(self.contentView).offset(-10 * 2.0);
    }];
    
    
    ///消息标签
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.messageLabel];
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.textColor = HEXCOLOR(0x666666);
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = @"";
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10 * 2.0);
        make.left.equalTo(self.contentView).offset(10 * 2.0).priorityHigh();
        make.right.equalTo(self.contentView).offset(-10 * 2.0);
    }];
    
    ///操作按钮
    self.operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.operationButton.backgroundColor = HEXCOLOR(0xF56456);
    self.operationButton.layer.cornerRadius = 35/2;
    self.operationButton.layer.masksToBounds = YES;
    [self.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.operationButton];
    [self.operationButton addTarget:self action:@selector(operationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(10 * 2.0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120.0, 35.0));
    }];
}

///操作按钮点击事件
- (void)operationButtonClick{
    self.operationButtonClickBlock();
}

///根据链接设置图片
- (void)setImageURL:(NSURL *)imageURL{
    [self.imageView yy_setImageWithURL:imageURL placeholder:[UIImage imageNamed:@"bg_system_error"]];
}

///直接设置图片
- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}

///设置按钮标题
- (void)setOperationButtonTitle:(NSString *)operationButtonTitle{
    [self.operationButton setTitle:operationButtonTitle forState:UIControlStateNormal];
}

///设置显示标题与消息
- (void)setTitle:(NSString *)title WithTitleFont:(UIFont *)titleFont WithMessage:(NSString *)message
 WithMessageFont:(UIFont *)messageFont{
    //设置标题文本
    self.titleLabel.text = title;
    //设置标题字体
    self.titleLabel.font = titleFont;
    //设置消息文本
    self.messageLabel.text = message;
    //设置消息字体
    self.messageLabel.font = messageFont;
    //计算标题高度
    CGFloat titleHeight = [self calculationTextHeight:title WithTextFont:titleFont];
    //计算消息高度
    CGFloat messageHeight = [self calculationTextHeight:message WithTextFont:messageFont];
    //计算内容视图高度(100为间距和)
    CGFloat contentViewHeight = titleHeight + messageHeight + CGRectGetWidth(self.frame) * 2 / 3 + 35.0 + 100;
    //判断内容高度是否超越了self高度
    if(contentViewHeight > (CGRectGetHeight(self.frame))){
        //超越时
        //重置内容视图约束
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(STATUSBARHEIGHT);
            make.left.bottom.right.equalTo(self);
        }];
        //重置标题标签约束
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10 * 2.0);
            make.left.equalTo(self.contentView).offset(10 * 2.0).priorityHigh();
            make.right.equalTo(self.contentView).offset(-10 * 2.0);
            make.height.mas_equalTo(CGRectGetHeight(self.frame) - (CGRectGetWidth(self.frame) * 2 / 3 + 35.0 + 100 + STATUSBARHEIGHT + messageHeight));
        }];
        //重置消息标签约束
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10 * 2.0);
            make.left.equalTo(self.contentView).offset(10 * 2.0).priorityHigh();
            make.right.equalTo(self.contentView).offset(-10 * 2.0);
            make.height.mas_equalTo(CGRectGetHeight(self.frame) - (CGRectGetWidth(self.frame) * 2 / 3 + 35.0 + 100 + STATUSBARHEIGHT + titleHeight));
        }];
    }else{
        //未超越时
        //重置内容视图约束
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(CGRectGetWidth(self.frame));
            make.height.mas_equalTo(contentViewHeight);
        }];
        //重置标题标签约束
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10 * 2.0);
            make.left.equalTo(self.contentView).offset(10 * 2.0).priorityHigh();
            make.right.equalTo(self.contentView).offset(-10 * 2.0);
        }];
        //重置消息标签约束
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10 * 2.0);
            make.left.equalTo(self.contentView).offset(10 * 2.0).priorityHigh();
            make.right.equalTo(self.contentView).offset(-10 * 2.0);
        }];
    }
}

///计算文本高度
- (CGFloat)calculationTextHeight:(NSString *)text WithTextFont:(UIFont *)font{
    //计算消息文本矩形
    CGRect rect = [text boundingRectWithSize:CGSizeMake (CGRectGetWidth(self.frame) - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font} context:nil];
    return ceil(rect.size.height);
}

@end
