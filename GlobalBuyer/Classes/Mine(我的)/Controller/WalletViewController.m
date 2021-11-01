//
//  WalletViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/5.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletTableViewCell.h"
#import "PurseRechargeViewController.h"
#import "PasswordViewSuper.h"
#import "RefundFillInTheAmountViewController.h"

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource,PasswordViewSuperDelegate>

@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UILabel *titleTotalNumLb;//余额标题
@property (nonatomic,strong)UILabel *totalNumLb;//余额数字
@property (nonatomic,strong)NSString *currencyOfTheBalance;

@property (nonatomic,strong)NSMutableArray *walletLogDataSource;//所有记录
@property (nonatomic,strong)NSMutableArray *incomeLogDataSource;//充值记录
@property (nonatomic,strong)NSMutableArray *expensesLogDataSource;//消费记录

@property (nonatomic,strong)NSString *currentQuery;
@property (nonatomic,strong)UILabel *currentQueryLb;

@property (nonatomic,assign)NSInteger pwdNum;
@property (nonatomic,strong)NSString *purseState;

@property (nonatomic,strong)NSString *firstPwd;
@property (nonatomic,strong)NSString *secondPwd;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)UIButton *getVerificationCodeBtn;
@property (nonatomic,strong)UITextField *verificationCodeTf;
@property (nonatomic,assign) int countDownNum;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pwdNum = 0;
    [self createUI];
    [self downData];
}

- (void)downData
{
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:WalletRecordApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            if ([responseObject[@"data"][@"walletLog"] count] != 0) {
                
                [self.walletLogDataSource removeAllObjects];
                [self.incomeLogDataSource removeAllObjects];
                [self.expensesLogDataSource removeAllObjects];
                
                NSArray *walletLogArr = responseObject[@"data"][@"walletLog"];
                self.walletLogDataSource = [NSMutableArray arrayWithArray:walletLogArr];
                NSArray *incomeLogArr = responseObject[@"data"][@"incomeLog"];
                self.incomeLogDataSource = [NSMutableArray arrayWithArray:incomeLogArr];
                NSArray *expensesLogArr = responseObject[@"data"][@"expensesLog"];
                self.expensesLogDataSource = [NSMutableArray arrayWithArray:expensesLogArr];
                self.totalNumLb.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"walletAmount"] floatValue]];
                self.titleTotalNumLb.text = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),responseObject[@"data"][@"currency"]];
                self.currencyOfTheBalance = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"currency"]];
                self.currentQuery = @"walletLog";
                
                [self.tableView reloadData];
            }
            
            self.purseState = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"sign"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (NSMutableArray *)walletLogDataSource
{
    if (_walletLogDataSource == nil) {
        _walletLogDataSource = [[NSMutableArray alloc]init];
    }
    return _walletLogDataSource;
}

- (NSMutableArray *)incomeLogDataSource
{
    if (_incomeLogDataSource == nil) {
        _incomeLogDataSource = [[NSMutableArray alloc]init];
    }
    return _incomeLogDataSource;
}

- (NSMutableArray *)expensesLogDataSource
{
    if (_expensesLogDataSource == nil) {
        _expensesLogDataSource = [[NSMutableArray alloc]init];
    }
    return _expensesLogDataSource;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GlobalBuyer_My_Wallet", nil);
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_changePW", nil) style:UIBarButtonItemStylePlain target:self action:@selector(modifyThePassword)];
}

