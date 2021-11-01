//
//  ShopDetailViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//
#import "GoodSpecification.h"
#import "ShopDetailViewController.h"
#import "ShopCartModel.h"
#import "LoginViewController.h"
#import <NJKWebViewProgressView.h>
#import <NJKWebViewProgress.h>
#import "ShoppingCartViewController.h"
#import "PopLoginViewController.h"
#import "NavigationController.h"
#import "LoadingView.h"
#import "LoadAnimation.h"
#import "CommissionViewController.h"
#import "CommissionDefaultViewController.h"
#import "OrderModel.h"
#import "ObjectAndString.h"
#import <CoreText/CoreText.h>
#import "ActivityWebViewController.h"
#import "TaobaoTransportApplyViewController.h"
#import "UserNotiView.h"
#import "FeedViewController.h"
#import "ServiceViewController.h"
#import "HistorySearchViewController.h"
#import "GoodSpecificationModel.h"
@interface ShopDetailViewController ()<UIWebViewDelegate,JSObjcDelegate,NJKWebViewProgressDelegate,UIScrollViewDelegate,GoodSpecificationDelegate>
{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
    BOOL isCollection;//yes 已收藏 no 未收藏
    BOOL isAllow;//yes 允许购买 no不允许购买
}
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic , strong) WKWebView * wkWebView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *addShoppingCartBtn;
@property (nonatomic, strong)UILabel *priceLa;
@property (nonatomic, strong)UIButton *shopBtn;
@property (nonatomic, assign)BOOL isOver;
@property (nonatomic, strong)UIBarButtonItem *backBtn;
@property (nonatomic, strong)UIBarButtonItem *goBtn;
@property (nonatomic, assign)BOOL pageCount;
@property (nonatomic, strong)UIView *bommView;
@property (nonatomic, strong)LoadingView *loadingView;
@property (nonatomic, strong)LoadAnimation * loadAnimation;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UIImageView *ServiceLv;
@property (nonatomic, copy)NSString *bodyStr;
@property (nonatomic, strong)UIButton *costCalculationBtn;
@property (nonatomic, assign)NSInteger btnTag;
@property (nonatomic, strong)UIButton *collectionBtn;

@property (nonatomic, copy)NSString *collectionIdOfGoods;
@property (nonatomic, copy)NSString *warehouseId;

@property (nonatomic, strong)UIView *collectionV;
@property (nonatomic, strong)UIImageView *collectionIV;
@property (nonatomic, strong)UILabel *collectionNameLb;
@property (nonatomic, strong)UILabel *collectionAttributesLb;
@property (nonatomic, strong)UILabel *collectionShopSourceLb;
@property (nonatomic, strong)UITextView *collectionTx;
@property (nonatomic, strong)UILabel *remarksLb;
@property (nonatomic, strong)UIButton *collectionSureBtn;
@property (nonatomic, strong)UIButton *closeCollectionBtn;
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

@property (nonatomic,strong)NSString *goodsUserSetNum;

@property (nonatomic, strong)UILabel *countLabel;//购物车角标

@property (nonatomic, strong)UIBarButtonItem *item;
@property (nonatomic, strong)UIBarButtonItem *item1;
@property (nonatomic, strong)GoodSpecification *goodSpecificationview;
@property (nonatomic, strong)UIControl *bgControl;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addData];
    isCollection = NO;
    isAllow=NO;
    // Do any additional setup after loading the view.
    [[BaiduMobStat defaultStat] logEvent:@"event3" eventLabel:@"[浏览商品]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"瀏覽商品" parameters:nil];
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
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.navigationController.navigationBar.translucent =NO;
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
//-(LoadAnimation *)loadAnimation{
//    if (_loadAnimation == nil) {
//        _loadAnimation = [LoadAnimation LoadingViewSetView:self.view];
//        _loadAnimation.imageName = @"";
//    }
//    return _loadAnimation;
//}

#pragma mark 设计UI界面
- (void)setupUI {
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"external"]) {
        self.tabBarController.tabBar.hidden = YES;
    }
    if (self.showTabbar == NO) {
        self.tabBarController.tabBar.hidden = YES;
    }
    self.backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClick)];
    self.goBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"x"] style:UIBarButtonItemStylePlain  target:self action:@selector(goForwardClick)];
    self.navigationItem.leftBarButtonItem = self.backBtn;
    UIButton * _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:NSLocalizedString(@"GlobalBuyer_feedback", nil) forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setFrame:CGRectMake(0.0, 7.0, 30.0, 30.0)];
    [_rightButton addTarget:self action:@selector(fankuiClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIButton * _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_rightButton setFrame:CGRectMake(0.0, 7.0, 30.0, 30.0)];
//    [_rightButton setBackgroundImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
//    [_rightButton addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"msg"] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
    
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomView];
//    [self.bottomView addSubview:self.addShoppingCartBtn];
    [self.bottomView addSubview:self.costCalculationBtn];
    [self.bottomView addSubview:self.shopBtn];
    [self.bottomView addSubview:self.countLabel];//购物车角标
    [self.bottomView addSubview:self.collectionBtn];
    [self.bottomView addSubview:self.shareGoodsBtn];

//    [self.view addSubview:self.bommView];
    [self.view addSubview:_webViewProgressView];
    [self.view addSubview:self.refreshBtn];
    [self.view addSubview:self.ServiceLv];
    [self.loadingView startLoading];
