//
//  NewGrouptheSeventhEveningOfTheSeventhMoonViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/8/14.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "NewGrouptheSeventhEveningOfTheSeventhMoonViewController.h"
#import "YUReplicatorAnimation.h"

@interface NewGrouptheSeventhEveningOfTheSeventhMoonViewController ()<CAAnimationDelegate>

@property(nonatomic, strong)UIView *operationView;//操作视图
@property(nonatomic, strong)UIImageView *backgroundImageView;//背景视图
@property(nonatomic, strong)UILabel *loveLabel;//喜欢标签
@property(nonatomic, strong)CABasicAnimation *loveLabelRotationAnimation;//喜欢标签旋转动画
@property (nonatomic, strong) dispatch_source_t timer;//计时器

@end

@implementation NewGrouptheSeventhEveningOfTheSeventhMoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"七夕"];
    //创建开始按钮
    [self createStartButton];
    //创建操作视图
    [self createOperationView];
    //创建背景视图
    [self createBackgroundView];
    //创建喜欢标签
    [self createLoveLabel];
}

///创建开始按钮
- (void)createStartButton{
    //开始按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:startButton];
    startButton.layer.cornerRadius = 22.0;
    startButton.layer.masksToBounds = YES;
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    startButton.backgroundColor = [UIColor redColor];
    [startButton setTitle:@"七夕快乐" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(10 * 2.0);
        make.right.equalTo(self.view).offset(-10 * 2.0);
        make.height.mas_equalTo(44);
    }];
}

///创建操作视图
- (void)createOperationView{
    //操作视图
    self.operationView = [[UIView alloc]initWithFrame:CGRectZero];
    self.operationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.operationView];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor blueColor];
    [self.operationView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.operationView);
        make.height.mas_equalTo(0.5);
    }];
    
    //操作按钮
    NSArray *buttonTitleArray = @[@"喜",@"欢",@"你"];
    NSMutableArray *buttonArray = [[NSMutableArray alloc]initWithCapacity:buttonTitleArray.count];
    for (int i = 0; i < buttonTitleArray.count; i++) {
        UIButton *operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        operationButton.backgroundColor = [UIColor blueColor];
        operationButton.titleLabel.font = [UIFont systemFontOfSize:15];
        operationButton.layer.cornerRadius = 13;
        [operationButton setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [operationButton addTarget:self action:@selector(operationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.operationView addSubview:operationButton];
        
        CGFloat buttonWidth = (SCREEN_WIDTH - (buttonTitleArray.count + 1) * 10) / 3;
        UIView *lastButton = buttonArray.lastObject;
        
        if (lastButton == nil) {
            [operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.operationView);
                make.left.equalTo(self.operationView.mas_left).offset(10);
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(26);
            }];
            
        } else {
            [operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.operationView);
                make.left.equalTo(lastButton.mas_right).offset(10);
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(26);
            }];
        }

        [buttonArray addObject:operationButton];
    }
}

///创建背景视图
- (void)createBackgroundView{
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.backgroundImageView.image = [UIImage imageNamed:@"qixi"];
    self.backgroundImageView.alpha = 0.0;
    [self.view addSubview:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(- 100);
    }];
}

///创建喜欢标签
- (void)createLoveLabel{
    self.loveLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.loveLabel.textAlignment = NSTextAlignmentCenter;
    self.loveLabel.alpha = 0.0;
    
    NSMutableAttributedString *attributedTermLabelText = [[NSMutableAttributedString alloc]initWithString:@"I LOVE YOU"];
    [attributedTermLabelText addAttributes:@{
        //文本字体
        NSFontAttributeName : [UIFont systemFontOfSize:30],
        //文本颜色
        NSForegroundColorAttributeName:[UIColor redColor],
        //文本字间距
        NSKernAttributeName:@(5.0),
        //笔画宽度
        NSStrokeWidthAttributeName:@(3.5),
        
    } range:NSMakeRange(0, @"I LOVE YOU".length)];
    
    self.loveLabel.attributedText = attributedTermLabelText;
    [self.view addSubview:self.loveLabel];
    
    [self.loveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(- 100);
    }];
}

