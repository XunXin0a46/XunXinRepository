//
//  TestCollectionViewItem.h
//  YiShopCustomer
//
//  Created by 王刚 on 2020/5/6.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const TestCollectionViewItemReuseIdentifier;

@interface TestCollectionViewItem : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题标签
@property (nonatomic, assign) BOOL selection;//是否处于选中状体

@end