//    [self.loadAnimation startLoadAnimation];
    
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
    
   
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@READ",self.websiteName]]isEqualToString:@"YES"]) {
        
    }else{
        if(self.websiteName){
            if (self.websiteIntroductionStr) {
                [self.tabBarController.view addSubview:self.websiteIntroductionBackV];
            }
        }
    }

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
- (void)bgControlClick{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.goodSpecificationview.frame = CGRectMake(0, kScreenH, kScreenW, 500);
        self.bgControl.hidden = YES;
    }];
    
}
- (void)closeGuidance
{
    [[NSUserDefaults standardUserDefaults]setObject:@"read" forKey:@"DetailsGuidance"];
    [self.guidanceV removeFromSuperview];
}

#pragma mark 界面控件初始化


- (UIControl *)bgControl{
    if (_bgControl == nil) {
        _bgControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _bgControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self.view addSubview:_bgControl];
        _bgControl.hidden = YES;
        [_bgControl addTarget:self action:@selector(bgControlClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bgControl;
}


-(UIView *)bommView {
    if (_bommView == nil) {
        _bommView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 49, kScreenW, 49)];
        _bommView.backgroundColor = [UIColor redColor];
        _bommView.alpha = 0.5;
    }
    return _bommView;
}

-(UIButton *)shopBtn {
    if (_shopBtn == nil) {
        _shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 202, 8, 35, 35)];
        [_shopBtn setImage:[UIImage imageNamed:@"ic_shopping_cartNO"] forState:UIControlStateNormal];
        _shopBtn.userInteractionEnabled = NO;
        [_shopBtn addTarget:self action:@selector(goShopClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopBtn;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 177, 3, 16, 16)];
        _countLabel.backgroundColor = [UIColor whiteColor];
        _countLabel.layer.borderWidth = 1;
        _countLabel.layer.borderColor = [[UIColor redColor]CGColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor redColor];
        _countLabel.layer.cornerRadius = 8;
        _countLabel.font = [UIFont systemFontOfSize:9];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.hidden=YES;
    }
    return _countLabel;
}
// 为购物车设置角标内数值
- (void)setShopCarCount:(NSString *)count{
    if ([count integerValue] == 0) {
        if (_countLabel) {
            [_countLabel removeFromSuperview];
            _countLabel = nil;
        }
    }else{
        _countLabel.hidden=NO;
//        if ([count integerValue] > 9) {
//            self.countLabel.text = @"9+";
//        }else{
//
//        }
        self.countLabel.text = count;
    }
    
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
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionNO"] forState:UIControlStateNormal];
        _collectionBtn.userInteractionEnabled = NO;
        [_collectionBtn addTarget:self action:@selector(addShoppingCartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}



- (UIImageView *)ServiceLv
{
    if (_ServiceLv == nil) {
        _ServiceLv = [[UIImageView alloc]initWithFrame:CGRectMake(55, kScreenH - 41-NavBarHeight, 35, 35)];
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
        _shareGoodsBtn.userInteractionEnabled = NO;
        _shareGoodsBtn.tag = 900;
        [_shareGoodsBtn addTarget:self action:@selector(addShoppingCartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareGoodsBtn;
}

- (UIButton *)refreshBtn
{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH - 43-NavBarHeight, 37, 37)];
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

- (UIButton *)addShoppingCartBtn {
    if (_addShoppingCartBtn == nil) {
        _addShoppingCartBtn = [[UIButton alloc]init];
        _addShoppingCartBtn.frame = CGRectMake(kScreenW - 115, 8, 100, 33);
        //_addShoppingCartBtn.layer.cornerRadius = 5;
        [_addShoppingCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addShoppingCartBtn setBackgroundColor:Main_Color];
        _addShoppingCartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addShoppingCartBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_AddShopcart", nil) forState:UIControlStateNormal];
        _addShoppingCartBtn.tag = 100;
        [_addShoppingCartBtn addTarget:self action:@selector(addShoppingCartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addShoppingCartBtn;
}

- (UIButton *)costCalculationBtn
{
    if (_costCalculationBtn == nil) {
        _costCalculationBtn = [[UIButton alloc]init];
        _costCalculationBtn.frame = CGRectMake(kScreenW - 100, 0, 100, 49);
        //_costCalculationBtn.layer.cornerRadius = 5;
        [_costCalculationBtn setTitleColor:[Unity getColor:@"#ff7b97"] forState:UIControlStateNormal];
        _costCalculationBtn.userInteractionEnabled = NO;
        [_costCalculationBtn setBackgroundColor:[UIColor redColor]];
        _costCalculationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_costCalculationBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_AddShopcart", nil) forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"TaoBaoTransportSwitch"]) {
            if (self.link) {
                if ([self.link containsString:@"tmall"]||[self.link containsString:@"taobao"]) {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"TaoBaoTransportSwitch"]isEqualToString:@"1"]) {
                        [_costCalculationBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_AddTransport", nil) forState:UIControlStateNormal];
                    }
                }
            }
            if (self.model.body.goodsLink) {
                if ([self.model.body.goodsLink  containsString:@"tmall"]||[self.model.body.goodsLink  containsString:@"taobao"]) {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"TaoBaoTransportSwitch"]isEqualToString:@"1"]) {
                        [_costCalculationBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_AddTransport", nil) forState:UIControlStateNormal];
                    }
                }
            }
        }
        _costCalculationBtn.tag = 200;
        [_costCalculationBtn addTarget:self action:@selector(addShoppingCartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _costCalculationBtn;
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
        _bottomView.frame = CGRectMake(0, kScreenH - 49-NavBarHeight, kScreenW , 49);
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
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH  -NavBarHeight-49)];
         _webView.delegate = self;
        _webViewProgressView= [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        [_webViewProgressView setProgress:0];
        _webViewProgress = [[NJKWebViewProgress alloc] init];
         _webView.delegate = _webViewProgress;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webViewProgress.webViewProxyDelegate = self;
        _webViewProgress.progressDelegate = self;
        NSString *ua = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        if (ua) {
            NSArray *uaComps = [ua componentsSeparatedByString:@" "];
            if ([uaComps containsObject:@"Marble"] == NO) {
                NSString *newUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari";
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": newUserAgent}];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    return _webView;
}

//收藏备注页
- (UIView *)collectionV
{
    if (_collectionV == nil) {
        _collectionV = [[UIView alloc]initWithFrame:CGRectMake(50, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width - 100, 330)];
        _collectionV.backgroundColor = [UIColor whiteColor];
        //_collectionV.layer.cornerRadius = 10;
        [_collectionV addSubview:self.collectionIV];
        [_collectionV addSubview:self.collectionNameLb];
        [_collectionV addSubview:self.collectionAttributesLb];
        [_collectionV addSubview:self.collectionShopSourceLb];
        [_collectionV addSubview:self.remarksLb];
        [_collectionV addSubview:self.collectionTx];
        [_collectionV addSubview:self.collectionSureBtn];
        [_collectionV addSubview:self.closeCollectionBtn];
        _collectionV.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255 blue:237.0/255.0 alpha:1];
    }
    return _collectionV;
}

- (UIButton *)closeCollectionBtn
{
    if (_closeCollectionBtn == nil) {
        _closeCollectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.collectionV.frame.size.width - 40, 10, 30, 30)];
        [_closeCollectionBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        [_closeCollectionBtn addTarget:self action:@selector(closeCollection) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeCollectionBtn;
}

- (void)closeCollection
{
    self.collectionV.frame = CGRectMake(50, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width - 100, 340);
    self.webView.userInteractionEnabled = YES;
}

- (UIImageView *)collectionIV
{
    if (_collectionIV == nil) {
        _collectionIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 60, 60)];
    }
    return _collectionIV;
}

- (UILabel *)collectionNameLb
{
    if (_collectionNameLb == nil) {
        _collectionNameLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 150 , 20)];
        _collectionNameLb.font = [UIFont systemFontOfSize:9];
    }
    return _collectionNameLb;
}

- (UILabel *)collectionAttributesLb
{
    if (_collectionAttributesLb == nil) {
        _collectionAttributesLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 150, 20)];
        _collectionAttributesLb.font = [UIFont systemFontOfSize:9];
    }
    return _collectionAttributesLb;
}

