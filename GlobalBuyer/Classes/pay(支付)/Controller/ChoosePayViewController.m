//
//  ChoosePayViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/8.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ChoosePayViewController.h"
#import "PayViewController.h"
#import "ChoosePayCell.h"
#import "ShopCartHeaderView.h"
#import "NoPayViewController.h"
#import "MineViewController.h"

#import "AllPayRequest.h"
#import "PayOrder.h"
#import "DateUtil.h"
#import "SignUtil.h"
#import "AllPaySDK.h"
#import "ImproveAccountInfoViewController.h"
#import "PasswordViewSuper.h"
#import "PaySuccessViewController.h"

@interface ChoosePayViewController ()<UITableViewDelegate,UITableViewDataSource,PasswordViewSuperDelegate>
@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)NSArray *paytypeName;
@property (nonatomic,strong)NSArray *paytype;
@property (nonatomic,strong)NSArray *paymethod;
@property (nonatomic,strong)NSMutableArray *payTypeArr;
@property (nonatomic,strong)NSMutableArray *elsePayTypeArr;
@property (nonatomic, strong)ShopCartHeaderView *shopCartHeaderView;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)MBProgressHUD *hud;

@property (nonatomic,assign)BOOL downLoading;

@property (nonatomic, strong)NSString *walletPayNum;
@property (nonatomic, strong)NSString *walletPayCurrency;
@property (nonatomic, strong)NSString *walletPayAmount;

@end

@implementation ChoosePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isCreating == YES) {
        
    }else{
        
        [self createOder];
    }
    [self initData];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    [self.delegate Refresh];
}

- (NSMutableArray *)payTypeArr
{
    if (_payTypeArr == nil) {
        _payTypeArr = [NSMutableArray new];
    }
    return _payTypeArr;
}

- (NSMutableArray *)elsePayTypeArr
{
    if (_elsePayTypeArr == nil) {
        _elsePayTypeArr = [NSMutableArray new];
    }
    return _elsePayTypeArr;
}

- (void)createOder
{
    self.downLoading = YES;

    NSArray *arr1 = [self.idsStr componentsSeparatedByString:@"["];
    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"]"];
    NSArray *arr3 = [arr2[0] componentsSeparatedByString:@","];
    NSMutableArray *arr4 = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < arr3.count; i++) {
        [arr4 addObject:arr3[i]];
    }
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *param;
    if ([self.couponsCode length] > 0) {
        if ([self.invoiceYesOrNo isEqualToString:@"YES"]) {
            param = @{@"api_id":API_ID,
                      @"api_token":TOKEN,
                      @"secret_key":userToken,
                      @"productIds":arr4,
                      @"expressType":self.orderType,
                      @"addressId":[NSString stringWithFormat:@"%@",self.orderAddress],
                      @"confirm":self.isInspection,
                      @"discount":[NSString stringWithFormat:@"%@",self.couponsCode],
                      @"invoiceArray":self.invoiceDict
                      };
        }else{
            param = @{@"api_id":API_ID,
                      @"api_token":TOKEN,
                      @"secret_key":userToken,
                      @"productIds":arr4,
                      @"expressType":self.orderType,
                      @"addressId":[NSString stringWithFormat:@"%@",self.orderAddress],
                      @"confirm":self.isInspection,
                      @"discount":[NSString stringWithFormat:@"%@",self.couponsCode]
                      };
        }

    }else{
        if ([self.invoiceYesOrNo isEqualToString:@"YES"]) {
            param = @{@"api_id":API_ID,
                      @"api_token":TOKEN,
                      @"secret_key":userToken,
                      @"productIds":arr4,
                      @"expressType":self.orderType,
                      @"addressId":[NSString stringWithFormat:@"%@",self.orderAddress],
                      @"confirm":self.isInspection,
                      @"invoiceArray":self.invoiceDict};
        }else{
            param = @{@"api_id":API_ID,
                      @"api_token":TOKEN,
                      @"secret_key":userToken,
                      @"productIds":arr4,
                      @"expressType":self.orderType,
                      @"addressId":[NSString stringWithFormat:@"%@",self.orderAddress],
                      @"confirm":self.isInspection};
        }
    }
    NSLog(@"-----%@",arr4);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:CreateOrderApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.orderId = responseObject[@"data"][@"id"];
            self.orderStatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"review_status"]];
            self.downLoading = NO;
            [self.hud hideAnimated:YES];
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 创建UI界面
- (ShopCartHeaderView *)shopCartHeaderView {
    if (_shopCartHeaderView == nil) {
        _shopCartHeaderView = [[ShopCartHeaderView alloc]init];
        _shopCartHeaderView.frame =CGRectMake(0, 64, kScreenW, [_shopCartHeaderView getH]);
    }
    return _shopCartHeaderView;
}

