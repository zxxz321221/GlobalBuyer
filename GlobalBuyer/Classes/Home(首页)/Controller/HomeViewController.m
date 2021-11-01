//
//  HomeViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/4/24.
//  Copyright © 2017年 薛铭. All rights reserved.
//
#import "WXApi.h"
#import "HomeViewController.h"
#import "BannerCell.h"
#import "BannerModel.h"
#import "FileArchiver.h"
#import "CategoryTitleModel.h"
#import "CategoryModel.h"
#import "CountryClassifyCell.h"
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"
#import "NewSearchViewController.h"
#import "GlobalClassifyGoodsViewController.h"
#import "CooperationRegisterViewController.h"
#import "LoginRootViewController.h"
#import "ActivityWebViewController.h"
#import "SGQRCodeScanningVC.h"
#import "LoginViewController.h"
#import "HomeSearchWithKeyViewController.h"
#import "NoviceGuidanceViewController.h"
#import "BrandViewController.h"
#import "TaobaoTransportViewController.h"
#import "GlobalShopDetailViewController.h"
#import "HelpDetailViewController.h"
#import "RotationChartGoodsViewController.h"
#import "HistorySearchViewController.h"
#import "HomeGoodsTitleCell.h"
#import "HomeDiscountCell.h"
#import "PreferentialDiscountViewController.h"
#import "HomeTopTenCell.h"
#import "HomeSpecialOfferCell.h"
#import "SpecialOfferViewController.h"
#import "NewYearViewController.h"
#import "MessageViewController.h"
#import "PurchaseInformationViewController.h"
#import "BrandClassViewController.h"
#import "HomeWebViewController.h"
#import "advertising.h"
#import "FLAnimatedImage.h"
#import "WebViewViewController.h"
#import "XMLDictionary.h"
#import<CommonCrypto/CommonDigest.h>
#import "HotSaleInSummerViewController.h"
#import "UserModel.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BannerCellDelegate,CountryClassifyCellDelegate,SGQRCodeScanningVCDelegate,UIScrollViewDelegate,HomeDiscountCellDelegate,HomeTopTenCellDelegate,HomeSpecialOfferCellDelegate,UITextViewDelegate>
{
    UIPageControl *pageController;
    BOOL isFirst;//判断是否是首次刷新页面   如果首次加载动画 否则动画取消后台刷新数据
    BOOL isBanner;//YES首页主题可点击 NO 首页主题 不可点击
}
@property (nonatomic,strong)UIView *tmpV;
@property (nonatomic,strong)UIButton *classBtn;//左上角分类按钮
@property (nonatomic,strong)UIButton *msgBtn;//右上角消息按钮
@property (nonatomic,strong)UIButton *serviceBtn;
@property (nonatomic,strong)UIButton *qrCodeBtn;
@property (nonatomic,strong)UITextField *searchTf;

@property (nonatomic,strong) UIView *searchBackView;
@property (nonatomic,strong) UITableView *collectionView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL newBannerData;
@property (nonatomic,strong) NSMutableArray *bannerArr;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *webArr;
@property (nonatomic,strong) NSMutableArray *goodArr;
@property (nonatomic,strong) NSMutableArray *selectCountryArr;
@property (nonatomic,strong) NSMutableArray *qAADataSorce;
@property (nonatomic,assign) NSInteger countryTag;
@property (nonatomic,strong) NSString *webLink;
@property (nonatomic,strong) NSString *preferentialActivitiesImg;
@property (nonatomic,strong) UIView *choiceCurrencyV;
@property (nonatomic,strong) UIView *preferentialActivitiesV;
@property (nonatomic,strong) UIView *guidanceV;
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) UIButton *gotoTopBtn;

@property (nonatomic,strong) NSMutableArray *discountDataSource;
@property (nonatomic,strong) NSMutableArray *topTenDataSource;
@property (nonatomic,strong) NSMutableArray *specialOfferDataSource;
@property (nonatomic,strong) NSMutableArray *newyearDataSource;
@property (nonatomic,strong) NSMutableArray *JDDataSource;
@property (nonatomic,strong) UIView *cccIv;
//----首页蒙版
@property (nonatomic,strong) UIView * maskView;
@property (nonatomic,strong) UIView * goodsView;
@property (nonatomic,strong) UITextView * textView;
@property(nonatomic, weak)UILabel *placeHolder;
@property (nonatomic,strong) UIScrollView * pageScrollView;

@property (nonatomic ,strong)NSDictionary * reteDic;
@property (nonatomic,strong) NSString * ebayKey;

@property (nonatomic,strong) advertising *aView;
//-----
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ebayKey = @"fashion";
    isFirst = YES;
    isBanner = NO;
    NSString *homeDir = NSHomeDirectory();
//    NSLog(@"%@",homeDir);
    [self setGoodsNumLb];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGoodsNum:) name:@"refreshGoodsNum" object:nil];
    [self createUI];
    [self.collectionView.mj_header beginRefreshing];
//    [self.aroundAnimation startAround];
//    [self downLoadCountry];

    if (!iOS14) {
        [self sureCurrency];
    }else{
        [self performSelector:@selector(sureCurrency) withObject:nil afterDelay:1.0];

    }
    self.page = 1;
    [self checkUserInfo];
    
    
    //判断剪切板内容
    [self JudgeClipboardC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notMessage) name:@"PushNotMessage" object:nil];
    
    [self enterForeground];
}


- (void)enterForeground{
   
    NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSString *enterprise = [[NSUserDefaults standardUserDefaults]objectForKey:@"enterprise"];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    if (email&&password&&enterprise&&userToken) {
        [self loginWithemail:email password:password enterprise:enterprise];
    }
    
    
}

- (void)loginWithemail:(NSString *)email password:(NSString *)password enterprise:(NSString *)enterprise{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = [NSDictionary new];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"],@"enterprise":enterprise};
    }else{
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"enterprise":enterprise};
    }


    [manager POST:UserLoginApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"error"]) {

        }
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self saveEmailLoginInfo:responseObject];
            
            [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"enterprise"];


        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#define mark 存储个人信息
-(void)saveEmailLoginInfo:(id _Nullable)responseObject {

    NSDictionary *dict = responseObject[@"data"];
    
    
    NSLog(@"============%lu",(unsigned long)[responseObject[@"bind"] count]);
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
    
    [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"id"] forKey:@"UserLoginId"];
    
    for (int i = 0; i < [responseObject[@"bind"] count] ; i++) {
        if ([responseObject[@"bind"][i]isEqualToString:@"weixin"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"WECHATBIND"];
        }
        
        if ([responseObject[@"bind"][i]isEqualToString:@"facebook"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"FACEBIND"];
        }
    }

    
    UserModel *model = [[UserModel alloc]initWithDictionary:dict error:nil];
    if (!model.sex) {
        model.sex = 0;
    }
    
    NSString *mobileStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mobile_phone"]];
    NSString *emailName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"email_name"]];
//    if (!model.fullname || [model.fullname isEqualToString: @"未命名"]) {
//        model.fullname = @"YK1253920N";
//    }
    if (!model.mobile_phone) {
        model.mobile_phone = @"";
    }
    
    
    [[NSUserDefaults standardUserDefaults]setObject:model.mobile_phone forKey:@"UserPhone"];
    [[NSUserDefaults standardUserDefaults]setObject:model.email forKey:@"USEREMAIL"];
    [[NSUserDefaults standardUserDefaults]setObject:model.avatar forKey:@"UserHeadImgUrl"];

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filename contents:nil attributes:nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.email,@"email",model.fullname,@"fullname",mobileStr,@"mobile_phone",model.currency,@"currency",emailName,@"email_name",model.sex,@"sex",model.created_at,@"created_at",nil];
    [dic writeToFile:filename atomically:YES];
    
    
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"dic is:%@",dic2);
    
    UserDefaultSetObjectForKey(model.secret_key, USERTOKEN);
    

}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestGif];    //首页动画
   
}
- (void)notMessage{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"buy"]) {
        ShopDetailViewController *vc = [ShopDetailViewController new];
        vc.link = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLink"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"entrust"]){
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLink"];
        [self.navigationController pushViewController:shopDetail animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"browse"]){
        ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
        webService.href = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLink"];
        webService.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webService animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"List"]){
        NewYearViewController *vc = [[NewYearViewController alloc]init];
        vc.dataSource = self.newyearDataSource;
        vc.currentPage = 0;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationType"]isEqualToString:@"dialog"]){
        [self.tabBarController.view addSubview:self.cccIv];
    }
}

- (UIView *)cccIv{
    if (_cccIv == nil) {
        _cccIv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _cccIv.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 100, kScreenH/2 - 100, 200, 200)];
        iv.userInteractionEnabled = YES;
        [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationdialogImage"]]]];
        [_cccIv addSubview:iv];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotokankan)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tap];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 - 30, kScreenH/2 + 120, 60, 60)];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_cccIv addSubview:btn];
        [btn addTarget:self action:@selector(closeCCCIV) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cccIv;
}

