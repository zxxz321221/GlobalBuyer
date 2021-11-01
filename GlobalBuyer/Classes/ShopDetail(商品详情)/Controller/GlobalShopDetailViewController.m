//
//  GlobalShopDetailViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/7/24.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "GlobalShopDetailViewController.h"
#import "ShopCartModel.h"
#import "LoginViewController.h"
#import <NJKWebViewProgressView.h>
#import <NJKWebViewProgress.h>
#import "ShoppingCartViewController.h"
#import "PopLoginViewController.h"
#import "NavigationController.h"
#import "LoadingView.h"
#import "CommissionViewController.h"
#import "CommissionDefaultViewController.h"
#import "OrderModel.h"
#import "ObjectAndString.h"
#import <CoreText/CoreText.h>
#import "ActivityWebViewController.h"
#import "ShopNotiView.h"
#import "PolicyWebViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "FeedViewController.h"
#import "ServiceViewController.h"
@interface GlobalShopDetailViewController ()<UIWebViewDelegate,GlobalJSObjcDelegate,NJKWebViewProgressDelegate,UIScrollViewDelegate,UITextViewDelegate,notiViewDelegate>
{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
    BOOL isEbay;//no 没有显示过 yes 显示过
}
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *priceLa;
@property (nonatomic, assign)BOOL isOver;
@property (nonatomic, strong)UIBarButtonItem *backBtn;
@property (nonatomic, strong)UIBarButtonItem *goBtn;
@property (nonatomic, assign)BOOL pageCount;
@property (nonatomic, strong)UIView *bommView;
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UIImageView *ServiceLv;
@property (nonatomic, copy)NSString *bodyStr;
@property (nonatomic, assign)NSInteger btnTag;
@property (nonatomic, strong)UIButton *collectionBtn;

@property (nonatomic, copy)NSString *collectionIdOfGoods;
@property (nonatomic, copy)NSString *warehouseId;


@property (nonatomic, strong)UIButton *refreshBtn;

@property (nonatomic, strong)UILabel *timeLb;
@property (nonatomic, strong)NSMutableArray *dataSoucer;

@property (nonatomic, assign)BOOL isCounDown;

@property (nonatomic, strong)UIView *guidanceV;

@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, assign)BOOL isInteractive;

@property (nonatomic, strong)NSTimer *collectionTimer;

@property (nonatomic, strong)NSString *tmpWebLink;

@property (nonatomic,assign)NSInteger currentMinTime;
@property (nonatomic,assign)NSInteger currentSecTime;
@property (nonatomic,assign)int currentElement;

@property (nonatomic,strong)UIButton *shareGoodsBtn;

@property (nonatomic,strong)UIView *inputOriginalV;
@property (nonatomic,strong)UILabel *inputOriginalLb;

@property (nonatomic,strong)UIView *websiteIntroductionBackV;
@property (nonatomic,strong)UIScrollView *websiteIntroductionSV;
@property (nonatomic,strong)NSTimer *websiteIntroductionTimer;
@property (nonatomic,assign)NSInteger websiteIntroductionHeight;

@property (nonatomic,strong)NSString *currentLink;
@property (nonatomic,strong)UIButton *entrustBtn;
@property (nonatomic,strong)UIView *entrustBackV;
@property (nonatomic,strong)UITextView *markTf;
@property (nonatomic,strong)UILabel *entrustGoodsNumLb;

@property (nonatomic,strong)UIButton *registerBtn;

@property (nonatomic,strong)ShopNotiView * notiView;
@property (nonatomic,strong)UITextField * ebayText;

@end

@implementation GlobalShopDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = Main_Color;
    self.navigationController.navigationBar.backgroundColor = Main_Color;
    
    isEbay = NO;
    [self setupUI];
    [self addData];
    // Do any additional setup after loading the view.

    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
//
}

- (void)viewWillAppear:(BOOL)animated
{
    //去掉导航栏下面的黑线
//    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardDidShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    
    //获取键盘的高度
    NSDictionary *userInfo = [note userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    self.inputOriginalV.frame = CGRectMake(0,kScreenH - height - 40, kScreenW, 40);
    self.inputOriginalLb.frame = CGRectMake(0, 0, kScreenW, 40);
    self.inputOriginalV.hidden = NO;
    self.inputOriginalLb.hidden = NO;
    
    NSLog(@"%d",height);
}

- (void)keyboardWillHide:(NSNotification *)note
{
    self.inputOriginalV.hidden = YES;
    self.inputOriginalLb.hidden = YES;
}


#pragma amrk 加载网页
- (void)addData {
    if (self.link) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.link]];
        [self.webView loadRequest: request];
    }else{
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.model.body.goodsLink]];
        [self.webView loadRequest: request];
    }
}

//初始化加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
        if (self.guideMessage) {
            _loadingView.messageLb.text = [NSString stringWithFormat:@"%@",self.guideMessage];
        }
    }
    return _loadingView;
}

