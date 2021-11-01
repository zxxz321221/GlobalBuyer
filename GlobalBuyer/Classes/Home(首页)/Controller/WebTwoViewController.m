//
//  WebTwoViewController.m
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/7/3.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import "WebTwoViewController.h"
#import <WebKit/WebKit.h>

@interface WebTwoViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
//@property (nonatomic , strong) AroundAnimation * aAnimation;

@end

@implementation WebTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
}
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
//        if ([self.flow isEqualToString:@"0"]) {
//            NSString * string;
//            string=[self.htmlStr stringByReplacingOccurrencesOfString:@"src=\""withString:@"src=\"http://shaogood.com"];
//            [_webView loadHTMLString:string baseURL:nil];
//        }else{
//            NSString * str = [self editString:self.htmlStr];
//            NSString * string = @"";
//            string = [NSString stringWithFormat:@"<div align=\"center\">\r\n\t%@<br />\r\n</div>",str];
//            [_webView loadHTMLString:string baseURL:nil];
//        }
    }
    return _webView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestHelp];
    
}
- (void)requestHelp{
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"name"] = self.num;
    parameters[@"locale"] = language;
    parameters[@"sign"] = @"symbol";
    
    
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/help/content/one" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSString * str = responseObject[@"data"][@"body"];
            NSString * string;
            string=[str stringByReplacingOccurrencesOfString:@"src=\""withString:@"src=\"hhttp://buy.dayanghang.net"];
            [self.webView loadHTMLString:string baseURL:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    [self.aAnimation startAround];
//    NSDictionary * dic = @{@"help":self.num};
//    [GZMrequest getWithURLString:[GZMUrl get_helpDetail_url] parameters:dic success:^(NSDictionary *data) {
//        NSLog(@"帮助详情%@",data);
////        [self.aAnimation stopAround];
//        self.title = data[@"data"][0][@"title"];
//        if ([[data objectForKey:@"code"]isEqualToString:@"success"]) {
//            if ([data[@"data"][0][@"flow"]isEqualToString:@"0"]) {
//                NSString * string;
//                string=[data[@"data"][0][@"content"] stringByReplacingOccurrencesOfString:@"src=\""withString:@"src=\"http://shaogood.com"];
//                [self.webView loadHTMLString:string baseURL:nil];
//            }else{
//                NSString * str = [self editString:data[@"data"][0][@"content"]];
//                NSString * string = @"";
//                string = [NSString stringWithFormat:@"<div align=\"center\">\r\n\t%@<br />\r\n</div>",str];
//                [self.webView loadHTMLString:string baseURL:nil];
//            }
//        }else{
//            [WHToast showMessage:data[@"msg"] originY:SCREEN_HEIGHT-[Unity countcoordinatesH:100] duration:2 finishHandler:^{}];
//        }
//    } failure:^(NSError *error) {
////        [self.aAnimation stopAround];
//        [WHToast showMessage:@"加载失败" originY:SCREEN_HEIGHT-[Unity countcoordinatesH:100] duration:2 finishHandler:^{}];
//    }];
}
- (NSString *)editString:(NSString *)str{
    NSString * str1 = @"http://www.shaogood.com";
    NSArray *array = [str componentsSeparatedByString:@";"];
    NSString * str2 = @"";
    for (int i=0; i<array.count; i++) {
        NSString * string = @"";
        if ([array[i] rangeOfString:@"||"].location == NSNotFound) {
            NSArray *array1 = [array[i] componentsSeparatedByString:@"|"];
            string = [NSString stringWithFormat:@"<h1>%@</h1><h3>%@</h3><img src=\"%@%@\" alt=\"\" />",array1[0],array1[1],str1,array1[2]];
            str2 = [str2 stringByAppendingFormat:@"%@",string];
            
        } else {
            NSArray *array1 = [array[i] componentsSeparatedByString:@"||"];
            string = [NSString stringWithFormat:@"<h1>%@</h1><h3></h3><img src=\"%@%@\" alt=\"\" />",array1[0],str1,array1[1]];
            str2 = [str2 stringByAppendingFormat:@"%@",string];
        }
    }
    return str2;
}
//- (AroundAnimation *)aAnimation{
//    if (!_aAnimation) {
//        UIWindow * window = [UIApplication sharedApplication].windows[0];
//        _aAnimation = [AroundAnimation AroundAnimationViewSetView:window];
//    }
//    return _aAnimation;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
