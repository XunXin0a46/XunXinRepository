//
//  TestCollectionView.h
//  YiShopCustomer
//
//  Created by 王刚 on 2020/5/6.
//  Copyright © 2020 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestCollectionView : UIView

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) void (^HideInViewyBlock)(void);

- (void)showInView:(UIView *)superView;
- (void)hideInView;

@end