- (UILabel *)collectionShopSourceLb
{
    if (_collectionShopSourceLb == nil) {
        _collectionShopSourceLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 150, 20)];
        _collectionShopSourceLb.font = [UIFont systemFontOfSize:9];
    }
    return _collectionShopSourceLb;
}

- (UILabel *)remarksLb
{
    if (_remarksLb == nil) {
        _remarksLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 20)];
        _remarksLb.text = @"备注(选填):";
        _remarksLb.font = [UIFont systemFontOfSize:9];
    }
    return _remarksLb;
}

- (UITextView *)collectionTx
{
    if (_collectionTx == nil) {
        _collectionTx = [[UITextView alloc]initWithFrame:CGRectMake(10, 120,[[UIScreen mainScreen] bounds].size.width - 100 - 20, 150)];
        //_collectionTx.layer.cornerRadius = 10;
        _collectionTx.layer.borderWidth = 1;
    }
    return _collectionTx;
}

- (UIButton *)collectionSureBtn
{
    if (_collectionSureBtn == nil) {
        _collectionSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 280, [[UIScreen mainScreen] bounds].size.width - 100 - 40, 40)];
        _collectionSureBtn.backgroundColor = Main_Color;
        [_collectionSureBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //_collectionSureBtn.layer.cornerRadius = 10;
        [_collectionSureBtn addTarget:self action:@selector(collectionSure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionSureBtn;
}

- (void)collectionSure
{
    self.collectionV.frame = CGRectMake(50, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width - 100, 330);
//    self.collectionBtn.selected = YES;
    self.webView.userInteractionEnabled = YES;
}

- (void)Service
{
    ServiceViewController * svc = [[ServiceViewController alloc]init];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
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
    
    [self setCookie];
    
    //定义要注入的css代码，这段代码是往页面head便签中添加style样式
//    NSString *const INJECT_CSS = @"var head = document.getElementsByTagName('head');var tagStyle=document.createElement(\"style\"); tagStyle.setAttribute(\"type\", \"text/css\");tagStyle.appendChild(document.createTextNode(\"iframe{-webkit-transform:translateZ(0px)}\"));head[0].appendChild(tagStyle);";
//    //注入css，解决购物车页面报WebActionDisablingCALayerDelegate的错误。
//    [webView stringByEvaluatingJavaScriptFromString:INJECT_CSS];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *women = [NSString stringWithFormat:@"%@",webView.request.URL];
    
    NSData *cookiesData    = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        //存储归档后的cookie
        [[NSUserDefaults standardUserDefaults] setObject: cookiesData forKey: @"cookie"];
    
    if ([women containsString:@"https://s.m.taobao.com/h5?search"]) {
//        [webView stopLoading];
        HistorySearchViewController *vc = [[HistorySearchViewController alloc]init];
        vc.put = @"1";
//        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://main.m.taobao.com/"]];
        [self.webView loadRequest: request];
    }
                                                                                     
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
    }else{
        [self.backBtn setImage:[UIImage imageNamed:@""]];
        self.navigationItem.leftBarButtonItem = self.goBtn;
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"reset({'from':'','to':''});"];
//    [self downloadData];
//    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self requestShoppingCar];
//    [self assetComplete:@""];
    [self performSelectorOnMainThread:@selector(commonJs) withObject:nil waitUntilDone:NO];
}

#pragma mark - 保持cookie
- (void)setCookie{
    //取出保存的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    if (cookies) {
        NSLog(@"有cookie");
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStorage setCookie:cookie];
//            if ([cookie.name isEqualToString:@"ylusername"]) { // 这里服务端规定cookie的名称。
//                [[NSUserDefaults standardUserDefaults] setObject: cookie.value forKey: @"userID"];
//            }
        }
    }else{
        NSLog(@"无cookie");
    }
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
    
    if (![href isEqualToString:@"about:blank"] && ![readyState isEqualToString:@"loading"]) {
        [self.timer setFireDate:[NSDate distantFuture]];
        //[self getURLHOST];

        [self.loadingView stopLoading];
//        [self.loadAnimation stopLoadAnimation];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DetailsGuidance"]isEqualToString:@"read"]) {
            
        }else{
            [self.tabBarController.view addSubview:self.guidanceV];
        }
        
        
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
//            self.collectionBtn.selected = YES;
            if (isAllow) {
                [_collectionBtn setImage:[UIImage imageNamed:@"collectionselected"] forState:UIControlStateNormal];
            }else{
                [_collectionBtn setImage:[UIImage imageNamed:@"collectionNO"] forState:UIControlStateNormal];
            }
            isCollection = YES;
        }else{
            self.collectionIdOfGoods = @"";
//            self.collectionBtn.selected = NO;
            if (isAllow) {
                [_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }else{
                [_collectionBtn setImage:[UIImage imageNamed:@"collectionNO"] forState:UIControlStateNormal];
            }
            isCollection = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.collectionIdOfGoods = @"";
//        self.collectionBtn.selected = NO;
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
}

#pragma mark 返回事件
- (void)popClick {
    [self.timer invalidate];
    [self.collectionTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
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
//    if ([self.webView canGoForward]) {
//        [self.webView goForward];
//    }
//    [self.timer invalidate];
//    [self.collectionTimer invalidate];
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self.timer invalidate];
    [self.collectionTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 加入购物车事件

//费用试算
- (void)createCommissionWithPictureUrl:(NSString *)pictureUrl titleOfGoods:(NSString *)titleOfGoods numberOfGoods:(NSString *)numberOfGoods priceOfGoods:(NSString *)priceOfGoods nameOfGoods:(NSString *)nameOfGoods attributesOfGoods:(NSString *)attributesOfGoods moneyTypeOfGoods:(NSString *)moneyTypeOfGoods tureNumberOfGoods:(NSString *)tureNumberOfGoods
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSure:) name:@"didSure" object:nil];
    if (/* DISABLES CODE */ (1)) {
        CommissionViewController *commVC = [[CommissionViewController alloc]init];
        commVC.pictureUrl = pictureUrl;
        commVC.titleOfGoods = titleOfGoods;
        if ([titleOfGoods isEqualToString:@"1688"]) {
            float place = [priceOfGoods floatValue]/[tureNumberOfGoods floatValue];
            commVC.priceOfGoods = [NSString stringWithFormat:@"%2f",place];
            commVC.tureNumberOfGoods = tureNumberOfGoods;
            commVC.numberOfGoods = tureNumberOfGoods;
//            @"1";
        }else{
            commVC.numberOfGoods = numberOfGoods;//数量
            commVC.priceOfGoods = priceOfGoods;//单价
        }
        commVC.nameOfGoods = nameOfGoods;
        commVC.attributesOfGoods = attributesOfGoods;
        commVC.moneyTypeOfGoods = moneyTypeOfGoods;
        commVC.bodyStr = self.bodyStr;
        commVC.nationalityStr = self.nationalityStr;
        commVC.tureNumberOfGoods = tureNumberOfGoods;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           [self.navigationController pushViewController:commVC animated:YES];

        }];
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
        if(isCollection == YES){
            [self deleteCollectionGoods];
            return;
        }
    }
    [self.webView stringByEvaluatingJavaScriptFromString:@"quickBuyAddcart();"];
    NSLog(@"获取商品信息");
}

