//
//  UIViewController+YSURequestManager.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "UIViewController+YSURequestManager.h"

//关联控制器请求管理器的key
static void* YSP_KEY_VIEW_CONTROLLER_REQUEST_MANAGER = &YSP_KEY_VIEW_CONTROLLER_REQUEST_MANAGER;

@implementation UIViewController(YSURequestManager)

///添加请求
- (void)addRequest:(YSURequest *)request{
    [[self yspRequestManager] addRequest:request withDelegate:self];
}

#pragma mark - YSURequestDelegate

///请求成功的默认实现
- (void)onRequestSucceed:(NSDictionary *)response ofWhat:(NSInteger)what {
    
}

///请求失败的默认实现
- (void)onRequestFailed:(YSURequestError *)error ofWhat:(NSInteger)what {
    
}

///请求进度的默认实现
- (void)onProgress:(YSURequestProgress *)progress ofWhat:(NSInteger)what {
    
}

///返回视图的请求进度视图
- (MBProgressHUD *)progressViewForView:(UIView *)view {
    //返回一个枚举器对象，按相反顺序访问数组中的每个对象
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            return (MBProgressHUD *)subview;
        }
    }
    return nil;
}

///请求开始发送执行的函数默认实现
- (void)onRequestStart:(YSURequest *)request {
    //判断是否显示加载图标
    if (request.alarm) {
        //更新进度对话框
        [self updateProgressDialog];
    }
}

- (void)onRequestFinished:(YSURequest *)request {
    //判断是否显示加载图标
    if (request.alarm) {
        //更新进度对话框
        [self updateProgressDialog];
    }
}

///更新进度对话框
- (void)updateProgressDialog {
    //获取请求对象数组
    NSArray *alarmRequests = [[self yspRequestManager] getAlarmRequests];
    NSString *message = nil;
    YSURequest *lastRequest = alarmRequests.lastObject;
    message = lastRequest.message;
    // 原条件判断alarmRequests.count > 0 && ![self progressViewForView:self.view] && self.view.window
    if(alarmRequests.count > 0 && ![self progressViewForView:self.view]){
        //显示一个简单的HUD窗口
        [MBProgressHUD showCustomHUDAddedTo:self.view withTitle:message image:[UIImage imageNamed:@"ic_loading"] animated:YES];
        
    } else {
        //隐藏HUD窗口
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //由于在用户断网的情况下，执行完showHUD之后，会立刻执行hideHUD方法，根据产品经理反馈，这种情况用户体验不好，
        //所以在此延迟0.3秒HUD显示时间后，再隐藏HUD。
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        //});
    }
    
}

///懒加载初始化请求管理器
- (YSURequestManager *)yspRequestManager {
    //根据key获取控制器关联的请求管理器
    YSURequestManager *requestManager = objc_getAssociatedObject(self, YSP_KEY_VIEW_CONTROLLER_REQUEST_MANAGER);
    //如果控制器没有关联的请求管理器
    if(!requestManager){
        //初始化请求管理器
        requestManager = [[YSURequestManager alloc] init];
        //设置控制器与请求管理器关联
        [self setRequestManager:requestManager];
    }
    //返回请求管理器对象
    return requestManager;
}

//设置控制器与请求管理器关联
- (void)setRequestManager:(YSURequestManager *)manager {
    objc_setAssociatedObject(self, YSP_KEY_VIEW_CONTROLLER_REQUEST_MANAGER, manager, OBJC_ASSOCIATION_RETAIN);
}

@end
