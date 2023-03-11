//
//  TestCALayerController.m
//  FrameworksTest
//   
//  Created by 王刚 on 2020/3/24.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestCALayerController.h"
#import "LayerShadowCell.h"
#import "LayerGradualChangeCell.h"
#import "LayerBasicAnimationCell.h"
#import "LayerKeyframeAnimationCell.h"
#import "TestReplicatorLayerViewController.h"

@interface TestCALayerController ()<UITableViewDataSource,CAAnimationDelegate>

//表视图
@property (nonatomic, strong) UITableView *tableView;
//表视图数据源
@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;
//转场动画用视图
@property (nonatomic, strong) UIView *transitionView;

@end

@implementation TestCALayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏标题视图
    [self createNavigationTitleView:@"CALayer"];
    //设置导航栏右侧按钮
    [self setrightBarButton];
    //初始化界面
    [self initializationUI];
}

///设置导航栏右侧按钮
- (void)setrightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"复制层" style:UIBarButtonItemStylePlain target:self action:@selector(testReplicatorLayer)];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

/// 导航栏右侧按钮点击事件
- (void)testReplicatorLayer{
    TestReplicatorLayerViewController *replicatorLayerViewController = [[TestReplicatorLayerViewController alloc]init];
    [self.navigationController pushViewController:replicatorLayerViewController animated:YES];
}

/// 初始化界面
- (void)initializationUI {
    //转场动画按钮
    UIButton *transitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [transitionBtn setTitle:@"转场动画" forState:UIControlStateNormal];
    [transitionBtn setBackgroundColor:[UIColor blueColor]];
    transitionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [transitionBtn addTarget:self action:@selector(transitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:transitionBtn];
    [transitionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEAD_BAR_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(75, 35));
    }];
    
    //表视图
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transitionBtn.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:LayerShadowCell.class forCellReuseIdentifier:LayerShadowCellReuseIdentifier];
    [self.tableView registerClass:LayerGradualChangeCell.class forCellReuseIdentifier:LayerGradualChangeCellReuseIdentifier];
    [self.tableView registerClass:LayerBasicAnimationCell.class forCellReuseIdentifier:LayerBasicAnimationCellReuseIdentifier];
    [self.tableView registerClass:LayerKeyframeAnimationCell.class forCellReuseIdentifier:LayerKeyframeAnimationCellReuseIdentifier];
}

///转场动画按钮点击
- (void)transitionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //显示转场动画视图
        CATransition *animation = [CATransition animation];
        //动画持续时间
        animation.duration = 0.4;
        //减缓速度，这会导致动画快速开始，然后随着它的进展而缓慢。
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //动画为推出类型
        animation.type = kCATransitionPush;
        //方向，向上方推出
        animation.subtype = kCATransitionFromTop;
        //添加动画
        [self.transitionView.layer addAnimation:animation forKey:@"Transition_Push"];
        //布局视图
        [self.view addSubview:self.transitionView];
        [self.transitionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 360));
        }];
    } else {
        //隐藏专场动画视图
        CATransition *animation = [CATransition animation];
        //设置代理
        animation.delegate = self;
        //动画持续时间
        animation.duration = 0.4;
        //减缓速度，这会导致动画快速开始，然后随着它的进展而缓慢。
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //动画为推出类型
        animation.type = kCATransitionPush;
        //方向，向下方推出
        animation.subtype = kCATransitionFromBottom;
        //添加动画
        [self.transitionView.layer addAnimation:animation forKey:@"Transition_PoP"];
        [self.transitionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 360));
        }];
    }
}

/// 懒加载表视图数据源
- (NSMutableArray<NSString *> *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
        [_dataSource addObject:LayerShadowCellReuseIdentifier];
        [_dataSource addObject:LayerGradualChangeCellReuseIdentifier];
        [_dataSource addObject:LayerBasicAnimationCellReuseIdentifier];
        [_dataSource addObject:LayerKeyframeAnimationCellReuseIdentifier];
    }
    return _dataSource;
}

/// 懒加载转场动画用视图
- (UIView *)transitionView {
    if (_transitionView == nil) {
        _transitionView = [[UIView alloc]initWithFrame:CGRectZero];
        _transitionView.backgroundColor = [UIColor redColor];
    }
    return _transitionView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = self.dataSource[indexPath.row];
    //阴影
    if ([reuseIdentifier isEqualToString:LayerShadowCellReuseIdentifier]) {
        LayerShadowCell *cell = [tableView dequeueReusableCellWithIdentifier:LayerShadowCellReuseIdentifier];
        return cell;
    }
    //渐变色
    if ([reuseIdentifier isEqualToString:LayerGradualChangeCellReuseIdentifier]) {
        LayerGradualChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:LayerGradualChangeCellReuseIdentifier];
        return cell;
    }
    //单帧动画
    if ([reuseIdentifier isEqualToString:LayerBasicAnimationCellReuseIdentifier]) {
        LayerGradualChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:LayerBasicAnimationCellReuseIdentifier];
        return cell;
    }
    //关键帧动画
    if ([reuseIdentifier isEqualToString:LayerKeyframeAnimationCellReuseIdentifier]) {
        LayerKeyframeAnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:LayerKeyframeAnimationCellReuseIdentifier];
        return cell;
    }
    return nil;
}

#pragma mark - CAAnimationDelegate

/// 动画结束
/// @param anim 结束的动画对象
/// @param flag 指示动画是否因为达到其活动持续时间后而结束的标志
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isMemberOfClass:CATransition.class] && flag) {
        CATransition *transition = (CATransition *)anim;
        if (transition.subtype == kCATransitionFromBottom) {
            [self.transitionView removeFromSuperview];
        }
    }
}

@end