#pragma mark 设计UI界面
- (void)setupUI {
    self.backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClick)];
    self.goBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"x"] style:UIBarButtonItemStylePlain  target:self action:@selector(goForwardClick)];
    self.navigationItem.leftBarButtonItem = self.goBtn;

    UIButton * _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:NSLocalizedString(@"GlobalBuyer_feedback", nil) forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setFrame:CGRectMake(0.0, 7.0, 30.0, 30.0)];
    [_rightButton addTarget:self action:@selector(fankuiClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.ebayText];
    
    [self.view addSubview:self.webView];
    
    
    
    
    [self.view addSubview:self.bottomView];
//    [self.bottomView addSubview:self.collectionBtn];
//    [self.bottomView addSubview:self.shareGoodsBtn];
    
    [self.view addSubview:self.bommView];
    [self.view addSubview:_webViewProgressView];
    [self.view addSubview:self.refreshBtn];
    [self.view addSubview:self.ServiceLv];
    [self.view addSubview:self.entrustBtn];
    [self.view addSubview:self.registerBtn];
    [self.loadingView startLoading];
    
    self.isLoading = NO;
    self.isInteractive = NO;
    
    self.title = NSLocalizedString(@"GlobalBuyer_Entrust_Webdetails", nil);
    
    
    self.inputOriginalV = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenW, 40)];
    self.inputOriginalV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:0.7];
    self.inputOriginalV.hidden = YES;
    self.inputOriginalLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    self.inputOriginalLb.hidden = YES;
    self.inputOriginalLb.textAlignment = NSTextAlignmentCenter;
    self.inputOriginalLb.text = NSLocalizedString(@"GlobalBuyer_InputOriginal", nil);
    self.inputOriginalLb.font = [UIFont systemFontOfSize:12];
    self.inputOriginalLb.textColor = [UIColor whiteColor];
    [self.inputOriginalV addSubview:self.inputOriginalLb];
    [self.view addSubview:self.inputOriginalV];
    
}

- (UIButton *)entrustBtn
{
    if (_entrustBtn == nil) {
        _entrustBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 120, kScreenH - 49-LL_StatusBarAndNavigationBarHeight, 120, 49)];
        [_entrustBtn setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_EntrustBtn", nil) forState:UIControlStateNormal];
        _entrustBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _entrustBtn.backgroundColor = [UIColor redColor];
        [_entrustBtn addTarget:self action:@selector(showEntrustBackV) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entrustBtn;
}

- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 240, kScreenH - 49-LL_StatusBarAndNavigationBarHeight, 120, 49)];
        [_registerBtn setTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Register", nil) forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _registerBtn.backgroundColor = [UIColor blackColor];
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (void)registerClick{
    [self.webView stringByEvaluatingJavaScriptFromString:@"jumpRegister();"];
}

- (void)showEntrustBackV
{
    [self.view addSubview:self.entrustBackV];
}

- (UIView *)entrustBackV
{
    if (_entrustBackV == nil) {
        _entrustBackV = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _entrustBackV.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        
        UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 130, 300, 260)];
        contentV.backgroundColor = [UIColor whiteColor];
        [_entrustBackV addSubview:contentV];
        UIImageView *iconIv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
        iconIv.image = [UIImage imageNamed:@"ic_link"];
        [contentV addSubview:iconIv];
        
        UILabel *linkLb = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 200, 30)];
        linkLb.textColor = [UIColor lightGrayColor];
        linkLb.text = self.currentLink;
        linkLb.font = [UIFont systemFontOfSize:13];
        [contentV addSubview:linkLb];
        
        UIView *firstLineV = [[UIView alloc]initWithFrame:CGRectMake(0, 60, 300, 0.5)];
        firstLineV.backgroundColor = [UIColor lightGrayColor];
        [contentV addSubview:firstLineV];
        
        self.markTf = [[UITextView alloc]initWithFrame:CGRectMake(10, 70, 280, 100)];
        self.markTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.markTf.layer.borderWidth = 0.5;
        self.markTf.delegate = self;
        self.markTf.textColor = [UIColor lightGrayColor];
        self.markTf.text = NSLocalizedString(@"GlobalBuyer_Amazon_AlertSize", nil);
        [contentV addSubview:self.markTf];
        
        UILabel *entrustNumLeftLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 120, 30)];
        entrustNumLeftLb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_EntrustNum", nil);
        entrustNumLeftLb.font = [UIFont systemFontOfSize:15];
        [contentV addSubview:entrustNumLeftLb];
        
        UIView *goodsNumBackV = [[UIView alloc]initWithFrame:CGRectMake(170, 180, 120, 30)];
        goodsNumBackV.layer.borderWidth = 0.5;
        goodsNumBackV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        goodsNumBackV.backgroundColor = [UIColor lightGrayColor];
        goodsNumBackV.layer.cornerRadius = 15;
        [contentV addSubview:goodsNumBackV];
        self.entrustGoodsNumLb = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 40, 30)];
        self.entrustGoodsNumLb.textAlignment = NSTextAlignmentCenter;
        self.entrustGoodsNumLb.backgroundColor = [UIColor whiteColor];
        self.entrustGoodsNumLb.text = @"1";
        [goodsNumBackV addSubview:self.entrustGoodsNumLb];
        UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
        [reduceBtn addTarget:self action:@selector(reduceEntrustNum) forControlEvents:UIControlEventTouchUpInside];
        [goodsNumBackV addSubview:reduceBtn];
        UIButton *plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 40, 30)];
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [goodsNumBackV addSubview:plusBtn];
        [plusBtn addTarget:self action:@selector(plusEntrustNum) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *secondLineV = [[UIView alloc]initWithFrame:CGRectMake(0, 220, 300, 0.5)];
        secondLineV.backgroundColor = [UIColor lightGrayColor];
        [contentV addSubview:secondLineV];
        UIView *thirdLineV = [[UIView alloc]initWithFrame:CGRectMake(150, 220, 0.5, 40)];
        thirdLineV.backgroundColor = [UIColor lightGrayColor];
        [contentV addSubview:thirdLineV];
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 220, 150, 40)];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelEntrust) forControlEvents:UIControlEventTouchUpInside];
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 220, 150, 40)];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureEntrust) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entrustBackV;
}

