//
//  AuditStatusViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/15.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "AuditStatusViewController.h"
#import "LoadingView.h"
#import "ParcelDetailsViewController.h"
#import "RepackagingViewController.h"
#import "CurrencyCalculation.h"
#import "ChoosePayViewController.h"
#import "NoPayTableViewCell.h"
#import "FinalPaymentDetailView.h"

@interface AuditStatusViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *passArr;
@property (nonatomic,strong)NSMutableArray *waitArr;
@property (nonatomic,strong)NSMutableArray *failArr;

@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,assign)NSInteger packageNumber;

@property (nonatomic,strong)UIView *freightDetailsBackV;

@property (nonatomic,strong)UILabel *localFreight;//当地运费
@property (nonatomic,strong)UILabel *exciseTax;//消费税
@property (nonatomic,strong)UILabel *warehousingFee;//仓储费
@property (nonatomic,strong)UILabel *internationalShipping;//国际运费
@property (nonatomic,strong)UILabel *parcelDuty;//包裹关税
@property (nonatomic,strong)UILabel *commodityPriceDifference;//商品差价
@property (nonatomic,strong)UILabel *addfee;

@property (nonatomic,strong)FinalPaymentDetailView *finalPaymentV;

@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation AuditStatusViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self refreshData];
}

- (void)refreshData
{
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],@"status":@"payWait"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:PackageApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.dataSource removeAllObjects];
            [self.dataArr removeAllObjects];
            [self.passArr removeAllObjects];
            [self.waitArr removeAllObjects];
            [self.failArr removeAllObjects];
            for (NSDictionary *dict  in responseObject[@"data"]) {
                //                if (![dict[@"package_num"] isEqual:[NSNull null]]) {
                [self.dataArr addObject:dict];
                if ([dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_PASS"]) {
                    NSString *str = [NSString stringWithFormat:@"%@",dict[@"pay_status"]];
                    if ([str isEqualToString:@"0"]) {
                        [self.passArr addObject:dict];
                    }
                }
                if ([dict[@"package_status"]isEqualToString:@"REVIEW_FIRST_WAIT"] || [dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_WAIT"]) {
                    [self.waitArr addObject:dict];
                }
                if ([dict[@"package_status"]isEqualToString:@"REVIEW_FAILURE"]) {
                    [self.failArr addObject:dict];
                }
                //                }
            }
            
            
            [self.dataSource addObject:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_YES", nil)];
            [self.dataSource addObject:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_WAIT", nil)];
            [self.dataSource addObject:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_NO", nil)];
            
            [self.loadingView stopLoading];
            if (self.passArr.count == 0 && self.waitArr.count == 0 && self.failArr.count == 0) {
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
                [self.tableV reloadData];
            }
            
            //            [UIView animateWithDuration:2 animations:^{
            //                self.loadingView.imgView.animationDuration = 3*0.15;
            //                self.loadingView.imgView.animationRepeatCount = 0;
            //                [self.loadingView.imgView startAnimating];
            //                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
            //            } completion:^(BOOL finished) {
            //
            //
            //
            //            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

//初始化汇率数据源
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}

- (UITableView *)tableV
{
    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH)) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.rowHeight = 100;
    }
    return _tableV;
}

- (NSMutableArray *)passArr
{
    if (_passArr == nil) {
        _passArr = [NSMutableArray new];
    }
    return _passArr;
}

- (NSMutableArray *)waitArr
{
    if (_waitArr == nil) {
        _waitArr = [NSMutableArray new];
    }
    return _waitArr;
}

- (NSMutableArray *)failArr
{
    if (_failArr == nil) {
        _failArr = [NSMutableArray new];
    }
    return _failArr;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downloadMoneytype];
    [self createUI];
}

