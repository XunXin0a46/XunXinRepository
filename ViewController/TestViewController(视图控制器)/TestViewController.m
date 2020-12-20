//
//  TestViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/6/3.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


///----------------------------------- UIViewController代码测试区 -------------------------------------

///获取当前视图所在控制器的代码片段
- (UIViewController *)getCurrentVC{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
      
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
        currentVC = rootVC;
    }
    
    return currentVC;
}

///既有模态显示又有push显示时，返回根控制
- (void)backToRootViewController{
    //获取当前视图控制器
    UIViewController *currentVC = [self getCurrentVC];
    //如果当前控制器是以模态显示的
    while(currentVC.presentingViewController != nil){
        //获取模态显示当前视图控制器的视图控制器
        currentVC = currentVC.presentingViewController;
        //模态的关闭显示当前视图控制器的视图控制器
        [currentVC dismissViewControllerAnimated:NO completion:nil];
    }
    //返回根视图控制器
    [currentVC.navigationController popToRootViewControllerAnimated:NO];
}

///-------------------------------- UIViewController代码测试区结束 -------------------------------------


@end
