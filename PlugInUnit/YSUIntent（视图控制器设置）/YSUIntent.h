//
//  YSUIntent.h
//  YiShop
//
//  Created by 宗仁 on 2016/11/14.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSUIntent;
@class YSUError;

@protocol UIViewControllerIntentDelegate <NSObject>

///将要关闭视图控制器
- (void)willCloseViewController:(__kindof UIViewController *)viewController withIntent:(YSUIntent *)intent;
///将要打开视图控制器
- (YSUError*)willOpenViewController:(__kindof UIViewController *)viewController withIntent:(YSUIntent *)intent;
///被打开的视图控制器已经关闭
- (void)onViewController:(__kindof UIViewController *)viewController ofRequestCode:(NSInteger)requestCode finshedWithResult:(NSInteger)resultCode andResultData:(NSDictionary *)resultData;

@end

///打开视图控制器的方式
typedef NS_ENUM(NSInteger,OpenViewControllerMethod){
    OPEN_METHOD_PUSH,
    OPEN_METHOD_POP,
    OPEN_METHOD_SHOW
};

@interface YSUIntent : NSObject

@property (nonatomic, assign) BOOL useNavigationToPush;//是否作为导航控制器的根控制
@property (nonatomic, assign) BOOL hidesBottomBarWhenPushed;//Push时隐藏底部栏
@property (nonatomic, assign) BOOL isRequest;//isRequest为YES会执行onViewController代理函数的条件之一
@property (nonatomic, assign) NSInteger requestCode;//申请码，用于区分接收器
@property (nonatomic, assign) BOOL animated;//是否动画
@property (nonatomic, strong) NSString *className;//类名
@property (nonatomic, assign) OpenViewControllerMethod method;//打开视图控制器的方式
@property (nonatomic, weak) id<UIViewControllerIntentDelegate> delegate;//设置代理

///获取存储数据的字典对象
- (NSDictionary *)getIntentData;
///为存储数据的字典设置键值
- (void)setObject:(id)object forKey:(NSString *)key;
///根据键获取存储在字典的数据
- (id)objectForKey:(NSString *)key;
///初始化函数
- (instancetype)initWithClassName:(NSString *)className;
///初始化函数
+ (instancetype)intentWithClassName:(NSString *)className;

@end
