//
//  ServiceViewController.m
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/11/19.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import "ServiceViewController.h"
#import "WebTwoViewController.h"
#import "UIWebView+DKProgress.h"
#import "DKProgressLayer.h"
@interface ServiceViewController ()<UIWebViewDelegate,HtmlJSDelegate>
@property (nonatomic , strong) UIWebView * webView;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"GlobalBuyer_OnlineService", nil);
    
    [self.view addSubview:self.webView];
    self.webView.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 44, DK_DEVICE_WIDTH, 2)];
    self.webView.dk_progressLayer.progressColor = [UIColor greenColor];
    self.webView.dk_progressLayer.progressStyle = DKProgressStyle_Gradual;
    
    [self.navigationController.navigationBar.layer addSublayer:self.webView.dk_progressLayer];

}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight)];
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://buy.dayanghang.net/user_data/special/wotata_help.html"]]]];
        _webView.scrollView.bounces=NO;//禁止webview滚动回弹
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"shaogoodBrowser"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
- (void)openHelp:(NSString *)numId
{
    NSLog(@"%@",numId);
    dispatch_async(dispatch_get_main_queue(), ^{
        WebTwoViewController * wtc = [[WebTwoViewController alloc]init];
        wtc.num = numId;
        [self.navigationController pushViewController:wtc animated:YES];
    });
}

@end
