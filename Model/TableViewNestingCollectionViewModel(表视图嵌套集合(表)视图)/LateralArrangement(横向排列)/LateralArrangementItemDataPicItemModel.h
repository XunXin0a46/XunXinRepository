//
//  LateralArrangementItemDataPicItemModel.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/24.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LateralArrangementItemDataPicItemModel : NSObject

@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, assign) CGFloat image_width;//图片宽
@property (nonatomic, assign) CGFloat image_height;//图片高
@property (nonatomic, assign) CGSize displaySize;//图片显示大小

///创建左侧模型
- (instancetype)initLeftItemModel;
///创建右侧模型一
- (instancetype)initRightOneItemModel;
///创建右侧模型二
- (instancetype)initRightTwoItemModel;

@end


