//
//  ActivityWebViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/14.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "ActivityWebViewController.h"
#import <WebKit/WebKit.h>
@interface ActivityWebViewController ()

@property (nonatomic,strong)WKWebView *web;

@end

@implementation ActivityWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadHref];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:self.web];
}

- (void)loadHref
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.href]];
    [self.web loadRequest:request];
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
