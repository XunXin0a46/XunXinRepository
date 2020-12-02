//
//  BarProgressView.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/12/2.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "BarProgressView.h"
#import "UIImage+TintColor.h"

@interface BarProgressView()

@property (nonatomic, strong) UIView *currentPercentView;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BarProgressView

- (instancetype)initWithPercent:(float)percent {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.backgroundImageView.alpha = 0.4;
        self.backgroundImageView.image = [[UIImage imageNamed:@"ic_status_bar_bg"] imageWithTintTheColor:[UIColor redColor]];
        [self addSubview:self.backgroundImageView];
        
        self.currentPercentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.currentPercentView];
        self.currentPercentView.backgroundColor = [UIColor redColor];
        self.currentPercentView.alpha = 0.8;
        
        self.percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.percentLabel];
        self.percentLabel.textAlignment = NSTextAlignmentCenter;
        self.percentLabel.textColor = [UIColor whiteColor];
        self.percentLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.percent = percent;
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.currentPercentView.layer.cornerRadius = self.layer.cornerRadius;
    self.currentPercentView.layer.masksToBounds = self.layer.masksToBounds;
}

- (void)setPercent:(float)percent {
    
    _percent = percent;
        
    NSNumberFormatter *parcentFormater = [[NSNumberFormatter alloc] init];
    parcentFormater.numberStyle = NSNumberFormatterDecimalStyle;
    parcentFormater.maximumFractionDigits = 2;
    
    NSString *outNumber = [NSString stringWithFormat:@"%@%%",[parcentFormater stringFromNumber:@(self.percent * 100)]];
   
    
    self.percentLabel.text = outNumber;
    [self.currentPercentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(self.percent);
    }];
}


@end
