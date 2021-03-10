//
//  TestUIViewViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/4.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestUIViewViewController.h"
#import "TestCommonViewViewController.h"
#import "ShoppingCartIconView.h"
#import "AnimationManager.h"

///测试hitTest:(CGPoint)point withEvent:(UIEvent *)event函数的自定义视图

@interface testView : UIView

@property (nonatomic, strong)UIButton *testCodeButton;//测试代码按钮

@end

@implementation testView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.testCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.testCodeButton.backgroundColor = [UIColor blueColor];
        self.testCodeButton.alpha = 0.5;
        self.testCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.testCodeButton setTitle:@"测试代码" forState:UIControlStateNormal];
        [self.testCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.testCodeButton];
        
        [self.testCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(-35);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(150, 55));
        }];
    }
    return self;
}

//寻找最佳响应者
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIButton class]]) {
        return view;
    }else if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.testCodeButton convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.testCodeButton.bounds, newPoint)) {
            view = self.testCodeButton;
        }
    }
    return view;
}

@end


@interface TestUIViewViewController ()

@property (nonatomic, strong) UIView *redView;//红色视图
@property (nonatomic, strong) UIView *greenView;//绿色视图
@property (nonatomic, strong) UIView *yellowView;//黄色视图
@property (nonatomic, strong) testView *tview;//点击范围视图
@property (nonatomic, strong) ShoppingCartIconView *cartView;//购物车图标视图
@property (nonatomic, strong) UIButton *plusButton;//加入购物车按钮
@property (nonatomic, strong) UILabel *numLabel;//购物车角标增加Label

@end

@implementation TestUIViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏标题视图
    [self createNavigationTitleView:@"测试视图"];
    //设置导航栏右侧按钮
    [self setrightBarButton];
    //创建测试视图
    [self createUI];
    //测试动画代码块
    [self testAnimationBlock];
    //创建购物车图标视图
    [self createCartView];
}

///设置导航栏右侧按钮
- (void)setrightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"视图通用样式" style:UIBarButtonItemStylePlain target:self action:@selector(openCommonView)];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

///前往视图通用样式控制器
- (void)openCommonView{
    TestCommonViewViewController *commonViewViewController = [[TestCommonViewViewController alloc]init];
    [self.navigationController pushViewController:commonViewViewController animated:YES];
}

///---------------------------------------- UIView代码测试区 -------------------------------------

///创建测试视图
- (void)createUI{
    
    //创建按钮
    NSArray *buttonTilteAry = @[@"红色至顶",@"绿下插黄",@"红绿交换"];
    NSMutableArray *buttonAry = [[NSMutableArray alloc]initWithCapacity:buttonTilteAry.count];
    //遍历按钮标题数组
    for (int i = 0; i < buttonTilteAry.count; i++) {
        //创建按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTilteAry[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        //获取数组中最后一个按钮对象
        UIButton *lastButton = [buttonAry lastObject];
        //创建第一个按钮的布局
        if(lastButton == nil){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(100);
                make.left.equalTo(self.view).offset(20);
                make.size.mas_equalTo(CGSizeMake(75, 35));
            }];
        }else{
            //其他按钮的布局
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastButton.mas_top);
                make.left.equalTo(lastButton.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(75, 35));
            }];
        }
        //存放按钮对象到数组
        [buttonAry addObject:button];
    }
    
    //创建视图
    //红色视图
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, 150, 150)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    //绿色视图
    self.greenView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMinY(self.redView.frame) + 30, 150, 150)];
    self.greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.greenView];
    
    //黄色视图
    self.yellowView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMinY(self.redView.frame) + 15, 150, 150)];
    self.yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.yellowView];
    
    //点击范围视图
    self.tview = [[testView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 150 - 20, CGRectGetMinY(self.redView.frame) + 35, 150, 150)];
    self.tview.backgroundColor = [UIColor redColor];
    [self.tview.testCodeButton addTarget:self action:@selector(testCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tview];
}


///移动指定的子视图，使其显示在其同级视图的顶部
- (void)testBringSubviewToFront:(UIView *)view{
    [self.view bringSubviewToFront:view];
}

///在视图层次结构中的另一个视图下方插入视图
- (void)testInsertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview{
    
    [self.view insertSubview:view belowSubview:siblingSubview];
}

