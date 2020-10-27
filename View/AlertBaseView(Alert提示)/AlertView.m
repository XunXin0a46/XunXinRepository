//
//  AlertView.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/10/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "AlertView.h"

@interface AlertView()

//标题(第一行)
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *titleHLine;

//内容(第二行)
@property(nonatomic,strong) UILabel *contentLabel;

//描述/键盘(第三行比较少的时候出现)
@property(nonatomic,strong) UILabel *describeLabel;
@property(nonatomic,strong) UITextField *textField;

//线
@property(nonatomic,strong) UIView *buttonHLine;
@property(nonatomic,strong) UIView *halfVLine;

//左右按钮
@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;

@end

@implementation AlertView

- (void) initUI
{
    if( IS_IPHONE_LANDSCAP){
        
        self.frame = CGRectMake(0, 0,  SCREEN_MAX_LENGTH, SCREEN_MIN_LENGTH);
    }else{
        self.frame = CGRectMake(0, 0,  SCREEN_MIN_LENGTH, SCREEN_MAX_LENGTH);
    }
    //背景不透明度
    super.backgroundOpacity = 0.7f;
    
    //显示内容左右边距
    _textHGap =  15;
    
    //标题属性
    _titleVGap =  18;
    _titleColor = HEX_COLOR(0x333333, 1);;
   
    _titleFont =   [UIFont systemFontOfSize:18];
    _titleAlign = NSTextAlignmentCenter;
    
    //内容属性
    _contentVGap =   14;
    _contentColor = HEX_COLOR(0x565656, 1);;
    _contentFont =   [UIFont systemFontOfSize:14];
    _contentAlign = NSTextAlignmentLeft;
    
    //内容属性
    _describeVGap =   14;
    _describeColor = HEX_COLOR(0x565656, 1);;
    _describeFont =   [UIFont systemFontOfSize:14];
    _describeAlign = NSTextAlignmentLeft;
    
    //键盘属性
    _fieldVGap =   14;
    _fieldHeight =   40;
    _fieldColor = HEX_COLOR(0x333333, 1);;
    _fieldPlaceColor = HEX_COLOR(0xB7B7B7, 1);;
    _fieldBorderColor = HEX_COLOR(0x2786f6, 1);
    _fieldNcornerRadius = 2;
    
    //左侧按钮属性
    _leftBtnColor = HEX_COLOR(0x2786f6, 1);
    _leftBtnBackGroundColor = HEX_COLOR(0xffffff, 1);
    _leftBtnFont =   [UIFont systemFontOfSize:15];
    //按钮高度
    _buttonHeight =   50;
    //右侧按钮属性
    _rightBtnColor = HEX_COLOR(0x2786f6, 1);
    _rightBtnBackGroundColor = HEX_COLOR(0xffffff, 1);
    _rightBtnfont =   [UIFont systemFontOfSize:15];
    
    //弹框属性
    _alertWidth =  290;
    _alertViewbackColor = [UIColor whiteColor];
    _alertBorderColor = HEX_COLOR(0xf4f5f6, 1);
    _alertNcornerRadius = 10;
    super.showType =  AlertShowSlideInToCenter;
    super.hideType =  AlertHideSlideOutToCenter;
    
    //线条属性
    _lineHGap = 0;
    _lineColor = HEX_COLOR(0xf2f2f2, 1);
    _hasTitleHLine = NO;
}

- (void) setupUI
{
    //获取窗口对象
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //添加提示视图
    [window addSubview:self];
    //添加提示视图背景视图
    [self addSubview:self.backgroundView];
    //添加提示框视图
    [self addSubview:self.alertView];
    //如果设置了标题
    if(_title.length > 0) {
        //添加标题到提示框视图
        [super.alertView addSubview:self.titleLabel];
        //设置标题标签文本
        _titleLabel.text = _title;
        //设置标题标签文本对齐方式
        _titleLabel.textAlignment = _titleAlign;
    }
    //如果设置了标题并且显示标题和内容中间横线
    if(_title.length > 0 && _hasTitleHLine) {
        //添加标题与内容水平线视图到提示框视图
        [super.alertView addSubview:self.titleHLine];
    }
    //如果设置了内容
    if(_content.length > 0) {
        //添加内容标签到提示框视图
        [super.alertView addSubview:self.contentLabel];
        //设置内容标签文本
        _contentLabel.text = _content;
    }
    //如果设置了右侧按钮标题
    if(_rightBtnTitle.length > 0) {
        //将右侧按钮添加到提示框视图
        [super.alertView addSubview:self.rightButton];
        //设置右侧按钮标题
        [_rightButton setTitle:_rightBtnTitle forState:UIControlStateNormal];
        //添加按钮分割竖线到提示框视图
        [super.alertView addSubview:self.halfVLine];
    }
    //如果设置了输入框占位符
    if (_placeholder.length > 0) {
        //添加文本输入框到提示框视图
        [super.alertView addSubview:self.textField];
    }
    //如果设置了描述
    if (_describe.length > 0) {
        //将描述标签添加到提示框视图
        [super.alertView addSubview:self.describeLabel];
        //设置描述标签文本
        _describeLabel.text=_describe;
    }
    //添加左侧按钮到提示框视图
    [super.alertView addSubview:self.leftButton];
    [_leftButton setTitle:_leftBtnTitle forState:UIControlStateNormal];
    
    [self layout];
}