- (void)initData{
    
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
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
    self.hud.label.text= NSLocalizedString(@"GlobalBuyer_Loading", nil);
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *param = [NSDictionary new];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (version.doubleValue <= 10.0) {
        param = @{@"api_id":API_ID,
                  @"api_token":TOKEN,
                  @"secret_key":userToken,
                  @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                  @"payClient":@"android",
                  @"locale":language};
    }else{
        param = @{@"api_id":API_ID,
                  @"api_token":TOKEN,
                  @"secret_key":userToken,
                  @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                  @"payClient":@"ios",
                  @"locale":language};
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetPayMentListApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.payTypeArr addObject:dict];
            }
        }else{

        }
        
        [self initElseData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    self.paytypeName = @[@[NSLocalizedString(@"GlobalBuyer_PayView_paytype_1", nil),NSLocalizedString(@"GlobalBuyer_PayView_paytype_2", nil)],@[NSLocalizedString(@"GlobalBuyer_PayView_paytype_3", nil),NSLocalizedString(@"GlobalBuyer_PayView_paytype_4", nil)]];
//    self.paytypeName = @[@[NSLocalizedString(@"GlobalBuyer_PayView_paytype_1", nil)],@[NSLocalizedString(@"GlobalBuyer_PayView_paytype_4", nil)]];
//    self.paytype =  @[@[@"CREDIT",@"CVS"],@[@"APMP",@"UP"]];
//    self.paytype =  @[@[@"CREDIT"],@[@"UP"]];
//    self.paymethod = @[@[@"Spgateway"],@[@"MoneySwapApp"]];
}

- (void)initElseData
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
    
    NSDictionary *param = [NSDictionary new];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if (version.doubleValue <= 10.0) {
        param = @{@"api_id":API_ID,
                  @"api_token":TOKEN,
                  @"payClient":@"android",
                  @"locale":language};
    }else{
        param = @{@"api_id":API_ID,
                  @"api_token":TOKEN,
                  @"payClient":@"ios",
                  @"locale":language};
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:GetPayMentListApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success");
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.elsePayTypeArr addObject:dict];
            }
            
            for (int i = 0; i < self.payTypeArr.count; i++) {
                [self.elsePayTypeArr removeObject:self.payTypeArr[i]];
            }
        }else{
            
        }
        NSLog(@"1111%d",self.isCreating);
        if (self.isCreating == YES){
            [self.hud hideAnimated:YES];
        }
        [self.hud hideAnimated:YES];
        [self.tabelView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
    }];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_PayView_choespaytype", nil);
    [self.view addSubview:self.tabelView];
    [self setNavigationBackBtn];

}

- (void)setNavigationBackBtn
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_mine"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}

- (void)backClick {
    if (![self.type isEqualToString:@"auditStatus"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsPushNoPayView"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
  
}

- (UITableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH)) style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.rowHeight = 60;
//        _tabelView.tableHeaderView = self.shopCartHeaderView;
    }
    return _tabelView;
}

