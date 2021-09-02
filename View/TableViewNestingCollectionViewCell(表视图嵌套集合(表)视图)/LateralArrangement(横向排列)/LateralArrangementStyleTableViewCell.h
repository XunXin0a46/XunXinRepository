//
//  LateralArrangementStyleTableViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/22.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const LateralArrangementStyleTableViewCellReuseIdentifier;

@interface LateralArrangementStyleTableViewCell : UITableViewCell

///创建数据数据
- (void)createDataSource;

///计算cell高度
+ (CGFloat)calculateDynamicHeight;

@end

