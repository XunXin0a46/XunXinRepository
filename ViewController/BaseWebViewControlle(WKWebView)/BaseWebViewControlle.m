//
//  BaseWebViewController.m


#import "BaseWebViewControlle.h"
#import "LoadHtmlWebViewControlle.h"


@interface BaseWebViewControlle ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate >

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BaseWebViewControlle

///该方法只会在控制器加载完view时被调用,viewDidLoad通常不会被第二次调用除非这个view因为某些原因没有及时加载出来
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createNavigationTitleView:@"WKWebView"];
    
    [self setUpCommonHeader];
    
    [self setrightBarButton];
    
    if(IS_NOT_EMPTY([[self getIntent]objectForKey:BaseWebViewControlleURL])){
        self.url = [[self getIntent]objectForKey:BaseWebViewControlleURL];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    //创建webview配置对象
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    webConfig.preferences = [[WKPreferences alloc] init];
    // 设置最小字体，默认值为0
    webConfig.preferences.minimumFontSize = 10;
    // 是否启用 javaScript，默认值为YES
    webConfig.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    webConfig.processPool = [[WKProcessPool alloc] init];
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    
    //然而这里的单引号一定要注意是英文的
    //格式  @"document.cookie = 'key1=value1';document.cookie = 'key2=value2'";
    NSString *cookie = [self getCookie];
    
    //注入js修改返回按钮的点击事件
    NSString *scriptStr =  [NSString stringWithFormat:@"function backHomeClick_test(){window.webkit.messageHandlers.backHomeClick_test.postMessage(null);}(function(){document.getElementsByClassName('sb-back')[0].href = 'javascript:window.backHomeClick_test()';}());"];
    //WKUserScript 对象表示可以注入到网页中的脚本
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:scriptStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    //内容交互控制器，自己注入JS代码及JS调用原生方法注册
    WKUserContentController* userContentController = WKUserContentController.new;
    //添加脚本消息处理程序
    [userContentController addScriptMessageHandler:self name:@"backHomeClick_test"];
    //加cookie给h5识别，表明在iOS端打开该地址
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookie
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    //添加用户脚本
    [userContentController addUserScript:cookieScript];
    //添加用户脚本
    [userContentController addUserScript:userScript];
    
    webConfig.userContentController = userContentController;
    
    //初始化webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:webConfig];
    //添加webView
    [self.view addSubview:self.webView];
    //设置背景颜色
    self.webView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.webView.navigationDelegate = self;
    //设置代理
    self.webView.UIDelegate = self;
    //为webView添加观察者
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //添加脚本消息处理程序
    [[_webView configuration].userContentController addScriptMessageHandler:self name:@"historyGo"];
    //获取状态栏的Frame
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的Frame
    CGRect navigationRect = self.navigationController.navigationBar.frame;
    //设置内边距
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(statusRect.size.height + navigationRect.size.height ,0,0,0));
    }];
    
    //UIProgressView用户界面进度视图
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    //进度条颜色
    self.progressView.progressTintColor = [UIColor purpleColor];
    //添加进度视图
    [self.webView addSubview:self.progressView];
    //设置约束
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.webView);
        make.height.mas_equalTo(2.0);
    }];
    //加载请求
    [self loadRequestWithUrlString:self.url];
    
}

///该方法会在view要被显示出来之前被调用。这总是会发生在ViewDidload被调用之后并且每次view显示之前都会调用该方法。
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

///视图被销毁，此处需要对你在init和viewDidLoad中创建的对象进行释放
- (void)dealloc {
    //移除观察者
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)setUpCommonHeader {
    if (self.navigationController.viewControllers.count > 1 ||
        self.presentingViewController) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backToPreviousViewController) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, 0, 25.0, 25.0);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        [backButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"btn_back_dark"] forState:UIControlStateHighlighted];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

///设置导航栏右侧按钮
- (void)setrightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"加载Html" style:UIBarButtonItemStylePlain target:self action:@selector(loadHtml)];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

///返回上一个视图控制器
- (void)backToPreviousViewController {
    [self goBack];
    //将存储的选中的控制器名称置空(点击返回按钮时，消除导航集合视图Item的选中)
    [TestSharedInstance sharedInstance].selectControllerName = @"";
}

///加载Html的控制器
- (void)loadHtml{
    LoadHtmlWebViewControlle *loadHtmlControlle = [[LoadHtmlWebViewControlle alloc]init];
    [self.navigationController pushViewController:loadHtmlControlle animated:YES];
}

- (void)goBack {
    //如果可以返回
    if([self.webView canGoBack]) {
        //进行返回
        [self.webView goBack];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///加载请求
- (void)loadRequestWithUrlString:(NSString *)urlString {
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    //NSHTTPCookieStorage,提供了管理所有NSHTTPCookie对象的接口,NSHTTPCookieStorage类采用单例的设计模式
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    //加载请求
    [self.webView loadRequest:request];
}

- (NSString*) getCookie {
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"document.cookie = '%@=%@';", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
}

///删除空格和换行符
- (NSString *)removeSpaceAndNewline:(NSString *)str {
    
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return temp;
}

/// 观察者方法，监听webView加载进度，调整进度条百分比
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //estimatedProgress当前导航的网页已经加载的估计值（double：0.0~1.0）
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress == 1.0) {
            [self.progressView removeFromSuperview];
        }
    }
}

- (void)setUrl:(NSString *)url{
    _url = url;
}

#pragma make -- WKNavigationDelegate

/// 在发送请求之前，决定是否允许或取消导航
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    
    NSString *scheme = [URL scheme];
    
    if (navigationAction.request.URL.absoluteString.length == 0) {
        //取消导航
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else if ([scheme isEqualToString:@"tel"]) {
        
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt:%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else {
        
        //如果是跳转一个新页面
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        //允许导航继续
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByClassName('header-middle')[0].innerHTML"];
    [webView evaluateJavaScript:tempString completionHandler:^(id Result, NSError * _Nullable error) {
        if (!error) {
            NSString *title = [self removeSpaceAndNewline:Result];
            NSError *error = nil;
            //  判断字符串是否包含html标签，包含则设置标题为webView.title
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"^<(\\s+|\\S+)>$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *result = [regularExpression matchesInString:title options:NSMatchingReportProgress range:NSMakeRange(0, title.length)];
            if (result.count) {
                [self setTitle:webView.title];
            } else {
                [self setTitle:title];
            }
            
        } else {
            [self setTitle:webView.title];
        }
    }];
    
}

/// 页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSString *url = webView.URL.absoluteString;
    NSLog(@"%@",url);
}


///页面加载失败时调用 (web视图加载内容时发生错误)
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    if(error.code == -999){
        return;
    }
    NSLog(@"加载错误时候才调用，错误原因=%@",error);
    
}


/// web视图导航过程中发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%@", error);
}

/// 接收到服务器重定向之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%@",webView.URL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webView.URL];
    [self.webView loadRequest:request];
}

/// 在收到响应之后决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}


#pragma make -- WKScriptMessageHandler

///当从网页接收到脚本消息时调用
//OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"backHomeClick_test"]) {
        [self backToPreviousViewController];
    }
}

#pragma make -- WKUIDelegate

///显示一个 JavaScript 警告弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

///显示一个 JavaScript 确认面板
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

///显示一个 JavaScript 文本输入面板
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

///当使用 Https 协议加载web内容时，使用的证书不合法或者证书过期时
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

@end
