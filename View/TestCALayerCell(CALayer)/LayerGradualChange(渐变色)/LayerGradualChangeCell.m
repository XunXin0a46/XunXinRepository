//
//  LayerGradualChangeCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2023/2/1.
//  Copyright © 2023 王刚. All rights reserved.
//

#import "LayerGradualChangeCell.h"

NSString * const LayerGradualChangeCellReuseIdentifier = @"LayerGradualChangeCellReuseIdentifier";

@interface LayerGradualChangeCell()

@property (nonatomic, strong) UIView *gradualChangeView;

@end

@implementation LayerGradualChangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.gradualChangeView = [[UIView alloc]initWithFrame:CGRectZero];
    self.gradualChangeView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.gradualChangeView];
    [self.gradualChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.top).offset(10);
        make.bottom.mas_equalTo(self.contentView.bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)layoutSubviews {
    //设置视图渐变色
    [self.contentView layoutSubviews];
    [self setGradualChangeColorView:self.gradualChangeView];
}

///设置视图渐变色
- (void)setGradualChangeColorView:(UIView *)view{
    //CAGradientLayer继承CALayer，可以设置渐变图层
    CAGradientLayer *grandientLayer = [[CAGradientLayer alloc] init];
    grandientLayer.frame = view.bounds;
    [view.layer addSublayer:grandientLayer];
    [view.layer insertSublayer:grandientLayer atIndex:0];
    //设置渐变的方向 左上(0,0)  右下(1,1)
    grandientLayer.startPoint = CGPointMake(0.0, 0.0);
    grandientLayer.endPoint = CGPointMake(0.0, 1.0);//纵向
    //grandientLayer.endPoint = CGPointMake(1.0, 0.0);//横向
    //colors渐变的颜色数组 这个数组中只设置一个颜色是不显示的
    grandientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor];
    //沿轴向在两个定义的端点之间变化
    grandientLayer.type = kCAGradientLayerAxial;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
