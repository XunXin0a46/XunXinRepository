//
//  DXRadianLayerView.h
//  FrameworksTest
//
//  Created by 王刚 on 2019/10/17.
//  Copyright © 2019 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DXRadianDirection) {
    DXRadianDirectionBottom     = 0,
    DXRadianDirectionTop        = 1,
    DXRadianDirectionLeft       = 2,
    DXRadianDirectionRight      = 3,
};

@interface DXRadianLayerView : UIView

// 圆弧方向, 默认在下方
@property (nonatomic) DXRadianDirection direction;
// 圆弧高/宽, 可为负值。 正值凸, 负值凹
@property (nonatomic) CGFloat radian;

@end


