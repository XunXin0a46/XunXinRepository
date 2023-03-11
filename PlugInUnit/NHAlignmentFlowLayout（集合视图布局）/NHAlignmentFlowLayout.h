//
//  NHAlignmentFlowLayout.h
//  Hukkster
//
//  Created by Nils Hayat on 7/1/13.
//  Copyright (c) 2013 Hukkster. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, NHAlignment) {
    NHAlignmentJustified = 0,
    NHAlignmentTopLeftAligned,  // 如果滚动方向为水平，则为顶部；如果为垂直，则为左侧
    NHAlignmentTopCaterGoryLeftAligned,//如果滚动方向为水平，则为顶部；如果为垂直，则为左侧固定范围
    NHAlignmentBottomRightAligned, // 如果滚动方向为水平，则为底部；如果为垂直，则为右侧
    
};

@interface NHAlignmentFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) NHAlignment alignment;

@end
