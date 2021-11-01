//
//  NoPayViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/13.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "NoPayViewController.h"
#import "NoPayTableViewCell.h"
#import "CurrencyCalculation.h"
#import "ChoosePayViewController.h"
#import "LoadingView.h"
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"

@interface NoPayViewController ()<UITableViewDelegate,UITableViewDataSource,ChoosePayViewControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,strong)NSString *serviceCharge;
@property (nonatomic, strong)UIView *expiredHintV;

@end

@implementation NoPayViewController

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
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"IsPushNoPayView"];
    [self downLoadServiceCharge];
    [self createUI];
    [self.view addSubview:[self expiredHintV]];
    //NotificationWarning(NSLocalizedString(@"GlobalBuyer_My_HintOutdated", nil));
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH - 104) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)moneytypeArr
{
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}


//获取服务费
- (void)downLoadServiceCharge
{
    [self.loadingView startLoading];
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"isoShort":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetServiceCharge parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.serviceCharge = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"service"] floatValue]];
        }
        
        [self downloadMoneytype];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}

- (void)downloadMoneytype {
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN};
    [manager GET:moneyTypeApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.moneytypeArr removeAllObjects];
        NSDictionary *dict = responseObject[@"data"];
        NSArray *fromArr = dict[@"from"];
        NSArray *toArr = dict[@"to"];
        for (int i = 0 ; i < fromArr.count; i++) {
            [self.moneytypeArr addObject:fromArr[i]];
        }
        for (int j = 0 ; j < toArr.count; j++) {
            [self.moneytypeArr addObject:toArr[j]];
        }
        [self downData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downData
{
    [self.dataSource removeAllObjects];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"pay_status":@"0"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:AllOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.dataSource addObject:dict];
            }
            [self.loadingView stopLoading];
            if (self.dataSource.count == 0) {
                UIImageView *emptyIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, kScreenH/2 - 50, 100, 100)];
                emptyIv.image = [UIImage imageNamed:@"my_Empty"];
                [self.view addSubview:emptyIv];
                UILabel *emptyLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 130, kScreenH/2 + 70, 260, 40)];
                emptyLb.text = NSLocalizedString(@"GlobalBuyer_My_Empty", nil);
                emptyLb.textColor = [UIColor lightGrayColor];
                emptyLb.font = [UIFont systemFontOfSize:16];
                emptyLb.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:emptyLb];
                UIButton *emptyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, kScreenH/2 + 120, 100, 30)];
                emptyBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                emptyBtn.layer.borderWidth = 0.7;
                [emptyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_BrowseTheHomePage", nil) forState:UIControlStateNormal];
                [emptyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [self.view addSubview:emptyBtn];
                [emptyBtn addTarget:self action:@selector(gotoHomePage) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [self.view addSubview:self.tableView];
                [self.tableView reloadData];
            }
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//                NSLog(@"%d",finished);
//
//            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)gotoHomePage
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"GotoHomeMark"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Wait", nil);
    self.navigationItem.titleView = titleLabel;
}
- (UIView *)expiredHintV
{
    if (_expiredHintV == nil) {
        _expiredHintV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        _expiredHintV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:0.7];
        UILabel *expiredHintLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        expiredHintLb.textAlignment = NSTextAlignmentCenter;
        expiredHintLb.textColor = [UIColor whiteColor];
        expiredHintLb.text = NSLocalizedString(@"GlobalBuyer_NoPayView_ExpiredHint", nil);
        expiredHintLb.font = [UIFont systemFontOfSize:13];
        [_expiredHintV addSubview:expiredHintLb];
        [expiredHintLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
        expiredHintLb.userInteractionEnabled = YES;
    }
    return _expiredHintV;
}
- (void)labelTap:(UIGestureRecognizer *)btn{
    self.tabBarController.selectedIndex = 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 30)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 270, 20)];
    lb.font = [UIFont systemFontOfSize:12];
    lb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_OrderNum", nil),self.dataSource[section][@"order_num"]];
    [iv addSubview:lb];
    
    
    UIButton *deleteOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 80, 5, 60, 20)];
    deleteOrderBtn.backgroundColor = Main_Color;
    [deleteOrderBtn setTitle:NSLocalizedString(@"删除订单", nil) forState:UIControlStateNormal];
    deleteOrderBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [deleteOrderBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    deleteOrderBtn.tag = section;
    [iv addSubview:deleteOrderBtn];
    
    return iv;
}

