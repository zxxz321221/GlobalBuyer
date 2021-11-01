//
//  ServiceHotlineViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/3/16.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ServiceHotlineViewController.h"
#import <WebKit/WebKit.h>
@interface ServiceHotlineViewController ()
@property (nonatomic , strong) WKWebView * wkWebView;
@end

@implementation ServiceHotlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**
        清除wkWebView所有缓存和cookie
     */
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
    
    //清除cookies
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]){
//        [storage deleteCookie:cookie];
//    }
//    //清除的缓存
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    NSURLCache * cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
    
    [self.view addSubview:self.wkWebView];
    [self LoadWeb];
}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight)];
    }
    return _wkWebView;
}

- (void)LoadWeb
{
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_HelpViewController_CustomerServiceHotline", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    
    
    NSString *str;
    
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
        str = @"http://buy.dayanghang.net/user_data/special/20180316/cn/telephone.html";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
        str = @"http://buy.dayanghang.net/user_data/special/20180316/tw/telephone.html";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
        str = @"http://buy.dayanghang.net/user_data/special/20180316/en/telephone.html";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
        str = @"http://buy.dayanghang.net/user_data/special/20180316/jp/telephone.html";
    }else{
        language = @"zh_CN";
        str = @"http://buy.dayanghang.net/user_data/special/20180316/cn/telephone.html";
    }
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
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
