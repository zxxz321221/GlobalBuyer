//
//  AlreadyPayViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/13.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "AlreadyPayViewController.h"
#import "AlreadyPayTableViewCell.h"
#import "CurrencyCalculation.h"
#import "LoadingView.h"
#import "ChoiceAddressViewController.h"
#import "AdditionInformationViewController.h"
#import "DomesticLogisticsViewController.h"


@interface AlreadyPayViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceAddressViewControllerDelegate>

@property (nonatomic,strong)NSMutableArray *orderIdSource;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *packSource;
@property (nonatomic,strong)UIView *pickV;
@property (nonatomic,strong)NSMutableArray *indexPathArr;

@property (nonatomic,strong)NSString *firstPick;
@property (nonatomic,strong)NSString *currentPick;
@property (nonatomic,strong)NSMutableArray *pickLimitDataSource;

@property (nonatomic,strong)UIView *valueAddedServiceBackV;
@property (nonatomic,strong)UIView *valueAddedService;

@property (nonatomic,strong)NSString *storageCountry;
@property (nonatomic,strong)NSString *storageName;
@property (nonatomic,strong)NSString *storageNode;

@property (nonatomic,strong)NSMutableArray *valueAddedServiceArr;
@property (nonatomic,strong)NSMutableArray *valueAddedServiceSelectArr;

@property (nonatomic,strong)UIScrollView *imageSV;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIPageControl *currentPage;

@property (nonatomic,strong)NSMutableArray *numUrl;
@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)NSString *weightNum;
@property (nonatomic,strong)UILabel *weightLb;

@end

@implementation AlreadyPayViewController

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
    [self downData];
    [self createUI];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)orderIdSource
{
    if (_orderIdSource == nil) {
        _orderIdSource = [NSMutableArray new];
    }
    return _orderIdSource;
}

- (NSMutableArray *)pickLimitDataSource
{
    if (_pickLimitDataSource == nil) {
        _pickLimitDataSource = [NSMutableArray new];
    }
    return _pickLimitDataSource;
}

- (NSMutableArray *)packSource
{
    if (_packSource == nil) {
        _packSource = [NSMutableArray new];
    }
    return _packSource;
}

- (NSMutableArray *)valueAddedServiceArr
{
    if (_valueAddedServiceArr == nil) {
        _valueAddedServiceArr = [NSMutableArray new];
    }
    return _valueAddedServiceArr;
}

- (NSMutableArray *)valueAddedServiceSelectArr
{
    if (_valueAddedServiceSelectArr == nil) {
        _valueAddedServiceSelectArr = [NSMutableArray new];
    }
    return _valueAddedServiceSelectArr;
}

- (NSMutableArray *)indexPathArr
{
    if (_indexPathArr == nil) {
        _indexPathArr = [NSMutableArray new];
    }
    return _indexPathArr;
}

- (NSMutableArray *)numUrl
{
    if (_numUrl == nil) {
        _numUrl = [NSMutableArray new];
    }
    return _numUrl;
}

//初始化汇率数据源
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-(kNavigationBarH + kStatusBarH)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (void)downData
{
    [self.dataSource removeAllObjects];
    [self.pickLimitDataSource removeAllObjects];
    [self.packSource removeAllObjects];
    [self.indexPathArr removeAllObjects];
    self.currentPick = nil;
    [self.loadingView startLoading];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"status":@"packageWait",
                             @"groupKey":@"express"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:AlreadyPayApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            NSArray *tmpKey = [responseObject[@"data"][@"payProducts"] allKeys];
            self.orderIdSource = [NSMutableArray arrayWithArray:tmpKey];
            
            for (int i = 0; i < tmpKey.count; i++) {
                NSDictionary *dict = @{self.orderIdSource[i]:responseObject[@"data"][@"payProducts"][self.orderIdSource[i]]};
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
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_WaitPack", nil);
    self.navigationItem.titleView = titleLabel;
    
    
    
    self.pickV = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 40, 25)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
    lb.text = NSLocalizedString(@"GlobalBuyer_My_Pack", nil);
    lb.textColor = [UIColor whiteColor];
    [self.pickV addSubview:lb];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickGoods)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.pickV addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.pickV];
}

