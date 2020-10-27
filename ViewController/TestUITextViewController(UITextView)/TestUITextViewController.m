//
//  TestUITextViewController.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/3/24.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "TestUITextViewController.h"
#import "UIPlaceHolderTextView.h"

@interface TestUITextViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TestUITextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationTitleView:@"文本视图"];
    [self textViewCodeTest];
}

///---------------------------------------- UITextView代码测试区 ------------------------------------

- (void)textViewCodeTest{
    
    UIPlaceHolderTextView *placeHolderTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectZero];
    placeHolderTextView.backgroundColor = [UIColor greenColor];
    placeHolderTextView.placeholder = @"粘贴文本，可自动识别姓名、电话和地址。\r如：李明 139****8888 北京市朝阳区xx街道xx大厦xx楼xx室。";
    placeHolderTextView.placeholderColor = [UIColor redColor];
    placeHolderTextView.layoutManager.allowsNonContiguousLayout = NO;
    placeHolderTextView.text = @"百度一下：www.baidu.com,文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的";
    placeHolderTextView.dataDetectorTypes  = UIDataDetectorTypeLink;
    placeHolderTextView.font = [UIFont systemFontOfSize:12];
    placeHolderTextView.textColor = [UIColor redColor];
    placeHolderTextView.selectable = YES;
    placeHolderTextView.editable = NO;
    placeHolderTextView.delegate = self;
    [self.view addSubview:placeHolderTextView];
    [placeHolderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 70));
    }];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectZero];
    textView.backgroundColor = [UIColor grayColor];
    textView.text = @"文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的，文本内容挺多的";
    textView.font = [UIFont systemFontOfSize:15];
    textView.layoutManager.allowsNonContiguousLayout = NO;
    textView.textColor = [UIColor whiteColor];
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:self.textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeHolderTextView.mas_bottom).offset(20);
        make.centerX.equalTo(placeHolderTextView);
        make.size.mas_equalTo(CGSizeMake(150, 100));
    }];
    
    //监听键盘将要出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘已经出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //监听键盘将要隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //监听键盘已经隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSLog(@"键盘将要出现");
    //获取高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"%d",height);
}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSLog(@"键盘已经出现");
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSLog(@"键盘将要隐藏");
}

- (void)keyboardDidHide:(NSNotification *)notification{
    NSLog(@"键盘已经隐藏");
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"即将开始编辑的文本视图");
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"询问代理是否应在指定的文本视图中停止编辑");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"已开始编辑指定的文本视图");
}

///隐藏键盘，实现UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        NSLog(@"放弃第一响应对象，隐藏键盘");
        
        return NO;
    }
    
    NSLog(@"询问代理是否应在文本视图中替换指定的文本");
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"通知委托指定文本视图中的文本或属性已被用户更改。");
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"通知代理在指定的文本视图中更改了文本选择");
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){
    NSLog(@"%@",URL);
    NSLog(@"%lu",(unsigned long)characterRange.length);
    return YES;
}

///------------------------------------------- UITextView代码测试区结束 ---------------------------------

@end
