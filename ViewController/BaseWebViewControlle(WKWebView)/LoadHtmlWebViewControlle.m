//
//  LoadHtmlWebViewControlle.m
//  FrameworksTest
//
//  Created by 王刚 on 2020/8/30.
//  Copyright © 2020 王刚. All rights reserved.
//

#import "LoadHtmlWebViewControlle.h"
#import "XLPhotoBrowser.h"

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

@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, copy) NSString *htmls;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) BOOL starLoadFlag;

@end

@implementation LoadHtmlWebViewControlle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"加载Html";
    [self createHtmlStr];
    [self createUI];
}

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
    
    self.htmlString = [TestUtils configResource:@"GoodsDesc.html" DescUrlString:html];
    
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

- (void)createUI{
    self.webView = [[WKWebView alloc]init];
    self.webView.scrollView.delegate = self;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = HEXCOLOR(0xEEF2F3);
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if ([self.htmlString containsString:@"http://"] || [self.htmlString containsString:@"https://"]) {
        [self.webView loadHTMLString:self.htmls baseURL:nil];
    } else {
        NSString *replacedString = [self.htmls stringByReplacingOccurrencesOfString:@"//" withString:@"https://"];
        [self.webView loadHTMLString:replacedString baseURL:nil];
    }
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
