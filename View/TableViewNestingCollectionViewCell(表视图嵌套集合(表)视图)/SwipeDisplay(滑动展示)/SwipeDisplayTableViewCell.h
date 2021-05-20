//
//  SwipeDisplayTableViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/4/24.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestTableViewModel.h"

FOUNDATION_EXPORT NSString * const SwipeDisplayTableViewCellReuseIdentifier;

@interface SwipeDisplayTableViewCell : UITableViewCell

@property (nonatomic, strong) TestTableViewModel *model;

///返回self高度
+ (CGFloat)calculateCellHeight:(TestTableViewModel *)model;

@end

