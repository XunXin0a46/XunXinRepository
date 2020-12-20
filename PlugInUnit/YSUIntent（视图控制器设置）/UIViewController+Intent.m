//
//  UIViewController+Intent.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/14.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "UIViewController+Intent.h"
#import "NSObject+Swizzling.h"
#import "YSUErrorCode.h"
#import <objc/runtime.h>

NSInteger const RESULT_OK = 0;
NSInteger const RESULT_CANCELED = 1;
NSInteger const RESULT_QUICK_BUY = 2;

static void * KEY_INTNET = &KEY_INTNET;
static void * KEY_IS_CLOSED = &KEY_IS_CLOSED;

@implementation UIViewController(Intent)

///根据类名打开视图控制器
- (YSUError *)openClass:(NSString *)className {
    YSUIntent*intent = [YSUIntent intentWithClassName:className];
    return [self openIntent:intent];
}

///打开目标控制器
- (YSUError *)openIntent:(YSUIntent*)intent {
    return [self openIntent:intent withRequest:NO andRequestCode:0];
}

///打开目标控制器，并传递申请码
- (YSUError *)openIntent:(YSUIntent*)intent withRequestCode:(NSInteger)requestCode {
    return [self openIntent:intent withRequest:YES andRequestCode:requestCode];
}

- (YSUError *)openIntent:(YSUIntent*)intent withRequest:(BOOL)request andRequestCode:(NSInteger)requestCode {
    //如果intent对象为空，返回异常
    if (!intent) {
        return [[YSUError alloc]initWithCode:YSU_ERROR_CLASS_NOT_FOUND andReason:LOCALIZE(@"intentIsEmpty")];
    }
    //如果YSUIntent对象中的没有类名属性或类名长度为0，返回异常
    if (!intent.className || intent.className.length == 0) {
        return [[YSUError alloc]initWithCode:YSU_ERROR_CLASS_NOT_FOUND andReason:LOCALIZE(@"classNameIsEmpty")];
    }
    //根据类名获取类
    Class class = NSClassFromString(intent.className);
    //如果类不存在，返回异常
    if (!class) {
        return [[YSUError alloc]initWithCode:YSU_ERROR_CLASS_NOT_FOUND andReason:LOCALIZE_FORMAT(@"formatClassNotFound",intent.className)];
    }
    //如果类存在，以类初始化视图控制器对象
    UIViewController *controller = [[class alloc]init];
    //如果视图控制器初始化失败并且初始化的的视图控制器是UIViewController类的实例或其子类的实例，返回异常
    if (!controller && [controller isKindOfClass:[UIViewController class]]) {
        return [[YSUError alloc]initWithCode:YSU_ERROR_CLASS_NOT_FOUND andReason:LOCALIZE_FORMAT(@"formatFailedToInitializeContrller",intent.className)];
    }
    //isRequest为YES会执行onViewController代理函数
    [intent setIsRequest:request];
    //设置申请码，用于区分接收器
    [intent setRequestCode:requestCode];
    //如果YSUIntent对象未设置代理，为其设置代理
    if (!intent.delegate) {
        [intent setDelegate:self];
    }
    //如果视图控制器对象实现了setIntent:函数，则执行setIntent:函数
    if ([controller respondsToSelector:@selector(setIntent:)]) {
        [controller setIntent:intent];
    }
    
    //执行将要打开视图控制器的函数（如果代理重写了此函数，执行从写的函数，否则执行默认的）
    return [self willOpenViewController:controller withIntent:intent];
}

///关闭当前控制器，并传回申请码RESULT_CANCELED
- (void)cancel {
    [self finishWithResultCode:RESULT_CANCELED];
}

///当前控制器完成了所有操作，关闭控制器
- (void)finish {
    [self cancel];
}

///当前控制器完成了所有操作，关闭控制器，并传递完成码
- (void)finishWithResultCode:(NSInteger)resultCode {
    [self finishWithResultCode:resultCode andResultData:nil];
}