#pragma mark 新增弹框事件
- (void)GoodSpecificationShow:(NSDictionary *)allAttributes
{
    self.bgControl.hidden = NO;
    if (self.goodSpecificationview == nil) {
        self.goodSpecificationview = [[GoodSpecification alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 510)];
    
        self.goodSpecificationview.detail = allAttributes;
        [self.view addSubview:self.goodSpecificationview];
        self.goodSpecificationview.delegate = self;
    
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.goodSpecificationview.frame = CGRectMake(0, kScreenH-500-LL_StatusBarAndNavigationBarHeight, kScreenW, 510);
    }];
}

#pragma mark GoodSpecificationDelegate
- (void)selectedSpecification:(NSString *)specification selectedNumber:(NSString * _Nullable)number{
    self.bgControl.hidden = YES;
    if (!specification) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_noselect", nil);
        // Move to bottm center.
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:1.f];
    }else{
         GoodSpecificationModel *model = [GoodSpecificationModel shareGoodSpecificationModel];
        model.attributesOfGoods = [NSString stringWithFormat:@"度数:%@",specification];
        NSLog(@"model ===>%@",model.attributesOfGoods);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:model.dic];
        dict[@"attributes"] = [NSString stringWithFormat:@"度数:%@",specification];
        model.numberOfGoods = number;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"dict ===>%@",dict);
        self.bodyStr = str;
        NSLog(@"dict ===>%@",str);
       
        
        [self createCommissionWithPictureUrl:model.pictureUrl titleOfGoods:model.titleOfGoods numberOfGoods:model.numberOfGoods priceOfGoods:model.priceOfGoods nameOfGoods:model.nameOfGoods attributesOfGoods:model.attributesOfGoods moneyTypeOfGoods:model.moneyTypeOfGoods tureNumberOfGoods:model.tureNumberOfGoods];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.goodSpecificationview.frame = CGRectMake(0, kScreenH, kScreenW, 500);
    }];
}
#pragma mark oc和js交互
#pragma mark 获取商品信息
- (void)getGoodsInfo:(NSString *)string {
    NSLog(@"getGoodsInfo  =========");
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
        dispatch_async(dispatch_get_main_queue(), ^{
        /**回到主线线程*/
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_noselect", nil);
            // Move to bottm center.
            hud.label.font = [UIFont systemFontOfSize:12];
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.f];
        });
        
        
        return;
        
    }
    
    NSLog(@"%@",string);
    
    NSLog(@"responseJSON%@",responseJSON);

    
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
    NSDictionary *allAttributes = responseJSON[@"allAttributes"];
    GoodSpecificationModel *model = [GoodSpecificationModel shareGoodSpecificationModel];
    model.dic = responseJSON;
    model.pictureUrl = pictureUrl;
    model.titleOfGoods = titleOfGoods;
    model.numberOfGoods = numberOfGoods;
    model.priceOfGoods = priceOfGoods;
    model.nameOfGoods = nameOfGoods;
    model.attributesOfGoods = attributesOfGoods;
    model.moneyTypeOfGoods = moneyTypeOfGoods;
    model.tureNumberOfGoods = tureNumberOfGoods;
    if (allAttributes) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:allAttributes];
        if (responseJSON[@"quantity"]) {
            [dic setValue:[NSString stringWithFormat:@"%@",responseJSON[@"quantity"] ]forKey:@"数量"];
        }
        
        [self GoodSpecificationShow:dic];
        
        return;
    }
    
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
            NSLog(@"---%@",url);
            message.shareObject = url;
            [[UMSocialManager defaultManager]shareToPlatform:UMSocialPlatformType_Facebook messageObject:message currentViewController:self completion:^(id result, NSError *error) {
                
            }];
        }];
        [alert addAction:takePhoto];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }

    if (self.btnTag == 300) {
        if(isCollection == YES){
            [self deleteCollectionGoods];
            return;
        }
        [self addCollectionWithName:nameOfGoods shopSource:titleOfGoods link:linkOfGoods pictureUrl:pictureUrl attributes:attributesOfGoods];
        return;
    }
    
    if ([responseJSON[@"shopSource"]isEqualToString:@"taobao"] || [responseJSON[@"shopSource"]isEqualToString:@"tmall"]) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"TaoBaoTransportSwitch"]) {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"TaoBaoTransportSwitch"]isEqualToString:@"1"]) {
                NSMutableDictionary *goodsDic = [[NSMutableDictionary alloc]init];
                goodsDic[@"goodLink"] = [NSString stringWithFormat:@"%@",responseJSON[@"link"]];
                goodsDic[@"quantity"] = [NSString stringWithFormat:@"%@",responseJSON[@"quantity"]];
                goodsDic[@"price"] = [NSString stringWithFormat:@"%@",responseJSON[@"price"]];
                goodsDic[@"picture"] = pictureUrl;
                goodsDic[@"attributes"] = [NSString stringWithFormat:@"%@",responseJSON[@"attributes"]];
                goodsDic[@"currency"] = [NSString stringWithFormat:@"%@",responseJSON[@"currency"]];
                goodsDic[@"name"] = [NSString stringWithFormat:@"%@",responseJSON[@"name"]];
                NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
                [tmpArr addObject:goodsDic];
                TaobaoTransportApplyViewController *vc = [[TaobaoTransportApplyViewController alloc]init];
                vc.goodsArr = tmpArr;
                NSLog(@"goodsArr %@",tmpArr);
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self createCommissionWithPictureUrl:pictureUrl titleOfGoods:titleOfGoods numberOfGoods:numberOfGoods priceOfGoods:priceOfGoods nameOfGoods:nameOfGoods attributesOfGoods:attributesOfGoods moneyTypeOfGoods:moneyTypeOfGoods tureNumberOfGoods:tureNumberOfGoods];
            }
        }else{
            [self createCommissionWithPictureUrl:pictureUrl titleOfGoods:titleOfGoods numberOfGoods:numberOfGoods priceOfGoods:priceOfGoods nameOfGoods:nameOfGoods attributesOfGoods:attributesOfGoods moneyTypeOfGoods:moneyTypeOfGoods tureNumberOfGoods:tureNumberOfGoods];
        }
    }else{
        [self createCommissionWithPictureUrl:pictureUrl titleOfGoods:titleOfGoods numberOfGoods:numberOfGoods priceOfGoods:priceOfGoods nameOfGoods:nameOfGoods attributesOfGoods:attributesOfGoods moneyTypeOfGoods:moneyTypeOfGoods tureNumberOfGoods:tureNumberOfGoods];
    }
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
    [[BaiduMobStat defaultStat] logEvent:@"event5" eventLabel:@"[收藏]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"收藏" parameters:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
    /**回到主线线程*/
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        [hud hideAnimated:YES afterDelay:1];
        hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Adding", nil);
    });
    
    
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
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            isCollection = YES;
            [_collectionBtn setImage:[UIImage imageNamed:@"collectionselected"] forState:UIControlStateNormal];
            self.collectionIdOfGoods = responseObject[@"data"][@"id"];
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"收藏成功!", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
            });
            
            
