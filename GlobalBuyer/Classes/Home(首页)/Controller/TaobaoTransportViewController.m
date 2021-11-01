//
//  TaobaoTransportViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "TaobaoTransportViewController.h"
#import "TaobaoShopCartViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <AlibabaAuthSDK/ALBBSession.h>
#import <AlibcTradeBiz/AlibcTradeEnv.h>
#import <WebKit/WebKit.h>
#import "ActViewController.h"
@interface TaobaoTransportViewController ()<UIScrollViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong)UIButton *toGrantAuthorizationBtn;
@property (nonatomic,strong)UIScrollView *scrollBack;
@property (nonatomic,strong)UIView *taobaoIntroduceV;
@property (nonatomic,assign)NSInteger taobaoIntroducePage;
@property (nonatomic,strong)UILabel *introduceLb;
@property (nonatomic,strong)UILabel *introduceNumLb;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIScrollView *sv;

@property (nonatomic, strong) UIProgressView *myProgressView;

@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation TaobaoTransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI
{
//    self.title = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ProcessIntroduction", nil);
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.navigationItem.titleView = titleView;
    titleView.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ProcessIntroduction", nil);
    titleView.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.toGrantAuthorizationBtn];
    [self.view addSubview:self.myWebView];
    [self.view addSubview:self.myProgressView];
    if([self.type isEqualToString:@"淘宝转运"]){
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://buy.dayanghang.net/user_data/special/20210321/index.html"]]];
    }else{
       [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://buy.dayanghang.net/user_data/special/20190429/TaoBaoTransport.html"]]];
    }
    
//    [self.view addSubview:self.scrollBack];
//    self.taobaoIntroducePage = 0;
    
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"TaoBaoIntroduce"]isEqualToString:@"YES"]) {
//
//    }else{
//        [self.view addSubview:self.taobaoIntroduceV];
//    }
}

- (UIView *)taobaoIntroduceV
{
    if (_taobaoIntroduceV == nil) {
        _taobaoIntroduceV = [[UIView alloc]initWithFrame:self.view.bounds];
        _taobaoIntroduceV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(50, 100, kScreenW - 100, kScreenH - 150)];
        conV.backgroundColor = [UIColor lightGrayColor];
        [_taobaoIntroduceV addSubview:conV];
        self.sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, conV.frame.size.width, conV.frame.size.height - 100)];
        self.sv.backgroundColor = [UIColor whiteColor];
        [conV addSubview:self.sv];
        NSArray *arr = @[@"ic_taobao_introduce_1",@"ic_taobao_introduce_2",@"ic_taobao_introduce_3",@"ic_taobao_introduce_4",@"ic_taobao_introduce_5",@"ic_taobao_introduce_6"];
        for (int i = 0; i < arr.count; i++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(self.sv.frame.size.width*i, 0, self.sv.frame.size.width, self.sv.frame.size.height)];
            iv.image = [UIImage imageNamed:arr[i]];
            [self.sv addSubview:iv];
        }
        self.sv.contentSize = CGSizeMake(self.sv.frame.size.width*6, 0);
        self.sv.showsVerticalScrollIndicator = NO;
        self.sv.showsHorizontalScrollIndicator = NO;
        self.sv.pagingEnabled = YES;
        self.sv.delegate = self;
        self.introduceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, conV.frame.size.height - 100, 100, 100)];
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_one", nil);
        self.introduceLb.numberOfLines = 0;
        [conV addSubview:self.introduceLb];
        
        self.introduceNumLb = [[UILabel alloc]initWithFrame:CGRectMake(conV.frame.size.width - 110, conV.frame.size.height - 100, 100, 100)];
        self.introduceNumLb.text = @"1/6";
        self.introduceNumLb.textAlignment = NSTextAlignmentRight;
        [conV addSubview:self.introduceNumLb];
        
        self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, conV.frame.size.height - 160, 50, 50)];
        [self.leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [conV addSubview:self.leftBtn];
        [self.leftBtn addTarget:self action:@selector(previousPage) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(conV.frame.size.width - 70, conV.frame.size.height - 160, 50, 50)];
        [self.rightBtn setImage:[UIImage imageNamed:@"ic_dialog_next"] forState:UIControlStateNormal];
        [conV addSubview:self.rightBtn];
        [self.rightBtn addTarget:self action:@selector(pageNext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _taobaoIntroduceV;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 0) {
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_one", nil);
        self.introduceNumLb.text = @"1/6";
        self.taobaoIntroducePage = 0;
        [self.leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 1) {
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_two", nil);
        self.introduceNumLb.text = @"2/6";
        self.taobaoIntroducePage = 1;
        [self.leftBtn setImage:[UIImage imageNamed:@"ic_dialog_previous"] forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 2) {
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_three", nil);
        self.introduceNumLb.text = @"3/6";
        self.taobaoIntroducePage = 2;
    }
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 3) {
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_four", nil);
        self.introduceNumLb.text = @"4/6";
        self.taobaoIntroducePage = 3;
    }
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 4) {
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_five", nil);
        self.introduceNumLb.text = @"5/6";
        self.taobaoIntroducePage = 4;
        [self.rightBtn setImage:[UIImage imageNamed:@"ic_dialog_next"] forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 5) {
        self.introduceLb.text = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis_six", nil);
        self.introduceNumLb.text = @"6/6";
        self.taobaoIntroducePage = 5;
        [self.rightBtn setImage:[UIImage imageNamed:@"ic_dialog_complete"] forState:UIControlStateNormal];
    }
}

- (void)pageNext
{
    if (self.taobaoIntroducePage == 5) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"TaoBaoIntroduce"];
        [self.taobaoIntroduceV removeFromSuperview];
        self.taobaoIntroduceV = nil;
        return;
    }
    if (self.taobaoIntroducePage < 6) {
        self.taobaoIntroducePage++;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.sv.contentOffset = CGPointMake(self.sv.frame.size.width*self.taobaoIntroducePage, 0);
    }];
}

