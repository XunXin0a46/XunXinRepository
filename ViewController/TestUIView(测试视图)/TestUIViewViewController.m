//
//  TestUIViewViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/4.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestUIViewViewController.h"

///测试hitTest:(CGPoint)point withEvent:(UIEvent *)event函数的自定义视图

@interface testView : UIView

@property (nonatomic, strong)UIButton *testCodeButton;

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

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) testView *tview;

@end

@implementation TestUIViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"测试视图"];
    [self createUI];
}

///---------------------------------------- UIView代码测试区 -------------------------------------

- (void)createUI{
    
    //创建按钮
    NSArray *buttonTilteAry = @[@"移至顶部",@"插入视图",@"层级交换"];
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
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 150 / 2, CGRectGetMaxY(self.view.frame) / 2 - 150 / 2, 150, 150)];
    self.view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 150 / 2, CGRectGetMinY(self.view1.frame) + 30, 150, 150)];
    self.view2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.view2];
    
    self.view3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 150 / 2, CGRectGetMinY(self.view1.frame) + 15, 150, 150)];
    self.view3.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.view3];
    
    //点击范围视图
    self.tview = [[testView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 150 / 2, CGRectGetMaxY(self.view.frame) - 150  - 75, 150, 150)];
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
    if([button.titleLabel.text isEqualToString:@"移至顶部"]){
        [self testBringSubviewToFront:self.view1];
    }else if([button.titleLabel.text isEqualToString:@"插入视图"]){
        [self testInsertSubview:self.view3 belowSubview:self.view2];
    }else if([button.titleLabel.text isEqualToString:@"层级交换"]){
        [self testexchangeSubviewAtIndex:self.view1 andView:self.view2];
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

///---------------------------------------- UIView代码测试区结束 ---------------------------------

@end