- (void)pickGoods
{
    
    NSLog(@"%lu",(unsigned long)self.packSource.count);
    if (self.packSource.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_SelectPack", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self downloadMoneytype];

    

//    ChoiceAddressViewController *addVC = [[ChoiceAddressViewController alloc]init];
//    addVC.delegate = self;
//    addVC.pickSource = self.packSource;
//    [self.navigationController pushViewController:addVC animated:YES];
}

//下载汇率
- (void)downloadMoneytype {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
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
        
        [self downValueAddedService];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downValueAddedService
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
    
    NSDictionary *params = @{@"api_id":LogisticsAPI_ID,@"api_token":LogisticsTOKEN,@"country_name":self.storageCountry,@"storage_name":self.storageName,@"node_name":self.storageNode,@"locale":language};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:GetValueAddedServiceApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self.hud hideAnimated:YES];
            [self.valueAddedServiceArr removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.valueAddedServiceArr addObject:dict];
            }
            
            
            [self.view addSubview:self.valueAddedServiceBackV];
            [self.view addSubview:self.valueAddedService];
            
            self.valueAddedServiceBackV.hidden = NO;
            [UIView animateWithDuration:1 animations:^{
                self.valueAddedService.frame = CGRectMake(0, kScreenH - 360, kScreenW, 360);
            }];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UIView *)valueAddedServiceBackV
{
    if (_valueAddedServiceBackV == nil) {
        _valueAddedServiceBackV = [[UIView alloc]initWithFrame:self.view.bounds];
        _valueAddedServiceBackV.userInteractionEnabled = YES;
        
        _valueAddedServiceBackV.hidden = YES;
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeValueAddedServiceBackV)];
        closeTap.numberOfTouchesRequired = 1;
        closeTap.numberOfTapsRequired = 1;
        [_valueAddedServiceBackV addGestureRecognizer:closeTap];
    }
    return _valueAddedServiceBackV;
}

- (void)closeValueAddedServiceBackV
{
    [UIView animateWithDuration:1 animations:^{
       
        self.valueAddedService.frame = CGRectMake(0, kScreenH, kScreenW, 360);
        
    } completion:^(BOOL finished) {
        self.valueAddedServiceBackV.hidden = YES;
        
        [self.valueAddedServiceSelectArr removeAllObjects];
        [self.valueAddedService removeFromSuperview];
        [self.valueAddedServiceBackV removeFromSuperview];
        self.valueAddedService = nil;
        self.valueAddedServiceBackV = nil;
    }];
}