- (void)gotokankan{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationdialogType"]isEqualToString:@"buy"]) {
        ShopDetailViewController *vc = [ShopDetailViewController new];
        vc.link = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLink"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationdialogType"]isEqualToString:@"entrust"]){
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLink"];
        [self.navigationController pushViewController:shopDetail animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationdialogType"]isEqualToString:@"browse"]){
        ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
        webService.href = [[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationLink"];
        webService.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webService animated:YES];
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NotificationdialogType"]isEqualToString:@"List"]){
        NewYearViewController *vc = [[NewYearViewController alloc]init];
        vc.dataSource = self.newyearDataSource;
        vc.currentPage = 0;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.cccIv removeFromSuperview];
    self.cccIv = nil;
}

- (void)closeCCCIV{
    [self.cccIv removeFromSuperview];
    self.cccIv = nil;
}

#pragma mark 刷新商品数量
-(void)refreshGoodsNum:(NSNotification*)notification
{
    [self refreshGoodsNum];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self refreshGoodsNum];
    self.tmpV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50+StatusBarHeight)];
    self.tmpV.backgroundColor = Main_Color;
    [self.tabBarController.view addSubview:self.tmpV];
//    self.serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 30, 30)];
//    [self.serviceBtn setImage:[UIImage imageNamed:@"class"] forState:UIControlStateNormal];
//    [self.tmpV addSubview:self.serviceBtn];
//    [self.serviceBtn addTarget:self action:@selector(serviceBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    self.classBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight+10, 30, 30)];
    [self.classBtn setImage:[UIImage imageNamed:@"class"] forState:UIControlStateNormal];
    [self.tmpV addSubview:self.classBtn];
    [self.classBtn addTarget:self action:@selector(classBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    self.qrCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 32, 14+StatusBarHeight, 25, 25)];
    [self.qrCodeBtn setImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
    [self.tmpV addSubview:self.qrCodeBtn];
    [self.qrCodeBtn addTarget:self action:@selector(qrCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-32, 34, 25, 25)];
//    [self.msgBtn setImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
//    [self.tmpV addSubview:self.msgBtn];
//    [self.msgBtn addTarget:self action:@selector(msgBtnCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.tmpV addSubview:self.searchBackView];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tmpV removeFromSuperview];
    self.tmpV = nil;
}

- (void)createUI
{
    self.view.backgroundColor = Main_Color;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.gotoTopBtn];
    [self createMaskView];
}


- (void)downLoadCountry
{
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
    
    NSArray *readArr = [FileArchiver readFileArchiver:@"Country"];
    if (readArr != nil) {
        self.selectCountryArr = [NSMutableArray arrayWithArray:readArr];
        [self.tabBarController.view addSubview:self.choiceCurrencyV];
    }
    
    NSDictionary *param = @{@"api_id":API_ID,
                            @"api_token":TOKEN,
                            @"locale":language};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:RegionApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.selectCountryArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.selectCountryArr addObject:dict];
            }
            if (readArr == nil) {
                [self.tabBarController.view addSubview:self.choiceCurrencyV];
            }
            [FileArchiver writeFileArchiver:@"Country" withArray:self.selectCountryArr];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UIView *)choiceCurrencyV
{
    if (_choiceCurrencyV == nil) {
        _choiceCurrencyV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _choiceCurrencyV.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
        UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 160, 300, 320)];
        iv.backgroundColor = [UIColor whiteColor];
        [_choiceCurrencyV addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300 - 40, 40)];
        lb.text = NSLocalizedString(@"GlobalBuyer_Selectcurrency", nil);
        lb.textColor = Main_Color;
        lb.font = [UIFont systemFontOfSize:22 weight:2];
        lb.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lb];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 70, 300 - 30, 1)];
        line.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [iv addSubview:line];
        
        UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 80, 270, 165)];
        backSv.contentSize = CGSizeMake(0, self.selectCountryArr.count/2*70);
        [iv addSubview:backSv];
        
        for (int i = 0; i < self.selectCountryArr.count; i++) {
            UIView *backIv = [[UIView alloc]initWithFrame:CGRectMake(10 + 15 * (i%2) + (i%2) * 115, 10 + ((i/2) * 50), 120, 40)];
            backIv.tag = 1000 + i;
            [backSv addSubview:backIv];
            UILabel *countryLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 120, 30)];
            countryLb.textColor = Main_Color;
            countryLb.textAlignment = NSTextAlignmentCenter;
            countryLb.text = self.selectCountryArr[i][@"name"];
            countryLb.font = [UIFont systemFontOfSize:14];
            [backIv addSubview:countryLb];
            if (i == 0) {
                backIv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
                self.countryTag = 1000;
            }else{
                backIv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCurrency:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [backIv addGestureRecognizer:tap];
        }
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 270, 300, 50)];
        sureBtn.backgroundColor = Main_Color;
        UILabel *sureLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        sureLb.textColor = [UIColor whiteColor];
        sureLb.text = NSLocalizedString(@"GlobalBuyer_Ok", nil);
        sureLb.font = [UIFont systemFontOfSize:20 weight:2];
        sureLb.textAlignment = NSTextAlignmentCenter;
        [sureBtn addSubview:sureLb];
        [iv addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureCurrency) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceCurrencyV;
}

- (void)selectCurrency:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < self.selectCountryArr.count; i++) {
        UIView *iv = (UIView *)[self.choiceCurrencyV viewWithTag:i + 1000];
        if (iv.tag == [tap view].tag) {
            iv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.countryTag = [tap view].tag;
        }else{
            iv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}

- (void)sureCurrency
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    
    [manager GET:JudgeTaobaoTransportApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"]] forKey:@"TaoBaoTransportSwitch"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"currency"] forKey:@"currency"];
//    [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"sign"] forKey:@"currencySign"];
//    [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"name"] forKey:@"currencyName"];
    
//    NSLog(@"%@",self.selectCountryArr[self.countryTag - 1000][@"currency"]);
//    [self.choiceCurrencyV removeFromSuperview];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"HomeGuidance"]isEqualToString:@"read"]) {
        
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSLog(@"board=============================%@",board.string);
        self.webLink = board.string;
        
        NSMutableArray *pictureHttpArr = [self getRangeStr:board.string findText:@"http"];
        NSMutableArray *pictureHttpsArr = [self getRangeStr:board.string findText:@"https"];
        
        if (self.webLink) {
            if (pictureHttpArr.count > 0 || pictureHttpsArr.count > 0) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                parameters[@"api_id"] = API_ID;
                parameters[@"api_token"] = TOKEN;;
                parameters[@"link"] = self.webLink;
                
                [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Home_PurchasingLink", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                        alert.tag = 999;
                        [alert show];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }else if ([self.webLink containsString:@"dyh-wotada"]){
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"InvitationCodeClick"]isEqualToString:@"YES"]) {
            
                }else{
                    if (![self chenkUserLogin]) {
                        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"InvitationCodeClick"];
                        NSString *str = [self.webLink stringByReplacingOccurrencesOfString:@"dyh-wotada" withString:@""];
                        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"InvitationCode"];
                        CooperationRegisterViewController *vc = [[CooperationRegisterViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }else{
                
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                parameters[@"api_id"] = API_ID;
                parameters[@"api_token"] = TOKEN;
                NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
                NSLog(@"当前使用的语言：%@",currentLanguage);
                if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
                    parameters[@"locale"] = @"zh_CN";
                }else if([currentLanguage isEqualToString:@"zh-Hant"]){
                    parameters[@"locale"] = @"zh_TW";
                }else if([currentLanguage isEqualToString:@"en"]){
                    parameters[@"locale"] = @"en";
                }else if([currentLanguage isEqualToString:@"Japanese"]){
                    parameters[@"locale"] = @"ja";
                }else{
                    parameters[@"locale"] = @"zh_CN";
                }
                
                [manager POST:CouponsStateApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        self.preferentialActivitiesImg = [NSString stringWithFormat:@"%@",responseObject[@"image"]];
                        [self.tabBarController.view addSubview:self.preferentialActivitiesV];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
        }else{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            parameters[@"api_id"] = API_ID;
            parameters[@"api_token"] = TOKEN;
            NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
            NSLog(@"当前使用的语言：%@",currentLanguage);
            if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
                parameters[@"locale"] = @"zh_CN";
            }else if([currentLanguage isEqualToString:@"zh-Hant"]){
                parameters[@"locale"] = @"zh_TW";
            }else if([currentLanguage isEqualToString:@"en"]){
                parameters[@"locale"] = @"en";
            }else if([currentLanguage isEqualToString:@"Japanese"]){
                parameters[@"locale"] = @"ja";
            }else{
                parameters[@"locale"] = @"zh_CN";
            }
            
            [manager POST:CouponsStateApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    self.preferentialActivitiesImg = [NSString stringWithFormat:@"%@",responseObject[@"image"]];
                    [self.tabBarController.view addSubview:self.preferentialActivitiesV];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        
    }else{
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSLog(@"board=============================%@",board.string);
        self.webLink = board.string;
        if ([self.webLink containsString:@"dyh-wotada"]){
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"InvitationCodeClick"]isEqualToString:@"YES"]) {
                [self.tabBarController.view addSubview:self.guidanceV];
            }else{
                if (![self chenkUserLogin]) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"InvitationCodeClick"];
                    NSString *str = [self.webLink stringByReplacingOccurrencesOfString:@"dyh-wotada" withString:@""];
                    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"InvitationCode"];
                    CooperationRegisterViewController *vc = [[CooperationRegisterViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

- (UIView *)preferentialActivitiesV
{
    if (_preferentialActivitiesV == nil) {
        _preferentialActivitiesV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _preferentialActivitiesV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UIImageView *activitiesIV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 120, kScreenH/2 - 140, 240, 280)];
        [activitiesIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebPictureApi,self.preferentialActivitiesImg]]];
        activitiesIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *activitiesIvTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activitiesRegisterTapClick)];
        activitiesIvTap.numberOfTapsRequired = 1;
        activitiesIvTap.numberOfTouchesRequired = 1;
        [activitiesIV addGestureRecognizer:activitiesIvTap];
        [_preferentialActivitiesV addSubview:activitiesIV];
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2-25, activitiesIV.frame.size.height + activitiesIV.frame.origin.y + 20 , 50, 50)];
        [closeBtn setImage:[UIImage imageNamed:@"优惠劵关闭按钮"] forState:UIControlStateNormal];
        [_preferentialActivitiesV addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(activitiesClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preferentialActivitiesV;
}

- (void)activitiesRegisterTapClick
{
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken) {
        [self.preferentialActivitiesV removeFromSuperview];
        self.preferentialActivitiesV = nil;
        self.tabBarController.selectedIndex = 3;
        return;
    }
    [self.preferentialActivitiesV removeFromSuperview];
    self.preferentialActivitiesV = nil;
    LoginRootViewController *cooVc = [[LoginRootViewController alloc]init];
    cooVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cooVc animated:YES];
}

