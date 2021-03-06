//
//  TestViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/6/3.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestViewController.h"
#import "TestViewTransitionController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视图控制器";
    //设置导航栏右侧导航项
    [self setRightNavigationItem];
}


///----------------------------------- UIViewController代码测试区 -------------------------------------

///获取当前视图所在控制器的代码片段
- (UIViewController *)getCurrentVC{
    //获取窗口的根视图控制器
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

///获取当前视图所在控制器的具体实现（递归）
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    
    UIViewController *currentVC;
    //获取根视图控制器现实的视图控制器
    if ([rootVC presentedViewController]) {
      
        rootVC = [rootVC presentedViewController];
    }
    
    //判断视图控制器类型
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        //标签栏视图控制器，获取当前选中的视图控制器
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        //导航栏控制器，获取导航界面中当前可见视图关联的视图控制器
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

///设置导航栏右侧导航项
- (void)setRightNavigationItem{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"模态动画" style:UIBarButtonItemStylePlain target:self action:@selector(goTestViewTransitionController)];
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

///水平三维翻转显示的控制器
- (void)goTestViewTransitionController{
    TestViewTransitionController *testViewTransition = [[TestViewTransitionController alloc]init];
    testViewTransition.modalPresentationStyle = UIModalPresentationFullScreen;
    testViewTransition.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:testViewTransition animated:YES completion:nil];

}

///-------------------------------- UIViewController代码测试区结束 -------------------------------------


@end
