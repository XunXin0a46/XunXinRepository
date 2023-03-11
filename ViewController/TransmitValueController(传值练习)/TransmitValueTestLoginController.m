//
//  TransmitValueTestLoginController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/9/20.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TransmitValueTestLoginController.h"
#import "TransmitValueTestRegisterController.h"
#import "TransmitValueTestHomePageController.h"

@interface TransmitValueTestLoginController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameText;//用户名输入框
@property (nonatomic, strong) UITextField *passWordText;//密码输入框
@property (nonatomic, strong) UIButton  *loginBtn;//登录按钮
@property (nonatomic, strong) UIButton *resignBtn;//注册按钮

@end

@implementation TransmitValueTestLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控制器标题
    self.title = @"登录";
    //设置控制器视图背景颜色
    self.view.backgroundColor = [UIColor yellowColor];
    //初始化用户名输入框
    self.userNameText = [self getTextField:100 leftViewName:@" 用户名:"];
    //初始化密码输入框
    self.passWordText = [self getTextField:CGRectGetMaxY(_userNameText.frame)+20 leftViewName:@" 密码:"];
    //初始化登录按钮
    self.loginBtn = [self buttonInitWith:CGRectMake(self.view.frame.size.width - 20 - 100, CGRectGetMaxY(_passWordText.frame) + 50, 100, 45) withTitle:@"登录"];
    self.loginBtn.backgroundColor=[UIColor redColor];
    //初始化注册按钮
    self.resignBtn=[self buttonInitWith:CGRectMake(20, CGRectGetMaxY(_passWordText.frame)+50, 100, 45) withTitle:@"注册"];
    self.resignBtn.backgroundColor=[UIColor greenColor];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fun:) name:@"tongzhi" object:nil];
}

- (void)dealloc{
    NSLog(@"登录已经释放了");
}

///初始化输入框
-(UITextField *)getTextField:(CGFloat )y leftViewName:(NSString *)name{
    //初始化输入框
    UITextField *  textField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, self.view.frame.size.width - 40, 45)];
    //设置输入框边框的宽度
    textField.layer.borderWidth = 1.0f;
    //输入的文字颜色
    textField.textColor = [UIColor greenColor];
    //设置输入框代理
    textField.delegate = self;
    //输入框左视图始终显示
    textField.leftViewMode = UITextFieldViewModeAlways;
    //设置输入框提示文本及提示文本颜色
    textField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName : [UIColor greenColor]}];
    //透明效果
    [textField setBackgroundColor:[UIColor clearColor]];
    //将输入框添加到当前控制器视图
    [self.view addSubview:textField];
    
    //初始化标签
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    //设置标签文本
    label.text = name;
    //设置标签文本对齐方式
    label.textAlignment = NSTextAlignmentCenter;
    //设置标签文本字体大小
    label.font = [UIFont systemFontOfSize:14];
    //设置标签文本的颜色
    label.textColor = [UIColor greenColor];
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
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //将按钮添加到控制器视图
    [self.view addSubview:button];
    //返回初始化的按钮
    return button;
}

///按钮点击事件
- (void)buttonClick:(UIButton *)button{
    //输入框放弃第一响应对象
    [self textResignFirstResponder];
    //注册按钮点击事件
    if ([button.titleLabel.text isEqualToString:@"注册"]) {
        NSLog(@"注册");
        TransmitValueTestRegisterController *resignVC = [[TransmitValueTestRegisterController alloc]init];
        [self.navigationController pushViewController:resignVC animated:YES];
    }
    //登录按钮点击事件
    if ([button.titleLabel.text isEqualToString:@"登录"]) {
        NSLog(@"登录");
        TransmitValueTestHomePageController *HomePageVC = [[TransmitValueTestHomePageController alloc]init];
        //对局部的对象变量使用弱引用
        __weak typeof(HomePageVC) weakHomePageVC = HomePageVC;
        //属性传值
        HomePageVC.userName = self.userNameText.text;
        HomePageVC.passWord = self.passWordText.text;
        [self.navigationController pushViewController:HomePageVC animated:YES];
        //Block回调
        HomePageVC.MyBlock = ^(NSString *userName,NSString *passWord){
            self.userNameText.text = userName;
            self.passWordText.text = passWord;
            NSLog(@"%@",weakHomePageVC.passWord);
        };
    }
}

///输入框放弃第一响应对象
- (void)textResignFirstResponder{
    [_userNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
}

///手指按下事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //输入框放弃第一响应对象
    [self textResignFirstResponder];
}

#pragma mark UITextFieldDelegate
///点击return键
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //输入框放弃第一响应对象
    [self textResignFirstResponder];
    return YES;
}

///通知执行的方法
-(void)fun:(NSNotification *)notification{
    //取出通知传递参数的字典
    NSDictionary *dic = notification.userInfo;
    //设置用户名输入框内容
    self.userNameText.text = [dic objectForKey:@"userName"];
    //设置密码输入框内容
    self.passWordText.text = [dic objectForKey:@"passWord"];
}


@end
