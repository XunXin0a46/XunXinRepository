//
//  TestCALayerController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/3/24.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCALayerController.h"
#import "TestReplicatorLayerViewController.h"

@interface TestCALayerController ()<CAAnimationDelegate>

@end

@implementation TestCALayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏标题视图
    [self createNavigationTitleView:@"CALayer"];
    //设置视图动画代码片段
    [self setViewAnimation];
    //设置转场动画按钮
    [self setTransitionBtn];
    //设置导航栏右侧按钮
    [self setrightBarButton];
}

///设置导航栏右侧按钮
- (void)setrightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"CAReplicatorLayer" style:UIBarButtonItemStylePlain target:self action:@selector(testReplicatorLayer)];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

///设置视图动画代码片段
- (void)setViewAnimation{
    //创建3个视图
    NSMutableArray *array= [[NSMutableArray alloc]init];
    for(int i =0; i < 4; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        if(i == 0){
            view.backgroundColor = [UIColor redColor];
            //设置单帧位置动画
            [self creatingAnimatePosition:view];
        }else if(i == 1){
            view.backgroundColor = [UIColor greenColor];
            //设置单帧缩放动画
            [self creatingAnimateScale:view];
        }else if(i == 2){
            view.backgroundColor = [UIColor yellowColor];
            //设置单帧透明度动画
            [self creatingAnimateOpacity:view];
        }else if(i == 3){
            view.backgroundColor = [UIColor blueColor];
            //设置单帧背景色动画
            [self  creatingAnimateBackgroundColor:view];
        }
        
        [self.view addSubview:view];
        [array addObject:view];
    }
    
    [array mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:70 leadSpacing:200 tailSpacing:200];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(70);
    }];
    
    //X轴横移动画
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [self changeViewFrame:view];
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectZero];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.cornerRadius = 10.0;
    [self.view addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEAD_BAR_HEIGHT);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self setLayerShadowToView:shadowView withColor:[UIColor grayColor] withOffset:CGSizeMake(0, 0) radius:3];
    
    //设置视图阴影
    UIView *gradualChangeView = [[UIView alloc]initWithFrame:CGRectZero];
    gradualChangeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:gradualChangeView];
    [gradualChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEAD_BAR_HEIGHT);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.view layoutIfNeeded];
    [self setGradualChangeColorView:gradualChangeView];
}

///设置转场动画按钮
- (void)setTransitionBtn{
    
    UIButton *transitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [transitionBtn setTitle:@"转场动画" forState:UIControlStateNormal];
    [transitionBtn setBackgroundColor:[UIColor blueColor]];
    transitionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [transitionBtn addTarget:self action:@selector(transitionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:transitionBtn];
    [transitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEAD_BAR_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(75, 35));
    }];
}

///设置涂层阴影
- (void)setLayerShadowToView:(UIView *)theView withColor:(UIColor*)color withOffset:(CGSize)offset radius:(CGFloat)radius {
    theView.layer.shadowColor = color.CGColor;
    //阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = offset;
    //阴影半径，默认3
    theView.layer.shadowRadius = radius;
    //阴影不透明度
    theView.layer.shadowOpacity = 1;
    //光栅化
    theView.layer.shouldRasterize = YES;
    theView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

///设置视图渐变色
- (void)setGradualChangeColorView:(UIView *)view{
    
    //CAGradientLayer继承CALayer，可以设置渐变图层
    CAGradientLayer *grandientLayer = [[CAGradientLayer alloc] init];
    grandientLayer.frame = view.bounds;
    [view.layer addSublayer:grandientLayer];
    [view.layer insertSublayer:grandientLayer atIndex:0];
    //设置渐变的方向 左上(0,0)  右下(1,1)
    grandientLayer.startPoint = CGPointZero;
    grandientLayer.endPoint = CGPointMake(0.0, 1.0);//纵向
    //grandientLayer.endPoint = CGPointMake(1.0, 0.0);//横向
    //colors渐变的颜色数组 这个数组中只设置一个颜色是不显示的
    grandientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor];
    //沿轴向在两个定义的端点之间变化
    grandientLayer.type = kCAGradientLayerAxial;
    
}

///设置单帧缩放动画
-(void)creatingAnimateScale:(UIView *)view{
    // 设定为缩放
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.1]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧背景色动画
-(void)creatingAnimateBackgroundColor:(UIView *)view{
    // 设定为缩放
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 颜色改变
    animation.fromValue = (id)[UIColor purpleColor].CGColor; // 开始时的颜色
    animation.toValue = (id)[UIColor orangeColor].CGColor; // 结束时的颜色
    animation.removedOnCompletion = NO;
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧透明度动画
-(void)creatingAnimateOpacity:(UIView *)view{
    // 设定为缩放
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 透明度改变
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 开始时的透明度
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的透明度
    animation.removedOnCompletion = NO;
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧位置动画
-(void)creatingAnimatePosition:(UIView *)view{
    // 设定为位移
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项设定
    animation.duration = 0.4; // 动画持续时间
    animation.repeatCount = HUGE_VALF; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = YES; // 动画结束时执行逆动画
    // 位移位置
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(170.f, 170.f)]; // 开始时的位置
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200.f, 200.f)]; // 结束时的位置
    animation.removedOnCompletion = NO;
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layer"];
}

- (void)changeViewFrame:(UIView *)view{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];

    animation.values = @[@100,@(-100),@100];
    animation.keyTimes = @[@0,@(3/6.),@1];
    //动画持续时间
    animation.duration = 2.f;
    //重复次数(HUGE_VALF为无限重复)
    animation.repeatCount = HUGE_VALF;
    //YES把更改的值追加到当前的present层中 keypath+=value ，NO是把更改的值设置成当前present层的值keypath = value
    animation.additive = YES;
    //true，则动画的当前值是上一个重复周期结束时的值，加上当前重复周期的值。false，则该值只是为当前重复周期计算的值。
    animation.cumulative = NO;
    [view.layer addAnimation:animation forKey:@"shaking"];
    
}

///转场动画按钮点击
- (void)transitionBtnClick{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor redColor];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    //动画持续时间
    animation.duration = 0.4;
    //减缓速度，这会导致动画快速开始，然后随着它的进展而缓慢。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //动画为推出类型
    animation.type = kCATransitionPush;
    //方向，向上方推出
    animation.subtype = kCATransitionFromTop;
    //添加动画
    [view.layer addAnimation:animation forKey:@"animation1"];
    //布局视图
    [self.view addSubview:view];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 360));
    }];
    
}

- (void)testReplicatorLayer{
    TestReplicatorLayerViewController *replicatorLayerViewController = [[TestReplicatorLayerViewController alloc]init];
    [self.navigationController pushViewController:replicatorLayerViewController animated:YES];
}

@end