//增值服务页面
- (UIView *)valueAddedService
{
    if (_valueAddedService == nil) {
        _valueAddedService = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 360)];
        _valueAddedService.backgroundColor = [UIColor whiteColor];
        _valueAddedService.userInteractionEnabled = YES;
        
        UILabel *valueAddedServiceLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 100   , 20, 200, 40)];
        valueAddedServiceLb.text = NSLocalizedString(@"GlobalBuyer_My_SelectionOfServices", nil);
        valueAddedServiceLb.textColor = Main_Color;
        valueAddedServiceLb.textAlignment = NSTextAlignmentCenter;
        valueAddedServiceLb.font = [UIFont systemFontOfSize:20];
        [valueAddedServiceLb sizeToFit];
        [_valueAddedService addSubview:valueAddedServiceLb];
        
        UIImageView *helpIv = [[UIImageView alloc]initWithFrame:CGRectMake(valueAddedServiceLb.frame.origin.x + valueAddedServiceLb.frame.size.width + 10, 20 , 24, 24)];
        helpIv.image = [UIImage imageNamed:@"tabBar_help"];
        helpIv.userInteractionEnabled = YES;
        [_valueAddedService addSubview:helpIv];
        UITapGestureRecognizer *helpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpTapClick)];
        helpTap.numberOfTapsRequired = 1;
        helpTap.numberOfTouchesRequired = 1;
        [helpIv addGestureRecognizer:helpTap];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, valueAddedServiceLb.frame.origin.y + valueAddedServiceLb.frame.size.height + 5 , kScreenW - 20, 1)];
        line.backgroundColor = Main_Color;
        [_valueAddedService addSubview:line];
        
        
        UIButton *valueAddedServiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _valueAddedService.frame.size.height - 50, kScreenW, 50)];
        [valueAddedServiceBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        valueAddedServiceBtn.backgroundColor = Main_Color;
        [_valueAddedService addSubview:valueAddedServiceBtn];
        [valueAddedServiceBtn addTarget:self action:@selector(commitValueAddedService) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIScrollView *valueAddedServiceSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, kScreenW , 240)];
        valueAddedServiceSv.contentSize = CGSizeMake(0, 20 + 50*self.valueAddedServiceArr.count);
        [_valueAddedService addSubview:valueAddedServiceSv];
        for (int i = 0; i < self.valueAddedServiceArr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20 + 50*i, 30 , 30)];
            btn.tag = 100 + i;
            [btn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
            [valueAddedServiceSv addSubview:btn];
            [btn addTarget:self action:@selector(valueAddedServiceClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(60, 20 + 50*i, 200, 30)];
            lb.text = [NSString stringWithFormat:@"%@",self.valueAddedServiceArr[i][@"name"]];
            [valueAddedServiceSv addSubview:lb];
            //coin
            UILabel *priceLb= [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 100, 20 + 50*i, 80, 30)];
            //[CurrencyCalculation getcurrencyCalculation:[self.valueAddedServiceArr[i][@"price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.valueAddedServiceArr[i][@"coin"] numberOfGoods:1.0]
            priceLb.text = [NSString stringWithFormat:@"%@",[CurrencyCalculation getcurrencyCalculation:[self.valueAddedServiceArr[i][@"price"] floatValue]  currentCommodityCurrency:self.valueAddedServiceArr[i][@"coin"] numberOfGoods:1.0]];
            priceLb.textAlignment = NSTextAlignmentRight;
            priceLb.font = [UIFont systemFontOfSize:12];
            priceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
            [valueAddedServiceSv addSubview:priceLb];
        }

    }
    return _valueAddedService;
}


- (void)valueAddedServiceClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected == YES) {
        [self.valueAddedServiceSelectArr addObject:self.valueAddedServiceArr[btn.tag - 100]];
    }
    
    if (btn.selected == NO) {
        [self.valueAddedServiceSelectArr removeObject:self.valueAddedServiceArr[btn.tag - 100]];
    }
}

