//
//  TaobaoShopCartViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "TaobaoShopCartViewController.h"
#import "TaobaoTransportApplyViewController.h"
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <WebKit/WebKit.h>
@interface TaobaoShopCartViewController ()<JSObjcADelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic , strong) WKWebView * wkWebView;

@property (nonatomic , copy)NSString *currentUrl;

@property (nonatomic , retain)UIView *tipShadowView;

@property (nonatomic , retain)UIImageView *tipImgV;

@end

@implementation TaobaoShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self INIT];
}
- (void)INIT{

    self.title = self.navT;
    [self.view addSubview:self.wkWebView];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - (StatusBarHeight+44), kScreenW, StatusBarHeight+44)];
    btn.backgroundColor = Main_Color;
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ApplicationForTransshipment", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(delayMethodssss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        //注册js方法
        config.userContentController = [[WKUserContentController alloc]init];
        //webViewAppShare这个需保持跟服务器端的一致，服务器端通过这个name发消息，客户端这边回调接收消息，从而做相关的处理
        [config.userContentController addScriptMessageHandler:self name:@"browser"];
        
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenW, kScreenH - NavBarHeight) configuration: config];

        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.shopCartStr]]]];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        //京东：https://p.m.jd.com/cart/cart.action?fromnav=1
        //网易：http://m.you.163.com/cart
        //淘宝：https://h5.m.taobao.com/mlapp/cart.html
    }
    return _wkWebView;
}

-(UIView *)tipShadowView{
    if (!_tipShadowView) {
        _tipShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tipShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _tipImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(10), kWidth(220), kWidth(355), kWidth(233))];
        _tipImgV.tag = 100;
        [_tipImgV setImage:[UIImage imageNamed:@"账号登录"]];
        [_tipShadowView addSubview:_tipImgV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipShadowViewClicked)];
        [_tipShadowView addGestureRecognizer:tap];
    }
    
    return _tipShadowView;
}

-(void)tipShadowViewClicked{
    if (self.tipImgV.tag == 100) {
        if ([self.tipImgV.image isEqual:[UIImage imageNamed:@"账号登录"]]) {
            [self.tipShadowView removeFromSuperview];
        }
    }else if (self.tipImgV.tag == 200){
        if ([self.tipImgV.image isEqual:[UIImage imageNamed:@"选择转运商品"]]) {
            [self.tipImgV setImage:[UIImage imageNamed:@"点击申请转运"]];
            self.tipImgV.frame = CGRectMake(0, SCREEN_HEIGHT-kWidth(255), SCREEN_WIDTH, kWidth(235));
        }else{
            [self.tipShadowView removeFromSuperview];
        }
    }
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([self.currentUrl containsString:@"https://havanalogin.taobao.com/mini_login.htm"]) {
        if (![UserDefault valueForKey:@"transfromTip"]) {
            [self.navigationController.view addSubview:self.tipShadowView];
        }
        
    }else if ([self.currentUrl isEqualToString:@"https://cart2.m.1688.com/page/cart.html"]){
        if (self.tipImgV.tag != 200) {
            if (![UserDefault valueForKey:@"transfromTip"]) {
                [self.navigationController.view addSubview:self.tipShadowView];
            }
            self.tipImgV.tag = 200;
            [self.tipImgV setImage:[UIImage imageNamed:@"选择转运商品"]];
            self.tipImgV.frame = CGRectMake(kWidth(15), NAVIGATION_BAR_HEIGHT+kWidth(80), kWidth(345), kWidth(105));
        }
    }
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    self.currentUrl = [navigationAction.request.URL absoluteString];
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"browser"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        //do something
        NSLog(@"%@", [message.body class]);
        NSData *JSONData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        if (responseJSON.count ==0) {
            //        NSLog(@"请先选择商品");
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_taobaocart_tishi", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, 180.f);
            [hud hideAnimated:YES afterDelay:2.f];
        }else{
            TaobaoTransportApplyViewController *vc = [[TaobaoTransportApplyViewController alloc]init];
            vc.goodsArr = responseJSON;
            vc.type = self.type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)delayMethodssss
{
    NSString *jsPath;
    if (self.type ==0) {
        jsPath = [[NSBundle mainBundle]pathForResource:@"showtaobaoShopcart.js" ofType:nil];
    }else if (self.type ==1){
        jsPath = [[NSBundle mainBundle]pathForResource:@"showjdShopcart.js" ofType:nil];
    }else if (self.type == 2){
        jsPath = [[NSBundle mainBundle]pathForResource:@"showyanxuanShopcart.js" ofType:nil];
    }else{
        jsPath = [[NSBundle mainBundle]pathForResource:@"show1688Shopcart.js" ofType:nil];
    }
    NSString *jsStr = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    //    self.taobaoWeb.delegate = self;
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    NSString *jsStr1;
    if (self.type ==0) {
        jsStr1 = [NSString stringWithFormat:@"taobaoShopCartInfo()"];
    }else if (self.type ==1){
        jsStr1 = [NSString stringWithFormat:@"jdShopCartInfo()"];
    }else if (self.type == 2){
        jsStr1 = [NSString stringWithFormat:@"jdShopCartInfo()"];
    }else{
        jsStr1 = [NSString stringWithFormat:@"shopCartInfo()"];
    }
    [self.wkWebView evaluateJavaScript:jsStr1 completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
    }];
}

- (void)taobaoShopcartInfo:(NSString *)string
{
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    if (responseJSON.count ==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_taobaocart_tishi", nil);
        hud.offset = CGPointMake(0.f, 180.f);
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        TaobaoTransportApplyViewController *vc = [[TaobaoTransportApplyViewController alloc]init];
        vc.goodsArr = responseJSON;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