///刷新用户界面
- (void)refreshUI{
    if( IS_IPHONE_LANDSCAP){
        
        self.frame = CGRectMake(0, 0,  SCREEN_MAX_LENGTH, SCREEN_MIN_LENGTH);
    }else{
        self.frame = CGRectMake(0, 0,  SCREEN_MIN_LENGTH, SCREEN_MAX_LENGTH);
    }
    self.backgroundView.frame = self.bounds;
    if(_title.length > 0) {
        _titleLabel.text = _title;
        _titleLabel.textAlignment = _titleAlign;
    }
    
    if(_title.length > 0 && _hasTitleHLine) {
       
    }
    
    if(_content.length > 0) {
    
        _contentLabel.text = _content;
    }
    
    if(_rightBtnTitle.length > 0) {
        
        [_rightButton setTitle:_rightBtnTitle forState:UIControlStateNormal];
    }
    
    if (_placeholder.length > 0) {

    }
    
    if (_describe.length > 0) {
    
        _describeLabel.text=_describe;
    }
    
    [_leftButton setTitle:_leftBtnTitle forState:UIControlStateNormal];
    
    [self layout];
}

///布局用户界面
- (void) layout
{
    //提示框宽
    CGFloat alertWidth = _alertWidth;
    //底部按钮高度
    CGFloat buttonHeight = _buttonHeight;
    //标题距上边距
    CGFloat titleVGap = _titleVGap;
    //内容距标题上边距
    CGFloat contentVGap = _title.length > 0 ? _contentVGap : _contentVGap +   16;
    //文本输入框距下边距
    CGFloat fieldVGap = _fieldVGap;
    //描述距标题下边距
    CGFloat describeVGap = _describeVGap;
    //累计提示框高度
    CGFloat alertHeight = 0;
    __block CGSize titleSize;
    
    if(_title.length > 0) {
        // 根据字体计算指定宽度的自动尺寸
        titleSize = [self sizeWith:_title width:alertWidth - _textHGap * 2 font:_titleFont];
        // 累计提示框高度
        alertHeight += titleVGap + titleSize.height;
    }
    
    __block CGSize contentSize;
    if(_content.length > 0) {
        //根据字体计算指定宽度的自动尺寸
        contentSize = [self sizeWith:_content width:alertWidth - _textHGap * 2 font:_contentFont];
        //累计提示框高度
        alertHeight += contentSize.height + contentVGap * 2;
    }
    
    if(_placeholder.length > 0){
        //累计提示框高度
        alertHeight += _fieldHeight + fieldVGap;
    }
    
    __block CGSize describeSize;
    if(_describe.length > 0) {
        //根据字体计算指定宽度的自动尺寸
        describeSize = [self sizeWith:_describe width:alertWidth - _textHGap * 2 font:_describeFont];
        //累计提示框高度
        alertHeight += describeSize.height + describeVGap;
    }
    //累计提示框高度
    alertHeight += buttonHeight;
    //设置提示框视图框架矩形
    super.alertView.frame=CGRectMake(( SCREEN_WIDTH-alertWidth)*0.5,( SCREEN_HEIGHT-alertHeight)*0.5, alertWidth,alertHeight);
    
    if(_title.length > 0) {
        //标题标签
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleVGap);
            make.left.mas_equalTo(self.textHGap);
            make.right.mas_equalTo(-self.textHGap);
            make.height.mas_equalTo(titleSize.height);
        }];
        //标题水平线
        if(_hasTitleHLine) {
            [_titleHLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.lineHGap);
                make.right.mas_equalTo(-self.lineHGap);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(titleVGap);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
    
    if(_content.length > 0) {
        //内容标签
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(self.title.length > 0){
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(contentVGap);
            }else{
                make.top.mas_equalTo(contentVGap);
            }
            make.left.mas_equalTo(self.textHGap);
            make.right.mas_equalTo(-self.textHGap);
            make.height.mas_equalTo(contentSize.height);
        }];
    }
    
    if(_describe.length > 0) {
        //描述标签
        [_describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(describeVGap);
            make.left.mas_equalTo(self.textHGap);
            make.right.mas_equalTo(-self.textHGap);
            make.height.mas_equalTo(describeSize.height);
        }];
    }
    
    if (_placeholder.length > 0) {
        //文本输入框
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textHGap);
            make.right.mas_equalTo(-self.textHGap);
            make.height.mas_equalTo(self.fieldHeight);
            make.bottom.mas_equalTo(-fieldVGap-buttonHeight);
        }];
    }
    
    //按钮水平线
    [_buttonHLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-buttonHeight);
        make.height.mas_equalTo(0.5);
    }];
    
    //左侧按钮
    [_leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        if(self.rightBtnTitle.length<1) {
            make.right.mas_equalTo(0);
        } else {
            make.right.mas_equalTo(-alertWidth*0.5 - 0.25);
        }
        make.top.mas_equalTo(self.buttonHLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    if(_rightBtnTitle.length > 0) {
        //右侧按钮
        [_rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alertWidth*0.5);
            make.width.mas_equalTo(alertWidth*0.5 - 0.25);
            make.top.mas_equalTo(self.buttonHLine.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        
        //按钮分割竖线
        [_halfVLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(0.5);
            make.top.mas_equalTo(self.buttonHLine.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void) dealloc
{
    NSLog(@"[%@]被释放",NSStringFromClass([self class]));
}

#pragma makr - 私有方法
///左侧按钮点击事件
-(void) clickLeft
{
    //如果左侧按钮操作块存在
    if(_leftBtnBlock != nil) {
        //执行左侧按钮操作块
        _leftBtnBlock();
    }
    //隐藏提示视图
    [self hide];
}

///右侧按钮的点击事件
-(void) clickRight
{
    //隐藏提示视图
    [self hide];
    //如果右侧按钮操作块存在
    if(_rightBtnBlock != nil){
        //执行右侧按钮操作块
        _rightBtnBlock();
    }
}

#pragma mark - 控件
///懒加载背景视图
- (UIView *) backgroundView
{
    if(!super.backgroundView){
        //初始化背景视图
        super.backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        //设置背景视图背景颜色
        super.backgroundView.backgroundColor=HEX_COLOR(0x000000, super.backgroundOpacity);
        //初始化点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        //设置点击手势事件
        [tap addTarget:self action:@selector(hide)];
        //添加点击手势到背景视图
        [super.backgroundView addGestureRecognizer:tap];
    }
    return super.backgroundView;
}

///懒加载提示框视图
- (UIView *) alertView
{
    if (!super.alertView) {
        //初始化提示框视图
        super.alertView = [[UIView alloc] init];
        //设置提示框视图背景颜色
        super.alertView.backgroundColor = _alertViewbackColor;
        //设置提示框边框颜色
        super.alertView.layer.borderColor =_alertBorderColor.CGColor;
        //设置提示框边框宽度
        super.alertView.layer.borderWidth = 0.5f;
        //添加按钮水平线视图到提示框视图
        [super.alertView addSubview:self.buttonHLine];
        //设置提示框视图圆角
        super.alertView.layer.cornerRadius = _alertNcornerRadius;
        //设置提示框视图超越层边界的部分裁剪
        super.alertView.layer.masksToBounds = YES;
    }
    return super.alertView;
}

///懒加载标题标签
- (UILabel *) titleLabel
{
    if (_titleLabel == nil) {
        //初始化标题标签
        _titleLabel = [[UILabel alloc] init];
        //设置标题标签字体大小
        _titleLabel.font = _titleFont;
        //设置标题标签文本对齐方式
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //设置标题标签文本颜色
        _titleLabel.textColor = _titleColor;
        //标题标签文本可以多行展示
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

///懒加载内容标签
- (UILabel *) contentLabel
{
    if (_contentLabel == nil) {
        //初始化内容标签
        _contentLabel = [[UILabel alloc] init];
        //设置内容标签字体大小
        _contentLabel.font = _contentFont;
        //设置内容标签文本对齐方式
        _contentLabel.textAlignment = _contentAlign;
        //设置内容标签文本颜色
        _contentLabel.textColor = _contentColor;
        //设置内容标签文本截断方式
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        //设置内容标签文本可多行展示
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

///懒加载描述标签
- (UILabel *) describeLabel
{
    if (_describeLabel == nil) {
        //初始化描述标签
        _describeLabel = [[UILabel alloc] init];
        //设置描述标签字体
        _describeLabel.font = _describeFont;
        //设置描述标签文本对齐方式
        _describeLabel.textAlignment = _describeAlign;
        //设置描述标签文本颜色
        _describeLabel.textColor = _describeColor;
        //设置描述标签文本截断方式
        _describeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        //设置内容标签文本可多行展示
        _describeLabel.numberOfLines = 0;
    }
    return _describeLabel;
}

///懒加载文本输入框
- (UITextField *)textField
{
    if (_textField == nil) {
        //初始化文本输入框
        _textField = [[UITextField alloc] init];
        //设置文书输入框占位符
        _textField.placeholder = _placeholder;
        //设置文本输入框圆角
        _textField.layer.cornerRadius = _fieldNcornerRadius;
        //设置文本输入框超出边界裁剪
        _textField.layer.masksToBounds = YES;
        //设置文本输入框边框颜色
        _textField.layer.borderColor = _fieldBorderColor.CGColor;
        //设置文本输入框边框宽度
        _textField.layer.borderWidth = 1.0f;
        //设置文本输入框输入文本字体大小
        _textField.font = _fieldFont;
        //设置文本输入框输入文本颜色
        _textField.textColor = _fieldColor;
        //禁止用户在文本输入框中复制文本
        _textField.secureTextEntry = YES;
        //设置文本输入框占位符字体颜色
        [_textField setValue:_fieldPlaceColor forKeyPath:@"_placeholderLabel.textColor"];
        //初始化左侧占位视图
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
        //包含文本，则始终显示覆盖视图
        _textField.leftViewMode = UITextFieldViewModeAlways;
        //将占位视图设置到文本输入框左侧视图中
        _textField.leftView = leftview;
    }
    return _textField;
}

///懒加载左侧按钮
- (UIButton *) leftButton{
    if (_leftButton == nil) {
        //初始化左侧按钮
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置左侧按钮标题字体大小
        _leftButton.titleLabel.font=_leftBtnFont;
        //设置左侧按钮标题文本颜色
        [_leftButton setTitleColor:_leftBtnColor forState:UIControlStateNormal];
        //添加左侧按钮的点击事件
        [_leftButton addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
        //设置左侧按钮的背景颜色
        _leftButton.backgroundColor = _leftBtnBackGroundColor;
    }
    return _leftButton;
}

///懒加载右侧按钮
- (UIButton *) rightButton{
    if (_rightButton == nil) {
        //初始化右侧按钮
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置右侧按钮标题字体大小
        _rightButton.titleLabel.font=_rightBtnfont;
        //设置右侧按钮标题文本颜色
        [_rightButton setTitleColor:_rightBtnColor forState:UIControlStateNormal];
        //添加右侧按钮的点击事件
        [_rightButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        //设置右侧按钮的背景颜色
        _rightButton.backgroundColor = _rightBtnBackGroundColor;
    }
    return _rightButton;
}

/// 懒加载标题水平线
- (UIView *) titleHLine
{
    if (_titleHLine == nil) {
        //初始化标题水平线视图
        _titleHLine = [[UIView alloc] init];
        //设置标题水平线视图颜色
        _titleHLine.backgroundColor = _lineColor;
    }
    return _titleHLine;
}

/// 懒加载按钮水平线
- (UIView *) buttonHLine{
    if (_buttonHLine == nil) {
        //初始化按钮水平线
        _buttonHLine = [[UIView alloc] init];
        //设置按钮水平线视图颜色
        _buttonHLine.backgroundColor = _lineColor;
    }
    return _buttonHLine;
}

///按钮分割竖线
- (UIView *) halfVLine{
    if (_halfVLine == nil) {
        //初始化按钮分割竖线
        _halfVLine = [[UIView alloc] init];
        //设置按钮分割竖线背景色
        _halfVLine.backgroundColor = _lineColor;
    }
    return _halfVLine;
}
/// 根据字体计算指定宽度的自动尺寸
- (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font
{
    if([text isKindOfClass:[NSNull class]] || text.length<1){
        text=@"";
    }
    CGSize size=[text boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    size.width=ceil(size.width)+3;
    size.height=ceil(size.height)+1;
    return size;
}


@end
