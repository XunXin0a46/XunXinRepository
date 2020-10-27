//
//  BezierPathController.m


#import "BezierPathController.h"
#import "CircleScaleView.h"

@interface UIPaopaoView : UIView

@end

@implementation UIPaopaoView{
    CGFloat kArrowHeight; //箭头高度
    CGFloat kArrowWidth;  //箭头宽度
    CGFloat kCornerRadius; //圆角半径
    CGFloat kArrowPosition; //参与箭头起点计算的值
    CGFloat kCornerRadiusArrowPadding;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //箭头高度
        kArrowHeight = 8.0;
        //箭头宽度
        kArrowWidth = 15.0;
        //圆角
        kCornerRadius = 10.0;
        //箭头与圆角间距
        kCornerRadiusArrowPadding = 10.0;
        //箭头位置居左
        kArrowPosition = kCornerRadius + kCornerRadiusArrowPadding;
        //箭头位置居中
        //kArrowPosition = 0.5 * self.frame.size.width - 0.5 * kArrowWidth;
        //箭头位置居右
        //kArrowPosition = self.frame.size.width - kCornerRadius - kArrowWidth - kCornerRadiusArrowPadding;
        
        //设置阴影颜色
        self.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0].CGColor;
        //设置阴影不透明度
        self.layer.shadowOpacity = 0.5;
        //设置阴影偏移量
        self.layer.shadowOffset = CGSizeMake(0, 0);
        //设置阴影圆角
        self.layer.shadowRadius = 2.0;
        
        //泡泡
        UIView *paopao = [[UIView alloc] initWithFrame: self.bounds];
        paopao.backgroundColor = [UIColor whiteColor];
        paopao.layer.cornerRadius = 3.0;
        paopao.layer.masksToBounds = YES;
        paopao.layer.mask = [self drawPaoPaoViewMaskLayer:paopao];
        
        [self addSubview:paopao];
    }
    return self;
}

///绘制遮罩层
- (CAShapeLayer *)drawPaoPaoViewMaskLayer:(UIView *)paopaoView
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = paopaoView.bounds;
    //右上弧中心
    CGPoint topRightArcCenter = CGPointMake(self.frame.size.width - kCornerRadius, kArrowHeight + kCornerRadius);
    //左上弧中心
    CGPoint topLeftArcCenter = CGPointMake(kCornerRadius, kArrowHeight + kCornerRadius);
    //右下弧中心
    CGPoint bottomRightArcCenter = CGPointMake(self.frame.size.width - kCornerRadius, self.
                                               frame.size.height- kArrowHeight - kCornerRadius);
    //左下弧中心
    CGPoint bottomLeftArcCenter = CGPointMake(kCornerRadius, self.frame.size.height - kArrowHeight - kCornerRadius);

    UIBezierPath *path = [UIBezierPath bezierPath];
    //将接收器的当前点移动到指定位置
    [path moveToPoint: CGPointMake(0, kArrowHeight + kCornerRadius)];
    //向接收器的路径追加一条直线(左侧直线)
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    //添加左下角弧线
    [path addArcWithCenter: bottomLeftArcCenter radius: kCornerRadius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    //指向下的箭头
    [path addLineToPoint: CGPointMake(kArrowPosition, self.frame.size.height - kArrowHeight)];
    [path addLineToPoint: CGPointMake(kArrowPosition + 0.5 * kArrowWidth, self.frame.size.height)];
    [path addLineToPoint: CGPointMake(kArrowPosition+kArrowWidth, self.frame.size.height - kArrowHeight)];
    [path addLineToPoint: CGPointMake(self.frame.size.width - kCornerRadius, self.frame.size.height - kArrowHeight)];

    //添加右下角弧线
    [path addArcWithCenter: bottomRightArcCenter radius: kCornerRadius startAngle: -M_PI-M_PI_2 endAngle: -M_PI * 2 clockwise: NO];
    //向接收器的路径追加一条直线(右侧直线)
    [path addLineToPoint: CGPointMake(self.frame.size.width, kArrowHeight+kCornerRadius)];
    //添加右上角弧线
    [path addArcWithCenter: topRightArcCenter radius: kCornerRadius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    //指向上的箭头
    //[path addLineToPoint: CGPointMake(kArrowPosition + kArrowWidth, kArrowHeight)];
    //[path addLineToPoint: CGPointMake(kArrowPosition + 0.5 * kArrowWidth, 0)];
    //[path addLineToPoint: CGPointMake(kArrowPosition, kArrowHeight)];
    //[path addLineToPoint: CGPointMake(kCornerRadius, kArrowHeight)];
    
    //添加左上角弧线
    [path addArcWithCenter: topLeftArcCenter radius: kCornerRadius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    //关闭路径
    [path closePath];

    maskLayer.path = path.CGPath;

    return maskLayer;
}

@end

@interface BezierPathController ()

@end

@implementation BezierPathController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"贝塞尔"];
    
    CircleScaleView *circleView = [[CircleScaleView alloc] initWithFrame:CGRectZero];
    circleView.backgroundColor = [UIColor redColor];
    circleView.maxValue = 10;
    circleView.currentValue = 5;
    [self.view addSubview:circleView];
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];

    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    testLabel.text = @"贝塞尔曲线图";
    testLabel.font = [UIFont systemFontOfSize:15];
    testLabel.textColor = [UIColor redColor];
    testLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:testLabel];
    [testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(circleView.mas_top).offset(- 60);
        make.width.mas_equalTo([self calculateTheSizeOfTheText:@"贝塞尔曲线图"].width + 20);
        make.height.mas_equalTo([self calculateTheSizeOfTheText:@"贝塞尔曲线图"].height + 20);
        make.centerX.equalTo(self.view);
    }];

    [self.view layoutIfNeeded];
    [self drawOuterBorder:testLabel];
    [self addDottedLineBorderWithView:circleView LineWidth:5 lineMargin:10 lineLength:5 lineColor:[UIColor greenColor]];
    
    UIPaopaoView *paopaoView = [[UIPaopaoView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 150 / 2, CGRectGetMaxY(self.view.frame) / 1.2 - 150 / 2, 150, 75)];
    [self.view addSubview:paopaoView];
}

