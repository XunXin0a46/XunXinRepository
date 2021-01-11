//
//  RootViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/1/5.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "TableViewNestingCollectionViewController.h"
#import "BezierPathController.h"
#import "TestCLLocationController.h"
#import "SignInController.h"
#import "YSUUtils.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *controller;//记录选中的新帖控制器

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //设置根视图控制器
    [self setRootViewController];
}

///设置根视图控制器
- (void)setRootViewController{
    //标签栏的自定义背景图像
    self.tabBar.backgroundImage = [YSUUtils imageWithColor:[UIColor clearColor] size:CGSizeMake(CGRectGetWidth(self.view.frame), 0.5)];
    //标签栏的自定义阴影图像
    self.tabBar.shadowImage = [YSUUtils imageWithColor:[UIColor redColor] size:CGSizeMake(CGRectGetWidth(self.view.frame), 0.5)];
    //标签栏是否半透明
    self.tabBar.translucent = NO;
    //标签栏项的定位方式
    self.tabBar.itemPositioning = UITabBarItemPositioningFill;
    //添加五个子控制器
    //首页
    ViewController *indexViewController = [[ViewController alloc]init];
    [self tabBarControll:self addControllerToNavigationController:indexViewController withWhetherNavigation:YES];
    //表嵌集
    TableViewNestingCollectionViewController *tableViewNestingCollectionViewController = [[TableViewNestingCollectionViewController alloc]init];
    [self tabBarControll:self addControllerToNavigationController:tableViewNestingCollectionViewController withWhetherNavigation:YES];
    //贝塞尔
    BezierPathController *bezierPathController = [[BezierPathController alloc]init];
    [self tabBarControll:self addControllerToNavigationController:bezierPathController withWhetherNavigation:NO];
    //位置
    TestCLLocationController *locationController = [[TestCLLocationController alloc]init];
    [self tabBarControll:self addControllerToNavigationController:locationController withWhetherNavigation:YES];
    //签到
    SignInController *signInController = [[SignInController alloc]init];
    [self tabBarControll:self addControllerToNavigationController:signInController withWhetherNavigation:YES];
}

///导航栏添加控制器
- (void)tabBarControll:(UITabBarController *)tabBarController addControllerToNavigationController:(UIViewController *)controller withWhetherNavigation:(BOOL)whetherNavigation{
    //判断是否是导航控制器
    if(whetherNavigation){
        //导航控制器
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
        [tabBarController addChildViewController:navigationController];
        //设置导航栏上的按钮 -> 由对应子控制器的tabBarItem属性
        if([controller isMemberOfClass:[ViewController class]]){
            navigationController.tabBarItem.title = @"首页";
            navigationController.tabBarItem.image = [UIImage imageNamed:@"tab_home_normal"];
            navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_home_index"];
            navigationController.tabBarItem.tag = 5000;
        }
        if([controller isMemberOfClass:[TableViewNestingCollectionViewController class]]){
            navigationController.tabBarItem.title = @"表嵌集";
            navigationController.tabBarItem.image = [UIImage imageNamed:@"tab_category_normal"];
            navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_category_selected"];
            navigationController.tabBarItem.badgeValue = @"重点";
            navigationController.tabBarItem.badgeColor = [UIColor purpleColor];
            navigationController.tabBarItem.tag = 5001;
        }
        if([controller isMemberOfClass:[TestCLLocationController class]]){
            navigationController.tabBarItem.title = @"位置";
            navigationController.tabBarItem.image = [UIImage imageNamed:@"tab_location_normal"];
            navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_location_selected"];
            navigationController.tabBarItem.tag = 5002;
        }
        if([controller isMemberOfClass:[SignInController class]]){
            navigationController.tabBarItem.title = @"签到";
            navigationController.tabBarItem.image = [UIImage imageNamed:@"tab_user_normal"];
            navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_user_selected"];
            navigationController.tabBarItem.tag = 5003;
        }
    }else{
        //视图控制器
        if([controller isMemberOfClass:[BezierPathController class]]){
            controller.tabBarItem.title = @"贝塞尔";
            controller.tabBarItem.image = [UIImage imageNamed:@"tab_cart_normal"];
            controller.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_cart_selected"];
            controller.tabBarItem.tag = 5004;
        }
        [tabBarController addChildViewController:controller];
    }
}

#pragma mark -- UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //如果点击了新帖
    if(viewController.tabBarItem.tag == 5001){
        //隐藏标签栏项的标记值
        viewController.tabBarItem.badgeValue = nil;
        //记录点击的新帖控制器
        self.controller = viewController;
    }else{
        //点击的不是新帖控制器时，恢复新帖标签项的标记值
        self.controller.tabBarItem.badgeValue = @"重点";
    }
}


@end
