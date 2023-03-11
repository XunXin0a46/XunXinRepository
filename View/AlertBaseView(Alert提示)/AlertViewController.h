//
//  AlertViewController.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertViewController : UIAlertController

///初始化操作表样式的警告视图控制器
+ (instancetype)sheetStyleAlertControllerWithFirstActionTtile:(NSString *)firstActionTitle firstCompletion:(void (^)(UIAlertAction *action))firstCompletion secondActionTitle:(NSString *)secondActionTitle secondCompletion:(void (^)(UIAlertAction *action))secondCompletion;

+ (instancetype)alertControllerWithStyleAlertTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionCompletion:(void (^)(UIAlertAction *))completion;

+ (instancetype)alertControllerWithStyleAlertTitle:(NSString *)title message:(NSString *)message firstActionTitle:(NSString *)firstActionTitle firstActionCompletion:(void (^)(UIAlertAction *))firstActionCompletion secondActionTitle:(NSString *)secondActionTitle secondActionCompletion:(void (^)(UIAlertAction *))secondActionCompletion;

@end

