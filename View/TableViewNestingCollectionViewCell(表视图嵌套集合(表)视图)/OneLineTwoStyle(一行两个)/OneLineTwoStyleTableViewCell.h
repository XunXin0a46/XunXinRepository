//
//  OneLineTwoStyleTableViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/21.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const OneLineTwoStyleTableViewCellReuseIdentifier;

@interface OneLineTwoStyleTableViewCell : UITableViewCell

///创建数据源
- (void)createDataSource;

///计算cell高度
+ (CGFloat)calculateDynamicHeight;

@end