- (void)helpTapClick
{
    AdditionInformationViewController *addVC = [[AdditionInformationViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)commitValueAddedService
{
    

    
    ChoiceAddressViewController *addVC = [[ChoiceAddressViewController alloc]init];
    addVC.delegate = self;
    addVC.pickSource = self.packSource;
    addVC.valueAddedServiceSource = [NSMutableArray arrayWithArray:self.valueAddedServiceSelectArr];
    [self.navigationController pushViewController:addVC animated:YES];
    
    [UIView animateWithDuration:1 animations:^{
        
        self.valueAddedService.frame = CGRectMake(0, kScreenH, kScreenW, 360);
        
    } completion:^(BOOL finished) {
        self.valueAddedServiceBackV.hidden = YES;
        
        [self.valueAddedServiceSelectArr removeAllObjects];
        [self.valueAddedService removeFromSuperview];
        [self.valueAddedServiceBackV removeFromSuperview];
        self.valueAddedService = nil;
        self.valueAddedServiceBackV = nil;
    }];
}

- (void)RefreshAdd
{
    [self refreshData];
}

- (void)refreshData
{
    for (int i = 0 ; i < self.dataSource.count; i++) {
        NSArray *tmpRowArr = [self.dataSource[i] allKeys];
        for (int j = 0 ; j < [self.dataSource[i][tmpRowArr[0]] count]; j++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            AlreadyPayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
            cell.btn.selected = NO;
        }
    }
    
    [self.dataSource removeAllObjects];
    [self.pickLimitDataSource removeAllObjects];
    [self.packSource removeAllObjects];
    [self.orderIdSource removeAllObjects];
    [self.indexPathArr removeAllObjects];
    self.currentPick = nil;
    

    
    [self.tableView reloadData];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"status":@"packageWait",
                             @"groupKey":@"express"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:AlreadyPayApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            NSArray *tmpKey = [responseObject[@"data"][@"payProducts"] allKeys];
            self.orderIdSource = [NSMutableArray arrayWithArray:tmpKey];
            
            for (int i = 0; i < tmpKey.count; i++) {
                NSDictionary *dict = @{self.orderIdSource[i]:responseObject[@"data"][@"payProducts"][self.orderIdSource[i]]};
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
                
                [self.tableView reloadData];
                
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    NSArray *tmparr = [self.dataSource[section] allKeys];
//    
//    return tmparr[0];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *tmparr = [self.dataSource[section] allKeys];
    
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    lb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_OrderNum", nil),tmparr[0]];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor grayColor];
    [iv addSubview:lb];
    
    UIButton *domesticBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 80, 5, 60, 20)];
    [domesticBtn setTitle:NSLocalizedString(@"GlobalBuyer_Order_title", nil) forState:UIControlStateNormal];
    domesticBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [domesticBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //btn.layer.cornerRadius = 2;
    domesticBtn.tag = section;
    domesticBtn.backgroundColor = Main_Color;
    [domesticBtn addTarget:self action:@selector(InquiryLogistics:) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:domesticBtn];
    
    NSArray *arr = [self.dataSource[section] valueForKey:tmparr[0]];
    NSDictionary *dic = arr.firstObject;
    if ([[dic valueForKey:@"confirm"] integerValue] == 1) {
        UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 160, 5, 60, 20)];
        [imageBtn setTitle:NSLocalizedString(@"GlobalBuyer_Logistics_Inspection", nil) forState:UIControlStateNormal];
        imageBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //btn.layer.cornerRadius = 2;
        imageBtn.tag = section;
        imageBtn.backgroundColor = Main_Color;
        [imageBtn addTarget:self action:@selector(showInspectionImage:) forControlEvents:UIControlEventTouchUpInside];
        [iv addSubview:imageBtn];
    }
    
    
    return iv;
}

- (void)InquiryLogistics:(UIButton *)btn
{
    NSArray *tmparr = [self.dataSource[btn.tag] allKeys];
    NSLog(@"%@     %@",tmparr[0],self.dataSource[btn.tag][tmparr[0]][0][@"get_package_product"][@"express_name"]);
    
    
    DomesticLogisticsViewController *domVC = [[DomesticLogisticsViewController alloc]init];
    domVC.packageNum = [NSString stringWithFormat:@"%@",tmparr[0]];
    domVC.packageName = [NSString stringWithFormat:@"%@",self.dataSource[btn.tag][tmparr[0]][0][@"get_package_product"][@"express_name"]];
    domVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:domVC animated:YES];
}


