//
//  PurseRechargeViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/6.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "PurseRechargeViewController.h"
#import "FillInTheAmountViewController.h"
#import "PayViewController.h"

@interface PurseRechargeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *payTypeDataSource;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSString *currentPayCurrency;
@property (nonatomic, strong)NSString *pay_menthod;
@property (nonatomic, strong)NSString *pay_type;

@end

@implementation PurseRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self downPayType];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GlobalBuyer_PayView_choespaytype", nil);
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)payTypeDataSource
{
    if (_payTypeDataSource == nil) {
        _payTypeDataSource = [[NSMutableArray alloc]init];
    }
    return _payTypeDataSource;
}

- (void)downPayType
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
    self.hud.label.text= NSLocalizedString(@"GlobalBuyer_Loading", nil);
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *param = [NSDictionary new];
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
    
    param = @{@"api_id":API_ID,
              @"api_token":TOKEN,
              @"secret_key":userToken,
              @"payClient":@"app",
              @"locale":language,
              @"payUsed":@"wallet"};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetPayMentListApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.payTypeDataSource removeAllObjects];
            NSArray *payTypeTmpArr = responseObject[@"data"];
            self.payTypeDataSource = [NSMutableArray arrayWithArray:payTypeTmpArr];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
    }
    return _tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.payTypeDataSource.count;
}

- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.payTypeDataSource[section][@"pay_method"]isEqualToString:@"Spgateway"]) {
        return NSLocalizedString(@"GlobalBuyer_PayView_taiwan", nil);
    }
    if ([self.payTypeDataSource[section][@"pay_method"]isEqualToString:@"MoneySwapAppNew"]) {
        return NSLocalizedString(@"GlobalBuyer_PayView_dalu", nil);
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payTypeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payTypeCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.payTypeDataSource[indexPath.section][@"pay_name"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.pay_menthod = self.payTypeDataSource[indexPath.section][@"pay_method"];
    self.pay_type = self.payTypeDataSource[indexPath.section][@"pay_type"];
    
    if ([self.pay_menthod isEqualToString:@"Spgateway"]) {
        self.currentPayCurrency = @"TWD";
    }
    
    if ([self.pay_menthod isEqualToString:@"MoneySwapApp"]) {
        self.currentPayCurrency = @"CNY";
    }

    
    FillInTheAmountViewController *fillInTheAmountVC = [[FillInTheAmountViewController alloc]init];
    fillInTheAmountVC.title = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
    fillInTheAmountVC.backVTitleStr = NSLocalizedString(@"GlobalBuyer_My_Wallet_EnterTheAmount", nil);
    fillInTheAmountVC.revaluedCurrencyStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_CurrentCurrency", nil),self.currentPayCurrency];

    fillInTheAmountVC.currency = self.currentPayCurrency;
    fillInTheAmountVC.pay_menthod = self.pay_menthod;
    fillInTheAmountVC.pay_type = self.pay_type;
    [self.navigationController pushViewController:fillInTheAmountVC animated:YES];
    
    
//    NSString *urlString ;
//    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
//    urlString = [NSString stringWithFormat:PurseRechargeApi,API_ID,TOKEN,userToken,self.amount,self.currentPayCurrency,self.pay_menthod,self.pay_type];
//
//    PayViewController *payVC = [[PayViewController alloc]init];
//    payVC.urlString = urlString;
//    payVC.shopCartVC = self;
//    [self.navigationController pushViewController:payVC animated:YES];
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
