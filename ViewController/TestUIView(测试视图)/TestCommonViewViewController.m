//
//  TestCommonViewViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/12/2.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCommonViewViewController.h"
#import "BarProgressView.h"
#import "PromptStyleOneView.h"

@interface TestCommonViewViewController()

@property (nonatomic, assign)CGFloat contentHeight;//记录内容高度
@property (nonatomic, strong)UIScrollView *scrollView;//包装视图的滚动视图

@end

@implementation TestCommonViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视图通用样式记录";
    self.view.backgroundColor = HEXCOLOR(0xEEF2F3);
    [self createUI];
    //更新滚动视图的内容高度
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.contentHeight);
    //隐藏底部标签栏
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    //显示底部标签栏
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.translucent = NO;
}

- (void)createUI{
    ///包装视图的滚动视图
    self.scrollView = self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 690 + HEAD_BAR_HEIGHT);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.scrollView];
    ///通用提示视图1
    [self createPromptStyleOneView];
    ///通用进度视图
    [self createCommonProgressView];
}

///通用提示视图1
- (void)createPromptStyleOneView{
    self.contentHeight += SCREEN_HEIGHT;
    PromptStyleOneView *promptStyleOne = [[PromptStyleOneView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    promptStyleOne.image = [UIImage imageNamed:@"bg_system_error"];
    promptStyleOne.operationButtonTitle = @"按钮";
    [promptStyleOne setTitle:@"标题" WithTitleFont:[UIFont systemFontOfSize:15] WithMessage:@"副标题" WithMessageFont:[UIFont systemFontOfSize:13]];
    [self.scrollView addSubview:promptStyleOne];
}

///通用进度视图
- (void)createCommonProgressView{
    //记录视图高度
    self.contentHeight += 120;
    ///内容视图
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(SCREEN_HEIGHT);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(120);
    }];
    ///图片视图
    YYAnimatedImageView *goodsImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
    //设置图片
    [goodsImageView yy_setImageWithURL:[NSURL URLWithString:@"https://68test.oss-cn-beijing.aliyuncs.com/images/746/taobao-yun-images/2019/06/05/556564393740/TB1dtxZduuSBuNjy1XcXXcYjFXa_!!0-item_pic.jpg?x-oss-process=image/resize,m_pad,limit_0,h_320,w_320"] placeholder:[UIImage imageNamed:@"pl_image"]];
    [contentView addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.centerY.equalTo(contentView);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    ///设置名称标签
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentView addSubview:goodsNameLabel];
    goodsNameLabel.font = [UIFont systemFontOfSize:14.0];
    goodsNameLabel.textColor = HEXCOLOR(0x353535);
    goodsNameLabel.numberOfLines = 2;
    goodsNameLabel.text = @"【AA普通】不参加活动的商品测试";
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImageView).offset(3.0);
        make.left.equalTo(goodsImageView.mas_right).offset(10);
        make.right.equalTo(contentView).offset(-10);
    }];
    ///条形进度
    BarProgressView *progressView = [[BarProgressView alloc]initWithPercent:0];
    progressView.percent = 0.45000000000000005;
    [contentView addSubview:progressView];
    [progressView setCornerRadius:6];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(10);
        make.top.equalTo(goodsNameLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.3f, progressView.layer.cornerRadius * 2));
    }];
    ///马上抢标签
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentView addSubview:buyLabel];
    buyLabel.text = @"马上抢";
    buyLabel.font = [UIFont systemFontOfSize:14.0];
    buyLabel.textAlignment = NSTextAlignmentCenter;
    buyLabel.textColor = [UIColor whiteColor];
    buyLabel.backgroundColor = HEXCOLOR(0xF56456);
    buyLabel.layer.cornerRadius = 14.0f;
    buyLabel.layer.masksToBounds = YES;
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-10);
        make.bottom.equalTo(goodsImageView);
        make.size.mas_equalTo(CGSizeMake(70.0f, 28.0f));
    }];
    ///活动价格标签
    UILabel *actGoodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentView addSubview:actGoodsPriceLabel];
    actGoodsPriceLabel.textColor = HEXCOLOR(0xF56456);
    actGoodsPriceLabel.font = [UIFont systemFontOfSize:19];
    actGoodsPriceLabel.text = @"￥2.00";
    [actGoodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsNameLabel.mas_left);
        make.centerY.equalTo(buyLabel.mas_centerY);
    }];
    ///商品原价标签
    UILabel *goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentView addSubview:goodsPriceLabel];
    //设置标签富文本
    goodsPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"￥9.80"] attributes:
    @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle| NSUnderlinePatternSolid),
      NSStrikethroughColorAttributeName: HEXCOLOR(0x999999),
      NSFontAttributeName: [UIFont systemFontOfSize:14.0],
      NSForegroundColorAttributeName: HEXCOLOR(0x999999)}];
      
    [goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(actGoodsPriceLabel.mas_right).offset(3.0f);
        make.bottom.equalTo(actGoodsPriceLabel.mas_bottom).offset (- 2);
    }];
    ///已抢购人数标签
    UILabel *purchaseNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentView addSubview:purchaseNumberLabel];
    purchaseNumberLabel.textColor = HEXCOLOR(0xF56456);
    purchaseNumberLabel.font = [UIFont systemFontOfSize:13.0];
    purchaseNumberLabel.text = @"1人已抢购";
    [purchaseNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.centerY.equalTo(progressView);
    }];
}

@end