//改了
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.payTypeArr.count;
    }else{
        return self.elsePayTypeArr.count;
    }
    
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    
    if (section == 0) {
        return NSLocalizedString(@"GlobalBuyer_PayView_choespaytype", nil);
    }else{
        return NSLocalizedString(@"GlobalBuyer_PayView_otherpaytype", nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ChoosePayCell *cell = TableViewCellDequeueInit(NSStringFromClass([ChoosePayCell class]));
//    
//    TableViewCellDequeueXIB(cell, ChoosePayCell);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payTypeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payTypeCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.payTypeArr[indexPath.row][@"pay_name"];
        
        if ([self.payTypeArr[indexPath.row][@"pay_type"]isEqualToString:@"APP"] ) {
            UIImageView *applePayIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 85, 10, 75, 40)];
            applePayIv.image = [UIImage imageNamed:@"ApplePayIcon.jpg"];
            [cell addSubview:applePayIv];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = self.elsePayTypeArr[indexPath.row][@"pay_name"];
        
        if ([self.elsePayTypeArr[indexPath.row][@"pay_type"]isEqualToString:@"APP"] ) {
            UIImageView *applePayIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 85, 10, 75, 40)];
            applePayIv.image = [UIImage imageNamed:@"ApplePayIcon.jpg"];
            [cell addSubview:applePayIv];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.downLoading == YES) {
        return;
    }
    
    if ([self.orderStatus isEqualToString:@"ORDER_RECEIVE_WAIT"]) {
//        UIAlertView *orderAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_PayView_Audit", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//        [orderAlert show];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_PayView_Audit", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    
    NSString *userEmail = [[NSUserDefaults standardUserDefaults]objectForKey:@"USEREMAIL"];
    
    if (userEmail==nil||userEmail.length == 0) {
        ImproveAccountInfoViewController *vc = [[ImproveAccountInfoViewController alloc]init];
        vc.isLogin = NO;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    
    
    [[BaiduMobStat defaultStat] logEvent:@"event8" eventLabel:@"[完成结算]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"完成結算" parameters:nil];
    if (indexPath.section == 0) {
        if (self.packageId == nil) {
            
        }else{
            
            if ([self.payTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"MoneySwapAppNew"]) {
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
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
                NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
                NSDictionary *param = @{@"api_id":API_ID,
                                        @"api_token":TOKEN,
                                        @"secret_key":userToken,
                                        @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                                        @"packageId":self.packageId,
                                        @"payMethod":self.payTypeArr[indexPath.row][@"pay_method"],
                                        @"payType":self.payTypeArr[indexPath.row][@"pay_type"]};
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager POST:GETTNPackagePayApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    
                    [self.hud hideAnimated:YES];
                    
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        
                        [AllPaySDK pay:responseObject[@"data"][@"tn"] mode:YES   scheme:@"com.dyh.globalBuyer"  ViewController:self  onResult: ^(NSDictionary *resultDic) {
                            
                            NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                            NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                            if ([dictMessage[@"state"]isEqualToString:@"success"]) {
                                PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                                vc.payType = self.type;
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }
                            if ([dictMessage[@"state"]isEqualToString:@"fail"]) {
//                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                [alert show];
                                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) preferredStyle:UIAlertControllerStyleAlert];
                                [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                                [self presentViewController:alertC animated:YES completion:nil];
                            }
                            
                        }];
                    }else{
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                        [alert show];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertC animated:YES completion:nil];
                    }
                    
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
                return;
            }
            
            if ([self.payTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"Wallet"]) {
                NSString *urlString ;
                NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
                NSString *paytype = self.payTypeArr[indexPath.row][@"pay_type"];
                NSString *payMed = self.payTypeArr[indexPath.row][@"pay_method"];
                urlString = [NSString stringWithFormat:PackagePayApi,API_ID,TOKEN,userToken,paytype,payMed,self.packageId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
                [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self.hud hideAnimated:YES];
                    
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        
                        self.walletPayNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"orderNo"]];
                        self.walletPayCurrency = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"currency"]];
                        self.walletPayAmount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"amount"]];
                        
                        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_LoginView_inputPW", nil) AlertMessageTitle:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil),self.walletPayCurrency] AlertAmount:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Order_Pay_TheAmount", nil),self.walletPayAmount]];
                        passwordVS.delegate = self;
                        passwordVS.setOrEnter = @"enter";
                        [passwordVS show];
                    }
                    
                    if ([responseObject[@"code"]isEqualToString:@"error"]) {
                        
                        if ([responseObject[@"sign"]isEqualToString:@"pwdNotSet"]) {//未设置密码
                            PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
                            passwordVS.delegate = self;
                            passwordVS.setOrEnter = @"set";
                            [passwordVS show];
                        }else if ([responseObject[@"sign"]isEqualToString:@"isBan"]) {//钱包被冻结
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                            [alert show];
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }else if ([responseObject[@"sign"]isEqualToString:@"notEnough"]){//余额不足
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                            [alert show];
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }
                        
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
                return;
            }
            

            
            NSString *urlString ;
            NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
            NSString *paytype = self.payTypeArr[indexPath.row][@"pay_type"];
            NSString *payMed = self.payTypeArr[indexPath.row][@"pay_method"];
            urlString = [NSString stringWithFormat:PackagePayApi,API_ID,TOKEN,userToken,paytype,payMed,self.packageId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
            
            PayViewController *payVC = [[PayViewController alloc]init];
            payVC.urlString = urlString;
            payVC.shopCartVC = self.shopCartVC;
            payVC.type = self.type;
            [self.navigationController pushViewController:payVC animated:YES];
            return;
        }
        
        
        if ([self.payTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"MoneySwapAppNew"]) {
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
            
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
            NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
            NSDictionary *param = @{@"api_id":API_ID,
                                    @"api_token":TOKEN,
                                    @"secret_key":userToken,
                                    @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                                    @"orderId":self.orderId,
                                    @"payMethod":self.payTypeArr[indexPath.row][@"pay_method"],
                                    @"payType":self.payTypeArr[indexPath.row][@"pay_type"]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager POST:GETTNSpgateWayPayApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                [self.hud hideAnimated:YES];
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    
                    [AllPaySDK pay:responseObject[@"data"][@"tn"] mode:YES   scheme:@"com.dyh.globalBuyer"  ViewController:self  onResult: ^(NSDictionary *resultDic) {
                        
                        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                        NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                        if ([dictMessage[@"state"]isEqualToString:@"success"]) {
                            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                            vc.payType = self.type;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }   
                        if ([dictMessage[@"state"]isEqualToString:@"fail"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alert show];
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }
                        
                    }];
                }else{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                    [alert show];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            return;
        }

        if ([self.payTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"Wallet"]) {
            NSString *urlString ;
            NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
            NSString *paytype = self.payTypeArr[indexPath.row][@"pay_type"];
            NSString *payMed = self.payTypeArr[indexPath.row][@"pay_method"];
            urlString = [NSString stringWithFormat:SpgateWayPayApi,API_ID,TOKEN,userToken,paytype,payMed,self.orderId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
            
            [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self.hud hideAnimated:YES];
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    
                    self.walletPayNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"orderNo"]];
                    self.walletPayCurrency = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"currency"]];
                    self.walletPayAmount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"amount"]];
                    
                    PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_LoginView_inputPW", nil) AlertMessageTitle:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil),self.walletPayCurrency] AlertAmount:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Order_Pay_TheAmount", nil),self.walletPayAmount]];
                    passwordVS.delegate = self;
                    passwordVS.setOrEnter = @"enter";
                    [passwordVS show];
                }
                
                if ([responseObject[@"code"]isEqualToString:@"error"]) {
                    
                    if ([responseObject[@"sign"]isEqualToString:@"pwdNotSet"]) {//未设置密码
                        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
                        passwordVS.delegate = self;
                        passwordVS.setOrEnter = @"set";
                        [passwordVS show];
                    }else if ([responseObject[@"sign"]isEqualToString:@"isBan"]) {//钱包被冻结
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                        [alert show];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) preferredStyle:UIAlertControllerStyleAlert];
                        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertC animated:YES completion:nil];
                    }else if ([responseObject[@"sign"]isEqualToString:@"notEnough"]){//余额不足
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                        [alert show];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) preferredStyle:UIAlertControllerStyleAlert];
                        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertC animated:YES completion:nil];
                    }
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            return;
        }

        
        NSString *urlString ;
        NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
        NSString *paytype = self.payTypeArr[indexPath.row][@"pay_type"];
        NSString *payMed = self.payTypeArr[indexPath.row][@"pay_method"];
        urlString = [NSString stringWithFormat:SpgateWayPayApi,API_ID,TOKEN,userToken,paytype,payMed,self.orderId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
        
        PayViewController *payVC = [[PayViewController alloc]init];
        payVC.urlString = urlString;
        payVC.shopCartVC = self.shopCartVC;
        payVC.type = self.type;
        [self.navigationController pushViewController:payVC animated:YES];
    }
    
    
    if (indexPath.section == 1) {
        if (self.packageId == nil) {

        }else{
            
            if ([self.elsePayTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"MoneySwapAppNew"]) {
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
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
                NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
                NSDictionary *param = @{@"api_id":API_ID,
                                        @"api_token":TOKEN,
                                        @"secret_key":userToken,
                                        @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                                        @"packageId":self.packageId,
                                        @"payMethod":self.elsePayTypeArr[indexPath.row][@"pay_method"],
                                        @"payType":self.elsePayTypeArr[indexPath.row][@"pay_type"]};
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager POST:GETTNPackagePayApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    
                    [self.hud hideAnimated:YES];
                    
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        
                        [AllPaySDK pay:responseObject[@"data"][@"tn"] mode:YES   scheme:@"com.dyh.globalBuyer"  ViewController:self  onResult: ^(NSDictionary *resultDic) {
                            
                            NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                            
                            NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                            if ([dictMessage[@"state"]isEqualToString:@"success"]) {
                                PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                                vc.payType = self.type;
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }
                            if ([dictMessage[@"state"]isEqualToString:@"fail"]) {
//                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                [alert show];
                                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) preferredStyle:UIAlertControllerStyleAlert];
                                [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                                [self presentViewController:alertC animated:YES completion:nil];
                            }
                            
                            
                        }];
                    }else{
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                        [alert show];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertC animated:YES completion:nil];
                    }
                    
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
                return;
            }
            
            if ([self.elsePayTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"Wallet"]) {
                NSString *urlString ;
                NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
                NSString *paytype = self.elsePayTypeArr[indexPath.row][@"pay_type"];
                NSString *payMed = self.elsePayTypeArr[indexPath.row][@"pay_method"];
                urlString = [NSString stringWithFormat:PackagePayApi,API_ID,TOKEN,userToken,paytype,payMed,self.packageId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
                [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self.hud hideAnimated:YES];
                    
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        
                        self.walletPayNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"orderNo"]];
                        self.walletPayCurrency = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"currency"]];
                        self.walletPayAmount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"amount"]];
                        
                        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_LoginView_inputPW", nil) AlertMessageTitle:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil),self.walletPayCurrency] AlertAmount:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Order_Pay_TheAmount", nil),self.walletPayAmount]];
                        passwordVS.delegate = self;
                        passwordVS.setOrEnter = @"enter";
                        [passwordVS show];
                    }
                    
                    if ([responseObject[@"code"]isEqualToString:@"error"]) {
                        
                        if ([responseObject[@"sign"]isEqualToString:@"pwdNotSet"]) {//未设置密码
                            PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
                            passwordVS.delegate = self;
                            passwordVS.setOrEnter = @"set";
                            [passwordVS show];
                        }else if ([responseObject[@"sign"]isEqualToString:@"isBan"]) {//钱包被冻结
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                            [alert show];
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }else if ([responseObject[@"sign"]isEqualToString:@"notEnough"]){//余额不足
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                            [alert show];
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }
                        
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
                return;
            }
            
            NSString *urlString ;
            NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
            NSString *paytype = self.elsePayTypeArr[indexPath.row][@"pay_type"];
            NSString *payMed = self.elsePayTypeArr[indexPath.row][@"pay_method"];
            urlString = [NSString stringWithFormat:PackagePayApi,API_ID,TOKEN,userToken,paytype,payMed,self.packageId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
            
            PayViewController *payVC = [[PayViewController alloc]init];
            payVC.urlString = urlString;
            payVC.shopCartVC = self.shopCartVC;
            payVC.type = self.type;
            [self.navigationController pushViewController:payVC animated:YES];
            return;
        }
        
        
        if ([self.elsePayTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"MoneySwapAppNew"]) {
        
            self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
            
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
            NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
            NSDictionary *param = @{@"api_id":API_ID,
                                    @"api_token":TOKEN,
                                    @"secret_key":userToken,
                                    @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                                    @"orderId":self.orderId,
                                    @"payMethod":self.elsePayTypeArr[indexPath.row][@"pay_method"],
                                    @"payType":self.elsePayTypeArr[indexPath.row][@"pay_type"]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager POST:GETTNSpgateWayPayApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                [self.hud hideAnimated:YES];
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    
                    [AllPaySDK pay:responseObject[@"data"][@"tn"] mode:YES   scheme:@"com.dyh.globalBuyer"  ViewController:self  onResult: ^(NSDictionary *resultDic) {
                        
                        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
                        NSDictionary *dictMessage = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                        if ([dictMessage[@"state"]isEqualToString:@"success"]) {
                            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                            vc.payType = self.type;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }
                        if ([dictMessage[@"state"]isEqualToString:@"fail"]) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alert show];
                            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_fail", nil) preferredStyle:UIAlertControllerStyleAlert];
                            [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                            [self presentViewController:alertC animated:YES completion:nil];
                        }
                        
                    }];
                }else{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                    [alert show];
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertC animated:YES completion:nil];
                }
                

                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self.hud hideAnimated:YES];
            }];
                    
            return;
        }
        
        if ([self.elsePayTypeArr[indexPath.row][@"pay_method"] isEqualToString:@"Wallet"]) {
            NSString *urlString ;
            NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
            NSString *paytype = self.elsePayTypeArr[indexPath.row][@"pay_type"];
            NSString *payMed = self.elsePayTypeArr[indexPath.row][@"pay_method"];
            urlString = [NSString stringWithFormat:SpgateWayPayApi,API_ID,TOKEN,userToken,paytype,payMed,self.orderId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
            
            [manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self.hud hideAnimated:YES];
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    
                    self.walletPayNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"orderNo"]];
                    self.walletPayCurrency = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"currency"]];
                    self.walletPayAmount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"amount"]];
                    
                    PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_LoginView_inputPW", nil) AlertMessageTitle:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil),self.walletPayCurrency] AlertAmount:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Order_Pay_TheAmount", nil),self.walletPayAmount]];
                    passwordVS.delegate = self;
                    passwordVS.setOrEnter = @"enter";
                    [passwordVS show];
                }
                
                if ([responseObject[@"code"]isEqualToString:@"error"]) {
                    
                    if ([responseObject[@"sign"]isEqualToString:@"pwdNotSet"]) {//未设置密码
                        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
                        passwordVS.delegate = self;
                        passwordVS.setOrEnter = @"set";
                        [passwordVS show];
                    }else if ([responseObject[@"sign"]isEqualToString:@"isBan"]) {//钱包被冻结
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                        [alert show];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_IsBan", nil) preferredStyle:UIAlertControllerStyleAlert];
                        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertC animated:YES completion:nil];
                    }else if ([responseObject[@"sign"]isEqualToString:@"notEnough"]){//余额不足
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                        [alert show];
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_NotEnough", nil) preferredStyle:UIAlertControllerStyleAlert];
                        [alertC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertC animated:YES completion:nil];
                    }
                    
                }
                
           
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            return;
        }
        
        NSString *urlString ;
        NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
        NSString *paytype = self.elsePayTypeArr[indexPath.row][@"pay_type"];
        NSString *payMed = self.elsePayTypeArr[indexPath.row][@"pay_method"];
        urlString = [NSString stringWithFormat:SpgateWayPayApi,API_ID,TOKEN,userToken,paytype,payMed,self.orderId,[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"]];
        
        PayViewController *payVC = [[PayViewController alloc]init];
        payVC.urlString = urlString;
        payVC.shopCartVC = self.shopCartVC;
        payVC.type = self.type;
        [self.navigationController pushViewController:payVC animated:YES];
    }
    


}

- (void)didEnterPWD:(NSString *)pwd withType:(NSString *)type
{
    if ([type isEqualToString:@"set"]) {
        [self setPWD:pwd];
    }
    
    if ([type isEqualToString:@"enter"]) {
        [self walletPayWithPWD:pwd];
    }
}

- (void)setPWD:(NSString *)pwd
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *param = [NSDictionary new];
    param = @{@"api_id":API_ID,
              @"api_token":TOKEN,
              @"secret_key":userToken,
              @"password":pwd};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:SetWalletPWDApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"message"];
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.5f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"message"];
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.5f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)walletPayWithPWD:(NSString *)pwd
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *param = [NSDictionary new];
    param = @{@"api_id":API_ID,
              @"api_token":TOKEN,
              @"secret_key":userToken,
              @"password":pwd,
              @"orderNo":[NSString stringWithFormat:@"%@",self.walletPayNum]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:WalletPayApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
            vc.payType = self.type;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"message"];
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.5f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