//下载汇率
- (void)downloadMoneytype {
    
    [self.loadingView startLoading];
    
    NSDictionary *param = @{@"api_id":API_ID,@"api_token":TOKEN};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:moneyTypeApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],@"status":@"payWait"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:PackageApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.dataSource removeAllObjects];
            [self.dataArr removeAllObjects];
            [self.passArr removeAllObjects];
            [self.waitArr removeAllObjects];
            [self.failArr removeAllObjects];
            for (NSDictionary *dict  in responseObject[@"data"]) {
                
                [self.dataArr addObject:dict];
                //                if (![dict[@"package_num"] isEqual:[NSNull null]]) {
                if ([dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_PASS"]) {
                    NSString *str = [NSString stringWithFormat:@"%@",dict[@"pay_status"]];
                    if ([str isEqualToString:@"0"]) {
                        [self.passArr addObject:dict];
                    }
                }
                if ([dict[@"package_status"]isEqualToString:@"REVIEW_FIRST_WAIT"] || [dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_WAIT"]) {
                    [self.waitArr addObject:dict];
                }
                if ([dict[@"package_status"]isEqualToString:@"REVIEW_FAILURE"]) {
                    [self.failArr addObject:dict];
                }
                //                }
            }
            
            [self.dataSource addObject:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_YES", nil)];
            [self.dataSource addObject:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_WAIT", nil)];
            [self.dataSource addObject:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_NO", nil)];
            
            [self.loadingView stopLoading];
            
            if (self.passArr.count == 0 && self.waitArr.count == 0 && self.failArr.count == 0) {
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
                [self.view addSubview:self.tableV];
            }
            
            //            [UIView animateWithDuration:2 animations:^{
            //                self.loadingView.imgView.animationDuration = 3*0.15;
            //                self.loadingView.imgView.animationRepeatCount = 0;
            //                [self.loadingView.imgView startAnimating];
            //                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
            //            } completion:^(BOOL finished) {
            //
            //
            //
            ////                [self.view addSubview:self.tableV];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_paymentofbalance", nil);
    self.navigationItem.titleView = titleLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArr[section];
    NSLog(@"model===>%@",dict);
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 45)];
    iv.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 270, 44)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_PackagesNum", nil),dict[@"package_unique"]];;
    [iv addSubview:lb];
    
    UIButton *deleteOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 7, 80, 30)];
    deleteOrderBtn.backgroundColor = [UIColor blackColor];
    deleteOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteOrderBtn addTarget:self action:@selector(showFreightDetails:) forControlEvents:UIControlEventTouchUpInside];
    deleteOrderBtn.tag = section;
    [iv addSubview:deleteOrderBtn];
    
    
    if ([dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_PASS"]) {
        NSString *str = [NSString stringWithFormat:@"%@",dict[@"pay_status"]];
        if ([str isEqualToString:@"0"]) {
            [deleteOrderBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_FreightDetails", nil) forState:UIControlStateNormal];
        }else{
            deleteOrderBtn.hidden = YES;
        }
    }else{
        deleteOrderBtn.hidden = YES;
    }

    return iv;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArr[section];
    
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 47+40)];
    iv.backgroundColor = [UIColor whiteColor];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 270, 20)];
    lb.font = [UIFont systemFontOfSize:14];

    
    lb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    [iv addSubview:lb];
    UIView *lineIv = [[UIView alloc]initWithFrame:CGRectMake(0, 42, kScreenW, 1.5)];
    lineIv.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1];
    [iv addSubview:lineIv];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 44+5, 80, 30)];
    [iv addSubview:btn];
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_PaymentOrder", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //btn.layer.cornerRadius = 2;
    btn.tag = section;
    btn.backgroundColor = [UIColor blackColor];
    
    if ([dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_PASS"]) {
        NSString *str = [NSString stringWithFormat:@"%@",dict[@"pay_status"]];
        if ([str isEqualToString:@"0"]) {
            lb.text = NSLocalizedString(@"GlobalBuyer_My_AuditStatus_YES", nil);
            [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Paytransport", nil) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(payFreight:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
        }

    }
    if ([dict[@"package_status"]isEqualToString:@"REVIEW_FIRST_WAIT"] || [dict[@"package_status"]isEqualToString:@"REVIEW_SECOND_WAIT"]) {
        lb.text = NSLocalizedString(@"GlobalBuyer_My_AuditStatus_WAIT", nil);
        [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_clickandrepackage", nil) forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([dict[@"package_status"]isEqualToString:@"REVIEW_FAILURE"]) {
        lb.text = NSLocalizedString(@"GlobalBuyer_My_AuditStatus_NO", nil);
        [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_clickandrepackage", nil) forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *lineIv1= [[UIView alloc]initWithFrame:CGRectMake(0, 44+10+30+5, kScreenW, 10)];
    lineIv1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [iv addSubview:lineIv1];

    return iv;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44+10+30+5+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataArr[section][@"get_package_product"];
    if (arr.count == 0) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NoPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoPayCell"];
    if (cell == nil) {
        cell = [[NoPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoPayCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arr = self.dataArr[indexPath.section][@"get_package_product"];
    
    if (arr.count>0&&arr[0][@"get_pay_product"]) {
        NSDictionary *dic = arr[0][@"get_pay_product"];
        NSString *string = dic[@"body"];
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSString *pictureUrl;
        NSMutableString *pictureStr = jsonDict[@"picture"];
        NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
        NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
        if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
            pictureUrl = pictureStr;
        }else{
            NSMutableString *tmpStr = jsonDict[@"link"];
            NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
            NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
            if (tmpHttpArr.count > 0) {
                pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
            }else if(tmpHttpsArr.count > 0){
                pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
        cell.lb.text = jsonDict[@"name"];
        cell.priceLb.text = [NSString stringWithFormat:@"%@%@",jsonDict[@"currency"],jsonDict[@"price"]];
        cell.numLb.text = [NSString stringWithFormat:@"x%@",jsonDict[@"quantity"]];

        
    }
    
    
    
    return cell;
    
}

- (void)showFreightDetails:(UIButton *)freightDetailsBtn
{
    self.packageNumber = freightDetailsBtn.tag;
    //[self.view addSubview:self.freightDetailsBackV];
    NSLog(@"%ld",(long)freightDetailsBtn.tag);
    
    if (!self.finalPaymentV) {
        self.finalPaymentV = [[FinalPaymentDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.finalPaymentV.moneytypeArr = self.moneytypeArr;
        self.finalPaymentV.dataDic = self.dataArr[self.packageNumber];
        self.finalPaymentV.paymentBtn.tag = self.packageNumber;
        [self.finalPaymentV.paymentBtn addTarget:self action:@selector(payFreight:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view addSubview:self.finalPaymentV];
    }else{
        self.finalPaymentV.paymentBtn.tag = self.packageNumber;
        self.finalPaymentV.moneytypeArr = self.moneytypeArr;
        self.finalPaymentV.dataDic = self.dataArr[self.packageNumber];
        [self.navigationController.view addSubview:self.finalPaymentV];
    }
}

- (UIView *)freightDetailsBackV
{
    if (_freightDetailsBackV == nil) {
        _freightDetailsBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _freightDetailsBackV.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:0.8];
        _freightDetailsBackV.userInteractionEnabled = YES;
        UITapGestureRecognizer *freightDetailsTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissFreightDetails)];
        freightDetailsTap.numberOfTapsRequired = 1;
        freightDetailsTap.numberOfTouchesRequired = 1;
        [_freightDetailsBackV addGestureRecognizer:freightDetailsTap];
        
        
        
        float getH = 50.0;
        
        UIView *midV = [[UIView alloc]initWithFrame:CGRectMake(40, 120, kScreenW - 80, 400)];
        midV.backgroundColor = [UIColor whiteColor];
        midV.userInteractionEnabled = YES;
        //        midV.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:0.9];
        [_freightDetailsBackV addSubview:midV];
        UITapGestureRecognizer *midVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(midvClick)];
        midVTap.numberOfTouchesRequired = 1;
        midVTap.numberOfTapsRequired = 1;
        [midV addGestureRecognizer:midVTap];
        
        //标题
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, midV.frame.size.width, 50)];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = Main_Color;
        titleLb.text = NSLocalizedString(@"GlobalBuyer_My_FreightDetails", nil);
        titleLb.font = [UIFont systemFontOfSize:20 weight:1];
        [midV addSubview:titleLb];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, midV.frame.size.width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [midV addSubview:line];
        
        //当地运费
        UILabel *leftLocalFreight = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 20)];
        leftLocalFreight.text = NSLocalizedString(@"GlobalBuyer_My_LocalFreight", nil);
        [midV addSubview:leftLocalFreight];
        self.localFreight = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, 60, 100, 20)];
        self.localFreight.font = [UIFont systemFontOfSize:13];
        self.localFreight.textAlignment = NSTextAlignmentRight;
        self.localFreight.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [midV addSubview:self.localFreight];
        
        if ([self.dataArr[self.packageNumber][@"package_freight"] floatValue] == 0) {
            leftLocalFreight.frame = CGRectMake(0, 0, 0, 0);
            self.localFreight.frame = CGRectMake(0, 0, 0, 0);
        }else{
            self.localFreight.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_freight"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataArr[self.packageNumber][@"product_currency"] numberOfGoods:1.0];
            getH = getH + leftLocalFreight.frame.size.height + 10.0;
        }
        
        
        
        //消费税
        UILabel *leftExciseTax = [[UILabel alloc]initWithFrame:CGRectMake( 10 , getH + 10, 100, 20)];
        leftExciseTax.text = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayDetailsLb", nil);
        [midV addSubview:leftExciseTax];
        self.exciseTax = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, getH + 10, 100, 20)];
        self.exciseTax.textAlignment = NSTextAlignmentRight;
        self.exciseTax.font = [UIFont systemFontOfSize:13];
        self.exciseTax.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [midV addSubview:self.exciseTax];
        
        if ([self.dataArr[self.packageNumber][@"package_tax"] floatValue] == 0) {
            leftExciseTax.frame = CGRectMake(0, 0, 0, 0);
            self.exciseTax.frame = CGRectMake(0, 0, 0, 0);
        }else{
            self.exciseTax.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_tax"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataArr[self.packageNumber][@"product_currency"] numberOfGoods:1.0];
            getH = getH + leftExciseTax.frame.size.height + 10.0;
        }
        
        
        
        //仓储费
        UILabel *leftWarehousingFee = [[UILabel alloc]initWithFrame:CGRectMake( 10 , getH + 10, 100, 20)];
        leftWarehousingFee.text = NSLocalizedString(@"GlobalBuyer_My_WarehousingFee", nil);
        [midV addSubview:leftWarehousingFee];
        self.warehousingFee = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, getH + 10, 100, 20)];
        self.warehousingFee.textAlignment = NSTextAlignmentRight;
        self.warehousingFee.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.warehousingFee.font = [UIFont systemFontOfSize:13];
        [midV addSubview:self.warehousingFee];
        if ([self.dataArr[self.packageNumber][@"package_storage"] floatValue] == 0) {
            leftWarehousingFee.frame = CGRectMake(0, 0, 0, 0);
            self.warehousingFee.frame = CGRectMake(0, 0, 0, 0);
        }else{
            //self.warehousingFee.text = [CurrencyCalculation getcurrencyCalculation:[self.passArr[self.packageNumber][@"package_storage"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.passArr[self.packageNumber][@"package_storage_currency"] numberOfGoods:1.0];
            self.warehousingFee.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_storage"] floatValue] currentCommodityCurrency:self.dataArr[self.packageNumber][@"package_storage_currency"] numberOfGoods:1.0];
            getH = getH + leftWarehousingFee.frame.size.height + 10.0;
        }
        
        
        
        
        //国际运费
        UILabel *leftInternationalShipping = [[UILabel alloc]initWithFrame:CGRectMake( 10 , getH + 10, 100, 20)];
        leftInternationalShipping.text = NSLocalizedString(@"GlobalBuyer_My_InternationalShipping", nil);
        [midV addSubview:leftInternationalShipping];
        self.internationalShipping = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, getH + 10, 100, 20)];
        self.internationalShipping.textAlignment = NSTextAlignmentRight;
        self.internationalShipping.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.internationalShipping.font = [UIFont systemFontOfSize:13];
        [midV addSubview:self.internationalShipping];
        if ([self.dataArr[self.packageNumber][@"package_transfer_freight"] floatValue] == 0) {
            leftInternationalShipping.frame = CGRectMake(0, 0, 0, 0);
            self.internationalShipping.frame = CGRectMake(0, 0, 0, 0);
        }else{
            //self.internationalShipping.text = [CurrencyCalculation getcurrencyCalculation:[self.passArr[self.packageNumber][@"package_transfer_freight"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.passArr[self.packageNumber][@"package_transport_currency"] numberOfGoods:1.0];
            self.internationalShipping.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_transfer_freight"] floatValue] currentCommodityCurrency:self.dataArr[self.packageNumber][@"package_transport_currency"] numberOfGoods:1.0];
            
            getH = getH + leftInternationalShipping.frame.size.height + 10.0;
        }
        
        
        
        
        //包裹关税
        UILabel *leftParcelDuty = [[UILabel alloc]initWithFrame:CGRectMake( 10 , getH + 10, 100, 20)];
        leftParcelDuty.text = NSLocalizedString(@"GlobalBuyer_My_ParcelDuty", nil);
        [midV addSubview:leftParcelDuty];
        self.parcelDuty = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, getH + 10, 100, 20)];
        self.parcelDuty.textAlignment = NSTextAlignmentRight;
        self.parcelDuty.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.parcelDuty.font = [UIFont systemFontOfSize:13];
        [midV addSubview:self.parcelDuty];
        if ([self.dataArr[self.packageNumber][@"package_tariff"] floatValue] == 0) {
            leftParcelDuty.frame = CGRectMake(0, 0, 0, 0);
            self.parcelDuty.frame = CGRectMake(0, 0, 0, 0);
        }else{
            //self.parcelDuty.text = [CurrencyCalculation getcurrencyCalculation:[self.passArr[self.packageNumber][@"package_tariff"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.passArr[self.packageNumber][@"package_rate_currency"] numberOfGoods:1.0];
            self.parcelDuty.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_tariff"] floatValue] currentCommodityCurrency:self.dataArr[self.packageNumber][@"package_rate_currency"] numberOfGoods:1.0];
            getH = getH + leftParcelDuty.frame.size.height + 10.0;
        }
        
        
        
        //商品差价
        UILabel *leftCommodityPriceDifference = [[UILabel alloc]initWithFrame:CGRectMake( 10 , getH + 10, 100, 20)];
        leftCommodityPriceDifference.text = NSLocalizedString(@"GlobalBuyer_My_CommodityPriceDifference", nil);
        [midV addSubview:leftCommodityPriceDifference];
        self.commodityPriceDifference = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, getH + 10, 100, 20)];
        self.commodityPriceDifference.textAlignment = NSTextAlignmentRight;
        self.commodityPriceDifference.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.commodityPriceDifference.font = [UIFont systemFontOfSize:13];
        [midV addSubview:self.commodityPriceDifference];
        if ([self.dataArr[self.packageNumber][@"package_adjust_price"] floatValue] == 0) {
            leftCommodityPriceDifference.frame = CGRectMake(0, 0, 0, 0);
            self.commodityPriceDifference.frame = CGRectMake(0, 0, 0, 0);
        }else{
            self.commodityPriceDifference.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_adjust_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataArr[self.packageNumber][@"product_currency"] numberOfGoods:1.0];
        }
        getH = getH + leftCommodityPriceDifference.frame.size.height + 10.0;
        
        
        //增值服务费
        UILabel *leftAddfeeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, getH + 10, 100, 20)];
        leftAddfeeLb.text = NSLocalizedString(@"GlobalBuyer_My_Addfee", nil);
        [midV addSubview:leftAddfeeLb];
        self.addfee = [[UILabel alloc]initWithFrame:CGRectMake(midV.frame.size.width - 110, getH + 10, 100, 20)];
        self.addfee.textAlignment = NSTextAlignmentRight;
        self.addfee.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.addfee.font = [UIFont systemFontOfSize:13];
        [midV addSubview:self.addfee];
        if ([self.dataArr[self.packageNumber][@"package_addfee"] floatValue] == 0) {
            leftAddfeeLb.frame = CGRectMake(0, 0, 0, 0);
            self.addfee.frame = CGRectMake(0, 0, 0, 0);
        }else{
            //更换币种标示
            //[CurrencyCalculation getcurrencyCalculation:[self.passArr[self.packageNumber][@"package_addfee"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.passArr[self.packageNumber][@"package_storage_currency"] numberOfGoods:1.0];
            self.addfee.text = [CurrencyCalculation getcurrencyCalculation:[self.dataArr[self.packageNumber][@"package_addfee"] floatValue] currentCommodityCurrency:self.dataArr[self.packageNumber][@"package_addfee_currency"] numberOfGoods:1.0];
        }
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, midV.frame.size.height - 40, midV.frame.size.width/2, 40)];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        cancelBtn.layer.borderWidth = 0.5;
        cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [midV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(dismissFreightDetails) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , midV.frame.size.height - 40, midV.frame.size.width, 40)];
        [payBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_PayFreight", nil) forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payBtn.backgroundColor = Main_Color;
        [midV addSubview:payBtn];
        [payBtn addTarget:self action:@selector(payFreight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freightDetailsBackV;
}

- (void)dismissFreightDetails
{
    [self.freightDetailsBackV removeFromSuperview];
    self.freightDetailsBackV = nil;
}

- (void)payFreight:(UIButton *)sender
{
    [self.finalPaymentV removeFromSuperview];
    ChoosePayViewController *chooseVC = [[ChoosePayViewController alloc]init];
    chooseVC.isCreating = YES;
    chooseVC.packageId = self.dataArr[sender.tag][@"id"];
    chooseVC.type = @"auditStatus";
    [self.navigationController pushViewController:chooseVC animated:YES];
}

- (void)midvClick
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%ld",(long)indexPath.section);
//
//    //支付运费
    if (indexPath.row == 0) {
        [self PackagePayWithIndexPath:indexPath];
    }
//
//    //审核中解包
//    if (indexPath.section == 1) {
//        [self deletePackageWithIndexPath:indexPath];
//    }
//
//    //解包
//    if (indexPath.section == 2) {
//        [self deletePackageWithIndexPath:indexPath];
//    }
}

//支付运费网络请求
- (void)PackagePayWithIndexPath:(NSIndexPath *)indexPath
{
    ParcelDetailsViewController *parceVC = [[ParcelDetailsViewController alloc]init];
    parceVC.packageId = self.dataArr[indexPath.section][@"id"];
    parceVC.dataSource = self.dataArr[indexPath.section][@"get_package_product"];
    [self.navigationController pushViewController:parceVC animated:YES];
    //    ChoosePayViewController *chooseVC = [[ChoosePayViewController alloc]init];
    //    chooseVC.isCreating = YES;
    //    chooseVC.packageId = self.passArr[indexPath.section][@"id"];
    //    [self.navigationController pushViewController:chooseVC animated:YES];
}

//解包网络请求
- (void)deletePackageWithIndexPath:(NSIndexPath *)indexPath
{
    
    RepackagingViewController *repVC = [[RepackagingViewController alloc]init];
    if (indexPath.section == 1) {
        repVC.dataSource = self.waitArr[indexPath.row];
    }
    if (indexPath.section == 2) {
        repVC.dataSource = self.failArr[indexPath.row];
    }
    [self.navigationController pushViewController:repVC animated:YES];
}


- (void)sureBtn:(UIButton *)sender
{
    self.packageNumber = sender.tag;
    
    //GlobalBuyer_My_AuditStatus_clickandrepackage_confirm
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: NSLocalizedString(@"GlobalBuyer_My_AuditStatus_clickandrepackage_confirm", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cancelPack];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:action];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}


- (void)cancelPack{
    
    NSLog(@"self.packageNumber %@",self.packageNumber);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"正在解包", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"packageId":self.dataArr[self.packageNumber][@"id"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PackageDeleteApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"解包成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"解包失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"解包失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