//            self.collectionBtn.selected = YES;
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"收藏失败!", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
            });
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"收藏失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        });
        
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
            dispatch_async(dispatch_get_main_queue(), ^{
            /**回到主线线程*/
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.label.text = NSLocalizedString(@"已移除收藏夹!", @"HUD message title");
               // Move to bottm center.
               hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];

            });
            
            
           
//            self.collectionBtn.selected = NO;
            isCollection = NO;
            [_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"移除失败!", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
            });
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"移除失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        });
        
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
    
    NSString *numberOfGoods = self.goodsUserSetNum;
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
    
    [[BaiduMobStat defaultStat] logEvent:@"event4" eventLabel:@"[加入购物车]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"加入購物車" parameters:nil];
    [manager POST:InsertOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
//
            
            [[UserNotiView alloc]initWithTitle:@"立即结算" message:NSLocalizedString(@"GlobalBuyer_GoodsDetail_ThirtyMin", nil) action:^(NSDictionary *message) {
                ShoppingCartViewController *shoppingCV = [ShoppingCartViewController new];
                [shoppingCV setNavigationBackBtn];
                shoppingCV.shopSource = shopSourceOfGoods;
                [self.navigationController pushViewController:shoppingCV animated:YES];
            }];
            
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"GlobalBuyer_GoodsDetail_ThirtyMin", nil);
//            // Move to bottm center.
//            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//            [hud hideAnimated:YES afterDelay:3.f];
            [self computingTime];
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
    self.goodsUserSetNum = bodyDict[@"goodsUserSetNum"];
    [self addShopCartWithString:self.bodyStr];
    
}