- (void)showInspectionImage:(UIButton *)btn
{
    [self.numUrl removeAllObjects];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSArray *tmparr = [self.dataSource[btn.tag] allKeys];
    NSLog(@"%@     ",tmparr[0]);
    
    //@"9385472697090169882333"
    NSDictionary *params = @{@"api_id":LogisticsAPI_ID,
                             @"api_token":LogisticsTOKEN,
                             @"express_no":[NSString stringWithFormat:@"%@",tmparr[0]]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:DomesticLogisticsImageApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSString *mosaicUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"platform"]];
            for (int i = 0 ; i < [responseObject[@"data"][@"picture"] count]; i++) {
                [self.numUrl addObject:[NSString stringWithFormat:@"%@%@",mosaicUrl,responseObject[@"data"][@"picture"][i]]];
            }
            
            self.weightNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"weight"]];
            
            self.imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64)];
            self.imageSV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
            self.imageSV.contentSize = CGSizeMake(kScreenW*self.numUrl.count, 0);
            self.imageSV.pagingEnabled = YES;
            [self.view addSubview:self.imageSV];
            self.imageSV.delegate = self;
            
            
            self.currentPage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenH - 100, kScreenW, 30)];
            self.currentPage.numberOfPages = self.numUrl.count;
            self.currentPage.tintColor = Main_Color;
            [self.view addSubview:self.currentPage];
            
            self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 70, 90, 40, 40)];
            [self.closeBtn setTitle:NSLocalizedString(@"GlobalBuyer_Close", nil) forState:UIControlStateNormal];
            self.closeBtn.layer.cornerRadius = 20;
            self.closeBtn.layer.borderWidth = 0.8;
            self.closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:self.closeBtn];
            [self.closeBtn addTarget:self action:@selector(closeInspectionImage) forControlEvents:UIControlEventTouchUpInside];
            
            self.weightLb = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, 150, 40)];
            self.weightLb.textColor = [UIColor whiteColor];
            self.weightLb.text = [NSString stringWithFormat:@"%@:%@KG",NSLocalizedString(@"GlobalBuyer_Order_Weight", nil),self.weightNum];
            self.weightLb.font = [UIFont systemFontOfSize:13];
            [self.view addSubview:self.weightLb];
            
            for (int i = 0; i < self.numUrl.count; i++) {
                UIImageView *imageIV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 140 + kScreenW*i, kScreenH/2 - 180, 280, 280)];
                [imageIV setContentMode:UIViewContentModeScaleAspectFit];
                imageIV.clipsToBounds = YES;
                [imageIV sd_setImageWithURL:self.numUrl[i] placeholderImage:[UIImage imageNamed:@"goods.png"]];
                [self.imageSV addSubview:imageIV];
            }
            
        }else{
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_Queryfailed", nil);
//            // Move to bottm center.
//            hud.offset = CGPointMake(0.f, 300.f);
//            [hud hideAnimated:YES afterDelay:3.f];
        
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_Queryfailed", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, 300.f);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
    

}

