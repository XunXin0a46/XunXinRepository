//
//  LoadHtmlWebViewControlle.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/30.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "LoadHtmlWebViewControlle.h"
#import "XLPhotoBrowser.h"
#import "TestWebViewAndJSInteractiveController.h"

//图片点击事件的js代码文本
static NSString *const JSGetImges = @"function addImgClickEvent() {\
var imgs = document.getElementsByTagName('img');\
var imgUrlStr='';\
for (var i = 0; i < imgs.length; i++) {\
var img = imgs[i];\
img.onclick = function (e) {\
var parentNode = this.parentNode;\
var tagName = parentNode.tagName;\
var url = parentNode.getAttribute('href');\
if ('A' ==  tagName) {\
e.preventDefault();\
e.stopPropagation();\
window.location.href = 'a:' + url;\
return false;\
} else {\
window.location.href = 'img:' + this.src;\
}\
};\
if(imgs[i].alt==''){\
imgUrlStr+='#'+imgs[i].src;\
}\
}\
return imgUrlStr;\
}";

@interface LoadHtmlWebViewControlle ()<UIScrollViewDelegate,WKUIDelegate, WKNavigationDelegate,XLPhotoBrowserDatasource>

@property (nonatomic, copy) NSString *htmlString;//图片相关的Html文本
@property (nonatomic, copy) NSString *htmls;//生成的需要加载的Html文本
@property (nonatomic, strong) WKWebView *webView;//webView
@property (nonatomic, strong) NSArray *imagesArray;//存放图片的数组
@property (nonatomic, assign) BOOL starLoadFlag;//页面是否开始加载

@end

@implementation LoadHtmlWebViewControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"加载Html";
    //创建Html文本
    [self createHtmlStr];
    //创建视图
    [self createUI];
    //设置导航栏右侧按钮
    [self setRightBarButton];
}

///创建Html文本
- (void)createHtmlStr{
    
    NSString *html = [NSString stringWithFormat:@"<div align=\"center\"> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376249515.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376245513.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376251204.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376269587.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376261822.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376277179.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376288004.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376289858.jpg\" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/gallery/2019/12/18/15766376299235.jpg\" /> \n"
    "<br/> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/images/2019/12/23/15770649519208.jpg\" width=\"750\" height=\"974\" alt="" /> \n"
    "<img src=\"https://oss.azmbk.com/images/shop/6/images/2019/12/23/15770649623568.jpg\" width=\"750\" height=\"875\" alt="" /> \n"
    "</div>"];
    
    //根据GoodsDesc.html文件配置图片相关的Html文本
    self.htmlString = [TestUtils configResource:@"GoodsDesc.html" DescUrlString:html];
    //生成需要加载的Html文本
    self.htmls = [NSString stringWithFormat:@"<html> \n"
    "<head> \n"
    "<style type=\"text/css\"> \n"
    "body {font-size:15px;}\n"
    "</style> \n"
    "</head> \n"
    "<body>"
    "<script type='text/javascript'>"
    "window.onload = function(){\n"
    "var $img = document.getElementsByTagName('img');\n"
    "for(var p in  $img){\n"
    " $img[p].style.width = '100%%';\n"
    "$img[p].style.height ='auto'\n"
    "}\n"
    "}"
    "</script>%@"
    "</body>"
    "</html>",self.htmlString];
}

///创建视图
- (void)createUI{
    //初始化WKWebView
    self.webView = [[WKWebView alloc]init];
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
        make.edges.equalTo(self.view);
    }];
    //判断图片相关的Html文本是否包含"http://"或者"https://"
    if ([self.htmlString containsString:@"http://"] || [self.htmlString containsString:@"https://"]) {
        //设置网页内容和基本URL并开始导航
        [self.webView loadHTMLString:self.htmls baseURL:nil];
    } else {
        //将所有的"//"替换为"https://"
        NSString *replacedString = [self.htmls stringByReplacingOccurrencesOfString:@"//" withString:@"https://"];
        //设置网页内容和基本URL并开始导航
        [self.webView loadHTMLString:replacedString baseURL:nil];
    }
}

///设置导航栏右侧按钮
- (void)setRightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"iOS与JS交互" style:UIBarButtonItemStylePlain target:self action:@selector(openTestWebViewAndJSInteractiveController)];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: HEXCOLOR(0x666666)} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

///前往web视图与js交互视图控制器
- (void)openTestWebViewAndJSInteractiveController{
    TestWebViewAndJSInteractiveController *webViewAndJSInteractive = [[TestWebViewAndJSInteractiveController alloc]init];
    webViewAndJSInteractive.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewAndJSInteractive animated:YES];
}

///显示大图
- (void)showBigImage:(NSURLRequest *)request imageArray:(NSArray *)imageArray{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    NSString *imageUrl = [requestString substringFromIndex:@"img:".length];
    NSArray *imgUrlArr= imageArray;
    NSInteger index=0;
    for (NSInteger i=0; i<[imgUrlArr count]; i++) {
        if([imageUrl isEqualToString:imgUrlArr[i]]){
            index=i;
            break;
        }
    }
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:imageArray currentImageIndex:index];
    browser.datasource = self;
    browser.pageDotColor = [UIColor grayColor]; // 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor whiteColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
}


#pragma mark --WKWebViewDelegate

///页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 修改图片大小 适应屏幕
    // 修改字体大小
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];
    //注入js代码
    [webView evaluateJavaScript:JSGetImges completionHandler:^(id Result,  NSError * _Nullable error) {
    }];
    //执行js
    __weak typeof(self) weakSelf=self;
    [webView evaluateJavaScript:@"addImgClickEvent()" completionHandler:^(id Result, NSError * error) {
        __strong typeof(self) strongSelf=weakSelf;
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"]){
            resurlt = [resurlt substringFromIndex:1];
        }
        strongSelf.imagesArray = [resurlt componentsSeparatedByString:@"#"];
        
    }];
    //  修改webView背景颜色
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#F56456'" completionHandler:^(id Result, NSError * _Nullable error) {
    }];
    
}

///在发送请求之前，决定是否允许或取消导航
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //判断是否是自定义的协议，如果是，拦截事件
    if ([navigationAction.request.URL.scheme isEqualToString:@"img"]) {
       //处理图片点击事件
        [self showBigImage:navigationAction.request imageArray:self.imagesArray];
    }else if ([navigationAction.request.URL.scheme isEqualToString:@"a"]){
        //处理链接
        NSString *urlStr = [navigationAction.request.URL.absoluteString substringFromIndex:@"a:".length];
        NSLog(@"%@",urlStr);
    }
    if (self.starLoadFlag) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

///页面开始加载web内容时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.starLoadFlag = YES;
}

@end
