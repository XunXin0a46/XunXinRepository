//
//  TestWebViewAndJSInteractiveController.m
//  FrameworksTest
//
//  Created by 王刚 on 2021/2/2.
//  Copyright © 2021 王刚. All rights reserved.
//

#import "TestWebViewAndJSInteractiveController.h"

@interface TestWebViewAndJSInteractiveController ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TestWebViewAndJSInteractiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IOS与JS交互";
    [self createUI];
}

- (void)dealloc{
    //删除脚本消息处理程序
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"jsCallios"];
}


- (void)createUI{
    
    ///调用JS函数的按钮
    UIButton *iosCallJsButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:iosCallJsButton];
    iosCallJsButton.layer.cornerRadius = 22.0;
    iosCallJsButton.layer.masksToBounds = YES;
    iosCallJsButton.titleLabel.font = [UIFont systemFontOfSize:16];
    iosCallJsButton.backgroundColor = [UIColor redColor];
    [iosCallJsButton setTitle:@"调用JS函数" forState:UIControlStateNormal];
    [iosCallJsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iosCallJsButton addTarget:self action:@selector(CallJsFunction) forControlEvents:UIControlEventTouchUpInside];
    
    [iosCallJsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- 10);
        make.left.equalTo(self).offset(10 * 2.0);
        make.right.equalTo(self).offset(-10 * 2.0);
        make.height.mas_equalTo(44);
    }];
    
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    //初始化偏好设置属性：preferences
    configuration.preferences = [WKPreferences new];
    //默认情况下，最小字体大小为0;
    configuration.preferences.minimumFontSize = 0;
    //是否支持JavaScript
    configuration.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //HTML5视频允许网页播放 
    configuration.allowsInlineMediaPlayback = YES;
    //自动播放, 不需要用户采取任何手势开启播放
    //WKAudiovisualMediaTypeNone 音视频的播放不需要用户手势触发, 即为自动播放
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    //注册要被js调用的jsCallios方法
    [configuration.userContentController addScriptMessageHandler:self name:@"jsCallios"];
    //初始化WKWebView
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
    //设置WKWebView滚动视图代理
    self.webView.scrollView.delegate = self;
    //设置WKWebView用户界面委托代理
    self.webView.UIDelegate = self;
    //设置WKWebView导航代理
    self.webView.navigationDelegate = self;
    //设置WKWebView背景色
    self.webView.backgroundColor = HEXCOLOR(0xEEF2F3);
    //添加WKWebView
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iosCallJsButton.mas_top);
        make.top.left.right.equalTo(self.view);
    }];
    //初始化异常
    NSError *error = nil;
    //读取正在运行的应用程序的捆绑目录中对应resource名称的文件，并使用给定的编码格式解析为字符串
    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestInteractive.html" ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    //设置网页内容
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

///调用JS函数
- (void)CallJsFunction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView evaluateJavaScript:@"iosCalljs('IOS给您拜年了')" completionHandler:^(id response, NSError *error) {
            NSLog(@"%@",error);
        }];
    });
}

#pragma mark -- WKNavigationDelegate
//监听页面加载状态

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"开始加载web页面");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"页面加载完成");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载失败");
}

#pragma mark -- WKUIDelegate
//显示一个alert弹框(iOS展示Html页面alert弹框时使用)

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - WKScriptMessageHandler
//监听js调用注册的函数

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //判断执行的函数名称
    if ([message.name isEqualToString:@"jsCallios"]) {
        NSDictionary *jsCalliosDic = (NSDictionary *)message.body;
        //获取消息参数
        if([jsCalliosDic.allKeys containsObject:@"hello"]){
            //显示提示
            [self.view makeToast:[jsCalliosDic objectForKey:@"hello"]duration:1.5 position:CSToastPositionCenter];
        }
    }
}

@end
