//
//  GestureRecognizerViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/9.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "GestureRecognizerViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "TestKMGestureRecognizerViewController.h"

@interface GestureRecognizerViewController ()<UIGestureRecognizerDelegate>

//测试缩放与旋转的图片视图
@property(nonatomic, strong) UIImageView *imageView;
//上一次缩放手势的比例因子
@property(nonatomic, assign)  CGFloat lastRecognizerScale;
//视图最大缩放比例
@property(nonatomic, assign)  CGFloat viewMaxScale ;
//视图最小缩放比例
 @property(nonatomic, assign) CGFloat viewMinScale ;
//上一次旋转手势的旋转值
 @property(nonatomic, assign) CGFloat lastRotationValue;
//图片数组
@property(nonatomic, copy) NSMutableArray *imageNameArray;
//当前图片的索引
@property(nonatomic, assign) NSInteger currentIndex;


@end

@implementation GestureRecognizerViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手势识别";
    [self initScale];
    [self createUI];
}

- (void)initScale{
    //初始化上一次手势的比例因子，默认为1
    self.lastRecognizerScale = 1;
    //初始化视图最大缩放比例，默认为2
    self.viewMaxScale = 2;
    //初始化视图最小缩放比例，默认为1
    self.viewMinScale = 1;
    //初始化图片名称数组
    self.imageNameArray = [[NSMutableArray alloc]initWithObjects:@"tian_kong_long",@"yi_shen_long",@"ju_shen_bing", nil];
    //UINavigationController+FDFullscreenPopGesture设置导航栏显示
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)createUI{
    
    ///平移手势识别器测试按钮
    //初始化按钮
    UIButton *testCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮框架矩形
    testCodeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 75 / 2, CGRectGetMinY(self.view.frame) + HEAD_BAR_HEIGHT, 75, 30);
    //按钮背景颜色
    testCodeButton.backgroundColor = [UIColor blueColor];
    //按钮标题字体大小
    testCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //按钮标题
    [testCodeButton setTitle:@"测试代码" forState:UIControlStateNormal];
    //按钮标题颜色
    [testCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //按钮添加点击事件
    [testCodeButton addTarget:self action:@selector(testCode) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮到视图
    [self.view addSubview:testCodeButton];
    
    ///点击手势识别器测试视图
    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 100 / 2, CGRectGetMaxY(testCodeButton.frame) + 20, 100, 100)];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    
    ///初始化点击手势识别器
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleClickEvent)];
    //要识别手势的点击次数
    singleClick.numberOfTapsRequired = 1;
    //手势被识别所需的手指数
    singleClick.numberOfTouchesRequired = 1;
    //添加点击手势识别器
    [testView addGestureRecognizer:singleClick];
    
    ///初始化点击手势识别器
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClickEvent)];
    //要识别手势的点击次数
    doubleClick.numberOfTapsRequired = 2;
    //手势被识别所需的手指数
    doubleClick.numberOfTouchesRequired = 1;
    //添加点击手势识别器
    [testView addGestureRecognizer:doubleClick];
    
    //双击手势识别失败后识别单击手势，没有识别失败为双击手势
    [singleClick requireGestureRecognizerToFail:doubleClick];
    
    ///初始化长按手势识别器
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvent)];
    longPress.minimumPressDuration = 1.0;
    //添加长按手势识别器
    [testView addGestureRecognizer:longPress];
    
    ///缩放、旋转、轻扫手势识别器测试图片视图
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tian_kong_long"]];
    //设置框架矩形
    self.imageView.frame = CGRectMake(0, CGRectGetMaxY(testView.frame) + 50, CGRectGetWidth(self.view.frame), 200);
    //设置内容的显示方式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //设置与用户进行交互，UIImageView默认为NO
    self.imageView.userInteractionEnabled = YES;
    //添加UIImageView到视图
    [self.view addSubview:self.imageView];
    
    ///初始化缩放手势识别器
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchEvent:)];
    //添加缩放手势识别器
    [self.imageView addGestureRecognizer:pinch];
    
    ///初始化旋转手势识别器
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationEvent:)];
    //添加旋转手势识别器
    [self.imageView addGestureRecognizer:rotation];

    ///初始化轻扫手势识别器（右侧轻扫，每个方向要单独添加）
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeEvent:)];
    //轻扫的方向
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    //轻扫手势需要的手指数
    rightSwipe.numberOfTouchesRequired = 2;
    //设置代理
    rightSwipe.delegate = self;
    //添加轻扫手势
    [self.imageView addGestureRecognizer:rightSwipe];
    
    ///初始化轻扫手势识别器（左侧轻扫，每个方向要单独添加）
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeEvent:)];
    //轻扫的方向
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    //轻扫手势需要的手指数
    leftSwipe.numberOfTouchesRequired = 2;
    //设置代理
    leftSwipe.delegate = self;
    //添加轻扫手势
    [self.imageView addGestureRecognizer:leftSwipe];
    
    ///边缘侧滑手势识别器测试图片视图
    UIImageView *screenEdgeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 10, CGRectGetMaxY(self.imageView.frame) + 40, 10, 200)];
    screenEdgeImageView.userInteractionEnabled = YES;
    screenEdgeImageView.image = [UIImage imageNamed:@"宇宙"];
    [self.view addSubview:screenEdgeImageView];
    
    ///初始化边缘侧滑手势识别器
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenEdgeEvent:)];
    //设置手势可接受的起始边
    screenEdgePanGestureRecognizer.edges = UIRectEdgeRight;
    //添加边缘侧滑手势识别器
    [screenEdgeImageView addGestureRecognizer:screenEdgePanGestureRecognizer];
    
    ///初始化边缘侧滑手势识别器
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bottomButton];
    bottomButton.layer.cornerRadius = 22.0;
    bottomButton.layer.masksToBounds = YES;
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
    bottomButton.backgroundColor = HEXCOLOR(0xF56456);
    [bottomButton setTitle:@"查看自定义手势" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(customGesture) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(- 10);
        make.left.equalTo(self).offset(10 * 2.0);
        make.right.equalTo(self).offset(-10 * 2.0);
        make.height.mas_equalTo(44);
    }];
}

