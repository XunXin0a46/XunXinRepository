//
//  AlertViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

///初始化操作表样式的警告视图控制器
+ (instancetype)sheetStyleAlertControllerWithFirstActionTtile:(NSString *)firstActionTitle firstCompletion:(void (^)(UIAlertAction * _Nonnull action))firstCompletion secondActionTitle:(NSString *)secondActionTitle secondCompletion:(void (^)(UIAlertAction * _Nonnull action))secondCompletion {
    
    AlertViewController *alertController = [super alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (alertController) {
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstActionTitle style:UIAlertActionStyleDestructive handler:firstCompletion];
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondActionTitle style:UIAlertActionStyleDefault handler:secondCompletion];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:firstAction];
        [alertController addAction:secondAction];
        [alertController addAction:cancelAction];
    }
    return alertController;
}

+ (instancetype)alertControllerWithStyleAlertTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionCompletion:(void (^)(UIAlertAction *))completion {
    
    AlertViewController *alertController = [super alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (alertController) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:completion];
        [alertController addAction:action];
    }
    return alertController;
}

+ (instancetype)alertControllerWithStyleAlertTitle:(NSString *)title message:(NSString *)message firstActionTitle:(NSString *)firstActionTitle firstActionCompletion:(void (^)(UIAlertAction *firstAction))firstActionCompletion secondActionTitle:(NSString *)secondActionTitle secondActionCompletion:(void (^)(UIAlertAction *secondAction))secondActionCompletion {
    
    AlertViewController *alertController = [super alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (alertController) {
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstActionTitle style:UIAlertActionStyleDefault handler:firstActionCompletion];
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondActionTitle style:UIAlertActionStyleDefault handler:secondActionCompletion];
        
        [alertController addAction:firstAction];
        [alertController addAction:secondAction];
    }
    return alertController;
}
@end