#pragma mark 下载数据购物车数据
- (void)downloadData{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken == nil) {
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//            [self.loadingView stopLoading];
//        }];
//        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DetailsGuidance"]isEqualToString:@"read"]) {
//            
//        }else{
//            [self.tabBarController.view addSubview:self.guidanceV];
//        }
        return;
    }
    NSDictionary *params = @{@"api_token":API_ID,@"api_token":TOKEN,@"secret_key":userToken};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.dataSoucer removeAllObjects];
        for (OrderModel *model in self.dataSoucer) {
            model.body.iSelect = @NO;
        }
        
        NSDictionary *dictData = responseObject[@"data"];
        NSArray *arrTitle = [dictData allKeys];
        NSMutableArray *arrBody = [[NSMutableArray alloc]init];
        for (int i = 0; i < arrTitle.count; i++) {
            for (int j = 0 ; j < [dictData[arrTitle[i]] count]; j++) {
                [arrBody addObject:dictData[arrTitle[i]][j]];
            }
        }
        
        for (NSDictionary *dict in arrBody) {
            OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
            model.Id = dict[@"id"];
            NSData *datas = [dict[@"body"] dataUsingEncoding:NSUTF8StringEncoding ];
            NSDictionary *bodyDict = [NSJSONSerialization JSONObjectWithData:datas options:0 error:nil];
            ShopCartModel *shopCartModel = [[ShopCartModel alloc]initWithDictionary:bodyDict error:nil];
            model.body = shopCartModel;
            model.shop_source = model.body.shopSource;
            if ([model.product_status isEqualToString:@"CART_WAIT"]) {
                [self.dataSoucer addObject:model];
            }
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (OrderModel *model in self.dataSoucer) {
            [arr addObject:[ObjectAndString getObjectData:model]];
        }
        self.dataSoucer = arr;
//        [self classifyData];
//        [self searchShopCart];
        //[self.loadingView stopLoading];



    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//            [self.loadingView stopLoading];
//        }];
//        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DetailsGuidance"]isEqualToString:@"read"]) {
//            
//        }else{
//            [self.tabBarController.view addSubview:self.guidanceV];
//        }

    }];
}

//分类购物车数据
- (void)classifyData {
    
    // 获取array中所有index值
    NSArray *indexArray = [self.dataSoucer valueForKey:@"shopSource"];
    
    // 将array装换成NSSet类型
    NSSet *indexSet = [NSSet setWithArray:indexArray];
    // 新建array，用来存放分组后的array
    NSMutableArray *resultArray = [NSMutableArray array];
    // NSSet去重并遍历
    [[indexSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 根据NSPredicate获取array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shopSource == %@",obj];
        NSArray *indexArray = [self.dataSoucer filteredArrayUsingPredicate:predicate];
        
        // 将查询结果加入到resultArray中
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in indexArray) {
            OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
            [arr addObject:model];
        }
        [resultArray addObject:arr];
    }];
    self.dataSoucer = resultArray;
}

