//
//  LabelWithCopy.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/11/23.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "LabelWithCopy.h"

@interface LabelWithCopy()

@property (nonatomic, copy) NSString *makeToastTilte;//提示信息

@end

@implementation LabelWithCopy

///返回一个布尔值，指示此对象是否可以成为第一个响应程序
- (BOOL)canBecomeFirstResponder {
    return YES;
}

///请求接收器启用或禁用用户界面中的指定命令
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

///将选定内容复制到粘贴板
- (void)copy:(id)sender {
    //返回用于常规复制粘贴操作的通用粘贴板
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    //设置第一个粘贴板项的字符串值
    board.string = self.text;
    //在窗口显示提示信息
    [[[UIApplication sharedApplication] keyWindow] makeToast:self.makeToastTilte];
}

///添加触摸处理程序
- (void)addTouchHandler {
    //一个布尔值，用于确定是否忽略用户事件并将其从事件队列中移除
    self.userInteractionEnabled = YES;
    //初始化单次点击或多次点击的手势响应对象
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    //设置手势被识别的轻击次数
    tap.numberOfTapsRequired = 1;
    //添加手势手势响应对象
    [self addGestureRecognizer:tap];
}

///初始化提示信息，并添加手势
- (instancetype)initWithMakeToastTilte:(NSString *)title {
    if (self = [super init]) {
        self.makeToastTilte = title;
        [self addTouchHandler];
    }
    return self;
}


- (void)handleTap:(UIGestureRecognizer *)tap {
    //要求UIKit使此对象成为其窗口中的第一个响应程序
    [self becomeFirstResponder];
    //初始化由菜单控制器管理的编辑菜单中的自定义项
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
    //为菜单控制器设置菜单项
    [UIMenuController.sharedMenuController setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    //设置视图中位于编辑菜单上方或下方的区域
    [UIMenuController.sharedMenuController setTargetRect:self.frame inView:self.superview];
    //显示或隐藏编辑菜单，可以选择设置动作的动画
    [UIMenuController.sharedMenuController setMenuVisible:YES animated:YES];
    
}


@end
