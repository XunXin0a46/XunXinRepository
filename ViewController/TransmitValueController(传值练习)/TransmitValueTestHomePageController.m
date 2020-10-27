//
//  TransmitValueTestHomePageController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TransmitValueTestHomePageController.h"

@interface TransmitValueTestHomePageController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *userNameText;//用户名输入框
@property(nonatomic, strong) UITextField *passWordText;//密码输入框
@property (nonatomic, strong) UIButton  *returnBtn;//登录按钮

@end

@implementation TransmitValueTestHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控制器标题
    self.title = @"首页";
    //设置控制器视图背景颜色
    self.view.backgroundColor = [UIColor redColor];
    //初始化用户名输入框
    self.userNameText=[self getTextField:100 leftViewName:@" 用户名:"];
    //设置用户名输入框文本
    self.userNameText.text = self.userName;
    //初始化密码输入框
    self.passWordText=[self getTextField:CGRectGetMaxY(_userNameText.frame)+20 leftViewName:@" 密码:"];
    //设置密码输入框文本
    self.passWordText.text = self.passWord;
    //初始化返回按钮
    self.returnBtn = [self buttonInitWith:CGRectMake((self.view.frame.size.width - 50) /2,CGRectGetMaxY(self.passWordText.frame) + 50 , 100, 45) withTitle:@"返回"];
    self.returnBtn.backgroundColor = [UIColor purpleColor];
}

- (void)dealloc{
    NSLog(@"主页已经释放了");
}


///初始化文本输入框
-(UITextField *)getTextField:(CGFloat )y leftViewName:(NSString *)name{
    //初始化输入框
    UITextField *  textField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 45)];
    //设置输入框边框的宽度
    textField.layer.borderWidth = 1.0f;
    //输入的文字颜色
    textField.textColor = [UIColor yellowColor];
    //设置输入框代理
    textField.delegate = self;
    //输入框左视图始终显示
    textField.leftViewMode = UITextFieldViewModeAlways;
    //设置输入框提示文本及提示文本颜色
    textField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName : [UIColor yellowColor]}];
    //透明效果
    [textField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textField];//将输入框添加到当前控制器视图
    //初始化标签
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    //设置标签文本
    label.text = name;
    //设置标签文本对齐方式
    label.textAlignment = NSTextAlignmentCenter;
    //设置标签文本字体大小
    label.font = [UIFont systemFontOfSize:14];
    //设置标签文本颜色
    label.textColor = [UIColor yellowColor];
    //文字自动适应标签宽度，当文字宽大于文本控件的宽时才会调整
    label.adjustsFontSizeToFitWidth = YES;
    //设置输入框的左视图
    textField.leftView = label;
    
    return textField;
}

///初始化按钮
- (UIButton *)buttonInitWith:(CGRect)frame withTitle:(NSString *)name{
    //初始化按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮位置
    button.frame = frame;
    //设置按钮标题
    [button setTitle:name forState:UIControlStateNormal];
    //设置按钮标题颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //按钮添加点击事件
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮到视图控制器
    [self.view addSubview:button];
    //返回按钮
    return button;
}

///按钮点击事件
-(void)buttonClick{
    //Block传值
    self.MyBlock(self.userNameText.text, self.passWordText.text);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