///开始按钮点击事件
- (void)startClick:(UIButton *)sender{
    //操作视图转场动画
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    //动画持续时间
    animation.duration = 1.0;
    //减缓速度，这会导致动画快速开始，然后随着它的进展而缓慢。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //动画为推出类型
    animation.type = kCATransitionPush;
    //方向，向上方推出
    animation.subtype = kCATransitionFromTop;
    //添加动画
    [self.operationView.layer addAnimation:animation forKey:@"animation1"];
    //布局视图
    [self.operationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    //设置单帧透明度动画(淡出或淡入)
    [self creatingAnimateOpacityWithFadeOut:sender];
}

///操作按钮点击事件
- (void)operationButtonClick:(UIButton *)sender{
    NSString *senderTitle = sender.titleLabel.text;
    if([senderTitle isEqualToString:@"喜"]){
        //设置单帧透明度动画(淡入)
        [self creatingAnimateOpacityWithFadeIn:self.backgroundImageView];
    }else if([senderTitle isEqualToString:@"欢"]){
        //心动画
        [self replicatorLayerHeart];
    }else if([senderTitle isEqualToString:@"你"]){
        //设置单帧透明度动画(淡入)
        [self creatingAnimateOpacityWithFadeIn:self.loveLabel];
        //定时执行旋转
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t queue = dispatch_get_main_queue();
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            //执行的函数或代码块
            //旋转动画
            weakSelf.loveLabelRotationAnimation = [weakSelf transitionAnimation:weakSelf.loveLabel];
        });
        dispatch_resume(_timer);
        
    }
}

///设置单帧透明度动画(淡出)
-(void)creatingAnimateOpacityWithFadeOut:(UIView *)view{
    // 设定为透明
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // 动画选项设定
    animation.duration = 1.0; // 动画持续时间
    animation.repeatCount = 0; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.fillMode = kCAFillModeForwards;//保持动画执行后的状态
    // 透明度改变
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的透明度
    animation.toValue = [NSNumber numberWithFloat:0.0]; // 结束时的透明度
    animation.removedOnCompletion = NO;//动画完成不在目标层移除
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layer"];
}

///设置单帧透明度动画(淡入)
-(void)creatingAnimateOpacityWithFadeIn:(UIView *)view{
    // 设定为透明
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    // 动画选项设定
    animation.duration = 1.0; // 动画持续时间
    animation.repeatCount = 0; // 重复次数(HUGE_VALF为无限重复)
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.fillMode = kCAFillModeForwards;//保持动画执行后的状态
    // 透明度改变
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 开始时的透明度
    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的透明度
    animation.removedOnCompletion = NO;//动画完成不在目标层移除
    // 添加动画
    [view .layer addAnimation:animation forKey:@"scale-layerII"];
}

///心动画
- (void)replicatorLayerHeart{
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(10, HEAD_BAR_HEIGHT - 10, 2, 12)];
    [self.view addSubview:aniView];
    [aniView.layer addSublayer: [YUReplicatorAnimation replicatorLayerWithType:YUReplicatorLayerHeart]];
}

///旋转动画
- (CABasicAnimation *)transitionAnimation:(UIView *)view{
    //设置为旋转
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //减缓速度，这会导致动画快速开始，然后随着它的进展而缓慢。
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //动画结束值
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2];
    // 动画持续时间
    rotationAnimation.duration = 4;
    //动画完成不在目标层移除
    rotationAnimation.removedOnCompletion = NO;
    //保持动画执行后的状态
    rotationAnimation.fillMode = kCAFillModeForwards;
    //设置代理
    rotationAnimation.delegate = self;
    // 添加动画
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //记录旋转动画对象
    return rotationAnimation;
}

#pragma mark -- CAAnimationDelegate

///动画开始执行
- (void)animationDidStart:(CAAnimation *)anim{
    //判断是否是旋转动画
    if([anim isMemberOfClass:[self.loveLabelRotationAnimation class]]){
        NSMutableAttributedString *attributedTermLabelText = [[NSMutableAttributedString alloc]initWithString:@"I LOVE YOU"];
        [attributedTermLabelText addAttributes:@{
            //文本字体
            NSFontAttributeName : [UIFont systemFontOfSize:30],
            //文本颜色
            NSForegroundColorAttributeName:[UIColor redColor],
            //文本字间距
            NSKernAttributeName:@(5.0),
            //笔画宽度
            NSStrokeWidthAttributeName:@(3.5),

        } range:NSMakeRange(0, @"I LOVE YOU".length)];
        //重置文本内容
        self.loveLabel.attributedText = attributedTermLabelText;
    }
}

///动画之行完成
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //判断是否是旋转动画
    if([anim isMemberOfClass:[self.loveLabelRotationAnimation class]]){
        NSMutableAttributedString *attributedTermLabelText = [[NSMutableAttributedString alloc]initWithString:@"我 爱 你"];
        [attributedTermLabelText addAttributes:@{
            //文本字体
            NSFontAttributeName : [UIFont systemFontOfSize:30],
            //文本颜色
            NSForegroundColorAttributeName:[UIColor orangeColor],
            //文本字间距
            NSKernAttributeName:@(5.0),
            //笔画宽度
            NSStrokeWidthAttributeName:@(3.5),

        } range:NSMakeRange(0, @"我 爱 你".length)];
        //重置文本内容
        self.loveLabel.attributedText = attributedTermLabelText;
    }
}

@end
