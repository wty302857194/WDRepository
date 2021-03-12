//
//  WDWKWebVC.m
//  WDMap
//
//  Created by wbb on 2021/3/9.
//

#import "WDWKWebVC.h"
#import <WebKit/WebKit.h>
@interface WDWKWebVC ()<WKNavigationDelegate>

@end

@implementation WDWKWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setWKWeb];
}
- (void)setWKWeb {
    //js脚本 （脚本注入设置网页样式）
    NSString *jScript = self.htmlString;
    //配置对象
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    //改变初始化方法 （这里一定要给个初始宽度，要不算的高度不对）
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jScript]];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

@end
