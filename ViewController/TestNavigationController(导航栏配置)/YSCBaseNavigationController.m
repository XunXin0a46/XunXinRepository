//
//  YSCBaseNavigationController.m

#import "YSCBaseNavigationController.h"

@interface YSCBaseNavigationController ()

@end

@implementation YSCBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

///重写pushViewController函数修改动画
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        if (animated) {

            CATransition *animation = [CATransition animation];
            animation.duration = 0.35f;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:animation forKey:nil];
            [self.view.layer addAnimation:animation forKey:nil];
            [super pushViewController:viewController animated:NO];
            return;
        }
    }
    [super pushViewController:viewController animated:animated];
}

@end
