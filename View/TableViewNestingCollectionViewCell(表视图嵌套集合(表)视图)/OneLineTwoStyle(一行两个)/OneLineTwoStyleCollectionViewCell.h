//
//  OneLineTwoStyleCollectionViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/5/21.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneLineTwoStyleModel.h"

FOUNDATION_EXTERN NSString * const OneLineTwoStyleCollectionViewCellReuseIdentifier;

@interface OneLineTwoStyleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) OneLineTwoStyleModel *model;

@end

