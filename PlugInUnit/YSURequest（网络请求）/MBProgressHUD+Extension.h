//
//  MBProgressHUD+Extension.h
//  YiShop
//
//  Created by 宗仁 on 2016/12/7.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD(Extension)
+ (instancetype)showHUDAddedTo:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated;

+ (instancetype)showCustomHUDAddedTo:(UIView *)view withTitle:(NSString *)title image:(UIImage *)image animated:(BOOL)animated;
@end