- (void)activitiesClose
{
    [self.preferentialActivitiesV removeFromSuperview];
    self.preferentialActivitiesV = nil;
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
            guidanceIV.image = [UIImage imageNamed:@"主页引导简体"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            guidanceIV.image = [UIImage imageNamed:@"主页引导繁体"];
        }else if([currentLanguage isEqualToString:@"en"]){
            guidanceIV.image = [UIImage imageNamed:@"主页引导英文"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            guidanceIV.image = [UIImage imageNamed:@"主页引导日文"];
        }else{
            guidanceIV.image = [UIImage imageNamed:@"主页引导简体"];
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
    [[NSUserDefaults standardUserDefaults]setObject:@"read" forKey:@"HomeGuidance"];
    [self.guidanceV removeFromSuperview];
    
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSLog(@"board=============================%@",board.string);
    self.webLink = board.string;
    
    NSMutableArray *pictureHttpArr = [self getRangeStr:board.string findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:board.string findText:@"https"];
    
    if (self.webLink) {
        if (pictureHttpArr.count > 0 || pictureHttpsArr.count > 0) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            parameters[@"api_id"] = API_ID;
            parameters[@"api_token"] = TOKEN;;
            parameters[@"link"] = self.webLink;
            
            [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Home_PurchasingLink", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                    alert.tag = 999;
                    [alert show];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
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

- (UIView *)searchBackView
{
    if (_searchBackView == nil) {
        _searchBackView = [[UIView alloc]initWithFrame:CGRectMake(50, 5+StatusBarHeight, kScreenW - 96, 40)];
        _searchBackView.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1];
        _searchBackView.layer.cornerRadius = 20;
        _searchBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoHistorySearch)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_searchBackView addGestureRecognizer:tap];
        UIImageView *magnifierIv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 24, 24)];
        magnifierIv.image = [UIImage imageNamed:@"放大镜"];
        [_searchBackView addSubview:magnifierIv];
        self.searchTf = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, _searchBackView.frame.size.width - 50, 30)];
        self.searchTf.font = [UIFont systemFontOfSize:13];
        self.searchTf.returnKeyType = UIReturnKeySearch;
        self.searchTf.delegate = self;
        self.searchTf.textColor = [UIColor whiteColor];
        self.searchTf.userInteractionEnabled = NO;
        NSAttributedString *attrString = [[NSAttributedString alloc]
                                          initWithString:NSLocalizedString(@"GlobalBuyer_SearchViewController_placeholder", nil) attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                            NSFontAttributeName:self.searchTf.font
                                            }];
        self.searchTf.attributedPlaceholder = attrString;
        [_searchBackView addSubview:self.searchTf];

    }
    return _searchBackView;
}

