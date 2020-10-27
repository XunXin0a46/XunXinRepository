//
//  YSCValidator.m
//  YiShop
//
//  Created by 骆超然 on 2016/11/21.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "YSCValidator.h"
#import <AVFoundation/AVFoundation.h>

@implementation YSCValidator

+ (BOOL)validateUsername:(NSString *)username {
    NSString *userNameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]{4,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:username];
}

+ (BOOL)validateNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5_-]{1,20}+$";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
    return [nicknamePredicate evaluateWithObject:nickname];
}

+ (BOOL)validatePassword:(NSString *)password {
//    /^[^\x{4e00}-\x{9fa5}\·]{6,20}$/u
    NSString *passwordRegex = @"^[a-zA-Z0-9-]{6,20}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:password];
}

//邮箱校验
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//验证手机号码 不区别运营商 18224454951
+ (BOOL)validateMobile:(NSString *)mobile {
    NSString * pattern =  @"^1(3[0-9]|4[56789]|5[0-9]|6[6]|7[0-9]|8[0-9]|9[189])\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:mobile];
}

+ (BOOL)validaeMoney:(NSString *)money {
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{0,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:money];
}

+ (BOOL)validateIdentity:(NSString *)identity {
    NSString *identityRegex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityRegex];
    return [identityTest evaluateWithObject:identity];
}

+ (BOOL)isMediaAuthor{
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //此应用程序没有被授权访问的照片数据。可能是家长控制权限
    //用户已经明确否认了这一照片数据的应用程序访问
    if (authStatus ==AVAuthorizationStatusRestricted ||
        authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
    }else{
        return YES;
    }
}
@end
