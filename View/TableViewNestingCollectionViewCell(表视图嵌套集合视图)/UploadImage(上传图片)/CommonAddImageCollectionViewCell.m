//
//  CommonAddImageCollectionViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/11.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "CommonAddImageCollectionViewCell.h"
#import "UIView+Action.h"

NSString * const CommonAddImageCollectionViewCellReuseIdentifier = @"CommonAddImageCollectionViewCellReuseIdentifier";

@interface CommonAddImageCollectionViewCell()

@property (nonatomic, strong) UIImageView *minImageView;// + 号图片视图
@property (nonatomic, strong) UILabel *title;//添加图片标签

@end

@implementation CommonAddImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.model = [[CommonImageCellModel alloc] init];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    
    /// + 号图片视图
    self.minImageView = [[UIImageView alloc]init];
    self.minImageView.image = [UIImage imageNamed:@"ic_upload_picture"];
    self.minImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.minImageView];
    self.minImageView.userInteractionEnabled = YES;
    
    ///添加图片标签
    self.title = [[UILabel alloc]init];
    self.title.text = @"添加图片";
    self.title.font = [UIFont systemFontOfSize:13.0];
    self.title.textColor = HEXCOLOR(0xB6B6B6);//[YSCUiUtils colorThree];
    [self.contentView addSubview:self.title];
    self.title.userInteractionEnabled = YES;
    
    [self updateConstraints];
    
    ///虚线边框
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = HEXCOLOR(0xB6B6B6).CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @4];
    [self.layer addSublayer:border];
    
    [self addEvent:self.contentView];
}

- (void)updateConstraints{
    
    [self.minImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minImageView.mas_bottom).offset(8);
        make.height.equalTo(@15).priorityHigh();
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)setModel:(CommonImageCellModel *)model{
    //设置添加图片标签
    if (model.imageCodes.count != 0) {
        self.title.text = [NSString stringWithFormat:@"%ld / %ld",model.imageCodes.count,model.maxNum];
    }else{
        self.title.text = @"添加图片";
    }
}


@end