///交换视图层级
- (void)testexchangeSubviewAtIndex:(UIView *)view1 andView:(UIView *)view2{
    NSInteger index1 = 0;
    NSInteger index2 = 0;
    for (int i = 0; i < self.view.subviews.count; i++) {
        if([self.view.subviews[i] isEqual:view1]){
            index1 = i;
        }else if([self.view.subviews[i] isEqual:view2]){
            index2 = i;
        }
    }
    if(index1 != index2){
        [self.view exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    }
}

///按钮的点击事件
- (void)buttonClick:(UIButton *)button{
    if([button.titleLabel.text isEqualToString:@"红色至顶"]){
        [self testBringSubviewToFront:self.redView];
    }else if([button.titleLabel.text isEqualToString:@"绿下插黄"]){
        [self testInsertSubview:self.yellowView belowSubview:self.greenView];
    }else if([button.titleLabel.text isEqualToString:@"红绿交换"]){
        [self testexchangeSubviewAtIndex:self.redView andView:self.greenView];
    }
}

///测试按钮点击
- (void)testCode{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"响应了点击" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"Top YES Button");
    }];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}

///测试动画代码块
- (void)testAnimationBlock{
    //创建测试动画的标签
    UILabel *animationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.view.frame) / 2, 200, 20)];
    animationLabel.textColor = [UIColor whiteColor];
    animationLabel.backgroundColor = [UIColor blueColor];
    animationLabel.text = @"我出现后就准备跑路了";
    animationLabel.textAlignment = NSTextAlignmentCenter;
    animationLabel.layer.cornerRadius = 8.0;
    animationLabel.layer.masksToBounds = YES;
    animationLabel.alpha = 0.0;
    [self.view addSubview:animationLabel];
    
    [UIView animateWithDuration:3.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animationLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            CGRect newAnimationLabelFrame = animationLabel.frame;
            newAnimationLabelFrame.origin.x = CGRectGetMaxX(self.view.frame) - 200 - 20;
            animationLabel.frame = newAnimationLabelFrame;
        } completion:^(BOOL finished) {
            animationLabel.text = @"我就跑路到这里吧";
        }];
    }];
}

///创建购物车图标视图
- (void)createCartView{
    
    //加入购物车按钮
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusButton setImage:[UIImage imageNamed:@"btn_plus_normal"] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"btn_plus_disabled"]
                     forState:UIControlStateSelected];
    self.plusButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.plusButton];
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.mas_equalTo(44.0);
        make.height.mas_equalTo(44.0);
    }];
    
    //购物车图标视图
    self.cartView = [[ShoppingCartIconView alloc] init];
    [self.view addSubview:self.cartView];
    [self.cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10 * 3.0 - 30);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    //购物车角标增加Label
    self.numLabel = [[UILabel alloc] init];
    self.numLabel.backgroundColor = [UIColor clearColor];
    self.numLabel.textColor = [UIColor redColor];
    self.numLabel.text = @"+1";
    self.numLabel.alpha = 0;
    self.numLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cartView.mas_right).offset(-7);
        make.bottom.equalTo(self.cartView.mas_top).offset(10);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
}

///加入购物车按钮点击事件
- (void)plusButtonClick{
    //购物车图标视图角标数量
    [self.cartView setCartNumber:[NSString stringWithFormat:@"%ld",self.cartView.cartCount + 1]];
    //抛物线动画起始位置
    CGRect originRect = [self.view convertRect:self.plusButton.frame toView:self.view];
    //抛物线动画终止位置
    CGRect destinationRect = [self.view convertRect:self.cartView.frame toView:self.view];
    //抛物线动画
    [[AnimationManager sharedManager] throwView:self.plusButton.imageView fromRect:originRect toRect:destinationRect];
    //角标数量增加动画
    self.numLabel.text = @"+1";
    self.numLabel.alpha = 1;
    //平移与缩放动画组
    NSArray *animations = @[[[AnimationManager sharedManager] rotationAnimationFromValue:CGPointMake(self.numLabel.frame.origin.x + 5, self.numLabel.frame.origin.y + 10) toValue:CGPointMake(self.numLabel.frame.origin.x+20, self.numLabel.frame.origin.y - 20)],[[AnimationManager sharedManager] scaleAnimationFromValue:1.0 toValue:2.0]];
    //购物车角标数量增加动画
    [[AnimationManager sharedManager] implementGroupAnimation:self.numLabel withAnimations:animations];
}

///---------------------------------------- UIView代码测试区结束 ---------------------------------

@end
