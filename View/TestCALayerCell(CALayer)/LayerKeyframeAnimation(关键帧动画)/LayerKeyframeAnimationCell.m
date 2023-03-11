//
//  LayerKeyframeAnimationCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2023/2/1.
//  Copyright © 2023 王刚. All rights reserved.
//

#import "LayerKeyframeAnimationCell.h"

NSString *const LayerKeyframeAnimationCellReuseIdentifier = @"LayerKeyframeAnimationCellReuseIdentifier";

@interface LayerKeyframeAnimationCell ()

//X轴横移动画视图
@property (nonatomic, strong) UIView *frameXview;
//添加曲线的视图
@property (nonatomic, strong) UIView *pathView;
//沿曲线动画运动的视图
@property (nonatomic, strong) UIView *pathAnimationView;

@end

@implementation LayerKeyframeAnimationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    //X轴横移动画视图
    self.frameXview = [[UIView alloc]initWithFrame:CGRectZero];
    self.frameXview.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.frameXview];
    [self.frameXview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    //添加曲线的视图
    self.pathView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.pathView];
    [self.pathView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frameXview.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(200);
    }];
    
    //沿曲线动画运动的视图
    self.pathAnimationView = [[UIView alloc]initWithFrame:CGRectZero];
    self.pathAnimationView.layer.contents = (id)[UIImage imageNamed:@"darts"].CGImage;
    [self.pathView addSubview:self.pathAnimationView];
    [self.pathAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pathView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)layoutSubviews {
    //在layoutSubviews中添加动画，以正确获取frame
    //X轴横移动画
    [self changeViewFrame:self.frameXview];
    //贝塞尔路径动画
    [self bezierPathAnimationWithbezierPathView:self.pathView animationView:self.pathAnimationView];
}

/// X轴横移动画
/// - Parameter view: 执行动画的视图
- (void)changeViewFrame:(UIView *)view{
    //如果视图没有添加过动画则添加动画
    if ([view.layer animationForKey:@"frameXview_animation_key"] == nil) {
        //X轴横移动画
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        //动画必须通过的值
        animation.values = @[@100,@(-100),@100];
        //动画的时间段，需要与values匹配
        animation.keyTimes = @[@0,@(3/6.),@1];
        //动画持续时间
        animation.duration = 2.f;
        //重复次数(HUGE_VALF为无限重复)
        animation.repeatCount = HUGE_VALF;
        //YES把更改的值追加到当前的present层中 keypath+=value ，NO是把更改的值设置成当前present层的值keypath = value
        animation.additive = YES;
        //true，则动画的当前值是上一个重复周期结束时的值，加上当前重复周期的值。false，则该值只是为当前重复周期计算的值。
        animation.cumulative = NO;
        [view.layer addAnimation:animation forKey:@"frameXview_animation_key"];
    }
}

/// 贝塞尔路径动画
/// - Parameters:
///   - bezierPathView: 添加贝塞尔曲线的视图
///   - animationView: 添加沿贝塞尔曲线动画运动的视图
- (void)bezierPathAnimationWithbezierPathView:(UIView *)bezierPathView animationView:(UIView *)animationView{
    if ([animationView.layer animationForKey:@"bezierPath_animation_key"] == nil) {
        [bezierPathView.superview layoutIfNeeded];
        //曲线
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMidX(bezierPathView.frame) - 200 / 2, (CGRectGetHeight(bezierPathView.frame) - 150) / 2, 200, 150)];
        //形状层
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        //路径形状填充颜色
        shapeLayer.fillColor = nil;
        //路径的线宽
        shapeLayer.lineWidth = 2.5f;
        //路径颜色
        shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        //渲染的形状的路径
        shapeLayer.path = path.CGPath;
        //添加形状层
        [bezierPathView.layer addSublayer:shapeLayer];

        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = path.CGPath;
        //动画持续时间
        animation.duration = 5.0f;
        //动画运行方式
        animation.calculationMode = kCAAnimationCubicPaced;
        //动画重复次数
        animation.repeatCount = HUGE_VALF;
        //自动旋转匹配切线
        animation.rotationMode = kCAAnimationRotateAuto;
        //添加动画
        [animationView.layer addAnimation:animation forKey:@"bezierPath_animation_key"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