- (void)reduceEntrustNum
{
    if ([self.entrustGoodsNumLb.text intValue] <= 1) {
        return;
    }else{
        self.entrustGoodsNumLb.text = [NSString stringWithFormat:@"%d",[self.entrustGoodsNumLb.text intValue]-1];
    }
}

- (void)plusEntrustNum
{
    self.entrustGoodsNumLb.text = [NSString stringWithFormat:@"%d",[self.entrustGoodsNumLb.text intValue]+1];
}

- (void)cancelEntrust
{
    [self.entrustBackV removeFromSuperview];
    self.entrustBackV = nil;
}

- (void)sureEntrust
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
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
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken == nil) {
        [hud hideAnimated:YES];
        LoginViewController * lvc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:lvc animated:YES];
        return;
    }
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"link":self.currentLink,
                             @"name":[NSString stringWithFormat:@"%@",[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]],
                             @"attribute":self.markTf.text,
                             @"quantity":self.entrustGoodsNumLb.text,
                             @"locale":language
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:EntrustBuyApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.entrustBackV removeFromSuperview];
            self.entrustBackV = nil;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"提交成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"提交失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"提交失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"GlobalBuyer_Amazon_AlertSize", nil)]) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(@"GlobalBuyer_Amazon_AlertSize", nil);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.markTf resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//网站介绍
- (UIView *)websiteIntroductionBackV
{
    if (_websiteIntroductionBackV == nil) {
        _websiteIntroductionBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _websiteIntroductionBackV.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        
        self.websiteIntroductionSV = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenW/2 - 140, kScreenH/2 - 150, 280 , 300)];
        self.websiteIntroductionSV.delegate = self;
        [_websiteIntroductionBackV addSubview:self.websiteIntroductionSV];
        
        
        UILabel *websiteIntroductionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 280, 1000)];
        websiteIntroductionLb.text = [NSString stringWithFormat:@"%@",self.websiteIntroductionStr];
        websiteIntroductionLb.font = [UIFont systemFontOfSize:16];
        websiteIntroductionLb.textColor = [UIColor whiteColor];
        websiteIntroductionLb.numberOfLines = 0;
        [websiteIntroductionLb sizeToFit];
        
        [self.websiteIntroductionSV addSubview:websiteIntroductionLb];
        
        self.websiteIntroductionSV.contentSize = CGSizeMake(0, 300+websiteIntroductionLb.frame.size.height);
        
        self.websiteIntroductionHeight = 0;
        
        self.websiteIntroductionTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(websiteIntroductionRoll) userInfo:nil repeats:YES];
        [self.websiteIntroductionTimer setFireDate:[NSDate distantPast]];
        [[NSRunLoop currentRunLoop] addTimer:self.websiteIntroductionTimer forMode:NSRunLoopCommonModes];
        
        UIButton *noLongerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.websiteIntroductionSV.frame.origin.x, self.websiteIntroductionSV.frame.origin.y + self.websiteIntroductionSV.frame.size.height + 10, 130 , 40)];
        noLongerBtn.layer.borderWidth = 0.7;
        noLongerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [noLongerBtn setTitle:NSLocalizedString(@"GlobalBuyer_Amazon_NoPrompt", nil) forState:UIControlStateNormal];
        [noLongerBtn addTarget:self action:@selector(noLongerClick) forControlEvents:UIControlEventTouchUpInside];
        [_websiteIntroductionBackV addSubview:noLongerBtn];
        
        UIButton *knowBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.websiteIntroductionSV.frame.origin.x + 150, self.websiteIntroductionSV.frame.origin.y + self.websiteIntroductionSV.frame.size.height + 10, 130, 40)];
        knowBtn.layer.borderWidth = 0.7;
        knowBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [knowBtn setTitle:NSLocalizedString(@"GlobalBuyer_Amazon_OK", nil) forState:UIControlStateNormal];
        [knowBtn addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
        [_websiteIntroductionBackV addSubview:knowBtn];
    }
    return _websiteIntroductionBackV;
}

- (void)noLongerClick
{
    [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:[NSString stringWithFormat:@"%@READ",self.websiteName]];
    [self.websiteIntroductionBackV removeFromSuperview];
    self.websiteIntroductionBackV = nil;
}

