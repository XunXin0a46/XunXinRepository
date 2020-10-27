//
//  YSCValidator.h
//  YiShop
//
//  Created by 骆超然 on 2016/11/21.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCValidator : NSObject

/**
 *  验证用户名输入是否合法
 *
 *  @param username 用户名
 *
 *  @return 返回值为 YES 时表明为合法输入
 */
+ (BOOL)validateUsername:(NSString *)username;

/**
 *  验证用户昵称输入是否合法
 *
 *  @param nickname 输入的用户昵称
 *
 *  @return 返回值为 YES 时表明为合法输入
 */

+ (BOOL)validateNickname:(NSString *)nickname;

/**
 *  验证密码格式
 */
+ (BOOL)validatePassword:(NSString *)password;

/**
 *  验证邮箱输入格式
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  验证手机号输入格式
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  验证金额输入格式
 */
+ (BOOL)validaeMoney:(NSString *)money;

/**
 *  验证身份证号码
 */
+ (BOOL)validateIdentity:(NSString *)identity;
/**
 *  验证用户是否开启相机权限
 */
+ (BOOL)isMediaAuthor;
@end
