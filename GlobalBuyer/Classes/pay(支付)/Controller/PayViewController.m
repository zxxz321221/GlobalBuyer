//
//  PayViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/8.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "PayViewController.h"
//#import "LoadingView.h"
//#import "UIWebView+DKProgress.h"
//#import "DKProgressLayer.h"

//#import "DYHURLSessionProtocol.h"
#import <WebKit/WebKit.h>
#import "PaySuccessViewController.h"

#import "NSURLProtocol+WKWebVIew.h"
@interface PayViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) UIProgressView *myProgressView;
@property (nonatomic, strong) WKWebView *myWebView;
//@property (nonatomic, strong)LoadingView *loadingView;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [NSURLProtocol wk_registerScheme:@"http"];
//    [NSURLProtocol wk_registerScheme:@"https"];
    [self setupUI];
    [self request];
    
    
    // Do any additional setup after loading the view.
}


//-(LoadingView *)loadingView{
//    if (_loadingView == nil) {
//        _loadingView = [LoadingView LoadingViewSetView:self.view];
//    }
//    return _loadingView;
//}

- (void)request {
    NSString *url = self.urlString;
    NSLog(@"Requset URL : %@",self.urlString);
    NSURL *Url = [[NSURL alloc]initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:Url];
    [self.myWebView loadRequest:request];
    //注册网络请求拦截
//    [NSURLProtocol registerClass:[DYHURLSessionProtocol class]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //取消注册网络请求拦截
//    [NSURLProtocol unregisterClass:[DYHURLSessionProtocol class]];
}
- (void)setupUI {
    [self setNavigationBackBtn];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_PayView_title", nil);
    [self.view addSubview:self.myWebView];

//    [self.loadingView startLoading];
}
- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH))];
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
    NSLog(@"payUrl:%@",[navigationAction.request.URL absoluteString]);
    NSString *requestUrl = [navigationAction.request.URL absoluteString];
    if ([requestUrl isEqualToString:@"http://buy.dayanghang.net/"]) {
        PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
        vc.payType = self.type;
        [self.navigationController pushViewController:vc animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
        return;
//        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsPushProcurementView"];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
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
//        _webView.frame = CGRectMake(0, 0, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH));
//        _webView.backgroundColor = Cell_BgColor;
//        _webView.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 40, DK_DEVICE_WIDTH, 4)];
//        _webView.dk_progressLayer.progressColor = [UIColor greenColor];
//        _webView.dk_progressLayer.progressStyle = DKProgressStyle_Gradual;
//        [self.navigationController.navigationBar.layer addSublayer:self.webView.dk_progressLayer];
//
//    }
//    return _webView;
//}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSLog(@"URLpi'pei%s,%@",__func__,[request.URL absoluteString]);
//    if ([[request.URL absoluteString] isEqual:@"http://buy.dayanghang.net/"] || [[request.URL absoluteString] isEqual:@"https://buy.dayanghang.net/"] || [[request.URL absoluteString] isEqual:@"http://buy.dayanghang.net"]) {
//        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
//        NSNotification *notification =[NSNotification notificationWithName:@"pay" object:nil userInfo:dict];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        //[self.navigationController popToViewController:self.shopCartVC animated:YES];
//    }
//
//    return YES;
//}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//
//    NSLog(@"%s",__func__);
//
////    [self.loadingView stopLoading];
////    [UIView animateWithDuration:2 animations:^{
////        self.loadingView.imgView.animationDuration = 3*0.15;
////        self.loadingView.imgView.animationRepeatCount = 0;
////        [self.loadingView.imgView startAnimating];
////        self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
////    } completion:^(BOOL finished) {
////
////    }];
//}
//
//-(void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"%s",__func__);
//
////    [self.webView.dk_progressLayer progressAnimationStart];
//
//}
//
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"%s",__func__);
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
