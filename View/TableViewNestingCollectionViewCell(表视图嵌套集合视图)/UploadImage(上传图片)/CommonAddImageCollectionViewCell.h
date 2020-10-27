//
//  CommonAddImageCollectionViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/11.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImageCellModel.h"

FOUNDATION_EXTERN NSString * const CommonAddImageCollectionViewCellReuseIdentifier;

@interface CommonAddImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CommonImageCellModel *model;

@end