///测试按钮点击(平移手势)
- (void)testCode{
    //实现提示
    [self.view makeToast:@"可以开始侧滑返回" duration:1 position:CSToastPositionTop];
    //初始化平移手势识别器对象
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    //可接触视图以识别此手势的最大手指数
    panGestureRecognizer.maximumNumberOfTouches = 1;
    //当前控制器负责从导航堆栈弹出顶视图控制器的手势识别器所附加到视图添加平移手势
    [self.navigationController.interactivePopGestureRecognizer.view addGestureRecognizer:panGestureRecognizer];
    //利用KVC获取手势数组
    NSArray *internalTargets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
    //获取这个手势对象
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    //获取内部handleNavigationTransition:函数编号
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    //设置代理
    panGestureRecognizer.delegate = self;
    //添加手势
    [panGestureRecognizer addTarget:internalTarget action:internalAction];
}

///单击事件
- (void)singleClickEvent{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"单击响应" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"Top YES Button");
    }];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}

///双击事件
- (void)doubleClickEvent{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"双击响应" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"Top YES Button");
    }];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}

///长按事件
- (void)longPressEvent{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"长按响应" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"Top YES Button");
    }];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}

///缩放事件
- (void)pinchEvent:(UIPinchGestureRecognizer *)recognizer{
    //判断手势识别器的当前状态
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        case UIGestureRecognizerStateChanged://缩放改变
        {
            //获取当前视图的缩放比例
            CGFloat currentViewScale = [[self.imageView.layer valueForKeyPath:@"transform.scale"] floatValue];
            //记录两个触摸点的比例因子变化(加1使这个新产生的比例因子大于0)，这个新产生的比例因子将作为每次调用次函数时，视图X与Y的缩放值
            CGFloat newRecognizerScale = recognizer.scale - self.lastRecognizerScale + 1;
            //限制视图的最大缩放值
            newRecognizerScale = MIN(newRecognizerScale, self.viewMaxScale / currentViewScale);
            //限制视图的最小缩放值
            newRecognizerScale = MAX(newRecognizerScale, self.viewMinScale / currentViewScale);
            //设置当前视图的缩放
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, newRecognizerScale, newRecognizerScale);
            //记录本次两个触摸点的比例因子的值作为上次两个触摸点的比例因子
            self.lastRecognizerScale = recognizer.scale;
        }
            break;
        case UIGestureRecognizerStateEnded://缩放结束
        {
            //每次缩放手势结束时，将记录的上一次手势的比例因子置为1
            self.lastRecognizerScale = 1;
        }
            break;

        default:
            break;
    }
}

