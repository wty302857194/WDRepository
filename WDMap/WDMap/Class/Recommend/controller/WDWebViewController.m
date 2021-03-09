//
//  WDWebViewController.m
//  WDMap
//
//  Created by wbb on 2021/2/26.
//

#import "WDWebViewController.h"
#import <WebKit/WebKit.h>

@interface WDWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * webView;
@end

@implementation WDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setWKWeb];
}

- (void)setWKWeb {
    //js脚本 （脚本注入设置网页样式）
    NSString *jScript = self.htmlString;
    //配置对象
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    //改变初始化方法 （这里一定要给个初始宽度，要不算的高度不对）
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
    [webView loadHTMLString:[self adaptWebViewForHtml:jScript] baseURL:nil];
    webView.scrollView.bounces = NO;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
}
//HTML适配图片文字
- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];

    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
     //适配图片宽度，让图片宽度最大等于屏幕宽度
//    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];

    
   //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}


@end