- (void)closeInspectionImage
{
    [self.imageSV removeFromSuperview];
    [self.closeBtn removeFromSuperview];
    [self.currentPage removeFromSuperview];
    [self.weightLb removeFromSuperview];
    
    self.imageSV = nil;
    self.closeBtn = nil;
    self.currentPage = nil;
    self.weightLb = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pages = scrollView.contentOffset.x/kScreenW ;
    self.currentPage.currentPage = pages;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tmparr = [self.dataSource[section] allKeys];
    
    return [self.dataSource[section][tmparr[0]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlreadyPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlreadyPayCell"];
    if (cell == nil) {
        cell = [[AlreadyPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlreadyPayCell"];
    }
    
    NSArray *tmparr = [self.dataSource[indexPath.section] allKeys];
    
    
    NSData *JSONData = [self.dataSource[indexPath.section][tmparr[0]][indexPath.row][@"body"] dataUsingEncoding:NSUTF8StringEncoding];
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
    cell.numLb.text = [NSString stringWithFormat:@"x%@",self.dataSource[indexPath.section][tmparr[0]][indexPath.row][@"quantity"]];
    cell.priceLb.text = [CurrencyCalculation getcurrencyCalculation:[self.dataSource[indexPath.section][tmparr[0]][indexPath.row][@"price"] floatValue] currentCommodityCurrency:responseJSON[@"currency"] numberOfGoods:[responseJSON[@"quantity"] floatValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.goodsId = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.section][tmparr[0]][indexPath.row][@"id"]];
    
    
    for (int i = 0; i < self.indexPathArr.count; i++) {
        if (indexPath.section == [self.indexPathArr[i] section]) {
            cell.btn.selected = YES;
            break;
        }else{
            cell.btn.selected = NO;
        }
    }
    
    if (self.pickLimitDataSource.count == 0) {
        cell.pickLimitV.hidden = YES;
    }else{
        for (int i = 0; i < self.pickLimitDataSource.count; i++) {
            for (int j = 0; j < [self.pickLimitDataSource[i] count]; j++) {
                if ([cell.goodsId isEqualToString:[NSString stringWithFormat:@"%@",self.pickLimitDataSource[i][j]]]) {
                    cell.pickLimitV.hidden = YES;
                    return cell;
                }else{
                    cell.pickLimitV.hidden = NO;
                }
            }
        }

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
    AlreadyPayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.pickLimitV.hidden == NO) {
        return;
    }
    
    NSArray *tmparr = [self.dataSource[indexPath.section] allKeys];

    
    if (cell.btn.selected == YES) {
        
        for (int i = 0; i < [self.dataSource[indexPath.section][tmparr[0]] count]; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            AlreadyPayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
            cell.btn.selected = NO;
            [self.packSource removeObject:self.dataSource[indexPath.section][tmparr[0]][i]];
            [self.indexPathArr removeObject:tmpIndexPath];
        }
        
        if (self.packSource.count == 0) {
            self.currentPick = nil;
            [self.pickLimitDataSource removeAllObjects];
            for (int i = 0 ; i < self.dataSource.count; i++) {
                NSArray *tmpRowArr = [self.dataSource[i] allKeys];
                for (int j = 0 ; j < [self.dataSource[i][tmpRowArr[0]] count]; j++) {
                    NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    AlreadyPayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
                    cell.pickLimitV.hidden = YES;
                }
            }
            [self.tableView reloadData];
        }
        
    }else{
        
        if (self.currentPick == nil || [self.currentPick isEqualToString:@""]) {
            self.currentPick = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.section][tmparr[0]][indexPath.row][@"id"]];
            [self getPickLimitWithGoodsId:self.currentPick];
        }else{
            for (int i = 0; i < [self.dataSource[indexPath.section][tmparr[0]] count]; i++) {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                AlreadyPayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
                cell.btn.selected = YES;
                [self.packSource addObject:self.dataSource[indexPath.section][tmparr[0]][i]];
                [self.indexPathArr addObject:tmpIndexPath];
            }
        }
        
        
        
    }


}

//打包限制检测
- (void)getPickLimitWithGoodsId:(NSString *)goodsId
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"payProductId":goodsId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PickLimitApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        [self.pickLimitDataSource removeAllObjects];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            self.storageCountry = responseObject[@"data"][@"storageArray"][@"storageCountry"];
            self.storageName = responseObject[@"data"][@"storageArray"][@"storageName"];
            self.storageNode = responseObject[@"data"][@"storageArray"][@"storageNode"];
            
            for (int i = 0; i < [responseObject[@"data"][@"productsArray"] count]; i++) {
                [self.pickLimitDataSource addObject:responseObject[@"data"][@"productsArray"][i]];
            }
  
            for (int i = 0; i < self.pickLimitDataSource.count; i++) {
                for (int j = 0; j < [self.pickLimitDataSource[i] count]; j++) {
                    if ([self.currentPick isEqualToString:[NSString stringWithFormat:@"%@",self.pickLimitDataSource[i][j]]]) {
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.pickLimitDataSource[i]];
                        NSLog(@"%@",arr);
                        for (int k = 0; k < arr.count; k++) {
                            for (int z = 0; z < self.dataSource.count; z++) {
                                NSArray *tmparr = [self.dataSource[z] allKeys];
                                for (int x = 0 ; x < [self.dataSource[z][tmparr[0]] count]; x++) {
                                    if (arr[k] == self.dataSource[z][tmparr[0]][x][@"id"]) {
                                        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:x inSection:z];
                                        AlreadyPayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
                                        cell.btn.selected = YES;
                                        [self.packSource addObject:self.dataSource[z][tmparr[0]][x]];
                                        [self.indexPathArr addObject:tmpIndexPath];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            [self.tableView reloadData];
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
