//
//  YSCHalfPriceGoodsListBottomTipsView.m
//  YiShopCustomer
//
//  Created by 王刚 on 2021/5/12.
//  Copyright © 2021 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSCHalfPriceGoodsListBottomTipsView.h"
#import "UIView+ExtraTag.h"
#import "UIView+Action.h"

@implementation YSCHalfPriceGoodsListBottomTipsViewModel

@end

@interface YSCHalfPriceGoodsListBottomTipsView()

@property (nonatomic, strong) UILabel *totalLabel;//合计标签
@property (nonatomic, strong) UILabel *totalPriceLabel;//合计金额标签
@property (nonatomic, strong) UIButton *tipsButton;//提示按钮
@property (nonatomic, strong) UILabel *describeLabel;//提示文案描述标签
@property (nonatomic, strong) UIButton *goCartButton;//去购物车按钮

@end

@implementation YSCHalfPriceGoodsListBottomTipsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //设置视图背景色
        self.backgroundColor = [UIColor whiteColor];
        //创建视图
        [self createUI];
    }
    return self;
}

///创建视图
- (void)createUI{
    ///顶部分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = HEXCOLOR(0xE5E5E5);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    ///合计标签
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.totalLabel.textColor = HEXCOLOR(0x353535);
    self.totalLabel.font = [UIFont systemFontOfSize:15];
    self.totalLabel.text = @"合计:";
    [self addSubview:self.totalLabel];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    
    ///合计金额标签
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.totalPriceLabel.textColor = HEXCOLOR(0xF56456);
    self.totalPriceLabel.font = [UIFont systemFontOfSize:15];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",120.678];
    [self addSubview:self.totalPriceLabel];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalLabel);
        make.left.equalTo(self.totalLabel.mas_right).offset(10 / 2);
    }];
    
    ///提示按钮
    self.tipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tipsButton setImage:[UIImage imageNamed:@"ic_alert_rule"]
                       forState:UIControlStateNormal];
    self.tipsButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.tipsButton setViewTypeForTag:ViewTypeNone];
    [self addEvent:self.tipsButton];
    [self addSubview:self.tipsButton];
    
    [self.tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalPriceLabel);
        make.left.equalTo(self.totalPriceLabel.mas_right).offset(10 / 2);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    ///提示文案描述标签
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.describeLabel.textColor = HEXCOLOR(0x999999);
    self.describeLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.describeLabel];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    
    ///去购物车按钮
    self.goCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goCartButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.goCartButton setTitle:@"去购物车" forState:UIControlStateNormal];
    self.goCartButton.backgroundColor = HEXCOLOR(0xF56456);
    [self.goCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goCartButton.layer.cornerRadius = 15.0;
    self.goCartButton.layer.masksToBounds = YES;
    [self.goCartButton setViewTypeForTag:ViewTypeNone];
    [self addEvent:self.goCartButton];
    [self addSubview:self.goCartButton];
    
    [self.goCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset((65 - 30) / 2);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}

///设置模型
- (void)setHalfPriceModel:(YSCHalfPriceGoodsListBottomTipsViewModel *)halfPriceModel{
    //设置合计金额标签
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",halfPriceModel.total_goods_amount];
    //设置总金额下方的提示文案描述标签
    if(halfPriceModel.total_goods_num >= halfPriceModel.package_num.integerValue){
        //符合优惠条件
        self.describeLabel.text = [NSString stringWithFormat:@"已满足门槛，第%@件享受%@折优惠",halfPriceModel.package_num,halfPriceModel.discount_num];
        
    }else if(halfPriceModel.total_goods_num > 0 && halfPriceModel.total_goods_num < halfPriceModel.package_num.integerValue){
        //不符合优惠条件
        self.describeLabel.text = [NSString stringWithFormat:@"再买%ld件，第%@件享受%@折优惠",halfPriceModel.package_num.integerValue - halfPriceModel.total_goods_num,halfPriceModel.package_num,halfPriceModel.discount_num];
        
    }else{
        //购物车中没有第二件半价商品
        self.describeLabel.text = @"赶快选购商品参与促销活动吧！";
    }
}

@end