- (void)previousPage
{

    if (self.taobaoIntroducePage > 0) {
        self.taobaoIntroducePage--;
    }
    if (self.taobaoIntroducePage < 0) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sv.contentOffset = CGPointMake(self.sv.frame.size.width*self.taobaoIntroducePage, 0);
    }];
}

- (UIButton *)toGrantAuthorizationBtn
{
    if (_toGrantAuthorizationBtn == nil) {
        _toGrantAuthorizationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - 40, kScreenW, 40)];
        _toGrantAuthorizationBtn.backgroundColor = Main_Color;
        [_toGrantAuthorizationBtn setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_AuthorizedLogin", nil) forState:UIControlStateNormal];
        [_toGrantAuthorizationBtn addTarget:self action:@selector(authorizationClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toGrantAuthorizationBtn;
}

- (void)authorizationClick
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//
//    ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
//    [albbSDK setAppkey:@"24912514"];
//    [albbSDK setAuthOption:NormalAuth];
//    [albbSDK auth:self successCallback:^(ALBBSession *session){
//        [hud hideAnimated:YES];
   
    
    
    if ([self.type isEqualToString:@"淘宝转运"]) {
        TaobaoShopCartViewController * tvc = [[TaobaoShopCartViewController alloc]init];
        tvc.shopCartStr = @"https://h5.m.taobao.com/mlapp/cart.html";
        tvc.type = 0;
        tvc.navT = @"TaoBaoCart";
        [self.navigationController pushViewController:tvc animated:YES];
               
           
    }else{
      ActViewController * vc = [[ActViewController alloc]init];
                   //        TaobaoShopCartViewController *vc = [[TaobaoShopCartViewController alloc]init];
                          
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = self.type;
        [self.navigationController pushViewController:vc animated:YES];
                   //    } failureCallback:^(ALBBSession *session,NSError *error){
                   //        NSLog(@"session == %@,error == %@",session,error);
                   //    }];
               
    }

}

- (UIScrollView *)scrollBack
{
    if (_scrollBack == nil) {
        _scrollBack = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64 - 40)];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*10.4)];
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            iv.image = [UIImage imageNamed:@"wotada-转运指引简体.jpg"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            iv.image = [UIImage imageNamed:@"wotada-转运指引繁体.jpg"];
        }else if([currentLanguage isEqualToString:@"en"]){
            iv.image = [UIImage imageNamed:@"wotada-转运指引繁体.jpg"];
        }else{
            iv.image = [UIImage imageNamed:@"wotada-转运指引繁体.jpg"];
        }
//        iv.image = [UIImage imageNamed:@"Wotada淘宝转运指引.jpg"];
        [_scrollBack addSubview:iv];
        _scrollBack.contentSize = CGSizeMake(0, kScreenW*10.4);
    }
    return _scrollBack;
}
- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-104)];
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
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
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