///返回单个字符的高度
- (CGSize)singleCharactorSizeWithFont:(UIFont *)font {
    NSString *text = @"C";
    return [text sizeWithAttributes:@{NSFontAttributeName: font}];
}

///计算文本的的大小
- (CGSize)calculateTheSizeOfTheText:(NSString *)text{
    CGSize itemSize = CGSizeZero;
    itemSize.height = [self singleCharactorSizeWithFont:[UIFont systemFontOfSize:15]].height;
    CGSize size = CGSizeMake (CGFLOAT_MAX,itemSize.height);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    itemSize = rect.size;
    return itemSize;
}

///为视图添加指定位置圆角
- (void)viewAddCornerRadius:(UIView *)view applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

///为视图添加指定位置的圆角边框
- (void)viewAddCornerRadius2:(UIView *)view applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius{
    UIBezierPath *outerBorderPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = outerBorderPath.CGPath;
    borderLayer.lineWidth = 2.0;
    borderLayer.frame = view.bounds;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor greenColor].CGColor;
    [view.layer addSublayer:borderLayer];
}

///绘制外边框
- (void)drawOuterBorder:(UIView *)view{
    [self viewAddCornerRadius2:view applyRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight radius:([self calculateTheSizeOfTheText:@"贝塞尔曲线图"].height + 20) / 2];
}

/**
*  给视图添加虚线边框
*
*  @param lineWidth  线宽
*  @param lineMargin 每条虚线之间的间距
*  @param lineLength 每条虚线的长度
*  @param lineColor 每条虚线的颜色
*/

- (void)addDottedLineBorderWithView:(UIView *)view LineWidth:(CGFloat)lineWidth lineMargin:(CGFloat)lineMargin lineLength:(CGFloat)lineLength lineColor:(UIColor *)lineColor;
{
    CAShapeLayer *border = [CAShapeLayer layer];

    border.strokeColor = lineColor.CGColor;

    border.fillColor = nil;

    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;

    border.frame = view.bounds;

    border.lineWidth = lineWidth;

    border.lineCap = @"round";

    border.lineDashPattern = @[@(lineLength), @(lineMargin)];

    [view.layer addSublayer:border];
}

///设置测试按钮
- (void)setTestButton{
    UIButton *testCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testCodeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) / 2 - 70 / 2, CGRectGetMaxY(self.view.frame) / 2 - 30 / 2, 70, 70);
    testCodeButton.backgroundColor = [UIColor blueColor];
    testCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [testCodeButton setTitle:@"测试代码" forState:UIControlStateNormal];
    [testCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testCodeButton.layer.cornerRadius = 35;
    [self.view addSubview:testCodeButton];
    [self addAnimation:testCodeButton];
}

///添加单圈扩散动画
- (void)addAnimation:(UIButton *)sender{
    //创建并返回一个新的UIBezierPath对象，该对象初始化时使用指定矩形内接的椭圆路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height)];
    //初始化形状层CAShapeLayer
    CAShapeLayer *senderLayer = [[CAShapeLayer alloc] init];
    //图层中心点在其父图层坐标空间中的位置
    senderLayer.position = CGPointMake(sender.frame.origin.x + sender.frame.size.width / 2, sender.frame.origin.y + sender.frame.size.height / 2);
    //层的边界矩形
    senderLayer.bounds = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
    //层的背景颜色
    senderLayer.backgroundColor = [UIColor clearColor].CGColor;
    //指定形状路径的线宽
    senderLayer.lineWidth = 5;
    //用于绘制形状路径的颜色
    senderLayer.strokeColor = [UIColor blueColor].CGColor;
    //用于填充形状路径的颜色
    senderLayer.fillColor = [UIColor clearColor].CGColor;
    //定义要渲染的形状的路径
    senderLayer.path = path.CGPath;
    //在已属于接收器的其他子层下插入指定的子层
    [self.view.layer insertSublayer:senderLayer below:sender.layer];
    //结束时的矩形
    CGRect endRect = CGRectInset(CGRectMake(sender.frame.origin.x, sender.frame.origin.y, sender.frame.size.height, sender.frame.size.height), -20, -20);
    //根据结束时的矩形创建结束时UIBezierPath对象
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    //要渲染的形状的路径
    senderLayer.path = endPath.CGPath;
    //接收器的不透明度，默认值为1.0
    senderLayer.opacity = 0.0;
    //贝塞尔的开始到结束位置的动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(path.CGPath);
    pathAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    //动画时长
    pathAnimation.duration = 1.0;
    //动画重复次数
    pathAnimation.repeatCount = HUGE_VALF;
    //贝塞尔的开始到结束透明度的动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    //动画时长
    opacityAnimation.duration = 1.0;
    //动画重复次数
    opacityAnimation.repeatCount = HUGE_VALF;

    [senderLayer addAnimation:opacityAnimation forKey:@""];
    [senderLayer addAnimation:pathAnimation forKey:@"path"];

}

@end
