//
//  BigPictureStyleTableViewItemCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/20.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "BigPictureStyleTableViewItemCell.h"
#import "UIImage+YSCTintColor.h"
#import "DateCountdown.h"

NSString *const BigPictureStyleTableViewItemCellReuseIdentifier = @"BigPictureStyleTableViewItemCellReuseIdentifier";

@interface BigPictureStyleTableViewItemCell()

@property (nonatomic, strong) UIView *lineViewBot;//顶部分割线
@property (nonatomic, strong) YYAnimatedImageView *goodsImageView;//商品图片视图
@property (nonatomic, strong) UILabel *goodsNameLabel;//商品名称标签
@property (nonatomic, strong) UILabel *priceLabel;//价格标签
@property (nonatomic, strong) UILabel *originalPriceLabel;//原价标签（划线价）
@property (nonatomic, strong) UIImageView *discountNumImageView;//折扣数量图片视图
@property (nonatomic, strong) UILabel *discountNumLabel;//折扣数量标签
@property (nonatomic, strong) UILabel *limitNumLabel;//限购数量标签
@property (nonatomic, strong) UIButton *purchaseButton;//立即抢购按钮
@property (nonatomic, strong) UILabel *countdownLabel;//活动将要结束倒计时标签
@property (nonatomic, strong) CALayer *separatorLineLayer;//底部分割线条
@property (nonatomic, strong) DateCountdown *countdown;//倒计时定时器

@end

@implementation BigPictureStyleTableViewItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    ///顶部分割线
    self.lineViewBot = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineViewBot.backgroundColor = HEXCOLOR(0xE5E5E5);
    [self.contentView addSubview:self.lineViewBot];
    
    ///商品图片视图
    self.goodsImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.goodsImageView];
    
    ///活动将要结束倒计时标签
    self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.countdownLabel];
    self.countdownLabel.textColor = [UIColor whiteColor];
    self.countdownLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.countdownLabel.font = [UIFont systemFontOfSize:12];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    
    ///商品名称标签
    self.goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.goodsNameLabel];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:15];
    self.goodsNameLabel.textColor = HEXCOLOR(0x353535);
    self.goodsNameLabel.numberOfLines = 1;
    
    ///价格标签
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.priceLabel];
    self.priceLabel.font = [UIFont systemFontOfSize:18];
    self.priceLabel.textColor = HEXCOLOR(0xF56456);
    
    ///原价标签（划线价）
    self.originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.originalPriceLabel];
    self.originalPriceLabel.font = [UIFont systemFontOfSize:13];
    self.originalPriceLabel.textColor = HEXCOLOR(0x999999);
    
    ///折扣数量图片视图
    self.discountNumImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.discountNumImageView.image = [[UIImage imageNamed:@"ic_evaluation_tag"]imageWithTintTheColor:HEXCOLOR(0xF56456)];
    self.discountNumImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.discountNumImageView];
    
    ///折扣数量标签
    self.discountNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.discountNumLabel];
    self.discountNumLabel.font = [UIFont systemFontOfSize:14];
    self.discountNumLabel.textColor = HEXCOLOR(0xF56456);
    
    ///限购数量标签
    self.limitNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.limitNumLabel];
    self.limitNumLabel.font = [UIFont systemFontOfSize:14];
    self.limitNumLabel.textColor = HEXCOLOR(0xF56456);
    
    ///立即抢购按钮
    self.purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.purchaseButton];
    self.purchaseButton.userInteractionEnabled = NO;
    self.purchaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.purchaseButton setTitle:@"立即抢购" forState:UIControlStateNormal];
    self.purchaseButton.backgroundColor = HEXCOLOR(0xF56456);
    [self.purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    ///底部分割线条
    self.separatorLineLayer = [[CALayer alloc] init];
    [self.contentView.layer addSublayer:self.separatorLineLayer];
    self.separatorLineLayer.backgroundColor = HEXCOLOR(0xebedf0).CGColor;
    
    //设置约束
    [self setupConstraints];
}

///设置约束
- (void)setupConstraints {
    
    ///顶部分割线
    [self.lineViewBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.contentView);
    }];
    
    ///商品图片视图
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.64);
    }];
    
    ///活动将要结束倒计时标签
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.goodsImageView);
        make.height.mas_equalTo(30.0);
    }];
    
    ///商品名称标签
    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(10);
        make.left.equalTo(self.goodsImageView.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    ///价格标签
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.goodsImageView.mas_left);
    }];
    
    ///原价标签（划线价）
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel.mas_bottom);
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
    }];
    
    ///折扣数量图片视图
    [self.discountNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.left.equalTo(self.priceLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    ///折扣数量标签
    [self.discountNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountNumImageView.mas_right).offset(10 / 2);
        make.bottom.equalTo(self.discountNumImageView.mas_bottom);
    }];
    
    ///限购数量标签
    [self.limitNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountNumLabel.mas_right).offset(10);
        make.bottom.equalTo(self.discountNumImageView.mas_bottom);
    }];
    
    ///立即抢购按钮
    NSString *title = [self.purchaseButton titleForState:UIControlStateNormal];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.purchaseButton.titleLabel.font}];
    titleSize.width += (10 * 2.6);
    titleSize.height += 10;
    self.purchaseButton.layer.cornerRadius = titleSize.height * 0.5;
    self.purchaseButton.layer.masksToBounds = YES;
    [self.purchaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.discountNumImageView.mas_bottom);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(titleSize);
    }];
}

- (void)setGoodsImageLink:(NSString *)goodsImageLink{
    //商品图片视图
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:goodsImageLink] placeholder:[UIImage imageNamed:@"bg_public"]];
    //商品名称标签
    self.goodsNameLabel.text =  @"一级分类商品";
    //价格标签
    self.priceLabel.text = @"￥22.5";
    //原价标签（划线价）
    NSAttributedString *originalPriceString = [[NSAttributedString alloc] initWithString:@"￥45" attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName: @0}];
    self.originalPriceLabel.attributedText = originalPriceString;
    //设置折扣数量
    self.discountNumLabel.text = [NSString stringWithFormat:@"%@折",@"5"];
    //设置限购数量
    self.limitNumLabel.text = [NSString stringWithFormat:@"限%@件",@"5"];
    //立即抢购按钮
    [self.purchaseButton setTitle:@"立即抢购" forState:UIControlStateNormal];
    //设置执行倒计时时间(每秒执行)
    __block NSInteger countdownTime = 538866;
    self.countdown = [[DateCountdown alloc]init];
    [self.countdown countDownWithPER_SECBlock:^{
        //活动将要结束倒计时标签
        countdownTime -= 1;
        self.countdownLabel.text = [TestUtils getTimeStringWithTimeInterval:countdownTime];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