- (void)knowClick
{
    [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
    [self.websiteIntroductionBackV removeFromSuperview];
    self.websiteIntroductionBackV = nil;
}

- (void)websiteIntroductionRoll
{
    if (self.websiteIntroductionHeight >= self.websiteIntroductionSV.contentSize.height) {
        [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
    }
    self.websiteIntroductionSV.contentOffset = CGPointMake(0, self.websiteIntroductionHeight++);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
}


//获取网站根目录
- (void)getURLHOST
{
    if (self.link) {
        
        self.nationalityStr = self.link;
        NSURL *url = [NSURL URLWithString:self.link];
        NSString *hostStr = url.host;
        NSLog(@"%@",hostStr);
        
    }else{
        
        self.nationalityStr = self.model.body.goodsLink;
        NSURL *url = [NSURL URLWithString:self.model.body.goodsLink];
        NSString *hostStr = url.host;
        NSLog(@"%@",hostStr);
        
    }
}

- (UIView *)guidanceV
{
    if (_guidanceV == nil) {
        _guidanceV = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        UIImageView *guidanceIV = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
        // 取得 iPhone 支持的所有语言设置
        NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
        NSLog (@"%@", languages);
        
        // 获得当前iPhone使用的语言
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            guidanceIV.image = [UIImage imageNamed:@"详情引导简体"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            guidanceIV.image = [UIImage imageNamed:@"详情引导繁体"];
        }else if([currentLanguage isEqualToString:@"en"]){
            guidanceIV.image = [UIImage imageNamed:@"详情引导英文"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            guidanceIV.image = [UIImage imageNamed:@"详情引导日文"];
        }else{
            guidanceIV.image = [UIImage imageNamed:@"详情引导简体"];
        }
        [_guidanceV addSubview:guidanceIV];
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 - 40, kScreenH/2 - 40, 80, 80)];
        [closeBtn addTarget:self action:@selector(closeGuidance) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.layer.cornerRadius = 40;
        closeBtn.layer.borderWidth = 0.8;
        closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        UILabel *closeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        closeLb.text = NSLocalizedString(@"GlobalBuyer_Close", nil);
        closeLb.textColor = [UIColor whiteColor];
        closeLb.textAlignment = NSTextAlignmentCenter;
        [closeBtn addSubview:closeLb];
        [_guidanceV addSubview:closeBtn];
    }
    return _guidanceV;
}

- (void)closeGuidance
{
    [[NSUserDefaults standardUserDefaults]setObject:@"read" forKey:@"DetailsGuidance"];
    [self.guidanceV removeFromSuperview];
}

#pragma mark 界面控件初始化
-(UIView *)bommView {
    if (_bommView == nil) {
        _bommView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 49-LL_StatusBarAndNavigationBarHeight, kScreenW, 49)];
        _bommView.backgroundColor = [UIColor whiteColor];
        _bommView.alpha = 0;
    }
    return _bommView;
}

- (void)goShopClick {
    ShoppingCartViewController *shoppingCV = [ShoppingCartViewController new];
    [shoppingCV setNavigationBackBtn];
    [self.navigationController pushViewController:shoppingCV animated:YES];
}

- (UIButton *)collectionBtn
{
    if (_collectionBtn == nil) {
        _collectionBtn = [[UIButton alloc]init];
        _collectionBtn.frame = CGRectMake(kScreenW - 158, 8, 33, 33);
        _collectionBtn.tag = 300;
        [_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionselected"] forState:UIControlStateSelected];
        [_collectionBtn addTarget:self action:@selector(addShoppingCartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}



- (UIImageView *)ServiceLv
{
    if (_ServiceLv == nil) {
        _ServiceLv = [[UIImageView alloc]initWithFrame:CGRectMake(55, kScreenH - 41-LL_StatusBarAndNavigationBarHeight, 35, 35)];
        _ServiceLv.image = [UIImage imageNamed:@"ic_service_white"];
        _ServiceLv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Service)];
        [_ServiceLv addGestureRecognizer:tap];
    }
    return _ServiceLv;
}

- (UIButton *)shareGoodsBtn
{
    if (_shareGoodsBtn == nil) {
        _shareGoodsBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 242, 7, 37, 37)];
        [_shareGoodsBtn setImage:[UIImage imageNamed:@"goodsshareNO"] forState:UIControlStateNormal];
        _shareGoodsBtn.tag = 900;
        [_shareGoodsBtn addTarget:self action:@selector(addShoppingCartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareGoodsBtn;
}

- (UIButton *)refreshBtn
{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH - 43-LL_StatusBarAndNavigationBarHeight, 37, 37)];
        [_refreshBtn setImage:[UIImage imageNamed:@"ic_refresh_white"] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshWeb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

- (void)refreshWeb
{
    NSString *location = self.webView.request.URL.absoluteString;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"link"] = [NSString stringWithFormat:@"%@",location];
    parameters[@"client"] = @"ios";
    
    [manager POST:RefreshWebApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    [self.webView reload];
}

- (NSMutableArray *)dataSoucer
{
    if (_dataSoucer == nil) {
        _dataSoucer = [NSMutableArray new];
    }
    return _dataSoucer;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.frame = CGRectMake(0, kScreenH -49-LL_StatusBarAndNavigationBarHeight, kScreenW , 49);
        _bottomView.backgroundColor = Main_Color;
    }
    return _bottomView;
}

- (UILabel *)priceLa {
    if (_priceLa == nil) {
        _priceLa = [[UILabel alloc]init];
        _priceLa.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.68 alpha:1];
        _priceLa.font = [UIFont systemFontOfSize:12];
        _priceLa.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_Allprice", nil),self.model.body.price];
    }
    return _priceLa;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -NavBarHeight-49)];
        _webView.delegate = self;
        _webViewProgressView= [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        [_webViewProgressView setProgress:0];
        _webViewProgress = [[NJKWebViewProgress alloc] init];
        _webView.delegate = _webViewProgress;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webViewProgress.webViewProxyDelegate = self;
        _webViewProgress.progressDelegate = self;
    }
    return _webView;
}