//密码修改
- (void)modifyThePassword
{
    if ([self.purseState isEqualToString:@"notActive"] || [self.purseState isEqualToString:@"pwdNotSet"]) {//未设置密码
        
        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
        passwordVS.delegate = self;
        passwordVS.setOrEnter = @"set";
        [passwordVS show];
        
        return;
    }

    PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_REPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_SendCode", nil) AlertAmount:@""];
    passwordVS.delegate = self;
    passwordVS.setOrEnter = @"reSet";
    [passwordVS show];
    self.verificationCodeTf = [[UITextField alloc]initWithFrame:CGRectMake(20, passwordVS.bg_view.frame.size.height/2 + 30,140 , 30)];
    self.verificationCodeTf.layer.borderWidth = 0.7;
    self.verificationCodeTf.layer.borderColor = Main_Color.CGColor;
    self.verificationCodeTf.placeholder = NSLocalizedString(@"GlobalBuyer_LoginView_InputVerificationCode", nil);
    [passwordVS.bg_view addSubview:self.verificationCodeTf];
    
    self.getVerificationCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(passwordVS.bg_view.frame.size.width - 100, passwordVS.bg_view.frame.size.height/2 + 30, 80, 30)];
    self.getVerificationCodeBtn.backgroundColor = Main_Color;
    self.getVerificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.getVerificationCodeBtn setTitle:NSLocalizedString(@"GlobalBuyer_LoginView_GetVerificationCode", nil) forState:UIControlStateNormal];
    [passwordVS.bg_view addSubview:self.getVerificationCodeBtn];
    [self.getVerificationCodeBtn addTarget:self action:@selector(getVerificationCodeClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getVerificationCodeClick
{
    if (self.getVerificationCodeBtn.selected == YES) {
        return;
    }
    
    
    self.countDownNum = 60;
    self.getVerificationCodeBtn.selected = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDownSixty) userInfo:nil repeats:YES];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    
    [manager POST:WalletVerificationCodeApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_RepeatedAcquisition", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)CountDownSixty
{
    [self.getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%ds",self.countDownNum] forState:UIControlStateSelected];
    
    if (self.countDownNum <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.getVerificationCodeBtn.selected = NO;
    }
    
    self.countDownNum--;
}


- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
        _titleView.backgroundColor = Main_Color;
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, 10, 1, 80)];
        lineV.backgroundColor = [UIColor whiteColor];
        [_titleView addSubview:lineV];
        
        self.titleTotalNumLb = [[UILabel alloc]initWithFrame:CGRectMake(0,22, kScreenW/2, 20)];
        self.titleTotalNumLb.textAlignment = NSTextAlignmentCenter;
        self.titleTotalNumLb.textColor = [UIColor whiteColor];
        self.titleTotalNumLb.font = [UIFont systemFontOfSize:18];
        self.titleTotalNumLb.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil);
        [_titleView addSubview:self.titleTotalNumLb];
        
        self.totalNumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kScreenW/2, 55)];
        self.totalNumLb.textAlignment = NSTextAlignmentCenter;
        self.totalNumLb.textColor = [UIColor whiteColor];
        self.totalNumLb.font = [UIFont systemFontOfSize:26];
        self.totalNumLb.text = @"0";
        [_titleView addSubview:self.totalNumLb];
        
        
        UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 + (kScreenW/2 - 70)/2, 20, 70, 25)];
        rechargeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        rechargeBtn.layer.cornerRadius = 5;
        rechargeBtn.layer.borderWidth = 0.5;
        [rechargeBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil) forState:UIControlStateNormal];
        [_titleView addSubview:rechargeBtn];
        [rechargeBtn addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *refundBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 + (kScreenW/2 - 70)/2, 55, 70, 25)];
        refundBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        refundBtn.layer.cornerRadius = 5;
        refundBtn.layer.borderWidth = 0.5;
        [refundBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Refund", nil) forState:UIControlStateNormal];
        [_titleView addSubview:refundBtn];
        [refundBtn addTarget:self action:@selector(refundClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _titleView;
}

//退款
- (void)refundClick
{
    
    if ([self.purseState isEqualToString:@"notActive"] || [self.purseState isEqualToString:@"pwdNotSet"]) {//未设置密码
        
        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
        passwordVS.delegate = self;
        passwordVS.setOrEnter = @"set";
        [passwordVS show];
        
        return;
    }
    
    RefundFillInTheAmountViewController *refundFillInTheAmountVC = [[RefundFillInTheAmountViewController alloc]init];
    refundFillInTheAmountVC.title = NSLocalizedString(@"GlobalBuyer_My_Wallet_RefundApplication", nil);
    refundFillInTheAmountVC.backVTitleStr = NSLocalizedString(@"GlobalBuyer_My_Wallet_EnterTheAmountOfTheRefund", nil);
    refundFillInTheAmountVC.revaluedCurrencyStr = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil),self.currencyOfTheBalance];
    refundFillInTheAmountVC.currency = self.currencyOfTheBalance;
    [self.navigationController pushViewController:refundFillInTheAmountVC animated:YES];
}