///旋转事件

- (void)rotationEvent:(UIRotationGestureRecognizer *)rotationGestureRecognizer{

    switch (rotationGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan://旋转开始
        case UIGestureRecognizerStateChanged://旋转改变
        {
            //每次的设置图片的旋转值基于上次结束旋转图片所处位置的旋转值进行计算
            CGFloat newRotationValue = rotationGestureRecognizer.rotation + self.lastRotationValue;
            //获取附加手势的视图
            UIView *view = rotationGestureRecognizer.view;
            //获取视图的layer
            CALayer *layer = view.layer;
            //3D旋转效果
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;

            rotationAndPerspectiveTransform.m34 = 1.0 / -500;

            //围绕向量（x，y，z）按角度弧度旋转t并返回结果。如果向量的长度为零，则行为未定义
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,newRotationValue, 1.0f, 0.0f, 0.0f);
            //设置层内容的转换
            layer.transform = rotationAndPerspectiveTransform;
        }
            break;
        case UIGestureRecognizerStateEnded://旋转结束
        {
            //每次旋转手势结束时，将记录的上一次手势结束时图片所处位置的旋转值
            self.lastRotationValue += rotationGestureRecognizer.rotation;
        }
            break;
        default:
            break;
    }
}


///轻扫事件
- (void)swipeEvent:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
    switch (swipeGestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            //右侧轻扫
            [self transitionAnimation:0];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            //左侧轻扫
            [self transitionAnimation:1];
            break;
        default:
            break;
    }
}

///轻扫旋转动画
- (void)transitionAnimation:(BOOL)isNext{
    
    [UIView animateWithDuration:1.0f animations:^{
        //获取图片视图图层
        CALayer *layer = self.imageView.layer;
        //3D旋转效果
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        //矩阵，值大概在1.0 / -500到1.0 / -1000间效果不错
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        //判断轻扫方向
        if(isNext){
            //左侧轻扫
            //围绕向量（x，y，z）按角度弧度旋转t并返回结果。如果向量的长度为零，则行为未定义
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,-M_E, 0.0f, 1.0f, 0.0f);
        }else{
            //右侧轻扫
            //围绕向量（x，y，z）按角度弧度旋转t并返回结果。如果向量的长度为零，则行为未定义
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform,M_E, 0.0f, 1.0f, 0.0f);
        }
        //设置层内容的转换
        layer.transform = rotationAndPerspectiveTransform;
        
    }completion:^(BOOL finished) {
        // 调用得到图片的方法
        self.imageView.image = [self getImage:isNext];
        // 重置图片视图层的transform，否则transform改变后会影响左右轻扫
        self.imageView.layer.transform = CATransform3DIdentity;
    }];
}

///轻扫获取图片
- (UIImage *)getImage:(BOOL)isNext{
    
    if (isNext)
    {
        // 左侧轻扫，下一张
        self.currentIndex = (self.currentIndex + 1) % self.imageNameArray.count;
    }else
    {
        // 右侧轻塞，上一张
        self.currentIndex = (self.currentIndex - 1 + self.imageNameArray.count) % self.imageNameArray.count;
    }
    //获取数组中的图片名称
    NSString *imageName = self.imageNameArray[self.currentIndex];
    //返回图片
    return [UIImage imageNamed:imageName];
}

///边缘侧滑事件
- (void)screenEdgeEvent:(UIPanGestureRecognizer *)gestureRecognizer{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
     if(gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged ){
         [UIView animateWithDuration:0.5 animations:^{
             imageView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 40, [UIScreen mainScreen].bounds.size.width, 200);
         }];
     }
}

///查看自定义手势
- (void)customGesture{
    TestKMGestureRecognizerViewController *controller = [[TestKMGestureRecognizerViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

//因为使用了FDFullscreenPopGesture，所以这里禁用了pop手势，方便添加自己的测试手势
//UINavigationController+FDFullscreenPopGesture设置交互式pop手势是否被禁用
- (BOOL)fd_interactivePopDisabled {

    return YES;
}


#pragma mark -- UIGestureRecognizerDelegate

///询问代理手势识别器是否应开始解释触摸。
//防止假死
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    // 当前控制器为根控制器不允许手势执行
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    // 如果这个push、pop动画正在执行（私有属性）不允许手势执行
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}


@end
