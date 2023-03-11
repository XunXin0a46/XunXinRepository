//
//  AppDelegate.m
//  FrameworksTest
//
//  Created by 王刚 on 2019/7/8.
//  Copyright © 2019 王刚. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"启动过程即将完成，应用程序即将运行");
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *rootViewController = [[RootViewController alloc]init];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"程序即将变为非活动状态");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"应用程序现在位于后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"应用程序即将进入前台");
    YSUIntent *intent = [[YSUIntent alloc]initWithClassName:@"SwipeViewController"];
    intent.method = OPEN_METHOD_POP;
    intent.useNavigationToPush = YES;
    [self.window.rootViewController openIntent:intent];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"应用程序已激活");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"应用程序将要终止");
}


@end
