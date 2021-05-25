//
//  OneLineTwoStyleCollectionViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/21.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "OneLineTwoStyleCollectionViewCell.h"
#import "UIView+UIViewRoundCorners.h"
#import "NSString+Extention.h"

NSString * const OneLineTwoStyleCollectionViewCellReuseIdentifier = @"OneLineTwoStyleCollectionViewCellReuseIdentifier";

@interface OneLineTwoStyleCollectionViewCell()

@property (nonatomic, strong) UIImageView *goodsImageView;//商品图片视图
@property (nonatomic, strong) UILabel *nameLabel;//名称标签
@property (nonatomic, strong) UILabel *locationlLabel;//定位标签
@property (nonatomic, strong) UILabel *priceLabel;//价格标签
@property (nonatomic, strong) UILabel *actPriceLabel;//活动价格标签
@property (nonatomic, strong) UIButton *bargainingButton;//立即砍价按钮

@end

@implementation OneLineTwoStyleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createUI{
    
    ///商品图片视图
    self.goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.goodsImageView];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGRectGetWidth(self.contentView.frame), CGRectGetWidth(self.contentView.frame));
    }];
    
    ///商品名称标签
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = HEXCOLOR(0x353535);
    self.nameLabel.numberOfLines = 2;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(ceil([TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:15]].height * 2));
    }];
    
    ///定位标签
    self.locationlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.locationlLabel];
    self.locationlLabel.font = [UIFont systemFontOfSize:14];
    self.locationlLabel.textColor = HEXCOLOR(0x999999);
    self.locationlLabel.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    self.locationlLabel.textAlignment = NSTextAlignmentCenter;
    self.locationlLabel.layer.borderWidth = 0.5;
    
    [self.locationlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(0.1,0.1));
    }];
    
    ///价值标签
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.priceLabel];
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    self.priceLabel.textColor = HEXCOLOR(0x999999);
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationlLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(CGRectGetWidth(self.frame) - 20);
    }];
    
    ///最低可砍至的活动价格标签
    self.actPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.actPriceLabel];
    self.actPriceLabel.font = [UIFont systemFontOfSize:13];
    self.actPriceLabel.textColor = HEXCOLOR(0x999999);
    
    [self.actPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.mas_equalTo(CGRectGetWidth(self.frame) - 20);
    }];
    
    ///立即砍价按钮
    self.bargainingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.bargainingButton];
    self.bargainingButton.layer.cornerRadius = 12.5;
    self.bargainingButton.layer.masksToBounds = YES;

    [self.bargainingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actPriceLabel);
        make.right.equalTo(self.contentView.mas_right).offset(- 5);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)setModel:(OneLineTwoStyleModel *)model{
    //设置样式，直角或圆角
    if([model.radiusStyle isEqualToString:@"1"]){
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
    }else{
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = YES;
    }
    //设置样式，无边白底或卡片投影
    if([model.shadowStyle isEqualToString:@"1"]){
        //添加四边阴影效果
        self.contentView.layer.masksToBounds = NO;
        [self.contentView addShadowWithColor:[UIColor blackColor]];
    }else{
        //移除四边阴影效果
        [self.contentView removeShadow];
    }
    //设置商品图片视图
    [self.goodsImageView setImage:model.image];
    //设置名称标签
    self.nameLabel.text = model.name;
    //设置定位标签
    self.locationlLabel.text = model.locationl;
    //计算定位标签大小
    CGRect rect = [model.locationl boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:14]].height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    //更新定位标签约束
    [self.locationlLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(ceil(rect.size.width + 5), [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:14]].height + 5));
    }];
    //设置砍价按钮图标
    [self.bargainingButton setImage:[UIImage imageNamed:@"a_btn_bargaining"] forState:UIControlStateNormal];
    //设置商品价格标签
    self.priceLabel.attributedText = [NSString stringWithFormat:@"价值%@",model.price].attributeSingleLine;
    //设置最低可砍至的活动价格标签
    NSString *actPriceStr = [NSString stringWithFormat:@"最低可砍至%@",model.activityaPrice];
    NSMutableAttributedString *actPriceMutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:actPriceStr];
    [actPriceMutableAttributedStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF56456) range:NSMakeRange([actPriceStr rangeOfString:model.activityaPrice].location, model.activityaPrice.length)];
    self.actPriceLabel.attributedText = actPriceMutableAttributedStr;
}

@end
