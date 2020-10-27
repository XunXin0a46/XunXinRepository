//
//  UIControl+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

/**
 为“UIControl”提供扩展。
 */
@interface UIControl (YYAdd)

/**
 从内部调度表中删除特定事件(或多个事件)的所有目标和操作。
 */
- (void)removeAllTargets;

/**
 将特定事件(或多个事件)的目标和操作添加或替换到内部调度表。
 
 @param target         目标对象—即发送操作消息到的对象。如果该值为nil，则将搜索响应者链以寻找愿意响应操作消息的对象
 
 @param action         标识操作消息的选择器。它不能为空。
 
 @param controlEvents  位掩码，指定发送操作消息的控制事件。
 */
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 将特定事件(或多个事件)的块添加到内部分派表。它将导致对@a块的强引用。
 
 @param block          在发送操作消息时调用的块（不能为nil）。块被保留。
 
 @param controlEvents  位掩码，指定发送操作消息的控制事件。
 */
- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 将特定事件(或多个事件)的块添加或替换到内部分派表。它将导致对@a块的强引用。
 
 @param block          在发送操作消息时调用的块（不能为nil）。块被保留。
 
 @param controlEvents  位掩码，指定发送操作消息的控制事件。
 */
- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
从内部调度表中删除特定事件(或多个事件)的所有块。
 @param controlEvents  位掩码，指定发送操作消息的控制事件。
 */
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
