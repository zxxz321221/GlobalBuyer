//
//  SelectCouponViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/4/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SelectCouponViewController.h"
#import "LoadingView.h"
#import "CouponCell.h"
#import "ChoosePayViewController.h"

@interface SelectCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSString *serviceCharge;

@end

@implementation SelectCouponViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
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
    [self.loadingView startLoading];
    
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

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GlobalBuyer_My_Tabview_Coupon", nil);
    [self.view addSubview:self.tableView];
    
    
    UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake( 0, kScreenH - 50, kScreenW, 50)];
    btn.backgroundColor = Main_Color;
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_DoNotUseCoupons", nil) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(doNotUse) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doNotUse
{
    [self.delegate cancelSelectCoupon];
    [self.navigationController popViewControllerAnimated:YES];
//    ChoosePayViewController *choosePayVC = [[ChoosePayViewController alloc]init];
//    choosePayVC .hidesBottomBarWhenPushed = YES;
//    choosePayVC.idsStr = self.idsStr;
//    choosePayVC.shopCartVC = self.shopCartVC;
//    choosePayVC.orderType = self.orderType;
//    choosePayVC.orderAddress = self.orderAddress;
//    choosePayVC.isInspection = self.isInspection;
//    [self.navigationController pushViewController:choosePayVC animated:YES];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-50) style:UITableViewStylePlain];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate isSelectCoupon:self.dataSource[indexPath.row][@"code"]];
    [self.navigationController popViewControllerAnimated:YES];
    
//    ChoosePayViewController *choosePayVC = [[ChoosePayViewController alloc]init];
//    choosePayVC .hidesBottomBarWhenPushed = YES;
//    choosePayVC.idsStr = self.idsStr;
//    choosePayVC.shopCartVC = self.shopCartVC;
//    choosePayVC.orderType = self.orderType;
//    choosePayVC.orderAddress = self.orderAddress;
//    choosePayVC.isInspection = self.isInspection;
//    choosePayVC.couponsCode = self.dataSource[indexPath.row][@"code"];
//    [self.dataSource removeObjectAtIndex:indexPath.row];
//    [self.tableView reloadData];
//    [self.navigationController pushViewController:choosePayVC animated:YES];
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
