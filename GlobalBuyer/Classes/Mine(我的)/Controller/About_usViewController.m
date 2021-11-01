//
//  About_usViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/16.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "About_usViewController.h"
#import <WebKit/WebKit.h>
@interface About_usViewController ()
@property (nonatomic , strong) WKWebView * wkWebView;
@end

@implementation About_usViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.wkWebView];
    [self requestHTML];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
    self.title = @"关于我们";
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView  = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-NavBarHeight)];
        
    }
    return _wkWebView;
}
- (void)requestHTML{
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
    parameters[@"name"] = @"about_us";
    parameters[@"sign"] = @"symbol";
    parameters[@"locale"] = language;
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/help/content/one" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSString * str = responseObject[@"data"][@"body"];
            NSString * string;
            string=[str stringByReplacingOccurrencesOfString:@"src=\""withString:@"src=\"http://buy.dayanghang.net"];
            [self.wkWebView loadHTMLString:string baseURL:nil];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREEN_WIDTH / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
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
