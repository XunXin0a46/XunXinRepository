//
//  UIViewController+YSCUsualTitle.m
//  YiShop
//
//  Created by 宗仁 on 2016/11/11.
//  Copyright © 2016年 秦皇岛商之翼网络科技有限公司. All rights reserved.
//

#import "UIViewController+YSCUsualTitle.h"
#import "NavigationItemTitleView.h"
#import "TestCollectionView.h"

static void * NavigationItemTitleViewKey = &NavigationItemTitleViewKey;//获取标题视图对象Key
static void * TestCollectionViewKey = &TestCollectionViewKey;//获取测试集合视图对象Key

@implementation UIViewController(YSCUsualTitle)

///设置导航栏通用的返回按钮
- (void)setUpCommonHeader {
    if ([self isMemberOfClass:NSClassFromString(@"WBSDKAuthorizeWebViewController")]) {
        return;
    }
    //如果当前在导航堆栈上的视图控制器数量大于1或者该控制有显示他的父级控制器
    if (self.navigationController.viewControllers.count > 1 ||
        self.presentingViewController) {
        //设置对象弱引用
        YSC_WEAK_SELF
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

///导航栏通用按钮返回事件
- (void)backToPreviousViewController {
    [self cancel];
}

///设置导航栏标题视图
- (void)createNavigationTitleView:(NSString *)text{
    //初始化导航栏的自定义标题视图
    NavigationItemTitleView *navigationItemTitleView = [[NavigationItemTitleView alloc]initWithFrame:CGRectZero];
    //设置导航栏的自定义标题视图的标题
    navigationItemTitleView.titleLabel.text = text;
    //存储当前设置导航栏的自定义标题
    [TestSharedInstance sharedInstance].selectControllerName = text;
    //存储导航栏的自定义标题视图对象
    objc_setAssociatedObject(self, NavigationItemTitleViewKey, navigationItemTitleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //计算文本矩形
    CGRect rect = [navigationItemTitleView.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:18]].height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil];
    //设置导航栏的自定义标题视图大小
    navigationItemTitleView.intrinsicContentSize = CGSizeMake(rect.size.width, [TestUtils singleCharactorSizeWithFont:[UIFont systemFontOfSize:18]].height);
    //添加按钮点击事件
    [navigationItemTitleView.labelMakeButton addTarget:self action:@selector(orderTypeSelectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置化导航栏的自定义标题视图到导航栏标题视图
    self.navigationItem.titleView = navigationItemTitleView;
}

///航栏标题视图按钮点击事件
- (void)orderTypeSelectionButtonClick:(UIButton *)sender{
    //按钮选中状态取反
    sender.selected = !sender.selected;
    //获取导航栏的自定义标题视图对象
    NavigationItemTitleView *navigationItemTitleView = objc_getAssociatedObject(self, NavigationItemTitleViewKey);
    //声明导航集合视图视图对象
    TestCollectionView *testCollectionView = nil;
    //判断是否已经存储过导航集合视图视图对象
    if(objc_getAssociatedObject(self, TestCollectionViewKey) == nil){
        //没有存储过导航集合视图视图对象
        testCollectionView = [[TestCollectionView alloc]initWithFrame:CGRectZero];
        //存储导航集合视图视图对象
        objc_setAssociatedObject(self, TestCollectionViewKey, testCollectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        //获取导航集合视图视图对象
        testCollectionView = objc_getAssociatedObject(self, TestCollectionViewKey);
    }
    //设置导航集合视图视图对象数据源
    testCollectionView.dataSource = @[@"滑动视图",@"集合视图",@"WKWebView",@"测试按钮",@"YYWebImage",@"测试代码",@"签到",@"阴影视图",@"下拉选",@"表视图",@"RunTime",@"贝塞尔",@"扫码",@"导航栏",@"百度REST",@"文本视图",@"CALayer",@"CGGeometry",@"CLLocation",@"滚动视图",@"测试正则",@"富文本标签",@"弹出菜单",@"测试视图",@"手势识别",@"条形二维码",@"表嵌集",@"倒计时"];
    
    testCollectionView.HideInViewyBlock = ^{
        //隐藏视图时恢复按钮指示状态
        sender.selected = !sender.selected;
        navigationItemTitleView.orderTypeSelectionButton.imageView.transform = CGAffineTransformMakeRotation(- M_PI_2);
    };
    //根据选中状态设置按钮图标的矩阵转换
    if(sender.isSelected){
        navigationItemTitleView.orderTypeSelectionButton.imageView.transform = CGAffineTransformMakeRotation( M_PI_2);
        [testCollectionView showInView:self.view];
        
    }else{
        navigationItemTitleView.orderTypeSelectionButton.imageView.transform = CGAffineTransformMakeRotation(- M_PI_2);
        [testCollectionView hideInView];
    }
}


@end
