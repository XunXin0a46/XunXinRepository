//
//  CommonAddedImageCollectionViewCell.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/11.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const CommonAddedImageCollectionViewCellReuseIdentifier;

@interface CommonAddedImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;//设置显示的图片
@property (nonatomic, copy) NSURL *imageURL;//设置显示的图片路径
@property (nonatomic, assign) BOOL editEnable;//是否启用删除按钮
@property (nonatomic, strong) UIImageView *imageView;//展示图片的视图

- (void)setImageCode:(NSString *)imageCode;//根据图片编码设置图片
- (void)setEditButtonViewType:(NSInteger)type;

@end


