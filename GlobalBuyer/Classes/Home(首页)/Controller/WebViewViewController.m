//
//  WebViewViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/6/29.
//  Copyright © 2017年 薛铭. All rights reserved.
//

#import "WebViewViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewViewController ()
@property (nonatomic , strong) WKWebView * wkWebView;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self LoadWeb];
}

- (void)LoadWeb
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.wkWebView];
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationUrl"];
    NSURL *url = [NSURL URLWithString:str];
    
    if (self.url) {
        url = [NSURL URLWithString:self.url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self.wkWebView loadRequest:request];
}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height+44+4)];
        
    }
    return _wkWebView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
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