//查找购物车中是否有该网站商品
- (void)searchShopCart
{
    for (int i = 0; i < self.dataSoucer.count; i++) {
        OrderModel *model = self.dataSoucer[i][0];
        NSLog(@"%@",model.body.shopSource);
        NSLog(@"%@",self.model.body.goodsLink);
        if (self.model.body.goodsLink == nil) {
            NSMutableArray *goodsArr = [self getRangeStr:self.link findText:model.body.shopSource];
            if (goodsArr.count > 0) {
                NSLog(@"有");
                [self computingTimeWithWhichElement:i];
                return;
            }
        }
        NSMutableArray *goodsArr = [self getRangeStr:self.model.body.goodsLink findText:model.body.shopSource];
        if (goodsArr.count > 0) {
            NSLog(@"有");
            [self computingTimeWithWhichElement:i];
            return;
        }

    }

}

//计算购物物品过期时间
- (void)computingTimeWithWhichElement:(int)element
{
    if (self.isCounDown == YES) {
        return;
    }
    NSTimeInterval tmpTime = 0.0;
    NSTimeInterval tmpTimeS = 0.0;
    NSTimeInterval time = 1800.0;
    NSInteger timeInteger = 0;
    for (int i = 0; i < [self.dataSoucer[element] count]; i++) {
        OrderModel *model = self.dataSoucer[element][i];
        NSLog(@"%@",model.created_at);
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString * dateString2 = model.created_at;
        
        NSDate *date1 = [NSDate date];
        NSDate *date2 = [df dateFromString:dateString2];
        
        tmpTime = [date1 timeIntervalSinceDate:date2];
        NSLog(@"%f",tmpTime);
        if (tmpTime >= tmpTimeS && tmpTime <= 1800.0) {
            time = tmpTime;
            tmpTimeS = tmpTime;
            timeInteger = time;
            NSLog(@"%f",time);
        }
    }
    
    if (time < 1800) {
        self.isCounDown = YES;
        NSInteger surplusTime = 1800 - timeInteger;
        self.timeLb = [[UILabel alloc]initWithFrame:CGRectMake(1, 25, 38, 15)];
        self.timeLb.backgroundColor = [UIColor redColor];
        self.timeLb.alpha = 0.6;
        self.timeLb.font = [UIFont systemFontOfSize:12];
        self.timeLb.textAlignment = NSTextAlignmentCenter;
        self.timeLb.layer.masksToBounds = YES;
        //self.timeLb.layer.cornerRadius = 5;
        self.timeLb.textColor = [UIColor whiteColor];
        __block NSInteger minTime = surplusTime/60;
        __block NSInteger secTime = surplusTime%60;
        if (minTime < 10) {
            if (minTime > 0) {
                if (secTime < 10) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }
            }else{
                if (secTime < 10) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }
            }
        }else{
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"%.ld:0%.ld",(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%.ld:00",(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"%.ld:%.ld",(long)minTime,(long)secTime];
            }
        }

        //[self.shopBtn addSubview:self.timeLb];
        
        self.currentMinTime = minTime;
        self.currentSecTime = secTime;
        self.currentElement = element;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCountDown) userInfo:nil repeats:YES];
//        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        }];
    }
}

- (void)TimerCountDown
{
    NSInteger minTime = self.currentMinTime;
    NSInteger secTime = self.currentSecTime;
    
    
    secTime--;
    if (secTime < 0) {
        secTime = 59;
        minTime--;
    }
    if (minTime < 10) {
        if (minTime > 0) {
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                }
            }
        }else{
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                }
            }
        }
    }else{
        if (secTime < 10) {
            self.timeLb.text = [NSString stringWithFormat:@"%.ld:0%.ld",(long)minTime,(long)secTime];
            if (secTime == 0) {
                self.timeLb.text = [NSString stringWithFormat:@"%.ld:00",(long)minTime];
            }
        }else{
            self.timeLb.text = [NSString stringWithFormat:@"%.ld:%.ld",(long)minTime,(long)secTime];
        }
    }
    if (minTime == 0 && secTime == 0) {
        self.isCounDown = NO;
        [self.timeLb removeFromSuperview];
        [self computingTimeWithWhichElement:self.currentElement];
    }
    
    
    self.currentMinTime = minTime;
    self.currentSecTime = secTime;

}