- (void)Service
{
    ServiceViewController * svc = [[ServiceViewController alloc]init];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
//    NSLog(@"123123123123123123");
//    ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
//    // 获得当前iPhone使用的语言
//    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
//    NSLog(@"当前使用的语言：%@",currentLanguage);
//    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else if([currentLanguage isEqualToString:@"en"]){
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else{
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }
//    webService.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webService animated:YES];
    
    //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    //    [chatViewManager pushMQChatViewControllerInViewController:self];
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_webViewProgressView setProgress:progress animated:YES];
}

#pragma mark webView代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.timer setFireDate:[NSDate distantPast]];
    [self.collectionTimer setFireDate:[NSDate distantPast]];
//    self.ebayText.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSLog(@"当前连接url %@",[self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.timer setFireDate:[NSDate distantPast]];
    [self.collectionTimer setFireDate:[NSDate distantPast]];
    
    //    if ([self.webView canGoForward]) {
    ////        self.navigationItem.leftBarButtonItems = @[self.backBtn,self.goBtn];
    //    }else if([self.webView canGoBack]){
    //
    //    }
    if ([self.webView canGoBack]) {
        [self.backBtn setImage:[UIImage imageNamed:@"back"]];
        self.navigationItem.leftBarButtonItems = @[self.backBtn,self.goBtn];
//        _ebayText.frame =CGRectMake(98, 24, kScreenW-108, 36);
    }else{
        [self.backBtn setImage:[UIImage imageNamed:@""]];
        self.navigationItem.leftBarButtonItem = self.goBtn;
//        _ebayText.frame =CGRectMake(54, 24, kScreenW-64, 36);
    }
    if (self.isShowText) {
        self.ebayText.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    }
    [self.webView stringByEvaluatingJavaScriptFromString:@"reset({'from':'','to':''});"];
    //    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark 计时器
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(insertJs) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (NSTimer *)collectionTimer{
    if (_collectionTimer == nil) {
        _collectionTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(webStateCheck) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_collectionTimer forMode:NSRunLoopCommonModes];
    }
    return _collectionTimer;
}

#pragma mark 插入common JS
- (void)insertJs {
    
    
    
    NSString*readyState =  [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState;"];
    self.currentLink = [self.webView stringByEvaluatingJavaScriptFromString:@"location.href;"];
    NSString*href =  [self.webView stringByEvaluatingJavaScriptFromString:@"location.href;"];
    NSLog(@"readyState -----%@----",readyState);
    NSLog(@"href -----%@----",href);
    
    //    if ([readyState isEqualToString:@"loading"] && self.isLoading == NO) {
    //        self.isLoading = YES;
    //        self.loadingView.imgView.animationDuration = 6*0.15;
    //        self.loadingView.imgView.animationRepeatCount = 0;
    //        [self.loadingView.imgView startAnimating];
    //    }
    //    if ([readyState isEqualToString:@"interactive"] && self.isInteractive == NO) {
    //        self.isInteractive = YES;
    //        self.loadingView.imgView.animationDuration = 3*0.15;
    //        self.loadingView.imgView.animationRepeatCount = 0;
    //        [self.loadingView.imgView startAnimating];
    //    }
    
    if (![href isEqualToString:@"about:blank"] && ![readyState isEqualToString:@"loading"] && ![href hasPrefix:@"https://www.linkhaitao.com/index.php"]) {
        [self.timer setFireDate:[NSDate distantFuture]];
        //[self getURLHOST];
        
        [self.loadingView stopLoading];
        if (self.isShowText) {
            if (isEbay) {}else{
                [self.notiView showNoti];
                isEbay = YES;
            }
            _webView.frame = CGRectMake(0, kNavigationBarH + kStatusBarH+20, kScreenW, kScreenH - kTabBarH -(kNavigationBarH + kStatusBarH)-20);
//            self.ebayText.text = self.link;
        }
        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DetailsGuidance"]isEqualToString:@"read"]) {
//
//        }else{
//            [self.tabBarController.view addSubview:self.guidanceV];
//        }
        
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"if(document.getElementById('dyh-tester') == null){javascript:var script = document.createElement('script'); script.src = '//buy.dayanghang.net/inject/tester.js '; script.id = 'dyh-tester';document.body.appendChild(script);}"];
        NSLog(@"=======tester");
        self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"browser"] = self;
        self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_translate", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
            [alertView show];
        };
        
        //        [UIView animateWithDuration:2 animations:^{
        //            self.loadingView.imgView.animationDuration = 3*0.15;
        //            self.loadingView.imgView.animationRepeatCount = 0;
        //            [self.loadingView.imgView startAnimating];
        //            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
        //        } completion:^(BOOL finished) {
        //
        //        }];
        
        
        
        //        NSString *lJs = @"document.documentElement.innerHTML";
        //        NSString *lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:lJs];
        //        NSLog(@"%@",lHtml1);
        
        //        NSString *jsPath = [[NSBundle mainBundle]pathForResource:@"Init.js" ofType:nil];
        //        NSString *jsStr = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
        //        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@",jsStr]];
        
        
        
    }
    
}

