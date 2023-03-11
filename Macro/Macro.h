//
//  Macro.h
//  FrameworksTest
//
//  Created by 王刚 on 2019/10/17.
//  Copyright © 2019 王刚. All rights reserved.
//  宏定义文件

#ifndef Macro_h
#define Macro_h

//MARK:- URL路由跳转测试使用
#define PATTERN_INSIDE [NSString stringWithFormat:@"(%@%@%@)",PATTERN_PREFIX,@"(?:.*?)",PATTERN_SUFFIX]
#define PATTERN_WEBVIEW [NSString stringWithFormat:@"%@",PATTERN_PREFIX]
#define PATTERN_GOODS_LIST_TWELVE  @"^/search\\.html\\?is_self=(\\d+)$"

//MARK:- URL
//定义根URL
#define YSCBaseURL [[NSUserDefaults standardUserDefaults] objectForKey:@"server"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"server"]:@"http://www.test.68mall.com"
//拼接URL正则表达式使用，开头可以存在或不存在https或http
#define PATTERN_PREFIX [NSString stringWithFormat:@"%@(?:%@){0,1}/",@"^(?:https://|http://){0,1}(?:[A-Z_a-z]+\\.){0,1}",[YSUUtils getDomain:YSCBaseURL]]
//拼接URL正则表达式使用，结尾可以存在或不存在.html
//(?:pattern)的含义：匹配 pattern 但不获取匹配结果，也就是说这是一个非获取匹配，不进行存储供以后使用。这在使用 "或" 字符 (|) 来组合一个模式的各个部分是很有用。例如， 'industr(?:y|ies) 就是一个比 'industry|industries' 更简略的表达式。
#define PATTERN_SUFFIX  @"(?:\\.html){0,1}"

// MARK:- 系统尺寸宏定义
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_LIUHAI (IS_IPHONE && !(SCREEN_MAX_LENGTH < 812))
#define IS_IPHONE_LANDSCAP (IS_IPHONE && IS_LANDSCAP)
#define IS_LANDSCAP (SCREEN_WIDTH > SCREEN_HEIGHT)

// MARK:- 手机型号
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_6P (IS_IPHONE_6 || IS_IPHONE_6P)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH >= 812)
//获取窗口对象
#define WINDOW [[UIApplication sharedApplication] keyWindow]
//屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//导航栏的高
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
//导航栏与状态栏的高
#define HEAD_BAR_HEIGHT (IS_IPHONE_X?88:64)
//状态栏的高
#define STATUSBARHEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
//获取视图的宽度
#define WIDTH(view) view.frame.size.width
//字符串不为空
#define IS_NOT_EMPTY(string) (string !=nil && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""] && ![string isKindOfClass:[NSNull class]] && ![string isEqualToString:@"<null>"])
//数组不为空
#define ARRAY_IS_NOT_EMPTY(array) (array && [array isKindOfClass:[NSArray class]] && [array count])
//字典不为空
#define DICTIONARY_IS_NOT_EMPTY(dictionary) (dictionary \
                                                && [dictionary isKindOfClass:[NSDictionary class]] \
                                                && [dictionary count])
//设置RGBA颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
//十六进制颜色
#define HEXCOLOR(c)                                  \
[UIColor colorWithRed:((c >> 16) & 0xFF) / 255.0 \
green:((c >> 8) & 0xFF) / 255.0  \
blue:(c & 0xFF) / 255.0         \
alpha:1.0]

//带有透明度的十六进制颜色
#define HEX_COLOR(hex,a) [UIColor colorWithRed:((float)((hex&0xFF0000)>>16))/255.0 green:((float)((hex&0xFF00)>>8))/255.0 blue:((float)(hex&0xFF))/255.0 alpha:(a)]

//带有所在位置的输出语句
#ifdef DEBUG
#define YSCLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define YSCLog(...)
#endif

//设备是IPHONE 5
#define DEVICE_IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)
//设备是IPHONE 6
#define DEVICE_IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0, 1334.0), [[UIScreen mainScreen] currentMode].size) : NO)
//设备是IPHONE 6P
#define DEVICE_IS_IPHONE_6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0, 2208.0), [[UIScreen mainScreen] currentMode].size) : NO)
//设备是IPHONE X
#define DEVICE_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125.0, 2436.0), [[UIScreen mainScreen] currentMode].size) : NO)
//设备是IPHONE XR
#define DEVICE_IS_IPHONE_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0, 1624.0), [[UIScreen mainScreen] currentMode].size) : NO)
//是否拥有安全区
#define WHETHER_HAVE_SAFE_AREA ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0)
//安全区高度
#define SAFE_AREA_HEIGHT [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom

// 自定义申明全局变量名称
#if defined(__cplusplus)
#define FOUNDATION_EXTERN extern "C"
#else
#define FOUNDATION_EXTERN extern
#endif

// 对象弱引用
#define YSC_WEAK_SELF __weak typeof(self) weakSelf=self;
// 对象强引用
#define YSC_STRONG_SELF __strong typeof(self) strongSelf=weakSelf;

#endif /* Macro_h */
