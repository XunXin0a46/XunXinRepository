//
//  LayerShadowCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2023/2/1.
//  Copyright © 2023 王刚. All rights reserved.
//

#import "LayerShadowCell.h"

NSString * const LayerShadowCellReuseIdentifier = @"LayerShadowCellReuseIdentifier";

@implementation LayerShadowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectZero];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.cornerRadius = 10.0;
    [self.contentView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.top).offset(10);
        make.bottom.mas_equalTo(self.contentView.bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self setLayerShadowToView:shadowView withColor:[UIColor grayColor] withOffset:CGSizeMake(0, 0) radius:3];
}

///设置涂层阴影
- (void)setLayerShadowToView:(UIView *)theView withColor:(UIColor*)color withOffset:(CGSize)offset radius:(CGFloat)radius {
    theView.layer.shadowColor = color.CGColor;
    //阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = offset;
    //阴影半径，默认3
    theView.layer.shadowRadius = radius;
    //阴影不透明度
    theView.layer.shadowOpacity = 1;
    //光栅化
    theView.layer.shouldRasterize = YES;
    theView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