//充值
- (void)rechargeClick
{
    if ([self.purseState isEqualToString:@"notActive"] || [self.purseState isEqualToString:@"pwdNotSet"]) {//未设置密码
        
        PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_NOSetPWD", nil) AlertAmount:@""];
        passwordVS.delegate = self;
        passwordVS.setOrEnter = @"set";
        [passwordVS show];
        
        return;
    }
    
    PurseRechargeViewController *purseRechargeVC = [[PurseRechargeViewController alloc]init];
    purseRechargeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:purseRechargeVC animated:YES];
}

- (void)didEnterPWD:(NSString *)pwd withType:(NSString *)type
{
    if ([type isEqualToString:@"reSet"]) {
        if (![self.verificationCodeTf.text isEqualToString:@""]) {
            [self reSetPWD:pwd verificationCode:self.verificationCodeTf.text];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_InputVerificationCode", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    if ([type isEqualToString:@"set"]) {
        
        if (self.pwdNum == 0) {
            self.firstPwd = pwd;
            PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_SetPWD", nil) AlertMessageTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_AgainSetPWD", nil) AlertAmount:@""];
            passwordVS.delegate = self;
            passwordVS.setOrEnter = @"set";
            [passwordVS show];
        }
        
        if (self.pwdNum == 1) {
            self.secondPwd = pwd;
            if ([self.firstPwd isEqualToString:self.secondPwd]) {
                
                [self setPWD:pwd];
                
            }else{
                MSAlertController *alertController = [MSAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: NSLocalizedString(@"GlobalBuyer_UserInfo_PWdif", nil) preferredStyle:MSAlertControllerStyleAlert];
                MSAlertAction *action = [MSAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
                }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            self.pwdNum = 0;
            return;
        }
        
        self.pwdNum++;
    }
}