///当前控制器完成了所有操作，关闭控制器，并传递完成码与一个存储数据的字典
- (void)finishWithResultCode:(NSInteger)resultCode andResultData:(NSDictionary *)resultData {
    //获取代理对象
    id delegate = [[self getIntent] delegate];
    //如果代理不存在，关闭当前视图控制器，结束函数
    if (!delegate){
        [self closeCurrentViewController];
        return;
    }
    //获取isRequest，isRequest为YES会执行onViewController代理函数的条件之一
    BOOL isRequest = [[self getIntent] isRequest];
    //获取申请码，用于区分接收器
    NSInteger requestCode = [[self getIntent] requestCode];
    //如果代理对象存在，并且代理对象实现了willCloseViewController:withIntent:函数
    if (delegate && [delegate respondsToSelector:@selector(willCloseViewController:withIntent:)]) {
        //执行将要关闭视图控制器的代理函数（如果代理重写了此函数，执行从写的函数，否则执行默认的）
        [delegate willCloseViewController:self withIntent:[self getIntent]];
    } else {
        //关闭当前视图控制器
        [self closeCurrentViewController];
    }
    //isRequest为YES，并且代理对象存在，并且代理实现了onViewController:ofRequestCode:finshedWithResult:andResultData:函数
    if (isRequest && delegate && [delegate respondsToSelector:@selector(onViewController:ofRequestCode:finshedWithResult:andResultData:)]){
        ///执行被打开的视图控制器已经关闭的代理函数函数
        [delegate onViewController:self ofRequestCode:requestCode finshedWithResult:resultCode andResultData:resultData];
    }
}

