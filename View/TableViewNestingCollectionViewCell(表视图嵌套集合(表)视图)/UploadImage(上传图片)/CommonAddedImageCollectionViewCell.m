//
//  CommonAddedImageCollectionViewCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/11.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "CommonAddedImageCollectionViewCell.h"
#import "UIView+ExtraTag.h"
#import "UIView+Action.h"
#import "UIImage+ImageBase64.h"

NSString * const CommonAddedImageCollectionViewCellReuseIdentifier = @"CommonAddedImageCollectionViewCellReuseIdentifier";

@interface CommonAddedImageCollectionViewCell()

@property (nonatomic, strong) UIButton *editButton;

@end

@implementation CommonAddedImageCollectionViewCell

// 按钮越界处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.editButton convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.editButton.bounds, newPoint)) {
            view = self.editButton;
        }
    }
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        ///展示图片的视图
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageView];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView setViewTypeForTag:1];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [self addEvent:_imageView];
        
        ///删除图片按钮
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_editButton];
        [_editButton setViewTypeForTag:2];
        _editButton.hidden = YES;
        [_editButton setImage:[UIImage imageNamed:@"ic_real_name_closed"] forState:UIControlStateNormal];
        [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.equalTo(self.contentView.mas_top).offset(3);
            make.size.mas_equalTo(CGSizeMake(20.0, 20.0));
        }];
        [self addEvent:_editButton];
        
    }
    return self;
}

///根据图片路径设置图片
- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self.imageView yy_setImageWithURL:_imageURL placeholder:nil];
}

///设置图片
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

- (void)setExtraInfoForTag:(NSInteger)extraInfo {
    [super setExtraInfoForTag:extraInfo];
    [self.imageView setExtraInfoForTag:extraInfo];
    [self.editButton setExtraInfoForTag:extraInfo];
}

///删除按钮是否启用
- (void)setEditEnable:(BOOL)editEnable {
    _editEnable = editEnable;
    _editButton.hidden = self.editEnable ? NO : YES;
}

///解析图片编码
- (void)setImageCode:(NSString *)imageCode{
    [self.imageView setImage:[UIImage ysc_imageWithBase64EncodingString:imageCode]];
}

-(void)setEditButtonViewType:(NSInteger)type{
    [_editButton setViewTypeForTag:type];
}


@end