- (void)gotoHistorySearch{
    HistorySearchViewController *vc = [[HistorySearchViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    if (textField.text.length <= 0) {
//        return YES;
//    }
//
//    HomeSearchWithKeyViewController *vc = [[HomeSearchWithKeyViewController alloc]init];
//    vc.keyWords = [NSString stringWithFormat:@"%@",textField.text];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//
//
//    return YES;
//}
//点击分类按钮
- (void)classBtnCilck{
//    NewSearchViewController *vc = [[NewSearchViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    BrandClassViewController * bvc = [[BrandClassViewController alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
    
//            PurseViewController * pvc = [[PurseViewController alloc]init];
//            pvc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:pvc animated:YES];
//    MyViewController * pvc = [[MyViewController alloc]init];
//    pvc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:pvc animated:YES];
}
//点击消息按钮
- (void)msgBtnCilck{
    MessageViewController * msg = [MessageViewController new];
    msg.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.barTintColor = Main_Color;
    [self.navigationController pushViewController:msg animated:YES];
}
//点击客服按钮
- (void)serviceBtnCilck
{
    ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
    }else if([currentLanguage isEqualToString:@"en"]){
        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
    }else{
        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
    }
    webService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webService animated:YES];
}

//点击扫码按钮
- (void)qrCodeBtnClick
{
    if (![self chenkUserLogin]) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        
        return;
    }
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        vc.delegate = self;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {

        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)openUrlWithScanUrl:(NSString *)url
{
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = url;
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

- (NSMutableArray *)bannerArr
{
    if (_bannerArr == nil) {
        _bannerArr = [[NSMutableArray alloc]init];
    }
    return _bannerArr;
}

- (NSMutableArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}

- (NSMutableArray *)webArr
{
    if (_webArr == nil) {
        _webArr = [[NSMutableArray alloc]init];
    }
    return _webArr;
}
- (NSMutableArray *)JDDataSource
{
    if (_JDDataSource == nil) {
        _JDDataSource = [[NSMutableArray alloc]init];
    }
    return _JDDataSource;
}


- (NSMutableArray *)goodArr
{
    if (_goodArr == nil) {
        _goodArr = [[NSMutableArray alloc]init];
    }
    return _goodArr;
}

- (NSMutableArray *)selectCountryArr
{
    if (_selectCountryArr == nil) {
        _selectCountryArr = [[NSMutableArray alloc]init];
    }
    return _selectCountryArr;
}

- (NSMutableArray *)qAADataSorce
{
    if (_qAADataSorce == nil) {
        _qAADataSorce = [[NSMutableArray alloc]init];
    }
    return _qAADataSorce;
}

- (NSMutableArray *)discountDataSource{
    if (_discountDataSource == nil) {
        _discountDataSource = [[NSMutableArray alloc]init];
    }
    return _discountDataSource;
}

- (NSMutableArray *)topTenDataSource{
    if (_topTenDataSource == nil) {
        _topTenDataSource = [[NSMutableArray alloc]init];
    }
    return _topTenDataSource;
}

- (NSMutableArray *)specialOfferDataSource{
    if (_specialOfferDataSource == nil) {
        _specialOfferDataSource = [[NSMutableArray alloc]init];
    }
    return _specialOfferDataSource;
}

- (NSMutableArray *)newyearDataSource{
    if (_newyearDataSource == nil) {
        _newyearDataSource = [[NSMutableArray alloc]init];
    }
    return _newyearDataSource;
}

-(UITableView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50+StatusBarHeight, kScreenW ,  kScreenH - 50-StatusBarHeight - kTabBarH) style:UITableViewStyleGrouped];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        _collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downloadBannerData)];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStatePulling", nil) forState:MJRefreshStatePulling];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateRefreshing", nil) forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.arrowView.hidden = YES;
        
        _collectionView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dowloadMoreData)];
        
         //设置文字
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStatePulling", nil) forState:MJRefreshStateRefreshing];
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateRefreshing", nil) forState:MJRefreshStateNoMoreData];

        _collectionView.mj_footer = footer;
        
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return  1;
    }else if (section == 1){
        if (self.discountDataSource.count == 0) {
            return 0;
        }else{
            return  1;
        }
    }else if (section == 2){
        if (self.specialOfferDataSource.count == 0) {
            return 0;
        }else{
            return  1;
        }
    }else if (section == 3){
        if (self.topTenDataSource.count == 0) {
            return 0;
        }else{
            return  1;
        }
    }else if (section == 4){
        return  1;
    }else{
        return self.goodArr.count/2;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//            if (self.newyearDataSource.count == 0) {
                return kScreenW/2.5 +  [Unity countcoordinatesH:90] + 290 + 250 - 60 + 110 - 90;
//            }else{
//                return kScreenW/2.5 + 100 + 290 + 250 - 60 + 110 - 70 + 10;
//            }
            
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
//            if (self.newyearDataSource.count == 0) {
                return kScreenW/2.5 +  [Unity countcoordinatesH:90] + 410 + 250 - 60 + 110 - 90;
//            }else{
//                return kScreenW/2.5 + 100 + 410 + 250 - 60 + 110 - 70 + 10;
//            }
        }else if([currentLanguage isEqualToString:@"en"]){
//            if (self.newyearDataSource.count == 0) {
                return kScreenW/2.5 +  [Unity countcoordinatesH:90] + 410 + 250 - 60 + 110 - 90;
//            }else{
//                return kScreenW/2.5 + 100 + 410 + 250 - 60 + 110 - 70 + 10;
//            }
        }else if([currentLanguage isEqualToString:@"Japanese"]){
//            if (self.newyearDataSource.count == 0) {
                return kScreenW/2.5 +  [Unity countcoordinatesH:90] + 410 + 250 - 60 + 110 - 90;
//            }else{
//                return kScreenW/2.5 + 100 + 410 + 250 - 60 + 110 - 70 + 10;
//            }
        }else{
//            if (self.newyearDataSource.count == 0) {
                return kScreenW/2.5 +  [Unity countcoordinatesH:90] + 290 + 250 - 60 + 110 - 90;
//            }else{
//                return kScreenW/2.5 + 100 + 290 + 250 - 60 + 110 - 70 + 10;
//                //100*self.newyearDataSource.count
//            }
        }
        
    }else if (indexPath.section == 1){
        if (self.discountDataSource.count == 0) {
            return 0.1;
        }else{
//            if (self.discountDataSource.count > 6) {
//                return 8*50;
//            }else{
                return ([self.discountDataSource[0] count]+2)*50;
//            }
        }
    }else if (indexPath.section == 2){
        if (self.specialOfferDataSource.count > 6) {
            return 260*3+60;
        }else{
            if (self.specialOfferDataSource.count%2 == 0) {
                return (self.specialOfferDataSource.count/2)*260+60;
            }else{
                return ((self.specialOfferDataSource.count/2)+1)*260+60;
            }
        }
    }else if (indexPath.section == 3){
        if (self.topTenDataSource.count > 10) {
            return 60*11;
        }else{
            return (self.topTenDataSource.count+1)*60;
        }
    }else if (indexPath.section == 4){
        return 100;
    }else if (indexPath.section == 5){
        return kScreenW/2 + 30;
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BannerCell class])];
        if (cell == nil) {
            cell = [[BannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([BannerCell class])];
        }
        cell.imgArr = self.bannerArr;
        cell.webArr = self.webArr;
//        cell.newyearArr = self.newyearDataSource;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        HomeDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeDiscountCell class])];
        if (cell == nil) {
            cell = [[HomeDiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomeDiscountCell class])];
        }
        cell.discountDataSource = self.discountDataSource[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){
        HomeSpecialOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeSpecialOfferCell class])];
        if (cell == nil) {
            cell = [[HomeSpecialOfferCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomeSpecialOfferCell class])];
        }
        cell.specialOfferDataSource = self.specialOfferDataSource;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 3){
        HomeTopTenCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTopTenCell class])];
        if (cell == nil) {
            cell = [[HomeTopTenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomeTopTenCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.topTenDataSource = self.topTenDataSource;
        return cell;
    }else if (indexPath.section == 4){
        HomeGoodsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeGoodsTitleCell class])];
        if (cell == nil) {
            cell = [[HomeGoodsTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomeGoodsTitleCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CountryClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CountryClassifyCell class])];
//        NSLog(@"总数%ld,(*2)%ld,(*2+1),%ld",self.goodArr.count,indexPath.row*2,indexPath.row*2+1);
        if (cell == nil) {
            cell = [[CountryClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CountryClassifyCell class])];
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.goodArr[indexPath.row*2][@"good_pic"]]]];
        [cell.rightImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.goodArr[indexPath.row*2+1][@"good_pic"]]]];

        if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"qiang"]) {
            cell.webIconIV.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"miao"]){
            cell.webIconIV.image = [UIImage imageNamed:@"京东分类"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"ju"]){
            cell.webIconIV.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"amazon-us"]){
            cell.webIconIV.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"6pm"]){
            cell.webIconIV.image = [UIImage imageNamed:@"6pm"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"rakuten"]){
            cell.webIconIV.image = [UIImage imageNamed:@"乐天"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"macys"]){
            cell.webIconIV.image = [UIImage imageNamed:@"梅西百货"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"Nissen"]){
            cell.webIconIV.image = [UIImage imageNamed:@"日线"];
        }else if ([self.goodArr[indexPath.row*2][@"good_site"]isEqualToString:@"ebay"]){
            cell.webIconIV.image = [UIImage imageNamed:@"Ebay"];
        }

        if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"qiang"]) {
            cell.rightWebIconIV.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"miao"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"京东分类"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"ju"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"amazon-us"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"6pm"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"6pm"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"rakuten"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"乐天"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"macys"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"梅西百货"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"Nissen"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"日线"];
        }else if ([self.goodArr[indexPath.row*2+1][@"good_site"]isEqualToString:@"ebay"]){
            cell.rightWebIconIV.image = [UIImage imageNamed:@"Ebay"];
        }
        
        cell.good_site = self.goodArr[indexPath.row*2][@"good_site"];
        cell.rightgood_site = self.goodArr[indexPath.row*2+1][@"good_site"];

        cell.goodName.text = [NSString stringWithFormat:@"%@",self.goodArr[indexPath.row*2][@"good_name"]];
        cell.rightGoodName.text = [NSString stringWithFormat:@"%@",self.goodArr[indexPath.row*2+1][@"good_name"]];

        cell.href = self.goodArr[indexPath.row*2][@"good_link"];
        cell.rightHref = self.goodArr[indexPath.row*2+1][@"good_link"];
        
        if (self.reteDic) {
            cell.priceLb.text = [CurrencyCalculation conversionCurrency:self.goodArr[indexPath.row*2][@"good_price"] Curr:self.goodArr[indexPath.row*2][@"good_currency"] ReteDic:self.reteDic GoodSite:self.goodArr[indexPath.row*2][@"good_site"]];
            cell.rightPriceLb.text = [CurrencyCalculation conversionCurrency:self.goodArr[indexPath.row*2+1][@"good_price"] Curr:self.goodArr[indexPath.row*2+1][@"good_currency"] ReteDic:self.reteDic GoodSite:self.goodArr[indexPath.row*2+1][@"good_site"]];
        }else{
            cell.priceLb.text = [NSString stringWithFormat:@"%@",[CurrencyCalculation getcurrencyCalculation:[self.goodArr[indexPath.row*2][@"good_price"] floatValue] currentCommodityCurrency:self.goodArr[indexPath.row*2][@"good_currency"] numberOfGoods:1.0]];

            cell.rightPriceLb.text = [NSString stringWithFormat:@"%@",[CurrencyCalculation getcurrencyCalculation:[self.goodArr[indexPath.row*2+1][@"good_price"] floatValue] currentCommodityCurrency:self.goodArr[indexPath.row*2+1][@"good_currency"] numberOfGoods:1.0]];
        }

        if ([self.goodArr[indexPath.row*2][@"init_price"]isEqualToString:@""]) {
            cell.oPriceLb.hidden = YES;
        }else{
            cell.oPriceLb.hidden = NO;
            NSString *oldPrice = [NSString stringWithFormat:@"%@",[CurrencyCalculation getcurrencyCalculation:[self.goodArr[indexPath.row*2][@"init_price"] floatValue] currentCommodityCurrency:self.goodArr[indexPath.row*2][@"good_currency"] numberOfGoods:1.0]];
            NSUInteger length = [oldPrice length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)  range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
            [cell.oPriceLb setAttributedText:attri];
        }

        if ([self.goodArr[indexPath.row*2+1][@"init_price"]isEqualToString:@""]) {
            cell.oRightPriceLb.hidden = YES;
        }else{
            cell.oRightPriceLb.hidden = NO;
            NSString *oldPriceR = [NSString stringWithFormat:@"%@",[CurrencyCalculation getcurrencyCalculation:[self.goodArr[indexPath.row*2+1][@"init_price"] floatValue] currentCommodityCurrency:self.goodArr[indexPath.row*2+1][@"good_currency"] numberOfGoods:1.0]];
            NSUInteger lengthR = [oldPriceR length];
            NSMutableAttributedString *attriR = [[NSMutableAttributedString alloc] initWithString:oldPriceR];
            [attriR addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)  range:NSMakeRange(0, lengthR)];
            [attriR addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, lengthR)];
            [cell.oRightPriceLb setAttributedText:attriR];
        }

        [NSString stringWithFormat:@"%@",[CurrencyCalculation getcurrencyCalculation:[self.goodArr[indexPath.row*2+1][@"init_price"] floatValue] currentCommodityCurrency:self.goodArr[indexPath.row*2+1][@"good_currency"] numberOfGoods:1.0]];
        
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)clickDiscountWithLink:(NSString *)link type:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = link;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = link;
        [self.navigationController pushViewController:shopDetail animated:YES];
    }
}

