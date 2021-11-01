//
//  TrackViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/10.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "TrackViewController.h"
#import <WebKit/WebKit.h>
@interface TrackViewController ()<WKNavigationDelegate>
@property (nonatomic, strong)NSString *htmlString;
@property (nonatomic, strong) UIProgressView *myProgressView;

@property (nonatomic, strong) WKWebView *myWebView;
@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self downloadData];
    // Do any additional setup after loading the view.
}

#pragma mark 下载物流数据
- (void)downloadData {
//    NSString *api_token = UserDefaultObjectForKey(USERTOKEN);
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    params[@"num"] = self.num;
//    params[@"api_token"] = api_token;
//    if (self.express_name) {
//        params[@"express_name"] = self.express_name;
//    }
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:TrackApi parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([responseObject[@"code"] isEqualToString:@"success"]) {
//            self.htmlString = responseObject[@"data"];
//            [self webViewLoadHTMLString];
//        }else{
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_Queryfailed", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    
//    }];
}

#pragma mark 加载html
- (void)webViewLoadHTMLString {
 NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendString:@"<html>"];
    // css js
    [htmlString appendString:@"<head>"];
    [htmlString appendString:self.htmlString];
    [htmlString appendString:@"</html>"];
    // css js
    [htmlString appendString:@"</head>"];
    [self.myWebView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark 设置UI
- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Order_title", nil);
    [self setNavigationBackBtn];
    [self.view addSubview:self.myWebView];
}
- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
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
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

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
