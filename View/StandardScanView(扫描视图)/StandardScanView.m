//
//  StandardScanView.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/2/6.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "StandardScanView.h"

CGFloat const YSCStandardScanViewAperturePadding = 60.0;
static CGFloat const OffsetY = 80.0;

@interface StandardScanView()

@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) CALayer *imageLayer;

@end

@implementation StandardScanView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        //扫描框的宽度
        CGFloat scanHoleWidth = SCREEN_WIDTH - YSCStandardScanViewAperturePadding * 2.0;
        //扫描框的高度
        CGFloat scanHoleHeight = scanHoleWidth;
        //扫描框矩形
        CGRect animationViewRect = RectAroundCenter(self.scanCenter, CGSizeMake(scanHoleWidth, scanHoleHeight));
        //扫描框视图
        _animationView = [[UIView alloc] initWithFrame:animationViewRect];
        [self addSubview:_animationView];
        _animationView.layer.borderWidth = 1.0;
        _animationView.layer.borderColor = [UIColor redColor].CGColor;
        _animationView.backgroundColor = [UIColor clearColor];
        //扫描标题标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:titleLabel];
        titleLabel.text = @"将条码对准框内即可扫描";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.animationView.mas_bottom).offset(20);
            make.centerX.equalTo(self.mas_centerX);
        }];
        //扫描线条图片
        _imageLayer = [[CALayer alloc] init];
        [_animationView.layer addSublayer:_imageLayer];
        _imageLayer.contents = (id)[UIImage imageNamed:@"ic_normal_code_scan"].CGImage;
        _imageLayer.frame = CGRectMake(-YSCStandardScanViewAperturePadding, -10.0, CGRectGetWidth(animationViewRect) + YSCStandardScanViewAperturePadding * 2, 20.0);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self scanAnimation];
}

///扫描动画
- (void)scanAnimation {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    self.imageLayer.anchorPoint = CGPointMake(0.25, 0.25);
    CGRect endRect = self.imageLayer.frame;
    endRect.origin.y += CGRectGetHeight(self.animationView.frame);
    animation.fromValue = [NSValue valueWithCGRect:self.imageLayer.frame];
    animation.toValue = [NSValue valueWithCGRect:endRect];
    animation.duration = 1.5;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    [self.imageLayer addAnimation:animation forKey:@"position_animation"];
}


- (void)drawRect:(CGRect)rect {
    //扫描框的宽度
    CGFloat scanHoleWidth = SCREEN_WIDTH - YSCStandardScanViewAperturePadding * 2.0;
    //扫描框的高度
    CGFloat scanHoleHeight = scanHoleWidth;
    //折线宽度
    CGFloat lineWidth = 3.0;
    //折线长度
    CGFloat lineLength = 18.0;
    //扫描框矩形
    CGRect holeRect = RectAroundCenter(self.scanCenter, CGSizeMake(scanHoleWidth, scanHoleHeight));
    CGRect holeInterSection = CGRectIntersection(holeRect, rect);

    [[UIColor clearColor] setFill];

    UIRectFill(holeInterSection);

    CGPoint topLeftPoint = CGPointMake(CGRectGetMinX(holeRect), CGRectGetMinY(holeRect));
    CGPoint topRightPoint = CGPointMake(CGRectGetMaxX(holeRect), CGRectGetMinY(holeRect));
    CGPoint bottomLeftPoint = CGPointMake(CGRectGetMinX(holeRect), CGRectGetMaxY(holeRect));
    CGPoint bottomRightPoint = CGPointMake(CGRectGetMaxX(holeRect), CGRectGetMaxY(holeRect));

    // 左上角折线
    CGPoint topLeftStartPoint = topLeftPoint;
    topLeftStartPoint.y += lineLength;

    CGPoint topLeftEndPoint = topLeftPoint;
    topLeftEndPoint.x += lineLength;

    [self.layer addSublayer:createInflexionLineLayer(topLeftStartPoint, topLeftPoint, topLeftEndPoint, lineWidth)];

    // 左下角折线
    CGPoint bottomLeftStartPoint = bottomLeftPoint;
    bottomLeftStartPoint.y -= lineLength;

    CGPoint bottomLeftEndPoint = bottomLeftPoint;
    bottomLeftEndPoint.x += lineLength;

    [self.layer addSublayer:createInflexionLineLayer(bottomLeftStartPoint, bottomLeftPoint, bottomLeftEndPoint, lineWidth)];

    // 右上角折线
    CGPoint topRightStartPoint = topRightPoint;
    topRightStartPoint.x -= lineLength;

    CGPoint topRightEndPoint = topRightPoint;
    topRightEndPoint.y += lineLength;

    [self.layer addSublayer:createInflexionLineLayer(topRightStartPoint, topRightPoint, topRightEndPoint, lineWidth)];

    // 右下角折线
    CGPoint bottomRightStartPoint = bottomRightPoint;
    bottomRightStartPoint.y -= lineLength;

    CGPoint bottomRightEndPoint = bottomRightPoint;
    bottomRightEndPoint.x -= lineLength;

    [self.layer addSublayer:createInflexionLineLayer(bottomRightStartPoint, bottomRightPoint, bottomRightEndPoint, lineWidth)];
}

///懒加载扫描框中心位置
- (CGPoint)scanCenter {
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    center.y -= OffsetY;
    return center;
}

///扫描框矩形
static CGRect RectAroundCenter(CGPoint center, CGSize size) {

    CGFloat halfWidth = size.width * 0.5;
    CGFloat halfHeight = size.height * 0.5;
    return CGRectMake(center.x - halfWidth,center.y - halfHeight, size.width, size.height);
}

///创建拐点线层
static CALayer *createInflexionLineLayer(CGPoint startPoint, CGPoint inflexionPoint, CGPoint endPoint, CGFloat lineWidth) {

    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:startPoint];
    [path addLineToPoint:inflexionPoint];
    [path addLineToPoint:endPoint];

    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = lineWidth;

    return shapeLayer;
}

@end
