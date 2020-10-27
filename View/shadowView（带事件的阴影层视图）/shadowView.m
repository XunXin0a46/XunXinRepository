//
//  shadowView.m


#import "shadowView.h"

@interface shadowView()<CAAnimationDelegate>

@property (nonatomic, strong) UIControl * backControl;//视图控制层
@property (nonatomic, strong) UIScrollView *characterDescriptionView;//底部文字描述视图
@property (nonatomic, strong) UILabel *characterDescriptionLabel;//文字描述标签

@end

@implementation shadowView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        [self drawView];
        
    }
    
    return self;
}

- (void)drawView{
    
    self.hidden = YES;
    ///视图控制层
    self.backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backControl.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.backControl addTarget:self action:@selector(backControlClick) forControlEvents:UIControlEventTouchUpInside];
    self.backControl.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    
    ///头部图片
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [headerImageView setImage:[UIImage imageNamed:@"bonus-layer-bg"]];
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(150);
    }];
    
    ///底部文字描述视图
    self.characterDescriptionView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.characterDescriptionView.backgroundColor = [UIColor clearColor];
    self.characterDescriptionView.scrollEnabled = YES;
    self.characterDescriptionView.alpha = 1;
    self.characterDescriptionView.layer.cornerRadius = 10.0;
    self.characterDescriptionView.layer.masksToBounds = YES;
    [self addSubview:self.characterDescriptionView];
    [self.characterDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        //距离底部留有10间距，不留间距为330-150 = 180；
        make.height.mas_equalTo(170);
    }];
    
    ///遮罩视图
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectZero];
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.alpha = 0.2f;
    coverView.layer.cornerRadius = 10.0;
    coverView.layer.masksToBounds = YES;
    [self.characterDescriptionView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        //距离底部留有10间距，不留间距为330-150 = 180；
        make.height.mas_equalTo(170);
    }];
    
    ///文字描述标签
    self.characterDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.characterDescriptionLabel.font = [UIFont systemFontOfSize:16];
    self.characterDescriptionLabel.backgroundColor = [UIColor clearColor];
     self.characterDescriptionLabel.textColor = [UIColor whiteColor];
    self.characterDescriptionLabel.numberOfLines = 0;
    [self.characterDescriptionView addSubview:self.characterDescriptionLabel];
    [self.characterDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.characterDescriptionView.mas_top).offset(10);
        make.bottom.equalTo(self.characterDescriptionView.mas_bottom).offset(-10);
        //标签的宽度等于self的宽度减去self与滚动视图的左右间距减去滚动视图与标签的左右间距
        make.width.mas_equalTo(280);
    }];
    
}

///显示视图
- (void)showInView:(UIView *)view{
    
    if (self.isHidden) {
        
        self.hidden = NO;
        
        if (self.backControl.superview == nil) {
            
            [view addSubview:self.backControl];
            
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.backControl.alpha = 1;
            
        }];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.2;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.type = kCATransitionFromTop;
        [self.layer addAnimation:animation forKey:@"animation1"];
        //布局视图
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(300, 330));
        }];
    }
}

///隐藏视图
- (void)hideInView{
    
    if (!self.isHidden) {
        
        self.hidden = YES;
        
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFade;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backControl.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
    
}

///控制层点击事件
- (void)backControlClick{
    
    [self hideInView];
    
}

///处理带<p></p>的字符串
- (NSMutableString *)handleHtmlText:(NSString *)htmlText{
    
    NSMutableString *mutableStr = [[NSMutableString alloc]init];
    if([htmlText containsString:@"</p>"]){
        
        NSArray *strArray = [htmlText componentsSeparatedByString:@"</p>"];
        for(int i = 0; i < strArray.count; i++){
            
            if([strArray[i] containsString:@"<p>"]){
                
                NSString *newStr = [strArray[i] stringByReplacingOccurrencesOfString:@"<p>" withString:@"•"];
                NSMutableString *mutableString = [[NSMutableString alloc]initWithString:newStr];
                [mutableString appendString:@"\r"];
                [mutableStr appendString:mutableString];
            }
            
        }
        
    }
    
    
    return mutableStr;
    
}

///设置红包玩法文本描述
- (void)setSignLabel:(NSString *)signLabel{
    
    self.characterDescriptionLabel.text = [self handleHtmlText:signLabel];
    self.characterDescriptionView.contentSize = CGSizeMake(0, [self.characterDescriptionLabel sizeThatFits:CGSizeMake(280, MAXFLOAT)].height);
}


@end
