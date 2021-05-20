//
//  BigPictureStyleTableViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/19.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const BigPictureStyleTableViewCellReuseIdentifier;

@interface BigPictureStyleTableViewCell : UITableViewCell

///创建数据源
- (void)createDataSource;

///返回cell高度
+ (CGFloat)calculateCellHeight;

@end


