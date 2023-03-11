//
//  BarProgressView.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/12/2.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarProgressView : UIView

@property (nonatomic) float percent;//百分比

//初始化
- (instancetype)initWithPercent:(float)percent;
//设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end

