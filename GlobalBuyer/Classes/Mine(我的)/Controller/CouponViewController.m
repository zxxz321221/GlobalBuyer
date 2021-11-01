//
//  CouponViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/4/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "CouponViewController.h"
#import "LoadingView.h"
#import "CouponCell.h"

@interface CouponViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSString *serviceCharge;

@property (nonatomic,strong)UIView *couponCodeV;
@property (nonatomic,strong)UITextField *couponCodeTF;
@property (nonatomic,strong)UIImageView *noCouponIv;
@property (nonatomic,strong)UILabel *noCouponLb;

@end

@implementation CouponViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self.loadingView startLoading];
    [self downData];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)downData
{
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
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"locale":language};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:AllCouponsApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.dataSource removeAllObjects];
            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
                if ([responseObject[@"data"][i][@"frozen"]isEqualToString:@"not_frozen"]) {
                    [self.dataSource addObject:responseObject[@"data"][i]];
                }

            }
            
            [self downLoadServiceCharge];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取服务费
- (void)downLoadServiceCharge
{
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"isoShort":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetServiceCharge parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.serviceCharge = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"service"] intValue]];
            
            [self.tableView reloadData];
            
        }
        [self.loadingView stopLoading];
        
        
        if (self.dataSource.count == 0) {
            
            self.noCouponIv.hidden = NO;
            self.noCouponLb.hidden = NO;
            
            
        }else{
            self.noCouponIv.hidden = YES;
            self.noCouponLb.hidden = YES;
        }
        
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//
//        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}

- (UIImageView *)noCouponIv
{
    if (_noCouponIv == nil) {
        _noCouponIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, kScreenH/2 - 50, 100, 100)];
        
        // 获得当前iPhone使用的语言
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            _noCouponIv.image = [UIImage imageNamed:@"无优惠券-J"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            _noCouponIv.image = [UIImage imageNamed:@"无优惠券-F"];
        }else if([currentLanguage isEqualToString:@"en"]){
            _noCouponIv.image = [UIImage imageNamed:@"无优惠券-E"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            _noCouponIv.image = [UIImage imageNamed:@"无优惠券-Ja"];
        }else{
            _noCouponIv.image = [UIImage imageNamed:@"无优惠券-J"];
        }
    }
    return _noCouponIv;
}

- (UILabel *)noCouponLb
{
    if (_noCouponLb == nil) {
        
        _noCouponLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 70, kScreenH/2 + 50 +20, 140, 40)];
        _noCouponLb.text = NSLocalizedString(@"GlobalBuyer_My_NoCoupons", nil);
        _noCouponLb.textAlignment = NSTextAlignmentCenter;
        _noCouponLb.font = [UIFont systemFontOfSize:14];
        _noCouponLb.textColor = [UIColor lightGrayColor];
    }
    return _noCouponLb;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GlobalBuyer_My_Tabview_Coupon", nil);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noCouponIv];
    self.noCouponIv.hidden = YES;
    [self.view addSubview:self.noCouponLb];
    self.noCouponLb.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_My_Tabview_Exchange", nil) style:UIBarButtonItemStylePlain target:self action:@selector(exchangeCoupons)];
}

- (UIView *)couponCodeV
{
    if (_couponCodeV == nil) {
        _couponCodeV = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, kScreenW , kScreenH)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelInputCode)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _couponCodeV.userInteractionEnabled = YES;
        [_couponCodeV addGestureRecognizer:tap];
        UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 120, kScreenH/2 - 100, 240, 200)];
        contentV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        contentV.layer.borderWidth = 1;
        contentV.backgroundColor = [UIColor whiteColor];
        [_couponCodeV addSubview:contentV];
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 40)];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_InputCouponCode", nil);
        titleLb.font = [UIFont systemFontOfSize:16];
        [contentV addSubview:titleLb];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 240, 1)];
        lineV.backgroundColor = [UIColor lightGrayColor];
        [contentV addSubview:lineV];
        self.couponCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 88, 160, 30)];
        self.couponCodeTF.layer.borderWidth = 0.7;
        self.couponCodeTF.delegate = self;
        self.couponCodeTF.returnKeyType = UIReturnKeyDone;
        [contentV addSubview:self.couponCodeTF];
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200 - 40, 240, 40)];
        okBtn.backgroundColor = Main_Color;
        [okBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [contentV addSubview:okBtn];
        [okBtn addTarget:self action:@selector(exchangeCouponsCommit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _couponCodeV;
}

- (void)cancelInputCode
{
    [self.couponCodeV removeFromSuperview];
    self.couponCodeTF = nil;
    self.couponCodeV = nil;
}

- (void)exchangeCoupons
{
    [self.view addSubview:self.couponCodeV];
}

- (void)exchangeCouponsCommit
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"coupon_code":[NSString stringWithFormat:@"%@",self.couponCodeTF.text]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:ExchangeCouponsApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_InputCouponCode_Success", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            [self downData];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(responseObject[@"message"], nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
        [self.couponCodeV removeFromSuperview];
        self.couponCodeTF = nil;
        self.couponCodeV = nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [self.couponCodeV removeFromSuperview];
        self.couponCodeTF = nil;
        self.couponCodeV = nil;
    }];
    

}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kScreenW/3.5+30;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    if (cell == nil) {
        cell = [[CouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if ([self.dataSource[indexPath.row][@"sign"]isEqualToString:@"service_charge"]) {
        cell.currencyLb.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]]];
        cell.priceLb.text = [NSString stringWithFormat:@"%@",self.serviceCharge];
        cell.rightLb.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row][@"name"]];
        cell.dateLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_My_Tabview_Coupon_Date", nil),self.dataSource[indexPath.row][@"expires_at"]];
        cell.leftLb.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Coupon_Type_1", nil);
    }
    

    return cell;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
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