- (void)clickDiscountWithMore{
    PreferentialDiscountViewController *vc = [[PreferentialDiscountViewController alloc]init];
//    NSMutableArray * array = [NSMutableArray new];
//    NSMutableArray * overdueArr = [NSMutableArray new];
//    NSMutableArray * listArray = [NSMutableArray new];
//    for (int i=0; i<self.discountDataSource.count; i++) {
//        if ([self checkProductDate:[self.discountDataSource[i] objectForKey:@"ends_at"]]) {
//            [array addObject:self.discountDataSource[i]];
//        }else{
//            [overdueArr addObject:self.discountDataSource[i]];
//        }
//    }
//    [listArray addObject:array];
//    [listArray addObject:overdueArr];
//    NSLog(@"%lu   ,    %@",listArray.count,listArray);
    vc.discountDataSource = self.discountDataSource;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)checkProductDate: (NSString *)tempDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:tempDate];
    
    // 判断是否大于当前时间
    if ([date earlierDate:[NSDate date]] != date) {
        
        return true;
    } else {
        
        return false;
    }
}
- (void)clickSpecialOfferWithLink:(NSString *)link type:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = link;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GlobalShopDetailViewController *shopDetail = [[GlobalShopDetailViewController alloc]init];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = link;
        [self.navigationController pushViewController:shopDetail animated:YES];
    }
}

- (void)clickSpecialOfferWithMore{
    SpecialOfferViewController *vc = [[SpecialOfferViewController alloc]init];
    vc.specialOfferDataSource = self.specialOfferDataSource;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickTopTenWithLink:(NSString *)link type:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = link;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = link;
        [self.navigationController pushViewController:shopDetail animated:YES];
    }
}

- (void)clickHomeGoodsWithLink:(NSString *)urlString Good_site:(NSString *)good_site
{
//    if ([good_site isEqualToString:@"ebay"]) {
//        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
//        shopDetail.hidesBottomBarWhenPushed = YES;
//        shopDetail.link = urlString;
//        NSLog(@"%@",urlString);
//        shopDetail.isShowText = YES;
//        [self.navigationController pushViewController:shopDetail animated:YES];
//    }else{
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = urlString;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}


-(void)downloadBannerData{
    [self downloadMoneytype];
    [self requestEbayKeyWords];
//    if (isFirst) {//如果首次刷新加载动画 否则取消动画
//        isFirst = NO;
//    }else{
        [self.titleArr removeAllObjects];
        [self.webArr removeAllObjects];
        [self.goodArr removeAllObjects];
        NSArray *array1 = [FileArchiver readFileArchiver:@"hometitleArr"];
        if (array1) {
            self.titleArr = [NSMutableArray arrayWithArray:array1];
        }

        NSArray *arra = [FileArchiver readFileArchiver:@"homewebArr"];
        if (arra) {
            self.webArr = [NSMutableArray arrayWithArray:arra];
        }
        NSArray *arr = [FileArchiver readFileArchiver:@"homegoodArr"];
        if (arr) {
            self.goodArr = [NSMutableArray arrayWithArray:arr];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];//停止动画
//    }

    self.newBannerData = YES;
    
    NSArray *array = [FileArchiver readFileArchiver:@"homeBanner"];
    if (array) {
        self.bannerArr = [NSMutableArray arrayWithArray:array];
    }
    
    
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
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"field"] = @"symbol";
    params[@"position"] = @"slide-index";
    params[@"locale"] = language;
    
    [manager POST:CountryAndSpecialDetailApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.bannerArr removeAllObjects];
        NSDictionary *data = responseObject[@"data"];
        NSArray *banner = (NSArray *)data;
        [self bannerArrToModel:banner];
        if (self.newBannerData) {
            NSLog(@"%lu",(unsigned long)self.bannerArr.count);
            [FileArchiver writeFileArchiver:@"homeBanner" withArray:self.bannerArr];
        }
        self.newBannerData = NO;
        [self downloadWebData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self downloadWebData];
        self.collectionView.hidden = NO;
        self.collectionView.mj_header.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)readBannerFile:(NSString *)fileName{
    NSArray *array = [FileArchiver readFileArchiver:fileName];
    if (array) {
        [self bannerArrToModel:array];
    }else{
    }
}
-(void)bannerArrToModel:(NSArray *)arr{
    
    for (NSDictionary *dict in arr) {
        BannerModel *model = [[BannerModel alloc]initWithDictionary:dict error:nil];
        [self.bannerArr addObject:model];
    }
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
    
}

- (void)downloadWebData{

    
//    NSArray *array = [FileArchiver readFileArchiver:@"hometitleArr"];
//    if (array) {
//        self.titleArr = [NSMutableArray arrayWithArray:array];
//        [self.collectionView reloadData];
//    }
    
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
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"locale":language};
    
    [manager  POST: CategoryTitleApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count == 0) {
            return ;
        }
        [self.titleArr removeAllObjects];
        for (NSDictionary *dict in dataArr) {
            CategoryTitleModel  *categoryTitleModel = [[CategoryTitleModel alloc]initWithDictionary:dict error:nil];
            categoryTitleModel.Id = dict[@"id"];
            [self.titleArr addObject:categoryTitleModel];
        }
        [FileArchiver writeFileArchiver:@"hometitleArr" withArray:self.titleArr];
        [self downloadWebDetailData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self downloadWebDetailData];
    }];
}

- (void)downloadWebDetailData{
    
    
    NSArray *array = [FileArchiver readFileArchiver:@"homewebArr"];
//    if (array) {
//        self.webArr = [NSMutableArray arrayWithArray:array];
//        [self.collectionView reloadData];
//    }
    
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
    
    CategoryTitleModel  *categoryTitleModel = self.titleArr[0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"locale":language};
    
    [manager  POST: @"http://buy.dayanghang.net/api/platform/web/category/hot/webapi/list" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count == 0) {
            return ;
        }
        [self.webArr removeAllObjects];
        for (NSDictionary *dict in dataArr) {
            CategoryModel *model = [[CategoryModel alloc]initWithDictionary:dict error:nil];
            model.Description = dict[@"description"];
            [self.webArr addObject:model];
        }
        [FileArchiver writeFileArchiver:@"homewebArr" withArray:self.webArr];
        if (![array isEqualToArray:self.webArr]) {
            [self.collectionView reloadData];
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//            [self.collectionView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        //干掉八爪鱼
        [self downGoodsData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        //干掉八爪鱼
        [self downGoodsData];
    }];
}

- (void)downGoodsData{
    
    [self requestEbayGoods:self.page isDown:YES];
//    [self downExternalJDDataPage:self.page isDown:YES];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//    parameters[@"api_id"] = API_ID;
//    parameters[@"api_token"] = TOKEN;
//    parameters[@"page"] = [NSString stringWithFormat:@"%ld",self.page];
//    parameters[@"sort_key"] = @"1";
//
//    [manager GET:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/limit/webapi/list" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//        if ([responseObject[@"code"]isEqualToString:@"success"]) {
//
//            [self.goodArr removeAllObjects];
//            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
//                [self.goodArr addObject:responseObject[@"data"][i]];
//            }
//            for (int i = 0 ; i < self.goodArr.count; i++) {
//                NSString *tmpStr = self.goodArr[i][@"good_name"];
//                for (int j = i + 1; j < self.goodArr.count; j++) {
//                    if ([tmpStr isEqualToString:self.goodArr[j][@"good_name"]]) {
//                        [self.goodArr removeObjectAtIndex:j];
//                    }
//                }
//            }
//
//            [FileArchiver writeFileArchiver:@"homegoodArr" withArray:self.goodArr];
//            [self requestEbayGoods:self.page isDown:YES];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self requestEbayGoods:self.page isDown:YES];
//    }];
}