- (void)deleteOrder:(UIButton *)deleteOrderBtn
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"orderId"] = [NSString stringWithFormat:@"%@",self.dataSource[deleteOrderBtn.tag][@"id"]];
    
    [manager POST:DeleteOrderApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.dataSource removeObjectAtIndex:deleteOrderBtn.tag];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
    }];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 80, 5, 60, 20)];
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_PaymentOrder", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //btn.layer.cornerRadius = 2;
    btn.tag = section;
    btn.backgroundColor = Main_Color;
    [btn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 32)];
    iv.backgroundColor = [UIColor whiteColor];
    [iv addSubview:btn];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 270, 20)];
    lb.font = [UIFont systemFontOfSize:12];
    
    if ([self.dataSource[section][@"coupons"] count] != 0) {
        for (int i = 0 ; i < [self.dataSource[section][@"coupons"] count]; i++) {
            if ([self.dataSource[section][@"coupons"][i][@"action"]isEqualToString:@"service_charge"]) {
                lb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:[self.dataSource[section][@"order_total"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataSource[section][@"currency"] numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:0.0]];
            }
        }
    }else{
        lb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:[self.dataSource[section][@"order_total"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataSource[section][@"currency"] numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:0.0]];
    }

    
    
    lb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    [iv addSubview:lb];
    UIView *lineIv = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenW, 2)];
    lineIv.backgroundColor = [UIColor whiteColor];
    [iv addSubview:lineIv];
    return iv;
}



- (void)payOrder:(UIButton *)btn
{
    ChoosePayViewController *chooseVC = [[ChoosePayViewController alloc]init];
    chooseVC.delegate = self;
    chooseVC.isCreating = YES;
    chooseVC.orderId = self.dataSource[btn.tag][@"id"];
    chooseVC.orderStatus = self.dataSource[btn.tag][@"review_status"];
    chooseVC.type = @"NoPay";
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)Refresh
{
    [self downData];
}

- (void)pushNoPayViewC
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 32;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section][@"get_product"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NoPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoPayCell"];
    if (cell == nil) {
        cell = [[NoPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoPayCell"];
    }
    NSLog(@"%@",self.dataSource[indexPath.section][@"get_product"][indexPath.row]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.dataSource[indexPath.section][@"get_product"] count] != 0) {
        NSData *JSONData = [self.dataSource[indexPath.section][@"get_product"][indexPath.row][@"body"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        cell.lb.text = responseJSON[@"name"];
        
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
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
        
        cell.numLb.text = [NSString stringWithFormat:@"x%@",self.dataSource[indexPath.section][@"get_product"][indexPath.row][@"quantity"]];
        cell.priceLb.text = [CurrencyCalculation getcurrencyCalculation:[self.dataSource[indexPath.section][@"get_product"][indexPath.row][@"price"] floatValue] currentCommodityCurrency:responseJSON[@"currency"] numberOfGoods:[responseJSON[@"quantity"] floatValue]];
    }
    
    
    return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource[indexPath.section][@"get_product"][indexPath.row][@"buy_type"]isEqualToString:@"item-price"]) {
        return;
    }
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
    NSData *JSONData = [self.dataSource[indexPath.section][@"get_product"][indexPath.row][@"body"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    shopVC.link = responseJSON[@"link"];
    [self.navigationController pushViewController:shopVC animated:YES];
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
