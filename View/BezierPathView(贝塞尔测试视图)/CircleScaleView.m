//
//  CircleScaleView.m

#import "CircleScaleView.h"

@interface CircleScaleView()<CAAnimationDelegate>

@end

@implementation CircleScaleView

- (void)drawRect:(CGRect)rect {
    [self setBackgroundPath];
}

///------------------------------------- 设置圆角 -------------------------------------------------------

- (void)setCornerRadius:(CGRect)rect{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30, 30)];
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.frame = self.bounds;
    shapLayer.path = maskPath.CGPath;
    self.layer.mask = shapLayer;
}

///------------------------------------- 设置圆角结束 ----------------------------------------------------

///------------------------------------- 比例视图测试 -------------------------------------------------------

- (void)setBackgroundPath{
    //背景圆环的贝塞尔曲线
       UIBezierPath *backgroundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.height / 2 - 9 / 2 startAngle:(3*M_PI) / 4  endAngle:M_PI / 4 clockwise:YES];
       UIColor *storkeColor = [UIColor grayColor];
       [storkeColor setStroke];
       backgroundPath.lineWidth = 5;
       [backgroundPath stroke];

       //设置比例动画
       [self setScaleAnimation];
       //设置比例标签
       [self setScaleLabel];
}

- (void)setScaleAnimation{
    //所占比例的贝塞尔曲线
    UIBezierPath *scalePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.height / 2 - 9 / 2 startAngle:(3*M_PI) / 4 endAngle:((3*M_PI) / 4 + self.currentValue/self.maxValue * 2 * M_PI) clockwise:YES];
    
    //设置形状，渲染图形
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = scalePath.CGPath;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.strokeEnd = 0.75;
    circleLayer.lineWidth = 5;
    circleLayer.frame = self.bounds;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:circleLayer];
    
    //设置动画
    CABasicAnimation *baseAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnima.duration = 1.5;
    baseAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    baseAnima.delegate = self;
    baseAnima.fromValue = [NSNumber numberWithInteger:0];
    [circleLayer addAnimation:baseAnima forKey:@"strokeEndAnimation"];
}

- (void)setScaleLabel{
    //设置比例标签
    UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    scaleLabel.text = [NSString stringWithFormat:@"已领\r%d%%",(int)floor(self.currentValue / self.maxValue * 100)];
    scaleLabel.textColor = [UIColor greenColor];;
    scaleLabel.textAlignment = NSTextAlignmentCenter;
    scaleLabel.font = [UIFont systemFontOfSize:12];
    scaleLabel.numberOfLines = 0;
    [self addSubview:scaleLabel];
    [scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

///--------------------------------------- 比例视图测试结束 ------------------------------------------------

@end