- (void)downDiscountData{
    
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
    parameters[@"api_token"] = TOKEN;
    parameters[@"locale"] = language;
    
    [manager GET:HomeDiscountApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.discountDataSource removeAllObjects];
//            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
//                [self.discountDataSource addObject:responseObject[@"data"][i]];
//            }
            NSMutableArray * array = [NSMutableArray new];
            NSMutableArray * overdueArr = [NSMutableArray new];
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                if ([self checkProductDate:[responseObject[@"data"][i] objectForKey:@"ends_at"]]) {
                    [array addObject:responseObject[@"data"][i]];
                }else{
                    [overdueArr addObject:responseObject[@"data"][i]];
                }
            }
            [self.discountDataSource addObject:array];
            [self.discountDataSource addObject:overdueArr];

        }
        [self downTopTenData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self downTopTenData];
    }];
}

- (void)downTopTenData{
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
    parameters[@"api_token"] = TOKEN;
    parameters[@"locale"] = language;
    
    [manager GET:HomeTopTenApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.topTenDataSource removeAllObjects];
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.topTenDataSource addObject:responseObject[@"data"][i]];
            }
            
        }
        [self downloadSpecialOfferData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self downloadSpecialOfferData];
    }];
}

- (void)downloadSpecialOfferData{
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
    parameters[@"api_token"] = TOKEN;
    parameters[@"locale"] = language;
    
    [manager GET:HomeSpecialOfferApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.specialOfferDataSource removeAllObjects];
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.specialOfferDataSource addObject:responseObject[@"data"][i]];
            }
            
        }
        [self downLoadYearData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self downLoadYearData];
    }];
}

- (void)downLoadYearData{
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
    parameters[@"api_token"] = TOKEN;
    parameters[@"locale"] = language;
    
    [manager GET:HomeYearApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.newyearDataSource removeAllObjects];
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.newyearDataSource addObject:responseObject[@"data"][i]];
            }
        }
        isBanner = YES;
//        NSMutableArray * arr = [NSMutableArray arrayWithArray:[FileArchiver readFileArchiver:@"homeYear"]];
//        if (![arr isEqualToArray:self.newyearDataSource]) {
//
//        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}

- (void)dowloadMoreData
{
    [self requestEbayGoods:self.page isDown:NO];
    
//    [self downExternalJDDataPage:self.page isDown:NO];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//    parameters[@"api_id"] = API_ID;
//    parameters[@"api_token"] = TOKEN;
//    parameters[@"page"] = [NSString stringWithFormat:@"%ld",self.page];
//    parameters[@"sort_key"] = @"1";
//
//    [manager GET:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/limit/webapi/list" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//        if ([responseObject[@"code"]isEqualToString:@"success"]) {
//
//            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
//                [self.goodArr addObject:responseObject[@"data"][i]];
//            }
//            for (int i = 0 ; i < self.goodArr.count; i++) {
//                NSString *tmpStr = self.goodArr[i][@"good_name"];
//                for (int j = i + 1; j < self.goodArr.count; j++) {
//                    if ([tmpStr isEqualToString:self.goodArr[j][@"good_name"]]) {
//                        [self.goodArr removeObjectAtIndex:j];
//                    }
//                }
//            }
//
//            NSLog(@"ebay商品删除 %ld",self.goodArr.count);
//            [self requestEbayGoods:self.page isDown:NO];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.collectionView.mj_footer endRefreshing];
//        [self dowloadMoreData];
//
//    }];
}