//计算购物物品过期时间
- (void)computingTime
{
    if (self.isCounDown == YES) {
        return;
    }
    
    NSTimeInterval time = 1.0;
    NSInteger timeInteger = time;
    
    if (time < 1800) {
        self.isCounDown = YES;
        NSInteger surplusTime = 1800 - timeInteger;
        self.timeLb = [[UILabel alloc]initWithFrame:CGRectMake(1, 25, 38, 15)];
        self.timeLb.backgroundColor = [UIColor redColor];
        self.timeLb.alpha = 0.6;
        self.timeLb.font = [UIFont systemFontOfSize:12];
        self.timeLb.textAlignment = NSTextAlignmentCenter;
        self.timeLb.layer.masksToBounds = YES;
        //self.timeLb.layer.cornerRadius = 5;
        self.timeLb.textColor = [UIColor whiteColor];
        __block NSInteger minTime = surplusTime/60;
        __block NSInteger secTime = surplusTime%60;
        if (minTime < 10) {
            if (minTime > 0) {
                if (secTime < 10) {
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
            
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }
            }else{
                if (secTime < 10) {
             
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
               
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
                    }
                }
            }
        }else{
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"%.ld:0%.ld",(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%.ld:00",(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"%.ld:%.ld",(long)minTime,(long)secTime];
            }
        }
        
        //[self.shopBtn addSubview:self.timeLb];
        
        self.currentMinTime = minTime;
        self.currentSecTime = secTime;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCountDown) userInfo:nil repeats:YES];
//        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            secTime--;
//            if (minTime < 10) {
//                if (minTime > 0) {
//                    if (secTime < 10) {
//                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
//                        if (secTime == 0) {
//                            self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
//                        }
//                    }else{
//                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
//                        if (secTime == 0) {
//                            self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
//                        }
//                    }
//                }else{
//                    if (secTime < 10) {
//                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:0%.ld",(long)minTime,(long)secTime];
//                        if (secTime == 0) {
//                            self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
//                        }
//                    }else{
//                        self.timeLb.text = [NSString stringWithFormat:@"0%.ld:%.ld",(long)minTime,(long)secTime];
//                        if (secTime == 0) {
//                            self.timeLb.text = [NSString stringWithFormat:@"0%.ld:00",(long)minTime];
//                        }
//                    }
//                }
//            }else{
//                if (secTime < 10) {
//                    self.timeLb.text = [NSString stringWithFormat:@"%.ld:0%.ld",(long)minTime,(long)secTime];
//                    if (secTime == 0) {
//                        self.timeLb.text = [NSString stringWithFormat:@"%.ld:00",(long)minTime];
//                    }
//                }else{
//                    self.timeLb.text = [NSString stringWithFormat:@"%.ld:%.ld",(long)minTime,(long)secTime];
//                }
//            }
//            if (minTime == 0 && secTime == 0) {
//                self.isCounDown = NO;
//                [self.timeLb removeFromSuperview];
//                [timer invalidate];
//            }
//            if (secTime == 0) {
//                secTime = 60;
//                minTime--;
//            }
//        }];
    }
}

#pragma mark 是否显示购物车
- (void)showCart:(NSString *)string {
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"%@",jsonDict[@"status"]);
    if (![jsonDict[@"status"] boolValue]) {//不可以购买
        dispatch_async(dispatch_get_main_queue(), ^{
            [_costCalculationBtn setTitleColor:[Unity getColor:@"#ff7b97"] forState:UIControlStateNormal];
            _costCalculationBtn.userInteractionEnabled = NO;
            [_shareGoodsBtn setImage:[UIImage imageNamed:@"goodsshareNO"] forState:UIControlStateNormal];
            _shareGoodsBtn.userInteractionEnabled = NO;
            [_shopBtn setImage:[UIImage imageNamed:@"ic_shopping_cartNO"] forState:UIControlStateNormal];
            _shopBtn.userInteractionEnabled = NO;
            [_collectionBtn setImage:[UIImage imageNamed:@"collectionNO"] forState:UIControlStateNormal];
            _collectionBtn.userInteractionEnabled = NO;
                });

       
//        [self performSelectorOnMainThread:@selector(noHideBommView) withObject:nil waitUntilDone:NO];
    }else{//可以购买
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_costCalculationBtn setTitleColor:[Unity getColor:@"#ffffff"] forState:UIControlStateNormal];
            _costCalculationBtn.userInteractionEnabled = YES;
            [_shareGoodsBtn setImage:[UIImage imageNamed:@"goodsshare"] forState:UIControlStateNormal];
            _shareGoodsBtn.userInteractionEnabled = YES;
            [_shopBtn setImage:[UIImage imageNamed:@"ic_shopping_cart"] forState:UIControlStateNormal];
            _shopBtn.userInteractionEnabled = YES;
            if (isCollection) {
                [_collectionBtn setImage:[UIImage imageNamed:@"collectionselected"] forState:UIControlStateNormal];
            }else{
                [_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
            _collectionBtn.userInteractionEnabled = YES;
        });
      
        //        [self performSelectorOnMainThread:@selector(hideBommView) withObject:nil waitUntilDone:NO];
    }
        
}

- (void)noHideBommView{
    self.bommView.hidden = NO;
}

- (void)hideBommView{
    self.bommView.hidden = YES;
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
    });
    
    

    
    NSLog(@"assetComplete");
    [self performSelectorOnMainThread:@selector(commonJs) withObject:nil waitUntilDone:NO];

    
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"browser"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_ShopDetail_Message_translate", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
    };
}

- (void)commonJs{
        [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:var script = document.createElement('script'); script.src = '//buy.dayanghang.net/inject/m-common.js'; document.body.appendChild(script);"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
}

//请求购物车角标
- (void)requestShoppingCar{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"secret_key"] = userToken;
    
    
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/cart/counts" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            NSString * cartProducts = [responseObject[@"data"]objectForKey:@"cartProducts"];
            NSLog(@"请求回来的数据 %@",cartProducts);
            [self setShopCarCount:[NSString stringWithFormat:@"%@",cartProducts]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
