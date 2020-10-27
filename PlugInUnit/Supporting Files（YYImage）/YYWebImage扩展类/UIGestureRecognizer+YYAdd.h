//
//  UIGestureRecognizer+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/10/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

/**
 为“UIGestureRecognizer”提供扩展。
 */
@interface UIGestureRecognizer (YYAdd)

/**
 使用动作块初始化已分配的手势识别器对象。
 
 @param block  一种操作块，用于处理接收方识别的手势。nil是无效的。它被手势所保留。
 
 @return 具体UIGestureRecognizer子类的初始化实例，如果在初始化对象时发生错误，则为nil。
 */
- (instancetype)initWithActionBlock:(void (^)(id sender))block;

/**
 向手势识别器对象添加操作块。它被手势所保留。
 
 @param block 由操作消息调用的块。nil不是一个有效值。
 */
- (void)addActionBlock:(void (^)(id sender))block;

/**
 删除所有动作块。
 */
- (void)removeAllActionBlocks;

@end