- (void)downQAA
{
    [self.qAADataSorce removeAllObjects];
    
    NSArray *array = [FileArchiver readFileArchiver:@"homeQAA"];
    if (array) {
        for (int i = 0 ; i < array.count; i++) {
            [self.qAADataSorce addObject:array[i]];
        }
        [self.collectionView reloadData];
    }
    
    
    
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
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"locale"] = language;
    params[@"sign"] = @"info";
    
    [manager POST:HelpListApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.qAADataSorce removeAllObjects];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSArray *arr = responseObject[@"data"][0][@"get_help_content"];
            for (int i = 0 ; i < arr.count; i++) {
                [self.qAADataSorce addObject:arr[i]];
            }
            
            
            [FileArchiver writeFileArchiver:@"homeQAA" withArray:self.qAADataSorce];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)cellImgClickWithLink:(NSString *)urlString withImg:(NSString *)img type:(NSString *)type url:(NSString *)url
{
    if ([type isEqualToString:@"list"]) {
        RotationChartGoodsViewController *vc = [[RotationChartGoodsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = NSLocalizedString(@"GlobalBuyer_Entrust_Webdetails", nil);
        vc.imgUrl = img;
        vc.apiUrl = url;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"buy"]) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = urlString;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"browse"]) {
        ActivityWebViewController *vc = [[ActivityWebViewController alloc]init];
        vc.href = urlString;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)selectAmazonOrOthers:(NSInteger)index
{
    if (index == 200) {//淘宝转运
        if (![self chenkUserLogin]) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            
            return;
        }
        TaobaoTransportViewController *vc = [[TaobaoTransportViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 201) {//淘宝转运
        if (![self chenkUserLogin]) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            
            return;
        }
        TaobaoTransportViewController *vc = [[TaobaoTransportViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = @"淘宝转运";
        [self.navigationController pushViewController:vc animated:YES];
//        MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:HUD];
//        HUD.labelText = @"加载中,请稍等...";
//        HUD.mode = MBProgressHUDModeText;
//
//        [HUD showAnimated:YES whileExecutingBlock:^{
//            sleep(2);
//
//        }];
    }
    if (index == 202) {//海淘咨询
        PurchaseInformationViewController *vc = [[PurchaseInformationViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 203) {//找商品
        _maskView.hidden=NO;
    }
//    if (index == 200) {
//        NewSearchViewController *vc = [[NewSearchViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (index == 201) {
//        if (![self chenkUserLogin]) {
//            LoginViewController *loginVC = [[LoginViewController alloc]init];
//            loginVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:loginVC animated:YES];
//
//            return;
//        }
//        TaobaoTransportViewController *vc = [[TaobaoTransportViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (index == 202) {
//        GlobalClassifyGoodsViewController *vc = [[GlobalClassifyGoodsViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (index == 203) {
//        BrandViewController *brandVC = [[BrandViewController alloc]init];
//        brandVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:brandVC animated:YES];
//    }
}

- (void)clickWebWithLink:(NSString *)link
{
    if ([link isEqualToString:@"http://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_ff3=1&pub=5575490065&toolid=10001&campid=5338507482&customid=1&ipn=psmain&icep_vectorid=229466&kwid=902099&mtid=824&kw=lg"]) {
        GlobalShopDetailViewController * vc = [GlobalShopDetailViewController new];
        vc.link = link;
        vc.hidesBottomBarWhenPushed = YES;
        vc.isShowText = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ShopDetailViewController *vc = [ShopDetailViewController new];
        vc.link = link;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickGlobalWebMore
{
    [self.navigationController.tabBarController setSelectedIndex:1];
}

- (void)clickOneImg
{
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
        ShopDetailViewController *vc = [ShopDetailViewController new];
        vc.link = @"http://buy.dayanghang.net/user_data/special/20201106/main.html";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
        if (![self chenkUserLogin]) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            
            return;
        }
        TaobaoTransportViewController *vc = [[TaobaoTransportViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = @"淘寶轉運";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
        ShopDetailViewController *vc = [ShopDetailViewController new];
        vc.link = @"http://buy.dayanghang.net/user_data/special/20201106/main.html";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"name":@"taobaoFreight",
                             @"sign":@"symbol",
                             @"locale":language};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:HelpOneApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            HelpDetailViewController *helpDetailVC = [HelpDetailViewController new];
            helpDetailVC.hidesBottomBarWhenPushed = YES;
            helpDetailVC.bodyStr = responseObject[@"data"][@"body"];
            helpDetailVC.navigationItem.title = responseObject[@"data"][@"title"];
            [self.navigationController pushViewController:helpDetailVC animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hideAnimated:YES];
    }];
}

- (void)clickTwoImg
{
//    TaobaoTransportViewController *vc = [[TaobaoTransportViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.type = @"淘宝转运";
//    [self.navigationController pushViewController:vc animated:YES];
    HotSaleInSummerViewController *vc = [[HotSaleInSummerViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)clickThreeImg
{
    ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
    // 获得当前iPhone使用的语言
//    webService.href = @"http://buy.dayanghang.net/user_data/special/20180528/index.html";
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        webService.href = @"http://buy.dayanghang.net/user_data/special/20190110/cn/Other.html";
    }else{
        webService.href = @"http://buy.dayanghang.net/user_data/special/20190110/tw/Other.html";
    }
    webService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webService animated:YES];
}

- (void)clickNewYearWithId:(NSString *)goodsid tag:(NSInteger)tag{
    NewYearViewController *vc = [[NewYearViewController alloc]init];
    NSLog(@"传给主题活动的数据%@,tag=%ld",self.newyearDataSource,(long)tag);
    vc.dataSource = self.newyearDataSource;
    vc.currentPage = tag;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickNovice
{
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    HomeWebViewController * hvc = [[HomeWebViewController alloc]init];
    hvc.hidesBottomBarWhenPushed = YES;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//        if (self.qAADataSorce.count == 0) {
//            return;
//        }
//        NoviceGuidanceViewController *ngVC = [[NoviceGuidanceViewController alloc]init];
//        ngVC.hidesBottomBarWhenPushed = YES;
//        ngVC.qaaSource = self.qAADataSorce;
//        [self.navigationController pushViewController:ngVC animated:YES];
        hvc.url = @"http://buy.dayanghang.net/user_data/special/20190429/IntroductionCN.html";
        hvc.title = @"wodata全球买手购物流程";
    }else{
//        [self.navigationController.tabBarController setSelectedIndex:4];
        hvc.url = @"http://buy.dayanghang.net/user_data/special/20190429/IntroductionTW.html";
        hvc.title = @"wodata全球買手購物流程";
    }
    [self.navigationController pushViewController:hvc animated:YES];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.tag == 999) {
//        NSLog(@"完成滚动");
    int offset_x = scrollView.contentOffset.x;
    int scro_w = kScreenW*0.8*0.9;
        int index=offset_x/scro_w;
//        NSLog(@"%d   ,   %d",offset_x,scro_w);
        pageController.currentPage=index;
//        return;
//    }
    [self.searchTf resignFirstResponder];
    if (scrollView.contentOffset.y > 760.0) {
        _gotoTopBtn.hidden = NO;
    }else{
        _gotoTopBtn.hidden = YES;
    }
}

- (UIButton *)gotoTopBtn{
    if (_gotoTopBtn == nil) {
        _gotoTopBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 70, kScreenH - 120, 50, 50)];
        [_gotoTopBtn setImage:[UIImage imageNamed:@"home_scroll_top"] forState:UIControlStateNormal];
        _gotoTopBtn.hidden = YES;
        [_gotoTopBtn addTarget:self action:@selector(gotoTopClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoTopBtn;
}

- (void)gotoTopClick{
    self.collectionView.contentOffset = CGPointMake(0, 0);
}

- (void)checkUserInfo
{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"secret_key"] = userToken;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
        params[@"JPushId"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"];
    }
    
    
    [manager POST:checkUserApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"error"]) {
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths    objectAtIndex:0];
            NSLog(@"path = %@",path);
            NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
            NSFileManager *defaultManager = [NSFileManager defaultManager];
            [defaultManager removeItemAtPath:filename error:nil];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
            UserDefaultRemoveObjectForKey(USERTOKEN);
            [self.navigationController popViewControllerAnimated:YES];
            [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_Facebook   completion:^(id result, NSError *error) {
                
            }];
            [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
            [[NSUserDefaults standardUserDefaults]setObject:@"false" forKey:@"DistributorBoss"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//首页蒙版
- (void)createMaskView{
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    
    _goodsView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-kScreenW*0.8)/2, (kScreenH-kScreenH*0.6)/2, kScreenW*0.8, kScreenH*0.6)];
    _goodsView.layer.cornerRadius = 7;
    _goodsView.backgroundColor = [UIColor whiteColor];
    [_maskView addSubview:_goodsView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake((kScreenW*0.8*0.1)/2, (kScreenH*0.6*0.09)/2, kScreenW*0.8*0.9, kScreenH*0.6*0.3)];
    _textView.delegate=self;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    _textView.textColor = [UIColor lightGrayColor];
    [_goodsView addSubview:_textView];
    
    [self setupPlaceHolder];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW*0.8*0.1)/2, kScreenH*0.6*0.33, kScreenW*0.8*0.9, kScreenH*0.6*0.1)];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = NSLocalizedString(@"GlobalBuyer_Home_maskView_prompt", nil);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = kScreenW*0.8*0.91;
    [_goodsView addSubview:label];
    
    _pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((kScreenW*0.8*0.1)/2, kScreenH*0.6*0.43, kScreenW*0.8*0.9, kScreenH*0.6*0.3)];
    pageController.tag = 999;
    _pageScrollView.contentSize = CGSizeMake(kScreenW*0.8*0.9*3, kScreenH*0.6*0.3);
    _pageScrollView.delegate = self;
    _pageScrollView.pagingEnabled = YES;
    [_goodsView addSubview:_pageScrollView];
    _pageScrollView.showsVerticalScrollIndicator = FALSE;
    _pageScrollView.showsHorizontalScrollIndicator = FALSE;
    
    [_pageScrollView addSubview:[self subViewPage:1]];
    [_pageScrollView addSubview:[self subViewPage:2]];
    [_pageScrollView addSubview:[self subViewPage:3]];
    
    pageController = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenW*0.8*0.1)/2, kScreenH*0.6*0.73, kScreenW*0.8*0.9, kScreenH*0.6*0.05)];
    pageController.numberOfPages=3;
    pageController.currentPage=0;
    pageController.currentPageIndicatorTintColor = Main_Color;
    pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_goodsView addSubview:pageController];
    
    UIButton * goodsBtn = [[UIButton alloc]initWithFrame:CGRectMake(_textView.mj_x, kScreenH*0.6*0.8, kScreenW*0.8*0.9, kScreenH*0.6*0.15)];

    CAGradientLayer *layerG = [CAGradientLayer new];

    layerG.colors=@[(__bridge id)[UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1].CGColor];

    layerG.startPoint = CGPointMake(0, 0.5);
    layerG.endPoint = CGPointMake(1, 0.5);
    layerG.frame = goodsBtn.bounds;
    [goodsBtn.layer addSublayer:layerG];
    [goodsBtn setTitle:NSLocalizedString(@"GlobalBuyer_Home_HeaderView_LookingGoods", nil) forState:UIControlStateNormal];
    goodsBtn.layer.masksToBounds=YES;
    goodsBtn.layer.cornerRadius = 28.0;
    [goodsBtn addTarget:self action:@selector(goodsBtn) forControlEvents:UIControlEventTouchUpInside];
    [_goodsView addSubview:goodsBtn];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW*0.85/2, kScreenH*0.78+20, kScreenW*0.15, kScreenW*0.15)];
    [cancelBtn setImage:[UIImage imageNamed:@"ic_dialog_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_maskView addSubview:cancelBtn];
    _maskView.hidden=YES;
}
- (UIView *)subViewPage:(NSInteger)page{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*0.8*0.9*(page-1), 0, kScreenW*0.8*0.9, kScreenH*0.6*0.3)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW*0.8*0.9, kScreenH*0.6*0.3*0.3)];
    NSString * labelName = [NSString stringWithFormat:@"GlobalBuyer_Home_ScrollView_labelName%ld",(long)page];
    label.text = NSLocalizedString(labelName, nil);
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH*0.6*0.3*0.3, kScreenW*0.8*0.9, kScreenH*0.6*0.3*0.7)];
    NSString * imageName = [NSString stringWithFormat:@"GlobalBuyer_Home_ScrollView_imageName%ld",(long)page];
    imageView.image = [UIImage imageNamed:NSLocalizedString(imageName, nil)];
    [view addSubview:imageView];
    return view;
}
// 给textView添加一个UILabel子控件
- (void)setupPlaceHolder
{
    UILabel *placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 150, 50)];
    self.placeHolder = placeHolder;
    
    placeHolder.text = NSLocalizedString(@"GlobalBuyer_Home_maskView_placeHolder", nil);
    placeHolder.textColor = [UIColor lightGrayColor];
    placeHolder.numberOfLines = 0;
    placeHolder.contentMode = UIViewContentModeTop;
    [self.textView addSubview:placeHolder];
}
//取消按钮
- (void)cancelBtn{
    _maskView.hidden = YES;
    _textView.text = @"";
    self.placeHolder.alpha = 1;
}
//找商品按钮
- (void)goodsBtn{
    if (_textView.text != nil) {
        NSString *textStr = self.textView.text;
        NSString *linkStr = @"";
        NSArray *textArr = [textStr componentsSeparatedByString:@" "];
        for (NSString *subStr in textArr) {
            if ([subStr containsString:@"https://"]) {
                linkStr = subStr;
            }
        }
        if (linkStr.length) {
            [self judgeWebUrl:linkStr];
        }
        
    }
    _textView.text = @"";
    self.placeHolder.alpha = 1;
    _maskView.hidden = YES;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
}
//判断网站是否开发
- (void)judgeWebUrl:(NSString *)URL{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"link"] = URL;
    
    [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {//已开发
            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
            shopDetailVC.link = URL;
            shopDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopDetailVC animated:YES];
//            return;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"您找的商品不存在";
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, 180.f);
                [hud hideAnimated:YES afterDelay:2.f];
            });
        }
        
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//判断剪切板内容
- (void)JudgeClipboardC{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSLog(@"剪贴板%@",pasteboard.URL);
    if (pasteboard.URL != nil) {
        _maskView.hidden=NO;
        self.placeHolder.alpha = 0;
        _textView.text = [NSString stringWithFormat:@"%@",pasteboard.URL];
    }
}
//处理ebay数据
- (NSMutableDictionary *)ebayData:(NSDictionary *)dic{
    NSString * url1 = @"http://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_ff3=2&pub=5575490065&toolid=10001&campid=5338507482&customid=1&icep_item=";
    NSString * url2 = @"&ipn=psmain&icep_vectorid=229466&kwid=902099&mtid=824&kw=lg";
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@:%@",key,obj);
        if ([key isEqualToString:@"good_link"]) {
            NSArray *array = [obj componentsSeparatedByString:@"?"];
            if (array.count<=1) {
                [dict setObject:obj forKey:key];
            }else{
                NSArray *arr = [array[0] componentsSeparatedByString:@"/"];
                NSInteger i = arr.count;
                NSString * str = [NSString stringWithFormat:@"%@%@%@",url1,arr[i-1],url2];
                [dict setObject:str forKey:key];
            }
        }else{
            [dict setObject:obj forKey:key];
        }
    }];
    return dict;
}
#pragma mark 下载汇率数据
- (void)downloadMoneytype {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:moneyTypeApi parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.reteDic = [[NSDictionary alloc]init];
        self.reteDic = responseObject[@"data"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)requestEbayKeyWords{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager GET:@"http://buy.dayanghang.net/app/ebayKeys.txt" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ebay关键词 %@",responseObject);
        NSArray * arr = [responseObject objectForKey:@"keys"];
        int x = arc4random() % arr.count;
        self.ebayKey = arr[x];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
    }];
}

