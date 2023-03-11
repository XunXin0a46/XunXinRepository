//
//  UIViewController+YSCSwizzle.m


#import "UIViewController+YSCSwizzle.h"

static char *viewLoadStartTimeKey = "viewLoadStartTimeKey";

@implementation UIViewController(YSCSwizzle)

//交换控制生命周期函数
+ (void)load {
    
    [UIViewController swizzleMethods:[self class] originalSelector:@selector(viewDidLoad) swizzledSelector:@selector(ysc_viewDidLoad)];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL origSel = @selector(viewDidAppear:);
        SEL swizSel = @selector(swiz_viewDidAppear:);
        [UIViewController swizzleMethods:[self class] originalSelector:origSel swizzledSelector:swizSel];
        
        SEL vcWillAppearSel=@selector(viewWillAppear:);
        SEL swizWillAppearSel=@selector(swiz_viewWillAppear:);
        [UIViewController swizzleMethods:[self class] originalSelector:vcWillAppearSel swizzledSelector:swizWillAppearSel];
        
        SEL vcDidLoadSel=@selector(viewDidLoad);
        SEL swizDidLoadSel=@selector(swiz_viewDidLoad);
        [UIViewController swizzleMethods:[self class] originalSelector:vcDidLoadSel swizzledSelector:swizDidLoadSel];
        
        SEL vcDidDisappearSel=@selector(viewDidDisappear:);
        SEL swizDidDisappearSel=@selector(swiz_viewDidDisappear:);
        [UIViewController swizzleMethods:[self class] originalSelector:vcDidDisappearSel swizzledSelector:swizDidDisappearSel];
        
        SEL vcWillDisappearSel=@selector(viewWillDisappear:);
        SEL swizWillDisappearSel=@selector(swiz_viewWillDisappear:);
        [UIViewController swizzleMethods:[self class] originalSelector:vcWillDisappearSel swizzledSelector:swizWillDisappearSel];
    });
}

- (void)ysc_viewDidLoad {
    
    [self ysc_viewDidLoad];
    [self setUpCommonHeader];
    
}

///设置视图加载开始时间
-(void)setViewLoadStartTime:(CFAbsoluteTime)viewLoadStartTime{
    
    objc_setAssociatedObject(self, &viewLoadStartTimeKey, @(viewLoadStartTime), OBJC_ASSOCIATION_COPY);
    
}

///获取加载开始时间
-(CFAbsoluteTime)viewLoadStartTime{
    
    return [objc_getAssociatedObject(self, &viewLoadStartTimeKey) doubleValue];
}

///为给定的类添加函数或交换类的实例函数
+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel{
    
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    //如果原始方法已经存在，则class_addMethod将失败
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        //origMethod和swizMethod已经存在，交换函数
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

- (void)swiz_viewDidAppear:(BOOL)animated{
    
    [self swiz_viewDidAppear:animated];
    if (self.viewLoadStartTime) {
        CFAbsoluteTime linkTime = (CACurrentMediaTime() - self.viewLoadStartTime);
      YSCLog(@" %f s--------------------ssssss   %@:速度：         %f s",self.viewLoadStartTime, self.class,linkTime  );
      #if DEBUG
      //在窗口输出打开控制器的耗时
      [WINDOW makeToast:[NSString stringWithFormat:@"速度：\n%f s",linkTime]];
      #endif

        self.viewLoadStartTime = 0;
    }
}

-(void)swiz_viewWillAppear:(BOOL)animated{
    
    [self swiz_viewWillAppear:animated];
    
}

-(void)swiz_viewDidDisappear:(BOOL)animated{
    
    [self swiz_viewDidDisappear:animated];
    
}

-(void)swiz_viewWillDisappear:(BOOL)animated{
    
    [self swiz_viewWillDisappear:animated];
    
}

-(void)swiz_viewDidLoad{
    
    self.viewLoadStartTime =CACurrentMediaTime();
    [self swiz_viewDidLoad];
    
}

///设置通用的导航栏返回按钮
- (void)setUpCommonHeader {
    //如果当前在导航堆栈上的视图控制器数量大于1或者该控制有显示他的父级控制器
    if (self.navigationController.viewControllers.count > 1 ||
        self.presentingViewController) {
        //设置按钮样式与点击事件
        __weak typeof(self) weakSelf = self;
        //初始化返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //添加按钮点击事件
        [backButton addTarget:weakSelf action:@selector(backToPreviousViewController) forControlEvents:UIControlEventTouchUpInside];
        //设置按钮框架矩形
        backButton.frame = CGRectMake(0, 0, 25.0, 40.0);//调整返回按钮点击区域大小 2019.9.2
        //设置按钮图片内间距
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        //设置常态下的按钮图片
        [backButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateNormal];
        //设置高亮状态下的
        [backButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateHighlighted];
        //设置导航栏按钮项
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        //添加导航栏按钮项到导航栏左侧
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

///返回上一个视图控制器
- (void)backToPreviousViewController {
    //控制返回的函数
    [self cancel];
    //将存储的选中的控制器名称置空(点击返回按钮时，消除导航集合视图Item的选中)
    [TestSharedInstance sharedInstance].selectControllerName = @"";
}

@end