- (void)reSetPWD:(NSString *)pwd verificationCode:(NSString *)verificationCode
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *param = [NSDictionary new];
    param = @{@"api_id":API_ID,
              @"api_token":TOKEN,
              @"secret_key":userToken,
              @"code":verificationCode,
              @"password":pwd};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:WalletResetPWDApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"message"];
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"message"];
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:1.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
            self.purseState = @"isSet";
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


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 80;
        _tableView.sectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableHeaderView = self.titleView;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.currentQuery isEqualToString:@"walletLog"]) {
        return self.walletLogDataSource.count;
    }else if ([self.currentQuery isEqualToString:@"incomeLog"]){
        return self.incomeLogDataSource.count;
    }else if ([self.currentQuery isEqualToString:@"expensesLog"]){
        return self.expensesLogDataSource.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableViewSectionHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    
    self.currentQueryLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    self.currentQueryLb.font = [UIFont systemFontOfSize:12];
    if ([self.currentQuery isEqualToString:@"walletLog"]) {
        self.currentQueryLb.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Allrecords", nil);
    }else if ([self.currentQuery isEqualToString:@"incomeLog"]){
        self.currentQueryLb.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Rechargerecord", nil);
    }else if ([self.currentQuery isEqualToString:@"expensesLog"]){
        self.currentQueryLb.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recordsofconsumption", nil);
    }
    [tableViewSectionHeaderV addSubview:self.currentQueryLb];
    
    UIButton *rechargeRecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 10, 80, 20)];
    [rechargeRecordBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Rechargerecord", nil) forState:UIControlStateNormal];
    [rechargeRecordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rechargeRecordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    rechargeRecordBtn.layer.cornerRadius = 10;
    rechargeRecordBtn.layer.borderWidth = 0.7;
    rechargeRecordBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [tableViewSectionHeaderV addSubview:rechargeRecordBtn];
    [rechargeRecordBtn addTarget:self action:@selector(rechargeRecordClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordsOfConsumptionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 200, 10, 80, 20)];
    [recordsOfConsumptionBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Recordsofconsumption", nil) forState:UIControlStateNormal];
    [recordsOfConsumptionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    recordsOfConsumptionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    recordsOfConsumptionBtn.layer.cornerRadius = 10;
    recordsOfConsumptionBtn.layer.borderWidth = 0.7;
    recordsOfConsumptionBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [tableViewSectionHeaderV addSubview:recordsOfConsumptionBtn];
    [recordsOfConsumptionBtn addTarget:self action:@selector(recordsOfConsumptionClick) forControlEvents:UIControlEventTouchUpInside];
    
    return tableViewSectionHeaderV;
}

- (void)rechargeRecordClick
{
    self.currentQuery = @"incomeLog";
    [self.tableView reloadData];
}

- (void)recordsOfConsumptionClick
{
    self.currentQuery = @"expensesLog";
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletCell"];
    if (cell == nil) {
        cell = [[WalletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WalletCell"];
    }
    
    
    
    if ([self.currentQuery isEqualToString:@"walletLog"]) {//全部记录
        
        
        cell.balanceLb.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),[self.walletLogDataSource[indexPath.row][@"after_amount"] floatValue]];
        cell.dateLb.text = self.walletLogDataSource[indexPath.row][@"change_time"];
        
        if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"recharge"]) {//充值
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
            cell.userName.textColor = [UIColor redColor];
            cell.numIdLb.text = @"";
            cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];

            
        }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"order"]){//支付订单
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentorder", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.walletLogDataSource[indexPath.row][@"body"][@"payNum"]];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"package"]){//支付包裹
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentoffreight", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.walletLogDataSource[indexPath.row][@"body"][@"payNum"]];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund"]){//退款
            
            if ([self.walletLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_WAIT"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit", nil)];
            }
            
            if ([self.walletLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_COMPLETE"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Success", nil)];
            }
            
            if ([self.walletLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_FAIL"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil)];
            }
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Refund", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund-fail"]){
            cell.numIdLb.text = @"";
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil);
            cell.userName.textColor = [UIColor redColor];
            cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
        }
        
    }else if ([self.currentQuery isEqualToString:@"incomeLog"]){//收入记录
        
        cell.dateLb.text = self.incomeLogDataSource[indexPath.row][@"change_time"];
        cell.balanceLb.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),[self.incomeLogDataSource[indexPath.row][@"after_amount"] floatValue]];
        
        if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"recharge"]) {//充值
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
            cell.userName.textColor = [UIColor redColor];
            cell.numIdLb.text = @"";
            cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"order"]){//支付订单
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentorder", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.incomeLogDataSource[indexPath.row][@"body"][@"payNum"]];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"package"]){//支付包裹
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentoffreight", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.incomeLogDataSource[indexPath.row][@"body"][@"payNum"]];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund"]){//退款
            
            if ([self.incomeLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_WAIT"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit", nil)];
            }
            
            if ([self.incomeLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_COMPLETE"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Success", nil)];
            }
            
            if ([self.incomeLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_FAIL"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil)];
            }
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Refund", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
        }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund-fail"]){
            cell.numIdLb.text = @"";
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil);
            cell.userName.textColor = [UIColor redColor];
            cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
        }
        
    }else if ([self.currentQuery isEqualToString:@"expensesLog"]){//支出记录
        
        cell.dateLb.text = self.expensesLogDataSource[indexPath.row][@"change_time"];
        cell.balanceLb.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),[self.expensesLogDataSource[indexPath.row][@"after_amount"] floatValue]];
        
        if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"recharge"]) {//充值
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
            cell.userName.textColor = [UIColor redColor];
            cell.numIdLb.text = @"";
            cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"order"]){//支付订单
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentorder", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.expensesLogDataSource[indexPath.row][@"body"][@"payNum"]];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"package"]){//支付包裹
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentoffreight", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.expensesLogDataSource[indexPath.row][@"body"][@"payNum"]];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund"]){//退款
            
            
            if ([self.expensesLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_WAIT"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit", nil)];
            }
            
            if ([self.expensesLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_COMPLETE"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Success", nil)];
            }
            
            if ([self.expensesLogDataSource[indexPath.row][@"status"]isEqualToString:@"REFUND_REVIEW_FAIL"]) {
                cell.numIdLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus", nil),NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil)];
            }
            
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Refund", nil);
            cell.userName.textColor = [UIColor greenColor];
            cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
            
        }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund-fail"]){
            cell.numIdLb.text = @"";
            cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil);
            cell.userName.textColor = [UIColor redColor];
            cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