#pragma mark - UIViewControllerIntentDelegate
///将要打开视图控制器代理函数的默认实现
- (YSUError *)willOpenViewController:(UIViewController *)controller withIntent:(YSUIntent *)intent {
    //如果视图控制器不存在，则返回异常
    if (!controller) {
        return [YSUError errorWithCode:YSU_ERROR_NIL_VIEW_CONTROLLER andReason:LOCALIZE(@"viewControllerCannotBeNil")];
    }
    //如果以PUSH的方式打开控制器
    if (intent.method == OPEN_METHOD_PUSH){
        //如果视图控制器未嵌入导航控制器,则返回异常
        if(!self.navigationController){
            return [[YSUError alloc]initWithCode:YSU_ERROR_CLASS_NOT_FOUND andReason:LOCALIZE(@"navigationControllerIsEmpty")];
        }
        //将视图控制器推到导航控制器上时是否隐藏屏幕底部的工具栏
        controller.hidesBottomBarWhenPushed = intent.hidesBottomBarWhenPushed;
        //是否要作为导航控制器的根控制器,如果YES，接收器不可以是导航控制器
        if (intent.useNavigationToPush) {
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
            
            [self.navigationController pushViewController:navigationController animated:intent.animated];
        } else {
            [self.navigationController pushViewController:controller animated:intent.animated];
        }
        //返回无异常的异常类对象
        return [YSUError ok];
        
    }
    //如果以POP的方式打开控制器
    else if (intent.method == OPEN_METHOD_POP) {
        //是否要作为导航控制器的根控制器
        if (intent.useNavigationToPush) {
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
            
            UIImage *image = [YSUUtils imageWithColor:HEXCOLOR(0xCBCBCB) size:CGSizeMake(SCREEN_WIDTH, 0.5)];
            //导航栏是否半透明
            navigationController.navigationBar.translucent = NO;
            //用于导航栏的阴影图像
            [navigationController.navigationBar setShadowImage:image];
            //设置导航栏背景图片为一个空的image，这样就透明了
            [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
            //定义此视图控制器以模式显示时将使用的表示样式
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            //模态地呈现视图控制器
            [self presentViewController:navigationController animated:YES completion:NULL];
            //返回无异常的异常类对象
            return [YSUError ok];
        }
        //当视图控制器或其后代之一呈现视图控制器时是否覆盖该视图控制器的视图
        controller.definesPresentationContext = YES;
        //定义此视图控制器以模式显示时将使用的表示样式
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        //模态地呈现视图控制器
        [self presentViewController:controller animated:intent.animated completion:NULL];
        //返回无异常的异常类对象
        return [YSUError ok];
        
    }
    //如果以SHOW的方式打开控制器
    else if (intent.method == OPEN_METHOD_SHOW) {
        //定义此视图控制器以模式显示时将使用的表示样式，其中内容显示在另一个视图控制器的内容上。
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        //显示视图控制器时要使用的转换样式
        //当视图控制器出现时，当前视图将淡出，而新视图将同时淡入。当视图控制器关闭时，使用类似类型的交叉淡入来返回原始视图。
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //模态地呈现视图控制器
        [self presentViewController:controller animated:intent.animated completion:NULL];
        //返回无异常的异常类对象
        return [YSUError ok];
    }
    //返回未知错误类型的异常类对象
    return [YSUError unknown];
}

///被打开的视图控制器已经关闭的默认实现
- (void)onViewController:(UIViewController *)viewController ofRequestCode:(NSInteger)requestCode finshedWithResult:(NSInteger)resultCode andResultData:(YSUIntent *)data{
    
}

///将要关闭视图控制器的代理函数默认实现
- (void)willCloseViewController:(UIViewController*)viewController withIntent:(YSUIntent *)intent{
    //如果导航控制器对象存在，并且导航控制器对象堆栈中视图控制器的数量大于1
    if (viewController.navigationController &&
        viewController.navigationController.viewControllers.count > 1) {
        //获取当前导航控制器对象
        UINavigationController *navigationController = viewController.navigationController;
        //获取当前控制器的所有子视图控制器
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:navigationController.childViewControllers];
        //判断当前控制器在导航堆栈中不在最上面时
        if(![viewControllers.lastObject isEqual:viewController]){
            if([viewController respondsToSelector:@selector(setClosed:)]) {
                //设置关闭状态为YES（控制器是不可见的）
                [viewController setClosed:YES];
            }
        }
        else{
            //弹出当前视图控制器
            [navigationController popViewControllerAnimated:intent.animated];
        }
    }
    //当前视图控制器是通过模态显示时
    else if (viewController.presentingViewController) {
        //模态的关闭当前视图控制器
        [viewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - Close current view controller.
///关闭当前视图控制器
- (void)closeCurrentViewController {
    //使视图放弃第一个响应程序状态。
    [self.view endEditing:YES];
    //当前视图控制器是通过模态显示时
    if (self.presentingViewController) {
        //模态的关闭当前视图控制器
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    //当前视图控制器是通过嵌入导航控制器中显示时
    else if (self.navigationController) {
        //获取导航控制器对象
        UINavigationController *navigationController = self.navigationController;
        //获取当前控制器的所有子视图控制器
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:navigationController.childViewControllers];
        //判断当前控制器在导航堆栈中的位置
        if ([viewControllers indexOfObject:self] != (viewControllers.count - 1)) {
            //不在导航堆栈的最上面时
            if([self respondsToSelector:@selector(setClosed:)]) {
                //设置关闭状态为YES（控制器是不可见的）
                [self setClosed:YES];
            }
        } else {
            //在导航堆栈的最上面时，弹出当前视图控制器
            [navigationController popViewControllerAnimated:YES];
        }
    }

}

#pragma mark - Getters and setters

///设置YSUIntent对象
- (void)setIntent:(YSUIntent *)intent {
    objc_setAssociatedObject(self, KEY_INTNET, intent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///获取YSUIntent对象
- (YSUIntent *)getIntent {
    return objc_getAssociatedObject(self, KEY_INTNET);
}

///设置关闭（是否可见状态）
- (void)setClosed:(BOOL)closed {
    objc_setAssociatedObject(self, KEY_IS_CLOSED, @(closed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///是否已经关闭（是否处于不可见的位置）
- (BOOL)isClosed {
    return [objc_getAssociatedObject(self, KEY_IS_CLOSED) boolValue];
}

@end
