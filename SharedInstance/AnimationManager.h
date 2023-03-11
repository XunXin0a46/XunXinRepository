//
//  AnimationManager.h
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/25.
//  Copyright © 2021 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationManager : NSObject

///构造动画管理器单例对象
+ (instancetype)sharedManager;

///视图抛物线动画
- (void)throwView:(UIView *)view fromRect:(CGRect)originRect toRect:(CGRect)endRect;

///返回缩放动画对象
- (CABasicAnimation*)scaleAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)tovalue;

///返回平移动画对象
- (CABasicAnimation*)rotationAnimationFromValue:(CGPoint)fromValue toValue:(CGPoint)tovalue;

///执行分组动画
- (void)implementGroupAnimation:(UIView *)view withAnimations:(NSArray *)animations;

@end