- (void)webStateCheck
{
    NSString*readyState =  [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState;"];
    NSString*href =  [self.webView stringByEvaluatingJavaScriptFromString:@"location.href;"];
    //NSLog(@"readyState -----%@----",readyState);
    //NSLog(@"href -----%@----",href);
    
    
    if (![href isEqualToString:@"about:blank"] && [readyState isEqualToString:@"complete"]){
        [self.collectionTimer setFireDate:[NSDate distantFuture]];
        [self JudgeCollectionYesOrNoWithLink:href];
    }
}

- (void)JudgeCollectionYesOrNoWithLink:(NSString *)link
{
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"secret_key"] = userToken;
    parameters[@"link"] = link;
    
    
    [manager POST:JudgeCollection parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.collectionIdOfGoods = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"favoriteId"]];
            self.collectionBtn.selected = YES;
        }else{
            self.collectionIdOfGoods = @"";
            self.collectionBtn.selected = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.collectionIdOfGoods = @"";
        self.collectionBtn.selected = NO;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //    [self.timer invalidate];
    //    [self.collectionTimer invalidate];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"external"]) {
        self.tabBarController.tabBar.hidden = NO;
    }
    self.ebayText.hidden = YES;
}

#pragma mark 返回事件
- (void)popClick {
//    [self.timer invalidate];
//    [self.collectionTimer invalidate];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 前进后退事件
- (void)goBackClick {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.timer invalidate];
        [self.collectionTimer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goForwardClick {
    [self.timer invalidate];
    [self.collectionTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
//    if ([self.webView canGoForward]) {
//        [self.webView goForward];
//    }
}

#pragma mark 加入购物车事件

//费用试算
- (void)createCommissionWithPictureUrl:(NSString *)pictureUrl titleOfGoods:(NSString *)titleOfGoods numberOfGoods:(NSString *)numberOfGoods priceOfGoods:(NSString *)priceOfGoods nameOfGoods:(NSString *)nameOfGoods attributesOfGoods:(NSString *)attributesOfGoods moneyTypeOfGoods:(NSString *)moneyTypeOfGoods tureNumberOfGoods:(NSString *)tureNumberOfGoods
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSure:) name:@"didSure" object:nil];
    if (1) {
        CommissionViewController *commVC = [[CommissionViewController alloc]init];
        commVC.pictureUrl = pictureUrl;
        commVC.titleOfGoods = titleOfGoods;
        if ([titleOfGoods isEqualToString:@"1688"]) {
            commVC.priceOfGoods = priceOfGoods;
            commVC.tureNumberOfGoods = tureNumberOfGoods;
            commVC.numberOfGoods = @"1";
        }else{
            commVC.numberOfGoods = numberOfGoods;
            commVC.priceOfGoods = priceOfGoods;
        }
        commVC.nameOfGoods = nameOfGoods;
        commVC.attributesOfGoods = attributesOfGoods;
        commVC.moneyTypeOfGoods = moneyTypeOfGoods;
        commVC.bodyStr = self.bodyStr;
        commVC.nationalityStr = self.nationalityStr;
        commVC.tureNumberOfGoods = tureNumberOfGoods;
        [self.navigationController pushViewController:commVC animated:YES];
    }else{
        CommissionDefaultViewController *commVC =[[CommissionDefaultViewController alloc]init];
        commVC.pictureUrl = pictureUrl;
        commVC.titleOfGoods = titleOfGoods;
        commVC.numberOfGoods = numberOfGoods;
        commVC.priceOfGoods = priceOfGoods;
        commVC.nameOfGoods = nameOfGoods;
        commVC.attributesOfGoods = attributesOfGoods;
        commVC.moneyTypeOfGoods = moneyTypeOfGoods;
        commVC.bodyStr = self.bodyStr;
        [self.navigationController pushViewController:commVC animated:YES];
    }
    
}

//获取网页商品信息
- (void)addShoppingCartClick:(UIButton *)btn {
    self.btnTag = btn.tag;
    if (self.btnTag == 300) {
        if(self.collectionBtn.selected == YES){
            [self deleteCollectionGoods];
            return;
        }
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"quickBuyAddcart();"];
    NSLog(@"获取商品信息");
}

