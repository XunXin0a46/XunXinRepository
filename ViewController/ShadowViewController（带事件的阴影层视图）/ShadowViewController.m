//
//  ShadowViewController.m


#import "ShadowViewController.h"
#import "shadowView.h"


@interface ShadowViewController ()

@end

@implementation ShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationTitleView:@"阴影视图"];
    NSString *signLabel = @"<p>连续浇水7天，可得20鲸豆可得15.00元红包;</p><p>连续浇水14天，可得40鲸豆可得15.00元红包;</p><p>连续浇水21天，可得60鲸豆可得15.00元红包;</p><p>连续浇水28天，可得80鲸豆可得15.00元红包;";
    shadowView *shadow = [[shadowView alloc]initWithFrame:CGRectZero];
    shadow.signLabel = signLabel;
    [shadow showInView:self.view];
    [self setGradualChangeColorView:shadow];
}

///设置红包玩法背景渐变色
- (void)setGradualChangeColorView:(UIView *)view{
    
    //CAGradientLayer继承CALayer，可以设置渐变图层
    CAGradientLayer *grandientLayer = [[CAGradientLayer alloc] init];
    grandientLayer.frame = CGRectMake(0, 0, 300, 330);
    [view.layer addSublayer:grandientLayer];
    [view.layer insertSublayer:grandientLayer atIndex:0];
    //设置渐变的方向 左上(0,0)  右下(1,1)
    grandientLayer.startPoint = CGPointZero;
    grandientLayer.endPoint = CGPointMake(0.0, 1.0);
    //colors渐变的颜色数组 这个数组中只设置一个颜色是不显示的
    grandientLayer.colors = @[(id)HEXCOLOR(0xfe5153).CGColor, (id)HEXCOLOR(0xfa2629).CGColor];
    grandientLayer.type = kCAGradientLayerAxial;
    
}


@end
