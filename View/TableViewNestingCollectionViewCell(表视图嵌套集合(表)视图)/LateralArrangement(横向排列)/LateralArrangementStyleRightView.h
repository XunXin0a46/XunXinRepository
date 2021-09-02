//
//  LateralArrangementStyleRightView.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/29.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LateralArrangementItemDataPicItemModel.h"

@interface LateralArrangementStyleRightView : UIView

@property (nonatomic) CGFloat borderHeight;//边框高度
@property (nonatomic, strong) UIImageView *imageView1;//图片视图一
@property (nonatomic, strong) UIImageView *imageView2;//图片视图二
@property (nonatomic, strong) NSArray<LateralArrangementItemDataPicItemModel *> *imageModels;//图片数据数组

///移除所有显示图片
- (void)removeAllImages;

@end