#pragma mark oc和js交互
#pragma mark 获取商品信息
- (void)getGoodsInfo:(NSString *)string {
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken == nil) {
        PopLoginViewController *popLogin = [PopLoginViewController new];
        popLogin.pop = YES;
        NavigationController *popLoginNa = [[NavigationController alloc]initWithRootViewController:popLogin];
        [self presentViewController:popLoginNa animated:YES completion:nil];
        return;
    }
    
    self.bodyStr = string;
    
    if (self.btnTag == 100) {
        [self addShopCartWithString:string];
        return;
    }
    
    NSString *pictureUrl;
    
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    if (![responseJSON[@"status"] boolValue]) {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_noselect", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        //        [alertView show];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_noselect", nil);
        // Move to bottm center.
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:1.f];
        
        return;
        
    }
    
    NSLog(@"%@",string);
    
    NSMutableString *pictureStr = responseJSON[@"picture"];
    NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
    if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
        pictureUrl = pictureStr;
    }else{
        NSMutableString *tmpStr = responseJSON[@"link"];
        NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
        NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
        if (tmpHttpArr.count > 0) {
            pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
        }else if(tmpHttpsArr.count > 0){
            pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
        }
    }
    
    NSString *titleOfGoods = responseJSON[@"shopSource"];
    NSString *numberOfGoods;
    NSString *priceOfGoods;
    NSString *tureNumberOfGoods;
    if ([titleOfGoods isEqualToString:@"1688"]) {
        numberOfGoods = @"1";
        priceOfGoods = responseJSON[@"totalPrice"];
        tureNumberOfGoods = responseJSON[@"quantity"];
    }else{
        numberOfGoods = responseJSON[@"quantity"];
        priceOfGoods = responseJSON[@"price"];
    }
    NSString *nameOfGoods = responseJSON[@"name"];
    NSString *attributesOfGoods = responseJSON[@"attributes"];
    NSString *moneyTypeOfGoods = responseJSON[@"currency"];
    NSString *linkOfGoods = responseJSON[@"link"];
    
    if (self.btnTag == 900) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        
        UIAlertAction *libray = [UIAlertAction actionWithTitle:@"分享到微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UMSocialMessageObject *message = [[UMSocialMessageObject alloc]init];
            UMShareWebpageObject *url = [[UMShareWebpageObject alloc]init];
            url.title = nameOfGoods;
            UIImage *goodsShareImge = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pictureUrl]]];
            url.thumbImage = goodsShareImge;
            url.webpageUrl = [NSString stringWithFormat:GoodsShareURL,pictureUrl,nameOfGoods,priceOfGoods,moneyTypeOfGoods,[linkOfGoods stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            message.shareObject = url;
            [[UMSocialManager defaultManager]shareToPlatform:UMSocialPlatformType_WechatSession messageObject:message currentViewController:self completion:^(id result, NSError *error) {
                
            }];
            
        }];
        [alert addAction:libray];
        
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"分享到FaceBook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UMSocialMessageObject *message = [[UMSocialMessageObject alloc]init];
            UMShareWebpageObject *url = [[UMShareWebpageObject alloc]init];
            url.title = nameOfGoods;
            UIImage *goodsShareImge = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pictureUrl]]];
            url.thumbImage = goodsShareImge;
            url.webpageUrl = [NSString stringWithFormat:GoodsShareURL,pictureUrl,nameOfGoods,priceOfGoods,moneyTypeOfGoods,[linkOfGoods stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            message.shareObject = url;
            [[UMSocialManager defaultManager]shareToPlatform:UMSocialPlatformType_Facebook messageObject:message currentViewController:self completion:^(id result, NSError *error) {
                
            }];
        }];
        [alert addAction:takePhoto];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (self.btnTag == 300) {
        if(self.collectionBtn.selected == YES){
            [self deleteCollectionGoods];
            return;
        }
        [self addCollectionWithName:nameOfGoods shopSource:titleOfGoods link:linkOfGoods pictureUrl:pictureUrl attributes:attributesOfGoods];
        return;
    }
    
    [self createCommissionWithPictureUrl:pictureUrl titleOfGoods:titleOfGoods numberOfGoods:numberOfGoods priceOfGoods:priceOfGoods nameOfGoods:nameOfGoods attributesOfGoods:attributesOfGoods moneyTypeOfGoods:moneyTypeOfGoods tureNumberOfGoods:tureNumberOfGoods];
}


//获取http OR https
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