- (void)downExternalJDDataPage:(NSInteger)page isDown:(BOOL)down{
    
//    self.animationBackV.hidden = NO;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml",@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *time = [self getCurrentTimes];
    

    NSString *mdStr = [NSString stringWithFormat:@"cf2109bc3d254ecba1a1a0b823b78bd1360buy_param_json{\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%ld,\"pageSize\":100},\"orderField\":0}access_token031e8a1b04c545a6bc033929f200873amxztapp_key398230142d607c53011684710b966978methodjd.kpl.open.xuanpin.searchgoodstimestamp%@v1.0cf2109bc3d254ecba1a1a0b823b78bd1",self.ebayKey,self.page,time];
    
    NSLog(@"mdStr============>%@",mdStr);

    
    NSString *url = [NSString stringWithFormat:@"https://api.jd.com/routerjson?access_token=031e8a1b04c545a6bc033929f200873amxzt&app_key=398230142d607c53011684710b966978&method=jd.kpl.open.xuanpin.searchgoods&v=1.0&timestamp=%@&360buy_param_json={\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%ld,\"pageSize\":100},\"orderField\":0}&sign=%@",time,self.ebayKey,self.page,[self md5:mdStr].uppercaseString];
    
    
    NSLog(@"url============>%@",url);
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:@"" progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //获得的json先转换成字符串
                NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                //字符串再生成NSData
                NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];

                //再解析
                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];


                NSMutableArray * jdArr = [[NSMutableArray alloc]init];
                NSArray *tmpArr = dicData[@"jd_kpl_open_xuanpin_searchgoods_responce"][@"searchgoodsResult"][@"result"][@"queryVo"];
                NSLog(@"tmpArr====>%@",tmpArr);
                NSLog(@"tmpArr.count====>%ld",tmpArr.count);
                
                if (tmpArr==nil ||tmpArr.count == 0) {
                }else{
                 
                    for (int i = 0 ; i < tmpArr.count ; i++) {
                        NSDictionary *dic = tmpArr[i];
                        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                        tmpDict[@"good_site"] = @"miao";
                        tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",dic[@"wareName"]];
                        tmpDict[@"good_link"] = [NSString stringWithFormat:@"https://item.m.jd.com/product/%@.html",dic[@"skuId"]];//https://item.m.jd.com/product/662188.html
                        tmpDict[@"good_pic"] = [NSString stringWithFormat:@"https://m.360buyimg.com/mobilecms/%@",dic[@"imageUrl"]];//https://m.360buyimg.com/mobilecms/jfs/t1/88307/5/16848/82493/5e7f0720E47dae41a/e1f4e04ad674b432.jpg
        //                NSLog(@"ebay图片地址%@",);
                        tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",dic[@"price"]];
                        tmpDict[@"good_currency"] = @"CNY";
                        [jdArr addObject:tmpDict];
                    }
                }
        if (self.goodArr.count == 0) {
            for (int i = 0 ; i < jdArr.count; i++) {
                if (![self.goodArr containsObject:jdArr[i]]) {
                    [self.goodArr addObject:jdArr[i]];
                }


            }
        }else{
            for (int i = 0 ; i < jdArr.count; i++) {
                if (![self.goodArr containsObject:jdArr[i]]) {
                    [self.goodArr insertObject:jdArr[i] atIndex:arc4random()%self.goodArr.count];
                }
            }
        }
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self.collectionView.mj_footer endRefreshing];

        [self.collectionView reloadData];
//        [self downExternalNewRakutenAccPage];
    }];
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}



//请求ebay商品
- (void)requestEbayGoods:(NSInteger)page isDown:(BOOL)down{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSLog(@"ebay字段：%@",self.ebayKey);
    if (self.ebayKey == nil) {
        self.ebayKey = @"fashion";
    }
    NSDictionary *params = @{@"paginationInput.pageNumber":[NSString stringWithFormat:@"%ld",(long)page],
                             @"keywords":self.ebayKey
                             };
    [manager GET:@"https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.9.0&SECURITY-APPNAME=-0-PRD-0ea9e4abd-faed9a4b&outputSelector=SellerInfo&affiliate.networkId=9&affiliate.trackingId=5338507482&affiliate.customId=1&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=100&itemFilter(0).name=Currency&itemFilter(0).value=USD&itemFilter(1).name=HideDuplicateItems&itemFilter(1).value=true&itemFilter(2).name=GetItFastOnly&itemFilter(2).value=true" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * ebayArr = [[NSMutableArray alloc]init];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"@count"]] isEqualToString:@"0"]) {
        }else{
            NSArray *tmpArr = responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"];
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"ebay";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"title"][0]];
                tmpDict[@"good_link"] = [[NSString stringWithFormat:@"https://www.ebay.com/itm/%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"viewItemURL"][0]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                tmpDict[@"good_pic"] = [[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"galleryURL"][0]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//                NSLog(@"ebay图片地址%@",);
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"sellingStatus"][0][@"currentPrice"][0][@"__value__"]];
                tmpDict[@"good_currency"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"sellingStatus"][0][@"currentPrice"][0][@"@currencyId"]];
                [ebayArr addObject:tmpDict];
            }
        }
        if (self.goodArr.count == 0) {
            for (int i = 0 ; i < ebayArr.count; i++) {
                if (![self.goodArr containsObject:ebayArr[i]]) {
                    [self.goodArr addObject:ebayArr[i]];
                }


            }
        }else{
            for (int i = 0 ; i < ebayArr.count; i++) {
                if (![self.goodArr containsObject:ebayArr[i]]) {
                    [self.goodArr insertObject:ebayArr[i] atIndex:arc4random()%self.goodArr.count];
                }
            }
        }
        [self downExternalJDDataPage:self.page isDown:down];
        if (down) {
            [FileArchiver writeFileArchiver:@"homegoodArr" withArray:self.goodArr];
            [self downDiscountData];
        }
        self.page++;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self downExternalJDDataPage:self.page isDown:down];
        self.page++;
//        [self.collectionView.mj_header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 首页gif动画
 */
- (advertising *)aView{
    if (!_aView) {
        UIWindow * window = [UIApplication sharedApplication].windows[0];
        _aView = [advertising setadvertising:window];
    }
    return _aView;
}
- (void)requestGif{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://bms.shaogood.com/api/app/show_pic" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"wotada"][@"state"] intValue] == 1) {
            FLAnimatedImage *image=  [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:responseObject[@"wotada"][@"picPath"]]]];
            self.aView.imageView.animatedImage = image;
            
        [self.aView showAdvertising];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
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
