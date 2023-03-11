//
//  LayerBasicAnimationCell.m
//  FrameworksTest
//
//  Created by 王刚 on 2023/2/1.
//  Copyright © 2023 王刚. All rights reserved.
//

#import "LayerBasicAnimationCell.h"

NSString * const LayerBasicAnimationCellReuseIdentifier = @"LayerBasicAnimationCellReuseIdentifier";

@implementation LayerBasicAnimationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    //创建4个视图
    NSMutableArray<UIView *> *array= [[NSMutableArray alloc]init];
    for(int i =0; i < 5; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.translatesAutoresizingMaskIntoConstraints = YES;
        [NSLayoutConstraint activateConstraints:@[
            [view.widthAnchor constraintEqualToConstant:70],
            [view.heightAnchor constraintEqualToConstant:70],
        ]];
        if(i == 0){
            view.backgroundColor = [UIColor redColor];
        }else if(i == 1){
            view.backgroundColor = [UIColor greenColor];
        }else if(i == 2){
            view.backgroundColor = [UIColor yellowColor];
        }else if(i == 3){
            view.backgroundColor = [UIColor blueColor];
        }else if(i == 4){
            view.layer.contents = (id)[UIImage imageNamed:@"btn_jiazai"].CGImage;
        }
        [array addObject:view];
    }
    
    UIStackView *stackView = [[UIStackView alloc]initWithArrangedSubviews:array];
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.spacing = 20;
    [self.contentView addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.top).offset(10);
        make.bottom.mas_equalTo(self.contentView.bottom).offset(-10);
    }];
    
    for(int i =0; i < 5; i ++) {
        UIView *view = array[i];
        if(i == 0){
            //设置单帧位置动画
            [self creatingAnimatePosition:view];
        }else if(i == 1){
            //设置单帧缩放动画
            [self creatingAnimateScale:view];
        }else if(i == 2){
            //设置单帧透明度动画
            [self creatingAnimateOpacity:view];
        }else if(i == 3){
            //设置单帧背景色动画
            [self  creatingAnimateBackgroundColor:view];
        }else if(i == 4){
            //设置单帧旋转动画
            [self creatingAnimateRotatio:view];
        }
    }
}

///设置单帧位置动画
-(void)creatingAnimatePosition:(UIView *)view{
    // 设定为位移
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画持续时间
    animation.duration = 1;
    // 重复次数(HUGE_VALF为无限重复)
    animation.repeatCount = HUGE_VALF;
    // 动画结束时执行逆动画
    animation.autoreverses = YES;
    // 位移开始位置
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(35.0f, 35.0f)];
    // 位移结束位置
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(35.0f, 45.f)];
    // 动画完成后不在层中移除
    animation.removedOnCompletion = NO;
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧缩放动画
-(void)creatingAnimateScale:(UIView *)view{
    // 设定为缩放
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画持续时间
    animation.duration = 1;
    // 重复次数(HUGE_VALF为无限重复)
    animation.repeatCount = HUGE_VALF;
    // 动画结束时执行逆动画
    animation.autoreverses = YES;
    // 开始时的倍率
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    // 结束时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.1];
    // 动画完成后不在层中移除
    animation.removedOnCompletion = NO;
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧透明度动画
-(void)creatingAnimateOpacity:(UIView *)view{
    // 设定为透明度改变
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // 动画持续时间
    animation.duration = 1;
    // 重复次数(HUGE_VALF为无限重复)
    animation.repeatCount = HUGE_VALF;
    // 动画结束时执行逆动画
    animation.autoreverses = YES;
    // 开始时的透明度
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    // 结束时的透明度
    animation.toValue = [NSNumber numberWithFloat:1.0];
    //动画完成不在目标层移除
    animation.removedOnCompletion = NO;
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧背景色动画
-(void)creatingAnimateBackgroundColor:(UIView *)view{
    // 设定为颜色改变
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    // 动画持续时间
    animation.duration = 1;
    // 重复次数(HUGE_VALF为无限重复)
    animation.repeatCount = HUGE_VALF;
    // 动画结束时执行逆动画
    animation.autoreverses = YES;
    // 开始时的颜色
    animation.fromValue = (id)[UIColor purpleColor].CGColor;
    // 结束时的颜色
    animation.toValue = (id)[UIColor orangeColor].CGColor;
    //动画完成不在目标层移除
    animation.removedOnCompletion = NO;
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧旋转动画
- (void)creatingAnimateRotatio:(UIView *)view{
    // 设置动画为旋转
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // 动画持续时间
    animation.duration = 2.0f;
    // 重复次数(HUGE_VALF为无限重复)
    animation.repeatCount = HUGE_VALF;
    // 开始时的位置
    animation.fromValue = [NSNumber numberWithFloat:0];
    // 结束时的位置
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    //动画完成不在目标层移除
    animation.removedOnCompletion = NO;
    // 添加动画
    [view.layer addAnimation:animation forKey:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
