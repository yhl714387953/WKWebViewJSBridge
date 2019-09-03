//
//  ViewController.m
//  WebViewJS-OC
//
//  Created by 嘴爷 on 2019/8/26.
//  Copyright © 2019 嘴爷. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate, WKScriptMessageHandler>

/** <#description#> */
@property (nonatomic, strong) WKWebView* webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];//必须先添加视图再添加约束
    [self addConstraintForWebView];
    [self loadHomePage];
    
    // Do any additional setup after loading the view.
}

-(void)addConstraintForWebView{
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    //    此属性必须要设置为NO，否则约束不生效
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[topConstraint, rightConstraint, bottomConstraint, leftConstraint]];
}

-(void)loadHomePage{
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"WebPage" ofType:@".html"];
    [self.webView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:filePath]];
}

#pragma mark - getter
-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;//可以禁止弹出全屏  网页video标签要加 上playsinline 这个属性
        WKUserContentController* uc = [[WKUserContentController alloc] init];
        config.userContentController = uc;
        [uc addScriptMessageHandler:self name:@"CallApp"];
        [uc addScriptMessageHandler:self name:@"APPVideoPlay"];
        //        其中name参数在JS里的写法如下：
        //        window.webkit.messageHandlers.CallApp.postMessage(params);
        //        就是 messageHandlers 后面的参数
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.UIDelegate = self;
    }
    
    return _webView;
}



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"方法名：%@", message.name);
    NSLog(@"参数：%@", message.body);
    
    if ([message.name isEqualToString:@"APPVideoPlay"]) {
        NSLog(@"是让我播放视频吗？");
        NSString* url = @"http://muymov.a.yximgs.com/bs2/newWatermark/MTQwMjI4MjU2NDM_zh_4.mp4";
        
        //  必须要有双引号
        NSString* method = [NSString stringWithFormat:@"videoPlay(\"%@\")", url];
        [self.webView evaluateJavaScript:method completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
            }else{
                NSLog(@"JS方法调用成功");
            }
        }];
    }
}

#pragma mark - WKUIDelegate
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"%@", message);
    completionHandler();
}


@end