//加入收藏
- (void)addCollectionWithName:(NSString *)name shopSource:(NSString *)shopSource link:(NSString *)link pictureUrl:(NSString *)pictureUrl attributes:(NSString *)attributes
{
    //    self.webView.userInteractionEnabled = NO;
    //    [self.view addSubview:self.collectionV];
    //    [self.collectionIV sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
    //    self.collectionNameLb.text = name;
    //    self.collectionAttributesLb.text = attributes;
    //    self.collectionShopSourceLb.text = shopSource;
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.collectionV.frame = CGRectMake(50, 220, [[UIScreen mainScreen] bounds].size.width - 100, 330);
    //    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Adding", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"secret_key"] = userToken;
    parameters[@"link"] = link;
    parameters[@"title"] = name;
    parameters[@"image"] = pictureUrl;
    parameters[@"source"] = shopSource;
    parameters[@"remark"] = @"";
    
    [manager POST:AddFavoriteApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.collectionIdOfGoods = responseObject[@"data"][@"id"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"收藏成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            self.collectionBtn.selected = YES;
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"收藏失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"收藏失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

//删除收藏
- (void)deleteCollectionGoods
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_deleteAdd", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"secret_key"] = userToken;
    parameters[@"favoriteId"] = self.collectionIdOfGoods;
    
    [manager POST:DeleteFavoriteApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"已移除收藏夹!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            self.collectionBtn.selected = NO;
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"移除失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"移除失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
    
}

//加入购物车
- (void)addShopCartWithString:(NSString *)string
{
    if (string != nil) {
        self.bodyStr = string;
    }
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    NSData *jsonData = [self.bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    if (![jsonDict[@"status"] boolValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_noselect", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
        
    }
    
    //通过通知中心发送通知
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"shopCart" object:nil userInfo:dict];
    
    self.bodyStr = string;
    
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    if (![responseJSON[@"status"] boolValue]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_noselect", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
        
    }
    
    NSLog(@"%@",string);
    NSString *pictureUrl;
    NSMutableString *pictureStr = responseJSON[@"picture"];
    NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
    if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
        pictureUrl = pictureStr;
    }else{
        NSMutableString *tmpStr = responseJSON[@"link"];
        NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
        NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
        if (tmpHttpArr.count > 0) {
            pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
        }else if(tmpHttpsArr.count > 0){
            pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
        }
    }
    
    NSString *numberOfGoods = responseJSON[@"quantity"];
    NSString *priceOfGoods = responseJSON[@"price"];
    NSString *nameOfGoods = responseJSON[@"name"];
    NSString *linkOfGoods = responseJSON[@"link"];
    NSString *shopSourceOfGoods = responseJSON[@"shopSource"];
    NSString *sourceOfGoods = responseJSON[@"source"];
    NSString *currencyOfGoods = responseJSON[@"currency"];
    NSString *attributes = responseJSON[@"attributes"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"secret_key"] = userToken;
    params[@"name"] = nameOfGoods;
    
    //1688重新计算单价
    CGFloat unitPrice;
    if ([shopSourceOfGoods isEqualToString:@"1688"]) {
        NSString *total = responseJSON[@"totalPrice"];
        unitPrice = [total floatValue]/[numberOfGoods floatValue];
        params[@"price"] = [NSString stringWithFormat:@"%.2f",unitPrice];
    }else{
        params[@"price"] = priceOfGoods;
    }
    
    
    params[@"quantity"] = numberOfGoods;
    params[@"shopSource"] = shopSourceOfGoods;
    params[@"source"] = sourceOfGoods;
    params[@"currency"] = currencyOfGoods;
    params[@"picture"] = pictureUrl;
    params[@"link"] = linkOfGoods;
    params[@"attributes"] = attributes;
    params[@"freightId"] = self.warehouseId;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Adding", nil);
    
    [manager POST:InsertOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_GoodsDetail_ThirtyMin", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"添加失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"添加失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

//费用计算页面加入购物车
- (void)didSure:(NSNotification *)notfi
{
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"didSure" object:nil];
    
    NSDictionary *bodyDict = [notfi userInfo];
    self.bodyStr = bodyDict[@"bodyStr"];
    self.warehouseId = bodyDict[@"warehouseId"];
    [self addShopCartWithString:self.bodyStr];
    
}


#pragma mark 是否显示购物车
- (void)showCart:(NSString *)string {
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"%@",jsonDict[@"status"]);
    if (![jsonDict[@"status"] boolValue]) {
        self.bommView.hidden = NO;
    }else{
        self.bommView.hidden = YES;
    }
}

#pragma mark 是否执行m-common.js
- (void)assetComplete:(NSString *)string
{
    //NotificationWarning(NSLocalizedString(@"GlobalBuyer_GoodsDetail_Notice", nil));
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_GoodsDetail_Notice", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, 260.f);
        [hud hideAnimated:YES afterDelay:2.f];
        
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:var script = document.createElement('script'); script.src = '//buy.dayanghang.net/inject/m-common.js'; document.body.appendChild(script);"];
        
        self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[@"browser"] = self;
        self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_translate", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
            [alertView show];
        };
        
    });
    
    
    
    
    NSLog(@"assetComplete");
    
    
    
    
}
- (ShopNotiView *)notiView{
    if (!_notiView) {
        _notiView = [ShopNotiView setShopNotiView:self.view];
        _notiView.delegate = self;
    }
    return _notiView;
}
//ebay进入委托页 屏幕顶部弹出框 详情按钮事件
- (void)detailClick{
    PolicyWebViewController * pvc = [[PolicyWebViewController alloc]init];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
}
- (UITextField *)ebayText{
    if (!_ebayText) {
        _ebayText = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 20)];
        _ebayText.backgroundColor = Main_Color;
        _ebayText.font = [UIFont systemFontOfSize:13];
        _ebayText.textColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1];
    }
    return _ebayText;
}
- (void)fankuiClick{
    FeedViewController *fvc = [[FeedViewController alloc]init];
    fvc.hidesBottomBarWhenPushed = YES;
    fvc.web_url = [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    [self.navigationController pushViewController:fvc animated:YES];
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
