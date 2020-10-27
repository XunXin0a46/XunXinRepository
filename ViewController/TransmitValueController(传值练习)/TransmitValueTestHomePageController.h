//
//  TransmitValueTestHomePageController.h
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TransmitValueTestHomePageController : UIViewController
//传递用户名的属性
@property(nonatomic,copy) NSString *userName;
//传递密码的属性
@property(nonatomic,copy) NSString *passWord;
//定义一个MyBlock属性
@property (nonatomic,copy)void(^MyBlock)(NSString *userName,NSString *passWord);

@end

