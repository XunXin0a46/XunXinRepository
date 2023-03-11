//
//  OneLinePictureAdaptationCollectionViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/18.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "OneLinePictureAdaptationCollectionViewCell.h"

NSString * const OneLinePictureAdaptationCollectionViewCellReuseIdentifier = @"NSString * const OneLinePictureAdaptationCollectionViewCellReuseIdentifier";

@implementation OneLinePictureAdaptationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
