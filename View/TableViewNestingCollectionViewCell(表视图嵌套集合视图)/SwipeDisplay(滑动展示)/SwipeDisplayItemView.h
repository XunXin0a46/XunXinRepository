//
//  SwipeDisplayItemView.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/4/24.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeDisplayItemModel.h"

@interface SwipeDisplayItemView : UIView

@property (nonatomic, strong)UILabel *countdownTime;//倒计时标签
@property (nonatomic, strong)SwipeDisplayItemModel *model;//模型

///计算视图高度
+ (CGFloat)calculateViewHeight;

@end

