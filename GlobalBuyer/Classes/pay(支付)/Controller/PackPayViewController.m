//
//  PackPayViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/10.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "PackPayViewController.h"
#import "LoadingView.h"
#import <WebKit/WebKit.h>
@interface PackPayViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong)LoadingView *loadingView;

@property (nonatomic, strong) UIProgressView *myProgressView;
@property (nonatomic, strong) WKWebView *myWebView;
@end

@implementation PackPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self request];
    // Do any additional setup after loading the view.
}

- (void)request {
    NSURL *url = [[NSURL alloc]initWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.myWebView loadRequest:request];
}

- (void)setupUI {
    [self setNavigationBackBtn];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Paytransport", nil);
    [self.view addSubview:self.myWebView];
//    [self.loadingView startLoading];
}
- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH))];
        _myWebView.navigationDelegate = self;
        _myWebView.UIDelegate = self;
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
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([[webView.URL absoluteString] isEqual:@"http://buy.dayanghang.net/"] || [[webView.URL absoluteString] isEqual:@"https://buy.dayanghang.net/"]) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
        NSNotification *notification =[NSNotification notificationWithName:@"pay" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
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
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
}
//- (UIWebView *)webView {
//    if (_webView == nil) {
//        _webView = [[UIWebView alloc]init];
//        _webView.delegate = self;
//        _webView.frame = CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH));
//        _webView.backgroundColor = Cell_BgColor;
//    }
//    return _webView;
//}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSLog(@"%@",request.URL);
//    if ([[request.URL absoluteString] isEqual:@"http://buy.dayanghang.net/"] || [[request.URL absoluteString] isEqual:@"https://buy.dayanghang.net/"]) {
//        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
//        NSNotification *notification =[NSNotification notificationWithName:@"pay" object:nil userInfo:dict];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    return YES;
//}
//
//-(void)webViewDidStartLoad:(UIWebView *)webView {
//
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self.loadingView stopLoading];
////    [UIView animateWithDuration:2 animations:^{
////        self.loadingView.imgView.animationDuration = 3*0.15;
////        self.loadingView.imgView.animationRepeatCount = 0;
////        [self.loadingView.imgView startAnimating];
////        self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
////    } completion:^(BOOL finished) {
////
////    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
