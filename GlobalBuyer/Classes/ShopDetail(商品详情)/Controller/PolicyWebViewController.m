//
//  PolicyWebViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/17.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "PolicyWebViewController.h"
#import <WebKit/WebKit.h>
@interface PolicyWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *myProgressView;

@property (nonatomic, strong) WKWebView *myWebView;
@end

@implementation PolicyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"wodata隐私政策";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myWebView];
    self.myWebView.frame = self.view.bounds;
    [self.view addSubview:self.myProgressView];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://buy.dayanghang.net/user_data/special/20190417/termsTW.html"]]];
}
- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _myWebView.navigationDelegate = self;
        _myWebView.opaque = NO;
        _myWebView.multipleTouchEnabled = YES;
        [_myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _myWebView;
}
// 记得取消监听
- (void)dealloc
{
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.myWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
