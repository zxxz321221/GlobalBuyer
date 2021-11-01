//
//  PurchaseInformationDetailViewControllerr.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/29.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "PurchaseInformationDetailViewControllerr.h"
#import "ShopDetailViewController.h"
#import <WebKit/WebKit.h>

@interface PurchaseInformationDetailViewControllerr ()<WKNavigationDelegate,HTMLJSObjcDelegate,WKScriptMessageHandler,UIWebViewDelegate>

@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic , strong) UIWebView * webView;
@property (nonatomic,strong)NSString *urlString;
@end

@implementation PurchaseInformationDetailViewControllerr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlString = @"";
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.navTitle;//安全座椅盘点！带着贝贝出门必备
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    
    
    NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendString:@"<html>"];
    [htmlString appendString:self.htmlStr];
    NSMutableArray *muArr = [self getRangeStr:htmlString findText:@"src="];
    NSLog(@"====%@",muArr);
    for (int i = 0; i < muArr.count; i++) {
        [htmlString insertString:WebPictureApi atIndex:[muArr[i] integerValue] + 5 + 24*i +i];
    }
    [htmlString appendString:@"</html>"];
    
    NSLog(@"%@",htmlString);
    
    
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *basePath = [NSString stringWithFormat:@"%@",bundlePath];
//    NSString *indexPath = [NSString stringWithFormat:@"%@/demo.html",basePath];
//    NSString *indexContent = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        //注册js方法
        config.userContentController = [[WKUserContentController alloc]init];
        //webViewAppShare这个需保持跟服务器端的一致，服务器端通过这个name发消息，客户端这边回调接收消息，从而做相关的处理
        [config.userContentController addScriptMessageHandler:self name:@"browser"];
        
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - NavBarHeight) configuration: config];
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"browser"]) {
//        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
//        // NSDictionary, and NSNull类型
//        //do something
        NSLog(@"+_+%@", [message.body class]);
        
//        NSData *JSONData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
//        NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//        if (responseJSON.count ==0) {
//            //        NSLog(@"请先选择商品");
//            //        NSLocalizedString(<#key#>, <#comment#>)
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"GlobalBuyer_taobaocart_tishi", nil);
//            // Move to bottm center.
//            hud.offset = CGPointMake(0.f, 180.f);
//            [hud hideAnimated:YES afterDelay:2.f];
//        }else{
//            TaobaoTransportApplyViewController *vc = [[TaobaoTransportApplyViewController alloc]init];
//            vc.goodsArr = responseJSON;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self.wkWebView evaluateJavaScript:@"document.readyState;" completionHandler:nil];
//    [self.wkWebView evaluateJavaScript:@"location.href;" completionHandler:nil];
//    // 此处是设置需要调用的js方法以及将对应的参数传入，需要以字符串的形式
//    NSString *jsFounction = [NSString stringWithFormat:@"openUrl()"];
//    // 调用API方法
//    [self.wkWebView evaluateJavaScript:jsFounction completionHandler:^(id object, NSError * _Nullable error) {
//        NSLog(@"obj:%@---error:%@", object, error);
//
//    }];
//
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString*readyState =  [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState;"];
    NSString*href =  [self.webView stringByEvaluatingJavaScriptFromString:@"location.href;"];
    NSLog(@"readyState -----%@----",readyState);
    NSLog(@"href -----%@----",href);

    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"browser"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_translate", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
    };
    NSLog(@"123");
}

- (void)openUrl:(NSString *)url :(NSString *)type
{
    if ([type isEqualToString:@"TYPE_PROXY_BUY"]) {
        self.urlString = url;
        [self performSelectorOnMainThread:@selector(push) withObject:nil waitUntilDone:NO];
        
       
    }
}

- (void)push{
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
           shopDetailVC.link = self.urlString;
           shopDetailVC.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:shopDetailVC animated:YES];
}

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
            
        {
            
            if (0 == i) {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }else
                
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
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
