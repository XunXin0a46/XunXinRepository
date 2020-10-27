// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UINavigationController+FDFullscreenPopGesture.h"
#import <objc/runtime.h>

@interface _FDFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _FDFullscreenPopGestureRecognizerDelegate

///手势识别器是否应该开始（询问代理手势识别器是否应该开始解释触摸）
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    // 译：当没有视图控制器被推入导航堆栈时忽略
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    // 译：当活动视图控制器不允许交互式弹出时忽略
    // 获取当前当前导航控制器堆栈中的顶部控制器
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    //判断改控制器是否禁用了交互式弹出
    if (topViewController.fd_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    // 译：当起始位置超过左边缘允许的最大初始距离时忽略
    // 获取手势在给定视图中的起始位置的点
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    // 获取开始交互式pop手势时允许的最大左边缘初始距离
    CGFloat maxAllowedInitialDistance = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    // 如果开始交互式pop手势时允许的最大左边缘初始距离大于0并且手势开始X轴方向的点大于最大左边缘初始距离
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }

    // Ignore pan gesture when the navigation controller is currently in transition.
    // 译：当导航控制器当前处于转换状态时忽略平移手势
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    // 译：当手势从相反的方向开始时，防止调用处理程序
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end

typedef void (^_FDViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (FDFullscreenPopGesturePrivate)

@property (nonatomic, copy) _FDViewControllerWillAppearInjectBlock fd_willAppearInjectBlock;

@end

@implementation UIViewController (FDFullscreenPopGesturePrivate) //私有的全屏弹出手势

+ (void)load
{
    //保证方法替换只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取类对象
        Class class = [self class];
        //获取viewWillAppear的函数编号
        SEL originalSelector = @selector(viewWillAppear:);
        //获取fd_viewWillAppear的函数编号
        SEL swizzledSelector = @selector(fd_viewWillAppear:);
        //获取当前类对象的实例函数viewWillAppear:
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        //获取当前类对象的实例函数fd_viewWillAppear:
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        //class_addMethod:如果发现方法已经存在，会返回失败，也可以用来做检查用，这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
        //向当前类的viewWillAppear:函数添加新的fd_viewWillAppear函数的实现，并添加描述方法参数和返回类型的字符串
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        //判断是否添加成功
        if (success) {
            //如果返回成功:则说明被替换方法没有存在，也就是被替换的方法没有被实现，需要先把这个方法实现，class_replaceMethod本身会尝试调用class_addMethod和method_setImplementation
            //替换当前类的fd_viewWillAppear:方法实现为viewWillAppear:方法的实现
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            //如果返回失败:则说明被替换方法已经存在.直接将两个方法的实现交换
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fd_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    // 译：转到最初实现
    [self fd_viewWillAppear:animated];
    
    if (self.fd_willAppearInjectBlock) {
        self.fd_willAppearInjectBlock(self, animated);
    }
}

- (_FDViewControllerWillAppearInjectBlock)fd_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFd_willAppearInjectBlock:(_FDViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(fd_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (FDFullscreenPopGesture)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    // 译：注入"-pushViewController:animated:"
    //保证方法替换只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取类对象
        Class class = [self class];
        //获取pushViewController:animated:的函数编号
        SEL originalSelector = @selector(pushViewController:animated:);
        //获取fd_pushViewController:animated:的函数编号
        SEL swizzledSelector = @selector(fd_pushViewController:animated:);
        //获取当前类对象的实例函数pushViewController:animated:
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        //获取当前类对象的实例函数fd_pushViewController:animated::
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        //class_addMethod:如果发现方法已经存在，会返回失败，也可以用来做检查用，这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
        //向当前类的pushViewController:animated:函数添加新的fd_pushViewController:animated:函数的实现，并添加描述方法参数和返回类型的字符串
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            //如果返回成功:则说明被替换方法没有存在，也就是被替换的方法没有被实现，需要先把这个方法实现，class_replaceMethod本身会尝试调用class_addMethod和method_setImplementation
            //替换当前类的fd_pushViewController:animated:方法实现为pushViewController:animated:方法的实现
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            //如果返回失败:则说明被替换方法已经存在.直接将两个方法的实现交换
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([self isKindOfClass:NSClassFromString(@"MFMessageComposeViewController")]) {
        [self fd_pushViewController:viewController animated:animated];
        return;
    }
    //如果当前控制器负责从导航堆栈弹出顶视图控制器的手势识别器所附加到视图的手势识别器对象数组不包含fd_fullscreenPopGestureRecognizer平移手势对象
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fd_fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        // 译：添加我们自己的手势识别器到板载屏幕边缘平移手势识别器的附加位置。
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];

        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        // 译：将手势事件转发到板载手势识别器的私有处理程序。
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.fd_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
        [self.fd_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];

        // Disable the onboard gesture recognizer.
        // 译：禁用板载手势识别器。
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Handle perferred navigation bar appearance.
    // 译：处理改变导航栏外观
    [self fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    // 译：转到主要实现。
    if (![self.viewControllers containsObject:viewController]) {
        [self fd_pushViewController:viewController animated:animated];
    }
}

///如果需要，设置基于视图控制器的导航栏外观
- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    //如果不可以自己控制导航栏的外观，直接返回
    if (!self.fd_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _FDViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            //设置导航栏是否隐藏
            [strongSelf setNavigationBarHidden:viewController.fd_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    // 译：安装程序将显示注入块到出现的视图控制器。设置消失的视图控制器，因为不是每个视图控制器都通过push被添加到堆栈中，也许通过"-setViewControllers:"
    appearingViewController.fd_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.fd_willAppearInjectBlock) {
        disappearingViewController.fd_willAppearInjectBlock = block;
    }
}

///懒加载弹出手势识别器代理
- (_FDFullscreenPopGestureRecognizerDelegate *)fd_popGestureRecognizerDelegate
{
    _FDFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);

    if (!delegate) {
        delegate = [[_FDFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

///懒加载全屏弹出手势识别器对象
- (UIPanGestureRecognizer *)fd_fullscreenPopGestureRecognizer
{
    //获取与self关联的平移手势对象
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    //如果与self关联的平移手势对象不存在
    if (!panGestureRecognizer) {
        //初始化平移手势对象
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        //可接触视图以识别此手势的最大手指数为1
        panGestureRecognizer.maximumNumberOfTouches = 1;
        //设置平移手势对象与self的关联
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    //返回平移手势对象
    return panGestureRecognizer;
}

///返回视图控制器是否可以自己控制导航栏的外观
- (BOOL)fd_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

///设置视图控制器是否可以自己控制导航栏的外观
- (void)setFd_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(fd_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (FDFullscreenPopGesture) // - 全屏弹出手势

///是否禁用交互式弹出
- (BOOL)fd_interactivePopDisabled
{
    //加此行代码是为了防止有输入框并且输入框为第一响应者的情况下，侧滑或者左上角返回上一页面当前页面UI下移动问题（lyutn）
    [self.view endEditing:YES];
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

///设置是否允许交互式弹出
- (void)setFd_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(fd_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///返回是否隐藏导航栏
- (BOOL)fd_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

///设置导航栏是否隐藏
- (void)setFd_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(fd_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
    //判断是单精度或双精度浮点数
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

///开始交互式pop手势时允许的最大左边缘初始距离。默认为0，这意味着它将忽略此限制。
- (void)setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    //获取函数编号
    SEL key = @selector(fd_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    //以函数编号为key设置最大左边缘初始距离的关联
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
