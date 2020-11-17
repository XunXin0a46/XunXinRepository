//
//  CountdownButton.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/11/16.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "CountdownButton.h"

@interface CountdownButton()

@property (strong, nonatomic) dispatch_source_t timer;//强引用声明dispatch_source_t对象，否则它就会被销毁。

@end


@implementation CountdownButton

- (void)dealloc {
    //定时器失效
    [self timerInvalidate];
}

///类方法初始化按钮
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    
    CountdownButton *button = [super buttonWithType:buttonType];
    //按钮背景色
    button.backgroundColor = HEXCOLOR(0xF56456);
    //按钮标题字体大小
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    //按钮圆角
    button.layer.cornerRadius = 3.0;
    //按钮超出层边界裁剪
    button.layer.masksToBounds = YES;
    //可以减小按钮标题字体大小以适应
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    //可以减小的最小比例
    button.titleLabel.minimumScaleFactor = 0.8;
    //设置按钮标题文本
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    //设置按钮标题文本颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}

///初始化按钮
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //按钮背景色
        self.backgroundColor = HEXCOLOR(0xF56456);
        //按钮标题字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        //按钮圆角
        self.layer.cornerRadius = 3.0;
        //按钮超出层边界裁剪
        self.layer.masksToBounds = YES;
        //可以减小按钮标题字体大小以适应
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
         //可以减小的最小比例
        self.titleLabel.minimumScaleFactor = 0.8;
        //设置按钮标题文本
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        //设置按钮标题文本颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

///开始倒计时并在完成时处理程序
- (void)startCountdownCompletionhander:(void (^)(void))completionHanlder {
    //倒计时时间(秒)
    __block NSTimeInterval time = 5.0;
    //如果self.timer为null，则进行创建
    if (self.timer == NULL) {
        //创建GCD中的定时器
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        //设置定时器
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        //设置事件
        dispatch_source_set_event_handler(self.timer, ^{
            //按钮是否启用
            BOOL enabled;
            //背景色
            UIColor *backgroundColor;
            //标题
            NSString *title;
            //标题颜色
            UIColor *titleColor;
            
            if (time <= 0) {
                //倒计时结束
                //定时器失效
                [self timerInvalidate];
                //设置按钮响应属性
                enabled = YES;
                backgroundColor = HEXCOLOR(0xF56456);
                title = @"获取验证码";
                titleColor = [UIColor whiteColor];
                
            } else {
                
                enabled = NO;
                backgroundColor = HEXCOLOR(0xEEEEEE);
                title = [NSString stringWithFormat:@"%2.0f秒后再次发送", time];
                titleColor = HEXCOLOR(0xBDBDBD);
            }
            
            time -= 1.0;
            
            //获取主队列，修改按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //将响应属性设置到按钮
                self.enabled = enabled;
                self.backgroundColor = backgroundColor;
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitleColor:titleColor forState:UIControlStateNormal];
                
                //判断是否执行倒计时完成块
                if (self.isEnabled &&
                    completionHanlder) {
                    completionHanlder();
                }
            });
        });
        //开始执行计时器
        dispatch_resume(self.timer);
    }
}

///定时器失效
- (void)timerInvalidate {
    
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
    self.timer = NULL;
}


@end
