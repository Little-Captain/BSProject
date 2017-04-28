//
//  LCWebViewController.m
//  BSProject
//
//  Created by Liu-Mac on 23/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCWebViewController.h"
#import <WebKit/WebKit.h>

#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <Masonry.h>

@interface LCWebViewController () <WKNavigationDelegate>

/** webView */
@property (nonatomic, weak) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;


@end

@implementation LCWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpWebView];
}

- (void)setUpWebView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebView *webView = [[WKWebView alloc] init];
    // 通过 KVO 监听网页加载进度
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView = webView;
    [self.view insertSubview:webView atIndex:0];
    webView.navigationDelegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressV.mas_bottom);
        make.bottom.equalTo(_toolBar.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)dealloc {
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - 监听网页加载进度

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath  isEqual: @"estimatedProgress"] && object == _webView) {
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            _progressV.hidden = YES;
            [_progressV setProgress:0 animated:NO];
        }else {
            _progressV.hidden = NO;
            [_progressV setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - 导航动作

- (IBAction)goBack:(UIBarButtonItem *)sender {
    
    [_webView goBack];
}

- (IBAction)goForward:(UIBarButtonItem *)sender {
    
    [_webView goForward];
}

- (IBAction)goRefresh:(UIBarButtonItem *)sender {
    
    [_webView reload];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    _back.enabled = [webView canGoBack];
    _forward.enabled = [webView canGoForward];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    _back.enabled = [webView canGoBack];
    _forward.enabled = [webView canGoForward];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    _back.enabled = [webView canGoBack];
    _forward.enabled = [webView canGoForward];
}

@end
