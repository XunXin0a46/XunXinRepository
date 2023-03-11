//
//  YSCOrderTypeSelectionItem.m
//  YiShopCustomer
//
//  Created by 王刚 on 2020/5/6.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "TestCollectionViewItem.h"

NSString *const TestCollectionViewItemReuseIdentifier = @"TestCollectionViewItemReuseIdentifier";

@interface TestCollectionViewItem()


@end

@implementation TestCollectionViewItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 15.0;
        self.contentView.backgroundColor = HEXCOLOR(0xf2f2f2);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = HEXCOLOR(0x999999);
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.numberOfLines = 1;
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

///设置选中状态
- (void)setSelection:(BOOL)selection{
    if(selection){
        self.titleLabel.textColor = HEXCOLOR(0xF56456);
        self.contentView.backgroundColor = [HEXCOLOR(0xF56456) colorWithAlphaComponent:0.1f];
    }else{
        self.contentView.alpha = 1;
        self.titleLabel.textColor = HEXCOLOR(0x353535);
        self.contentView.backgroundColor = HEXCOLOR(0xf2f2f2);
    }
}

//写在cell中的自适应代码
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height = size.height;
    layoutAttributes.frame = cellFrame;
    return layoutAttributes;
}

@end
