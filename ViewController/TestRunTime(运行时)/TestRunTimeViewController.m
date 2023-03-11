//
//  TestRunTimeViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/4.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestRunTimeViewController.h"
#import "UIView+ExtraTag.h"
#import "UIView+Action.h"

@interface Person: NSObject

@end

@implementation Person

- (void) foo {
    NSLog(@"foo即使不存在也不会报错");//Person的foo函数
}

@end


@interface TestRunTimeViewController ()

@end

@implementation TestRunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"RunTime"];
    //设置标签
    [self setClickLabel];
    //执行foo函数,测试消息转发
    [self performSelector:@selector(foo)];
}

///----------------------------------------- 为标签添加点击事件 ----------------------------------
- (void)setClickLabel{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat labelWidth = 180;
    CGFloat labelheigth = 20;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((screen.size.width - labelWidth)/2, (screen.size.height - labelheigth)/2, labelWidth, labelheigth)];
    //设置文本
    label.text = @"可以点击的标签";
    //设置文本左右居中
    label.textAlignment = NSTextAlignmentCenter;
    //设置文本颜色
    label.textColor = [UIColor redColor];
    [self.view addEvent:label];
    //视图中添加标签
    [self.view addSubview:label];
    [self.view addTarget:self action:@selector(onClick:) section:0];
}

- (void)onClick:(UIView *)sender{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"响应了点击" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            NSLog(@"Top YES Button");
        }];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:true completion:nil];
}

///--------------------------------------- 为标签添加点击事件结束 ---------------------------------

///--------------------------------- 消息转发开始 ------------------------------------------------

//1.动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    //如果是执行foo函数，就动态解析，指定新的IMP
    if (sel == @selector(foo)) {
        class_addMethod([self class], sel, (IMP)fooMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void fooMethod(id obj, SEL _cmd) {
    //新的foo函数
    NSLog(@"foo即使不存在也不会报错");
}

//2.备用接收者
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(foo)) {
        //返回Person对象，让Person对象接收这个消息
        return [Person new];
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

//3.完整消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"foo"]) {
        //签名，进入forwardInvocation
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;

    Person *p = [Person new];
    if([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    }
    else {
        [self doesNotRecognizeSelector:sel];
    }

}

///--------------------------------- 消息转发结束 -----------------------------------------------

@end
