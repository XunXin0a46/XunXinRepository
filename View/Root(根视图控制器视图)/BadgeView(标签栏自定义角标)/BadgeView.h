//
//  BadgeView.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/1/31.
//  Copyright © 2021 王刚. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface BadgeView : UIView

@property (nonatomic, strong) IBInspectable UIColor *bgColor;//背景颜色
@property (nonatomic, strong) IBInspectable NSString *badgeValue;//文本标签显示文本
@property (nonatomic, strong) IBInspectable UIColor *textColor;//文本标签文本颜色
@property (nonatomic, strong) IBInspectable UIFont *textFont;//文本标签文本字体

@end


