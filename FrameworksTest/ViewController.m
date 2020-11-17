//
//  ViewController.m

#import "ViewController.h"
#import "TestCollectionViewController.h"
#import "BaseWebViewControlle.h"
#import "SwipeViewController.h"
#import "TestButtonController.h"
#import "YYImageExample.h"
#import "DXRadianLayerView.h"
#import "TestCodeController.h"
#import "SignInController.h"
#import "ShadowViewController.h"
#import "TestTableViewController.h"
#import "TestTableViewDetelateCellController.h"
#import "TestRunTimeViewController.h"
#import "BezierPathController.h"
#import "ScanViewController.h"
#import "TestNavigationController.h"
#import "TestBaiDuRESTController.h"
#import "TestUITextViewController.h"
#import "TestCALayerController.h"
#import "TestCGGeometryController.h"
#import "TestCLLocationController.h"
#import "TextUIScrollViewController.h"
#import "TestRegularViewController.h"
#import "TestTTTAttributedLabelViewController.h"
#import "TestYBPopupMenuViewController.h"
#import "TestUIViewViewController.h"
#import "GestureRecognizerViewController.h"
#import "BarcodeAndQrCodeViewController.h"
#import "TableViewNestingCollectionViewController.h"
#import "TransmitValueTestLoginController.h"
#import "TestXIBViewConreoller.h"
#import "TestCountDownViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *controllerNameAry;
 
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createNavigationTitleView:@"FrameworksTest"];
    
    CGFloat navigationBarHeight = 0;
    if(WHETHER_HAVE_SAFE_AREA){
        navigationBarHeight = 88;
    }else{
        navigationBarHeight = 64;
    }
    //底部为弧线的背景视图
    DXRadianLayerView *view = [[DXRadianLayerView alloc]initWithFrame:CGRectMake(0, navigationBarHeight, SCREEN_WIDTH, 475)];
    view.radian = 10.0;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    //创建按钮
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
}

///设置按钮
- (void)createUI{
    //控制器名称数组(与下面按钮相对应)
    self.controllerNameAry = @[@"SwipeViewController",@"TestCollectionViewController",@"BaseWebViewControlle",@"TestButtonController",@"YYImageExample",@"TestCodeController",@"SignInController",@"ShadowViewController",@"TestTableViewController",@"TestTableViewDetelateCellController",@"TestRunTimeViewController",@"BezierPathController",@"ScanViewController",@"TestNavigationController",@"TestBaiDuRESTController",@"TestUITextViewController",@"TestCALayerController",@"TestCGGeometryController",@"TestCLLocationController",@"TextUIScrollViewController",@"TestRegularViewController",@"TestTTTAttributedLabelViewController",@"TestYBPopupMenuViewController",@"TestUIViewViewController",@"GestureRecognizerViewController",@"BarcodeAndQrCodeViewController",@"TableViewNestingCollectionViewController",@"TransmitValueTestLoginController",@"TestXIBViewConreoller",@"TestCountDownViewController"];
    //按钮标题数组
    NSArray *buttonTilteAry = @[@"滑动视图",@"集合视图",@"WKWebView",@"测试按钮",@"YYWebImage",@"测试代码",@"签到",@"阴影视图",@"下拉选",@"表视图",@"RunTime",@"贝塞尔",@"扫码",@"导航栏",@"百度REST",@"文本视图",@"CALayer",@"CGGeometry",@"CLLocation",@"滚动视图",@"测试正则",@"富文本标签",@"弹出菜单",@"测试视图",@"手势识别",@"条形二维码",@"表嵌集",@"传值练习",@"XIB测试",@"倒计时"];
    //按钮对象数组
    NSMutableArray *buttonAry = [[NSMutableArray alloc]initWithCapacity:buttonTilteAry.count];
    //记录当前按钮的行数
    NSInteger row = 0;
    //遍历按钮标题数组
    for (int i = 0; i < buttonTilteAry.count; i++) {
        //创建按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTilteAry[i] forState:UIControlStateNormal];
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
            //按钮换行
            if(i % 4 == 0){
                row += 1;
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(100 + ((35 + 20) * row));
                    make.left.equalTo(self.view).offset(20);
                    make.size.mas_equalTo(CGSizeMake(75, 35));
                }];
            }else{
                //不需要换行
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastButton.mas_top);
                    make.left.equalTo(lastButton.mas_right).offset(10);
                    make.size.mas_equalTo(CGSizeMake(75, 35));
                }];
            }
        }
        //存放按钮对象到数组
        [buttonAry addObject:button];
        //设置按钮渐变色
        [self setGradualChangeColorButton:button];
    }
    //创建按钮与控制器对应的字典
    [TestSharedInstance sharedInstance].buttonCorrespondingControllerDictionary = [self createButtonCorrespondingControllerDictionary:buttonTilteAry withController:self.controllerNameAry];
}

///按钮渐变色
- (void)setGradualChangeColorButton:(UIButton *)button{
    //CAGradientLayer继承CALayer，可以设置渐变图层
    CAGradientLayer *grandientLayer = [[CAGradientLayer alloc] init];
    grandientLayer.frame = CGRectMake(0, 0, 75.0, 35.0);
    [button.layer addSublayer:grandientLayer];
    [button.layer insertSublayer:grandientLayer atIndex:0];
    //设置渐变的方向 左上(0,0)  右下(1,1)
    grandientLayer.startPoint = CGPointZero;
    grandientLayer.endPoint = CGPointMake(1.0, 0.0);
    //colors渐变的颜色数组 这个数组中只设置一个颜色是不显示的
    grandientLayer.colors = @[(id)HEXCOLOR(0x5C9CDC).CGColor, (id)HEXCOLOR(0x657CDA).CGColor];
    grandientLayer.type = kCAGradientLayerAxial;
}

///按钮点击事件
- (void)buttonClick:(UIButton *)button{
    //根据控制器名称获取控制器类
    Class class = NSClassFromString(self.controllerNameAry[button.tag]);
    //初始化控制器
    UIViewController *controller = [[class alloc]init];
    //一些控制器需要处理数据
    if([controller isMemberOfClass:[BaseWebViewControlle class]]){
        //BaseWebViewControlle传递路径后跳转
        BaseWebViewControlle *webViewControlle = (BaseWebViewControlle *)controller;
        //跳转控制器
        [self.navigationController pushViewController:controller animated:YES];
        [webViewControlle setUrl:@"https://www.68mall.com"];
        return;
    }else if([controller isMemberOfClass:[TestCollectionViewController class]]){
        //集合视图设置数据源
        TestCollectionViewController *collectionViewController = (TestCollectionViewController *)controller;
        [self.navigationController pushViewController:controller animated:YES];
        NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"满减",@"满100元减2元、包邮、送5积分、送红包、送赠品",@"包邮",@"赠", nil];
        [collectionViewController setArray:array];
        return;
    }
    //如果控制器初始化失败，不进行跳转
    if (!controller && [controller isKindOfClass:[UIViewController class]]) {
        return;
    }
    //跳转控制器
    [self.navigationController pushViewController:controller animated:YES];
}

///创建按钮与控制器对应的字典
- (NSDictionary *)createButtonCorrespondingControllerDictionary:(NSArray *)buttonAry withController:(NSArray *)controllerAry{
    //初始化存储数据的字典
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < buttonAry.count; i++) {
        [dictionary setObject:controllerAry[i] forKey:buttonAry[i]];
    }
    return dictionary;
}

@end
