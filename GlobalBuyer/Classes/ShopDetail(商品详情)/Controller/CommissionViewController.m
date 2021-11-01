//
//  CommissionViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/13.
//  Copyright © 2017年 薛铭. All rights reserved.
//

#import "CommissionViewController.h"
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"
#import "LoadingView.h"
#import "FileArchiver.h"
#import "TariffDetailsViewController.h"


@interface CommissionViewController ()<UITextFieldDelegate>
{
    UILabel *commodityCostRightLb;
    NSString * yunfei;
}
@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,strong)UIScrollView *backSv;
@property (nonatomic,strong)UIView *titleBackV;
@property (nonatomic,strong)UIView *expenseListV;
@property (nonatomic,strong)UIView *firstPayV;
@property (nonatomic,strong)UIView *payDetailsV;
@property (nonatomic,strong)UIView *firstPayTotalV;
@property (nonatomic,strong)UILabel *firstPayTotalLb;
@property (nonatomic,strong)UIView *totalV;
@property (nonatomic,strong)UIView *secondPayV;
@property (nonatomic,strong)UIView *secondPayDetailsV;
@property (nonatomic,strong)UILabel *secondPayTotalLb;
@property (nonatomic,strong)UIView *noticeV;
@property (nonatomic,strong)UIView *whiteColorBackV;
@property (nonatomic,strong)UIView *btnBackV;
@property (nonatomic,strong)UILabel *sureLb;
@property (nonatomic,strong)UIView *closeBackV;
@property (nonatomic,strong)UIView *shopSourceBackV;
@property (nonatomic,strong)UIScrollView *categoryV;
@property (nonatomic,strong)UIView *categoryOneV;
@property (nonatomic,strong)UILabel *categoryOneLb;
@property (nonatomic,strong)UIView *categoryTwoV;
@property (nonatomic,strong)UILabel *categoryTwoLb;
@property (nonatomic,strong)UIView *categoryThreeV;
@property (nonatomic,strong)UILabel *categoryThreeLb;
@property (nonatomic,strong)UIView *categoryFourV;
@property (nonatomic,strong)UILabel *categoryFourLb;
@property (nonatomic,strong)UILabel *categoryDetailLb;
@property (nonatomic,strong)UIView *kgV;
@property (nonatomic,strong)UILabel *kgNumLb;
@property (nonatomic,assign)int categoryInt;
@property (nonatomic,assign)NSNumber *freightNum;
@property (nonatomic,strong)UILabel *commodityCostRightLb;
@property (nonatomic,strong)UILabel *totalLb;

@property (nonatomic,strong)UILabel *receivingAreaRightLb;
@property (nonatomic,strong)UIView *choiceCurrencyV;
@property (nonatomic,assign)NSInteger countryTag;

@property (nonatomic,strong)UIView *choiceWarehouseV;
@property (nonatomic,assign)NSInteger warehouseTag;

@property (nonatomic,strong)UIView *choiceShippingAreaV;
@property (nonatomic,assign)NSInteger shippingAreaTag;

@property (nonatomic,strong)LoadingView *loadingView;

@property (nonatomic,strong)UILabel *shippingAreaRightLb;
@property (nonatomic,strong)UILabel *loadingPlaceRightLb;
@property (nonatomic,strong)NSString *consignmentPlaceId;
@property (nonatomic,strong)NSString *loadingPlaceId;
@property (nonatomic,strong)NSString *receivingPlaceId;
@property (nonatomic,strong)NSMutableArray *countryArr;
@property (nonatomic,strong)NSMutableArray *warehouseArr;
@property (nonatomic,strong)NSMutableArray *searchWareHouseArr;

@property (nonatomic,strong)UILabel *freightRightLb;

@property (nonatomic,strong)NSString *RecordStr;

//服务费
@property (nonatomic,strong)NSString *serviceCharge;
//显示服务费
@property (nonatomic,strong)UILabel *purchasingRightLb;
//消费税
@property (nonatomic,strong)UILabel *secondPayDetailsRightLb;
//记录消费税
@property (nonatomic,strong)NSString *exciseTax;
@property (nonatomic,assign)BOOL isCreateUi;
@property (nonatomic,assign)BOOL isChoice;

@property (nonatomic,strong)UIButton *goodsminusBtn;
@property (nonatomic,strong)UILabel *numberLb;

@property (nonatomic,strong)UIView *changeGoodsNumV;
@property (nonatomic,strong)UITextField *firstTF;
@property (nonatomic,strong)UIButton *firstMBtn;
@property (nonatomic,strong)UIButton *firstABtn;

@property (nonatomic,strong)UIView *changeKgNumV;
@property (nonatomic,strong)UITextField *secondTF;
@property (nonatomic,strong)UIButton *secondMBtn;
@property (nonatomic,strong)UIButton *secondABtn;

@end

@implementation CommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BaiduMobStat defaultStat] logEvent:@"event6" eventLabel:@"[预算页面]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"預算頁面" parameters:nil];
    self.navigationItem.title = self.titleOfGoods;
    self.view.backgroundColor = Cell_BgColor;
    [self.loadingView startLoading];
    [self downloadMoneytype];
}

//初始化汇率数据源
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}

//初始化国家数据源
-(NSMutableArray *)countryArr
{
    if (_countryArr == nil) {
        _countryArr = [NSMutableArray new];
        NSArray *arr = [FileArchiver readFileArchiver:@"Country"];
        _countryArr = [NSMutableArray arrayWithArray:arr];
    }
    return _countryArr;
}

//初始化仓库数据源
-(NSMutableArray *)warehouseArr
{
    if (_warehouseArr == nil) {
        _warehouseArr = [NSMutableArray new];
    }
    return _warehouseArr;
}

-(NSMutableArray *)searchWareHouseArr
{
    if (_searchWareHouseArr == nil) {
        _searchWareHouseArr = [NSMutableArray new];
    }
    return _searchWareHouseArr;
}

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

//下载汇率
- (void)downloadMoneytype {
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

        [self downLoadSign];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downLoadSign
{
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"link":self.titleOfGoods};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:GetSignApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.nationalityStr = responseObject[@"data"][@"country"];
        }else{
            self.nationalityStr = @"";
        }
        
        
         [self downLoadServiceCharge];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取服务费
- (void)downLoadServiceCharge
{
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"isoShort":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetServiceCharge parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.serviceCharge = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"service"] floatValue]];
            self.purchasingRightLb.text = [CurrencyCalculation getcurrencyCalculation:[self.serviceCharge floatValue] currentCommodityCurrency:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"] numberOfGoods:1.0];
        }
        
        [self downLoadCountry];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}

//下载国家仓库
- (void)downLoadCountry
{
    self.totalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
    self.commodityCostRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
    self.secondPayDetailsRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
    self.firstPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
    self.secondPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
    
    for (int i = 0; i < self.countryArr.count; i ++) {
        if ([self.nationalityStr isEqualToString:self.countryArr[i][@"sign"]]) {
            self.consignmentPlaceId = self.countryArr[i][@"sign"];
        }
    }
    self.loadingPlaceId = @"";
    if (self.isChoice) {
        self.receivingPlaceId = [[NSUserDefaults standardUserDefaults]objectForKey:@"ReceiveCurrencySign"];
    }else{
        self.receivingPlaceId = [[NSUserDefaults standardUserDefaults]objectForKey:@"currencySign"];
    }
    
    NSDictionary *params;
    if (self.consignmentPlaceId) {
        params = @{@"api_id":API_ID,
                   @"api_token":TOKEN,
                   @"fromCountry":self.consignmentPlaceId,
                   @"toCountry":self.receivingPlaceId};
    }else{
        params = @{@"api_id":API_ID,
                   @"api_token":TOKEN,
                   @"fromCountry":@"",
                   @"toCountry":self.receivingPlaceId};
    }

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:WarehouseApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.warehouseArr removeAllObjects];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSDictionary *dataDic = responseObject[@"data"];
            

            if ([dataDic isKindOfClass:[NSDictionary class]]&&[[dataDic allKeys] containsObject:@"storages"]) {
                for (NSDictionary *dict in responseObject[@"data"][@"storages"]) {
                    [self.warehouseArr addObject:dict];
                }
                
            }else{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"數據請求失敗", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, 0.f);
                [hud hideAnimated:YES afterDelay:1.f];
                
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            
            for (int i = 0; i < self.warehouseArr.count ; i++) {
                if ([self.nationalityStr isEqualToString:self.warehouseArr[i][@"country"]]) {
                    self.loadingPlaceId = [NSString stringWithFormat:@"%@",self.warehouseArr[i][@"id"]];
                    self.RecordStr = self.warehouseArr[i][@"name"];
                    if ([self.warehouseArr[i][@"tax_radio"]isEqual: @1]) {
                        self.exciseTax = [NSString stringWithFormat:@"%.2f",[self.priceOfGoods floatValue]*[self.numberOfGoods floatValue]*[self.warehouseArr[i][@"tax_rate"] floatValue]];
                        self.secondPayDetailsRightLb.text = [NSString stringWithFormat:@"%@(%@%@)",[CurrencyCalculation getcurrencyCalculation:[self.exciseTax floatValue] currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:1.0],NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:[self.exciseTax floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:1.0]];
                    }else{
                        self.exciseTax = @"0";
                        self.secondPayDetailsRightLb.text = @"0";
                    }
                    
                    break;
                }
            }

        }
        
        [self.loadingView stopLoading];
        [self createUI];
        [self downLoadFreight];
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//
//        }];
        
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.loadingView stopLoading];
        [self createUI];
        [self downLoadFreight];
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//
//        }];
        
    }];

}



//计算运费
- (void)downLoadFreight
{

    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"fromCountry":self.consignmentPlaceId,
                             @"fromStorageId":self.loadingPlaceId,
                             @"toCountry":self.receivingPlaceId,
                             @"categoryId":@(self.categoryInt),
                             @"weight":self.kgNumLb.text,
                             @"currencyTo":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:CalculatedFreightApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSLog(@"%@,%@",[responseObject[@"data"] class],responseObject[@"data"]);
            self.freightNum = responseObject[@"data"];
            yunfei=[self.freightNum stringValue];
            
//            NSNumber *number = [NSNumber numberWithDoubleValue:responseObject[@"data"]];
            
            self.commodityCostRightLb.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:[self.freightNum floatValue] currentCommodityCurrency:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"] numberOfGoods:1.0]];
            
            NSString *tmpStr = NSLocalizedString(@"GlobalBuyer_Entrust_totalLb", nil);
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStr,[CurrencyCalculation calculationCurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue] freight:[self.freightNum floatValue] serviceCharge:[self.serviceCharge floatValue] exciseTax:[self.exciseTax floatValue]]]];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStr.length+1, [CurrencyCalculation calculationCurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue] freight:[self.freightNum floatValue] serviceCharge:[self.serviceCharge floatValue] exciseTax:[self.exciseTax floatValue]].length)];
            self.totalLb.attributedText = attStr;
            self.totalLb.textAlignment = NSTextAlignmentRight;
            self.totalLb.font = [UIFont systemFontOfSize:16];
            
            
            self.firstPayTotalLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue] freight:0 serviceCharge:[self.serviceCharge floatValue] exciseTax:[self.exciseTax floatValue]]];
            
            self.secondPayTotalLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:0 freight:[self.freightNum floatValue]  serviceCharge:0 exciseTax:0]];
            
            self.sureLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_btn", nil);
            self.btnBackV.userInteractionEnabled = YES;
            self.btnBackV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
            
        }else{
            self.sureLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
            self.btnBackV.userInteractionEnabled = NO;
            self.btnBackV.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
            self.firstPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
            self.secondPayDetailsRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
            self.commodityCostRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
            self.secondPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
            self.totalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
            self.totalLb.textAlignment = NSTextAlignmentRight;
            self.totalLb.font = [UIFont systemFontOfSize:16];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.sureLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        self.btnBackV.userInteractionEnabled = NO;
        self.btnBackV.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
        self.firstPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        self.secondPayDetailsRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        self.commodityCostRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        self.secondPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        self.totalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        self.totalLb.textAlignment = NSTextAlignmentRight;
        self.totalLb.font = [UIFont systemFontOfSize:16];
    }];
}

//创建UI画面
- (void)createUI
{
    if (self.isCreateUi) {
        
    }else{
        self.isCreateUi = YES;
        [self.view addSubview:self.backSv];
        [self.view addSubview:self.changeGoodsNumV];
        [self.view addSubview:self.changeKgNumV];
    }

}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}
//背景
- (UIScrollView *)backSv
{
    if (_backSv == nil) {
        _backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-NavBarHeight)];
        _backSv.contentSize = CGSizeMake(0, 1210);
        [_backSv addSubview:self.titleBackV];
        [_backSv addSubview:self.expenseListV];
        [_backSv addSubview:self.firstPayV];
        [_backSv addSubview:self.payDetailsV];
        [_backSv addSubview:self.firstPayTotalV];
        [_backSv addSubview:self.secondPayV];
        [_backSv addSubview:self.totalV];
        [_backSv addSubview:self.secondPayDetailsV];
        [_backSv addSubview:self.noticeV];
        [_backSv addSubview:self.whiteColorBackV];
        if ([self.source isEqualToString:@"shopCart"]) {
            [_backSv addSubview:self.shopSourceBackV];
        }else{
            
        }
        [_backSv addSubview:self.closeBackV];
    }
    return _backSv;
}

//头部商品信息
- (UIView *)titleBackV
{
    if (_titleBackV == nil) {
        _titleBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , [[UIScreen mainScreen] bounds].size.width, 120)];
        _titleBackV.backgroundColor = [UIColor whiteColor];
        //商品图片
        UIImageView *iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
         NSLog(@"self.pictureUrl =====> %@",self.pictureUrl);
    
        NSURL * url = [NSURL URLWithString:[self.pictureUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        NSLog(@"url =====> %@",url);
        [iconIV sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSLog(@"*****************%@",error);
        }];
        [_titleBackV addSubview:iconIV];
        //商品名字
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, [[UIScreen mainScreen] bounds].size.width - 180, 30)];
        nameLb.numberOfLines = 0;
        nameLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        nameLb.font = [UIFont systemFontOfSize:12];
        nameLb.text = self.nameOfGoods;
        [_titleBackV addSubview:nameLb];
        //商品副标题
        UILabel *attributesLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, [[UIScreen mainScreen] bounds].size.width - 180, 30)];
        attributesLb.numberOfLines = 0;
        attributesLb.font = [UIFont systemFontOfSize:10];
        attributesLb.text = self.attributesOfGoods;
        [attributesLb sizeToFit];
        attributesLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        [_titleBackV addSubview:attributesLb];
        //商品个数
        self.numberLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 80, 75, 40, 40)];
        self.numberLb.userInteractionEnabled = YES;
        self.numberLb.font = [UIFont systemFontOfSize:17];
        UITapGestureRecognizer *numTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNumV)];
        numTap.numberOfTapsRequired = 1;
        numTap.numberOfTouchesRequired = 1;
        [self.numberLb addGestureRecognizer:numTap];
        if ([self.titleOfGoods isEqualToString:@"1688"]) {
            self.numberLb.text = [NSString stringWithFormat:@"%@",self.tureNumberOfGoods];
        }else{
            self.numberLb.text = [NSString stringWithFormat:@"%@",self.numberOfGoods];
        }
        self.numberLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.numberLb.textAlignment = NSTextAlignmentCenter;
        [_titleBackV addSubview:self.numberLb];
        
        self.goodsminusBtn = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 100, 87, 17, 17)];
        [self.goodsminusBtn setImage:[UIImage imageNamed:@"ic_minus"] forState:UIControlStateNormal];
        [self.goodsminusBtn setImage:[UIImage imageNamed:@"ic_minus_enabled"] forState:UIControlStateSelected];
        [_titleBackV addSubview:self.goodsminusBtn];
        if ([self.numberLb.text intValue] <= 1) {
            self.goodsminusBtn.selected = YES;
        }
        [self.goodsminusBtn addTarget:self action:@selector(goodsNumMinus:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 40, 87, 17, 17)];
        [addBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [_titleBackV addSubview:addBtn];
        [addBtn addTarget:self action:@selector(goodsNumAdd) forControlEvents:UIControlEventTouchUpInside];
        if ([self.titleOfGoods isEqualToString:@"1688"]) {
            self.numberLb.userInteractionEnabled = NO;
            self.goodsminusBtn.userInteractionEnabled = NO;
            addBtn.userInteractionEnabled = NO;
        }else{
            self.numberLb.userInteractionEnabled = YES;
            self.goodsminusBtn.userInteractionEnabled = YES;
            addBtn.userInteractionEnabled = YES;
        }
        //商品价格
        UILabel *priceLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 80, 200, 28)];
        if ([self.priceOfGoods length] <= 0){
            priceLb.text = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"GlobalBuyer_Entrust_Artificial", nil),NSLocalizedString(@"GlobalBuyer_Entrust_ArtificialLiaison", nil)];
            priceLb.font = [UIFont systemFontOfSize:10];
            priceLb.numberOfLines = 0;
        }else{
            priceLb.text = [NSString stringWithFormat:@"%@%0.2f", self.moneyTypeOfGoods,[self.priceOfGoods floatValue]];
//            [CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberOfGoods floatValue]];
            priceLb.font = [UIFont systemFontOfSize:15];
        }

        priceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        
        [_titleBackV addSubview:priceLb];
    }
    return _titleBackV;
}

- (void)goodsNumMinus:(UIButton *)btn{
    if (btn.selected == YES) {
        return;
    }
    self.numberLb.text = [NSString stringWithFormat:@"%d",[self.numberLb.text intValue]-1];
    if ([self.numberLb.text intValue] <= 1) {
        btn.selected = YES;
    }
    
    [self update];
}

- (void)goodsNumAdd{
    if ([self.numberLb.text intValue] >= 100) {
        return;
    }
    self.numberLb.text = [NSString stringWithFormat:@"%d",[self.numberLb.text intValue]+1];
    if ([self.numberLb.text intValue] > 1) {
        self.goodsminusBtn.selected = NO;
    }
    
    [self update];
}

- (void)showNumV{
    self.changeGoodsNumV.hidden = NO;
}

- (UIView *)changeGoodsNumV{
    if (_changeGoodsNumV == nil) {
        _changeGoodsNumV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _changeGoodsNumV.hidden = YES;
        _changeGoodsNumV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(30, kScreenH/2 - 100, kScreenW - 60, 200)];
        conV.backgroundColor = [UIColor whiteColor];
        [_changeGoodsNumV addSubview:conV];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, conV.frame.size.width, 70)];
        title.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_EntrustNum", nil);
        title.font = [UIFont systemFontOfSize:17];
        title.textAlignment = NSTextAlignmentCenter;
        [conV addSubview:title];
        
//        @property (nonatomic,strong)UITextField *firstTF;
//        @property (nonatomic,strong)UIButton *firstMBtn;
//        @property (nonatomic,strong)UIButton *firstABtn;
        
        UIView *kV = [[UIView alloc]initWithFrame:CGRectMake(40, 75, conV.frame.size.width - 80, 50)];
        kV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        kV.layer.borderWidth = 0.7;
        [conV addSubview:kV];
        
        
        self.firstMBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self.firstMBtn setImage:[UIImage imageNamed:@"ic_minus"] forState:UIControlStateNormal];
        [self.firstMBtn setImage:[UIImage imageNamed:@"ic_minus_enabled"] forState:UIControlStateSelected];
        [kV addSubview:self.firstMBtn];
        if ([self.numberLb.text intValue] <= 1) {
            self.firstMBtn.selected = YES;
        }
        [self.firstMBtn addTarget:self action:@selector(congoodsNumMinus:) forControlEvents:UIControlEventTouchUpInside];
        
        self.firstABtn = [[UIButton alloc]initWithFrame:CGRectMake(kV.frame.size.width - 40, 10, 30, 30)];
        [self.firstABtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [kV addSubview:self.firstABtn];
        [self.firstABtn addTarget:self action:@selector(congoodsNumAdd) forControlEvents:UIControlEventTouchUpInside];
        
        self.firstTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, kV.frame.size.width - 100, 50)];
        self.firstTF.textAlignment = NSTextAlignmentCenter;
        self.firstTF.text = self.numberLb.text;
        self.firstTF.keyboardType = UIKeyboardTypeNumberPad;
        self.firstTF.delegate = self;
        [kV addSubview:self.firstTF];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, conV.frame.size.width/2, 50)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [conV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelChangeGoodsNum) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(conV.frame.size.width/2, 150, conV.frame.size.width/2, 50)];
        sureBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [conV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureChangeGoodsNum) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeGoodsNumV;
}

- (void)cancelChangeGoodsNum{
    self.changeGoodsNumV.hidden = YES;
}

- (void)sureChangeGoodsNum{
    if ([self.firstTF.text intValue] > 1) {
        self.goodsminusBtn.selected = NO;
    }
    self.numberLb.text = self.firstTF.text;
    self.changeGoodsNumV.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[NSString stringWithFormat:@"%@%@",textField.text,string] intValue] > 100) {
        textField.text = @"100";
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"最多100!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, 0.f);
        [hud hideAnimated:YES afterDelay:1.f];
        return NO;
    }
    return YES;
}

- (void)congoodsNumMinus:(UIButton *)btn{
    if (btn.selected == YES) {
        return;
    }
    self.firstTF.text = [NSString stringWithFormat:@"%d",[self.firstTF.text intValue]-1];
    if ([self.firstTF.text intValue] <= 1) {
        btn.selected = YES;
    }
}

- (void)congoodsNumAdd{
    if ([self.firstTF.text intValue] >= 100) {
        return;
    }
    self.firstTF.text = [NSString stringWithFormat:@"%d",[self.firstTF.text intValue]+1];
    if ([self.firstTF.text intValue] > 1) {
        self.firstMBtn.selected = NO;
    }
}

//费用清单标题
- (UIView *)expenseListV
{
    if (_expenseListV == nil) {
        _expenseListV = [[UIView alloc]initWithFrame:CGRectMake(0,self.titleBackV.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 50)];
        //_expenseListV.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:241.0/255.0 blue:208.0/255.0 alpha:1];
        _expenseListV.backgroundColor = [UIColor blackColor];
        UILabel *expenseListLb = [[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width)/2 - 80, 0, 160, 50)];
        expenseListLb.textAlignment = NSTextAlignmentCenter;
        expenseListLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_expenseListLb", nil);
        expenseListLb.font = [UIFont systemFontOfSize:22 weight:2];
        //expenseListLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        expenseListLb.textColor = [UIColor whiteColor];
        [_expenseListV addSubview:expenseListLb];
    }
    return _expenseListV;
}

//首次支付费用
- (UIView *)firstPayV
{
    if (_firstPayV == nil) {
        _firstPayV = [[UIView alloc]initWithFrame:CGRectMake(0, self.expenseListV.frame.origin.y + self.expenseListV.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 55)];
        _firstPayV.backgroundColor = [UIColor whiteColor];
        UILabel *firstPayLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,  [[UIScreen mainScreen] bounds].size.width - 40, 45)];
        firstPayLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_firstPayLb", nil);
        firstPayLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        firstPayLb.font = [UIFont systemFontOfSize:18 weight:2];
        [_firstPayV addSubview:firstPayLb];
    }
    return _firstPayV;
}

//支付详情
- (UIView *)payDetailsV
{
    if (_payDetailsV == nil) {
        _payDetailsV = [[UIView alloc]initWithFrame:CGRectMake(0, self.firstPayV.frame.origin.y + self.firstPayV.frame.size.height + 1, [[UIScreen mainScreen] bounds].size.width, 114)];
        _payDetailsV.backgroundColor = [UIColor whiteColor];
        //商品费用title
        UILabel *commodityCostLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 200, 30)];
        commodityCostLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_commodityCostLb", nil);
        commodityCostLb.font = [UIFont systemFontOfSize:16];
        commodityCostLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [_payDetailsV addSubview:commodityCostLb];
        //商品价格右侧price
        commodityCostRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 300, 8, 290, 30)];
        if ([self.priceOfGoods length] <= 0) {
            commodityCostRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Artificial", nil);
        }else{
            commodityCostRightLb.text = [NSString stringWithFormat:@"%@(%@%@)",[CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberOfGoods floatValue]],NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberOfGoods floatValue]]];
        }

        commodityCostRightLb.font = [UIFont systemFontOfSize:13];
        commodityCostRightLb.textAlignment = NSTextAlignmentRight;
        commodityCostRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [_payDetailsV addSubview:commodityCostRightLb];
        //代购费
        UILabel *purchasingLb = [[UILabel alloc]initWithFrame:CGRectMake(10, commodityCostLb.frame.size.height + commodityCostLb.frame.origin.y , 200, 30)];
        purchasingLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_purchasingLb", nil);
        purchasingLb.font = [UIFont systemFontOfSize:16];
        purchasingLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [_payDetailsV addSubview:purchasingLb];
        //代购价格右侧10元人民币
        self.purchasingRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, commodityCostLb.frame.size.height + commodityCostLb.frame.origin.y, 210, 30)];
//        purchasingRightLb.text = [NSString stringWithFormat:@"￥10.00(%@%@)",NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:10.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:@"CNY" numberOfGoods:1]];
        self.purchasingRightLb.text = [CurrencyCalculation getcurrencyCalculation:[self.serviceCharge floatValue] currentCommodityCurrency:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"] numberOfGoods:1.0];
        self.purchasingRightLb.textAlignment = NSTextAlignmentRight;
        self.purchasingRightLb.font = [UIFont systemFontOfSize:13];
        self.purchasingRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [_payDetailsV addSubview:self.purchasingRightLb];
//        //预付1公斤运费
//        UILabel *freightLb = [[UILabel alloc]initWithFrame:CGRectMake(10, purchasingLb.frame.origin.y + purchasingLb.frame.size.height, 200, 30)];
//        freightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_freightLb", nil);
//        freightLb.font = [UIFont systemFontOfSize:16];
//        freightLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
//        [_payDetailsV addSubview:freightLb];
//        //预付1公斤运费右侧
//        UILabel *freightRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, purchasingRightLb.frame.origin.y + purchasingRightLb.frame.size.height , 200, 30)];
//        freightRightLb.text = @"0";
//        freightRightLb.textAlignment = NSTextAlignmentRight;
//        freightRightLb.font = [UIFont systemFontOfSize:16];
//        freightRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
//        [_payDetailsV addSubview:freightRightLb];
//        //支付手续费
//        UILabel *serviceChargeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, freightLb.frame.origin.y+freightLb.frame.size.height, 200, 30)];
//        serviceChargeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_serviceChargeLb", nil);
//        serviceChargeLb.font = [UIFont systemFontOfSize:16];
//        serviceChargeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
//        [_payDetailsV addSubview:serviceChargeLb];
//        //支付手续费右侧
//        UILabel *serviceChargeRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, freightRightLb.frame.origin.y + freightRightLb.frame.size.height , 200, 30)];
//        serviceChargeRightLb.text = @"0";
//        serviceChargeRightLb.textAlignment = NSTextAlignmentRight;
//        serviceChargeRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
//        serviceChargeRightLb.font = [UIFont systemFontOfSize:16];
//        [_payDetailsV addSubview:serviceChargeRightLb];
        

        
        //商品税金
        UILabel *secondPayDetailsLb = [[UILabel alloc]initWithFrame:CGRectMake(10, purchasingLb.frame.origin.y+ purchasingLb.frame.size.height, 200, 30)];
        secondPayDetailsLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayDetailsLb", nil);
        secondPayDetailsLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        secondPayDetailsLb.font = [UIFont systemFontOfSize:16];
        [_payDetailsV addSubview:secondPayDetailsLb];
        //商品税金右侧
        self.secondPayDetailsRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, purchasingLb.frame.origin.y+ purchasingLb.frame.size.height, 210, 30)];
        if (self.exciseTax) {
            self.secondPayDetailsRightLb.text = [NSString stringWithFormat:@"%@(%@%@)",[CurrencyCalculation getcurrencyCalculation:([self.exciseTax floatValue] * [self.numberOfGoods floatValue]) currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:1.0],NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:([self.exciseTax floatValue] * [self.numberOfGoods floatValue]) moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:1.0]];
            self.secondPayDetailsRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        }else{
            self.secondPayDetailsRightLb.text = @"0";
            self.secondPayDetailsRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        }

        
        if ([self.priceOfGoods length] <= 0){
            self.secondPayDetailsRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Artificial", nil);
            self.secondPayDetailsRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        }
        
        self.secondPayDetailsRightLb.font = [UIFont systemFontOfSize:13];
        self.secondPayDetailsRightLb.textAlignment = NSTextAlignmentRight;
        [_payDetailsV addSubview:self.secondPayDetailsRightLb];
    }
    return _payDetailsV;
}

//首次费用合计
- (UIView *)firstPayTotalV
{
    if (_firstPayTotalV == nil) {
        _firstPayTotalV = [[UIView alloc]initWithFrame:CGRectMake(0, self.payDetailsV.frame.origin.y + self.payDetailsV.frame.size.height + 1, [[UIScreen mainScreen] bounds].size.width, 100)];
        _firstPayTotalV.backgroundColor = [UIColor whiteColor];
        self.firstPayTotalLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, 10, 210, 35)];
        self.firstPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
        self.firstPayTotalLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.firstPayTotalLb.textAlignment = NSTextAlignmentRight;
        [_firstPayTotalV addSubview:self.firstPayTotalLb];
        [_firstPayTotalV addSubview:self.btnBackV];
    }
    return _firstPayTotalV;
}

//第2阶段费用
- (UIView *)secondPayV
{
    if (_secondPayV == nil) {
        _secondPayV = [[UIView alloc]initWithFrame:CGRectMake(0, self.firstPayTotalV.frame.origin.y + self.firstPayTotalV.frame.size.height + 1, [[UIScreen mainScreen] bounds].size.width, 55)];
        _secondPayV.backgroundColor = [UIColor whiteColor];
        //第2阶段费用标题
        UILabel *secondPayLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,  [[UIScreen mainScreen] bounds].size.width - 40, 45)];
        secondPayLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayLb", nil);
        secondPayLb.font = [UIFont systemFontOfSize:18 weight:2];
        secondPayLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [_secondPayV addSubview:secondPayLb];
        //第2阶段费用右侧
        UILabel *secondPayRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, 15, 210, 25)];
        secondPayRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayRightLb", nil);
        secondPayRightLb.font = [UIFont systemFontOfSize:14];
        secondPayRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        secondPayRightLb.textAlignment = NSTextAlignmentRight;
        [_secondPayV addSubview:secondPayRightLb];
    }
    return _secondPayV;
}

//第2阶段费用详情
- (UIView *)secondPayDetailsV
{
    if (_secondPayDetailsV == nil) {
        _secondPayDetailsV = [[UIView alloc]initWithFrame:CGRectMake(0, self.secondPayV.frame.origin.y + self.secondPayV.frame.size.height + 1,  [[UIScreen mainScreen] bounds].size.width, 128 + 65 + 170 + 60 + 40)];
        _secondPayDetailsV.backgroundColor = [UIColor whiteColor];

        //当地运费
        UILabel *purchasingLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 8 , 200, 30)];
        purchasingLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_purchasingLb_2", nil);
        purchasingLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        purchasingLb.font = [UIFont systemFontOfSize:16];
        [_secondPayDetailsV addSubview:purchasingLb];
        //当地运费右侧
        UILabel *purchasingRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, 8, 210, 30)];
        purchasingRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayDetailsRightLb", nil);
        purchasingRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        purchasingRightLb.textAlignment = NSTextAlignmentRight;
        purchasingRightLb.font = [UIFont systemFontOfSize:14];
        [_secondPayDetailsV addSubview:purchasingRightLb];
        //关税
        UILabel *freightLb = [[UILabel alloc]initWithFrame:CGRectMake(10, purchasingLb.frame.origin.y + purchasingLb.frame.size.height, 200, 30)];
        freightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_freightLb_2", nil);
        freightLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        freightLb.font = [UIFont systemFontOfSize:16];
        [_secondPayDetailsV addSubview:freightLb];
        //关税右侧
        self.freightRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, purchasingRightLb.frame.origin.y + purchasingRightLb.frame.size.height , 210, 30)];//182
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]isEqualToString:@"CNY"]) {
            self.freightRightLb.userInteractionEnabled = YES;
            
            //self.freightRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_ChinaFreight", nil);
            
            NSString *agreementStr = NSLocalizedString(@"GlobalBuyer_Entrust_Category_ChinaFreight", nil);
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",agreementStr]];
            NSRange range = NSMakeRange(0, agreementStr.length);
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            self.freightRightLb.attributedText = content;
        }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]isEqualToString:@"TWD"]){
            self.freightRightLb.userInteractionEnabled = YES;
            //            self.freightRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_TWFreight", nil);
            
            NSString *agreementStr = NSLocalizedString(@"GlobalBuyer_Entrust_Category_TWFreight", nil);
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",agreementStr]];
            NSRange range = NSMakeRange(0, agreementStr.length);
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            self.freightRightLb.attributedText = content;
        }else{
            self.freightRightLb.userInteractionEnabled = NO;
            self.freightRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
        }
        self.freightRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.freightRightLb.textAlignment = NSTextAlignmentRight;
        self.freightRightLb.font = [UIFont systemFontOfSize:14];
        [_secondPayDetailsV addSubview:self.freightRightLb];
        //关税解释
//        UIImageView *helpFreightIv = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 34, purchasingRightLb.frame.origin.y + purchasingRightLb.frame.size.height + 3, 24, 24)];
//        helpFreightIv.image = [UIImage imageNamed:@"tabBar_help"];
//        helpFreightIv.userInteractionEnabled = YES;
//        [_secondPayDetailsV addSubview:helpFreightIv];
        UITapGestureRecognizer *helpFreightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpFreight)];
        helpFreightTap.numberOfTapsRequired = 1;
        helpFreightTap.numberOfTouchesRequired = 1;
        [self.freightRightLb addGestureRecognizer:helpFreightTap];
        
        //选择公斤
        self.kgV.frame = CGRectMake( kScreenW - 100 , freightLb.frame.origin.y + freightLb.frame.size.height + 2, 90, 25);
        [_secondPayDetailsV addSubview:self.kgV];
        //预估重量（kg）
        UILabel *estimateLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.kgV.frame.origin.y , 200, 30)];
        estimateLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Estimatedweight", nil);
        estimateLb.font = [UIFont systemFontOfSize:16];
        estimateLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [_secondPayDetailsV addSubview:estimateLb];
        //国际运费
        UILabel *commodityCostLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.kgV.frame.size.height + self.kgV.frame.origin.y + 5, 120, 30)];
        commodityCostLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_commodityCostLb_2", nil);
        commodityCostLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        commodityCostLb.font = [UIFont systemFontOfSize:16];
        [_secondPayDetailsV addSubview:commodityCostLb];
        
        //发货地区
        UILabel *shippingAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(10, commodityCostLb.frame.origin.y + commodityCostLb.frame.size.height , 120, 30)];
        shippingAreaLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_shippingAreaLb", nil);
        shippingAreaLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        shippingAreaLb.font = [UIFont systemFontOfSize:16];
        [_secondPayDetailsV addSubview:shippingAreaLb];
        //发货地区右侧
        self.shippingAreaRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 170, commodityCostLb.frame.origin.y + commodityCostLb.frame.size.height + 3, 160, 24)];
        self.shippingAreaRightLb.text = NSLocalizedString(@"GlobalBuyer_Currency_area", nil);
        
        for (int i = 0; i < self.countryArr.count; i ++) {
            if ([self.nationalityStr isEqualToString:self.countryArr[i][@"sign"]]) {
                self.shippingAreaRightLb.text = self.countryArr[i][@"name"];
                self.consignmentPlaceId = self.countryArr[i][@"sign"];
            }
        }
        self.shippingAreaTag = 3000;
        if ([self.shippingAreaRightLb.text isEqualToString:NSLocalizedString(@"GlobalBuyer_Currency_area", nil)]) {
            self.shippingAreaRightLb.userInteractionEnabled = YES;
        }
        self.shippingAreaRightLb.font = [UIFont systemFontOfSize:14];
        self.shippingAreaRightLb.textAlignment = NSTextAlignmentRight;
//        self.shippingAreaRightLb.layer.borderColor = Main_Color.CGColor;
//        self.shippingAreaRightLb.layer.borderWidth = 0.5;
        //self.shippingAreaRightLb.layer.cornerRadius = 3;
        self.shippingAreaRightLb.textColor =  [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [_secondPayDetailsV addSubview:self.shippingAreaRightLb];
        UITapGestureRecognizer *shippingAreaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShippingArea)];
        shippingAreaTap.numberOfTapsRequired = 1;
        shippingAreaTap.numberOfTouchesRequired = 1;
        [self.shippingAreaRightLb addGestureRecognizer:shippingAreaTap];
        
//        //集货地区
//        UILabel *loadingPlaceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, shippingAreaLb.frame.origin.y + shippingAreaLb.frame.size.height, 120, 30)];
//        loadingPlaceLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_loadingPlaceLb", nil);
//        loadingPlaceLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
//        loadingPlaceLb.font = [UIFont systemFontOfSize:16];
//        [_secondPayDetailsV addSubview:loadingPlaceLb];
//        //集货地右侧
//        self.loadingPlaceRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 170, self.shippingAreaRightLb.frame.origin.y + self.shippingAreaRightLb.frame.size.height + 6, 150, 24)];
//        self.loadingPlaceRightLb.font = [UIFont systemFontOfSize:14];
//        self.loadingPlaceRightLb.textAlignment = NSTextAlignmentCenter;
//        self.loadingPlaceRightLb.layer.borderColor = Main_Color.CGColor;
//        //self.loadingPlaceRightLb.layer.cornerRadius = 3;
//        self.loadingPlaceRightLb.layer.borderWidth = 0.5;
//        if ([self.loadingPlaceId isEqualToString:@""]) {
//            self.loadingPlaceRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_loadingPlaceRightLb", nil);
//        }else{
//            self.loadingPlaceRightLb.text = self.RecordStr;
//        }
//        self.loadingPlaceRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
//        self.loadingPlaceRightLb.userInteractionEnabled = YES;
//        [_secondPayDetailsV addSubview:self.loadingPlaceRightLb];
//        UITapGestureRecognizer *tapLoadingP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectLoadingPlace)];
//        tapLoadingP.numberOfTapsRequired = 1;
//        tapLoadingP.numberOfTouchesRequired = 1;
//        [self.loadingPlaceRightLb addGestureRecognizer:tapLoadingP];
        
        //收货地区
        UILabel *receivingAreaLb = [[UILabel alloc]initWithFrame:CGRectMake(10, shippingAreaLb.frame.origin.y + shippingAreaLb.frame.size.height , 120, 30)];
        receivingAreaLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_receivingAreaLb", nil);
        receivingAreaLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        receivingAreaLb.font = [UIFont systemFontOfSize:16];
        [_secondPayDetailsV addSubview:receivingAreaLb];
        //收货地右侧
        self.receivingAreaRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 170, shippingAreaLb.frame.origin.y + shippingAreaLb.frame.size.height + 3, 160, 24)];
        self.receivingAreaRightLb.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"];
//        self.receivingAreaRightLb.layer.borderWidth = 0.5;
        //self.receivingAreaRightLb.layer.cornerRadius = 3;
        self.receivingAreaRightLb.userInteractionEnabled = YES;
//        self.receivingAreaRightLb.layer.borderColor = Main_Color.CGColor;
        self.receivingAreaRightLb.textAlignment = NSTextAlignmentRight;
        self.receivingAreaRightLb.font = [UIFont systemFontOfSize:14];
        self.receivingAreaRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.receivingPlaceId = [[NSUserDefaults standardUserDefaults]objectForKey:@"currencySign"];
        [_secondPayDetailsV addSubview:self.receivingAreaRightLb];
//        UITapGestureRecognizer *tapAREA = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAREA)];
//        tapAREA.numberOfTapsRequired = 1;
//        tapAREA.numberOfTouchesRequired = 1;
//        [self.receivingAreaRightLb addGestureRecognizer:tapAREA];
        
        //选择品类文字
        UILabel *categoryLb = [[UILabel alloc]initWithFrame:CGRectMake(10, commodityCostLb.frame.origin.y + commodityCostLb.frame.size.height + 60 , kScreenW - 20, 30)];
        categoryLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_categoryLb", nil);
        categoryLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        categoryLb.font = [UIFont systemFontOfSize:16];
        [_secondPayDetailsV addSubview:categoryLb];
        //选择品类
        self.categoryV.frame = CGRectMake(10,  commodityCostLb.frame.origin.y + commodityCostLb.frame.size.height + 65 + 30 , kScreenW - 20, 130);
        self.categoryInt = 1;
        [_secondPayDetailsV addSubview:self.categoryV];
        //国际运费（kg）右侧
        self.commodityCostRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, self.kgV.frame.size.height + self.kgV.frame.origin.y + 5, 210, 30)];
        self.commodityCostRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
        self.commodityCostRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.commodityCostRightLb.font = [UIFont systemFontOfSize:14];
        self.commodityCostRightLb.textAlignment = NSTextAlignmentRight;
        [_secondPayDetailsV addSubview:self.commodityCostRightLb];
        
        //选择品类提示
        UILabel *categoryNoticeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.categoryV.frame.origin.y + self.categoryV.frame.size.height + 5, kScreenW - 20, 30)];
        categoryNoticeLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        categoryNoticeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_categoryNoticeLb", nil);
        categoryNoticeLb.numberOfLines = 0;
        categoryNoticeLb.font = [UIFont systemFontOfSize:12];
        [_secondPayDetailsV addSubview:categoryNoticeLb];
        
//        //支付手续费
//        UILabel *serviceChargeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, commodityCostLb.frame.origin.y+commodityCostLb.frame.size.height + 137 + 65 + 60, 200, 30)];
//        serviceChargeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_serviceChargeLb_2", nil);
//        serviceChargeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
//        serviceChargeLb.font = [UIFont systemFontOfSize:16];
//        [_secondPayDetailsV addSubview:serviceChargeLb];
//        //支付手续费右侧
//        UILabel *serviceChargeRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, commodityCostLb.frame.origin.y+commodityCostLb.frame.size.height + 137 + 65 + 60, 210, 30)];
//        serviceChargeRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_serviceChargeRightLb", nil);
//        serviceChargeRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
//        serviceChargeRightLb.textAlignment = NSTextAlignmentRight;
//        serviceChargeRightLb.font = [UIFont systemFontOfSize:14];
//        [_secondPayDetailsV addSubview:serviceChargeRightLb];

        
        self.secondPayTotalLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, commodityCostLb.frame.origin.y+commodityCostLb.frame.size.height + 137 + 65 + 60 + 30, 210, 30)];
        self.secondPayTotalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
        self.secondPayTotalLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        self.secondPayTotalLb.textAlignment = NSTextAlignmentRight;
        [_secondPayDetailsV addSubview:self.secondPayTotalLb];
        
        [self downLoadFreight];
    }
    return _secondPayDetailsV;
}

//查看关税帮助
- (void)helpFreight
{
    TariffDetailsViewController *tariffDetailsVC = [[TariffDetailsViewController alloc]init];
    [self.navigationController pushViewController:tariffDetailsVC animated:YES];
}


//添加选择发货地视图
- (void)selectShippingArea
{
    [self.view addSubview:self.choiceShippingAreaV];
}

//创建发货地区视图
- (UIView *)choiceShippingAreaV
{
    if (_choiceShippingAreaV == nil) {
        _choiceShippingAreaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _choiceShippingAreaV.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
        UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 160, 300, 320)];
        iv.backgroundColor = [UIColor whiteColor];
        [_choiceShippingAreaV addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300 - 40, 40)];
        lb.text = NSLocalizedString(@"GlobalBuyer_Currency_area", nil);
        lb.textColor = Main_Color;
        lb.font = [UIFont systemFontOfSize:22 weight:2];
        lb.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lb];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 70, 300 - 30, 1)];
        line.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [iv addSubview:line];
        
        UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 80, 270, 165)];
        backSv.contentSize = CGSizeMake(0, self.countryArr.count/2*70);
        [iv addSubview:backSv];
        
        for (int i = 0; i < self.countryArr.count; i++) {
            UIView *backIv = [[UIView alloc]initWithFrame:CGRectMake(10 + 15 * (i%2) + (i%2) * 115, 10 + ((i/2) * 50), 120, 40)];
            backIv.tag = 3000 + i;
            [backSv addSubview:backIv];
            UILabel *countryLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 110, 30)];
            countryLb.textColor = Main_Color;
            NSArray *strArr = [self.countryArr[i][@"name"] componentsSeparatedByString:@" "];
            countryLb.text = strArr[0];
            countryLb.font = [UIFont systemFontOfSize:14];
            countryLb.textAlignment = NSTextAlignmentCenter;
            [backIv addSubview:countryLb];
            if (i == 0) {
                backIv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
                for (int j = 0 ; j < self.warehouseArr.count; j++) {
                    if ([self.countryArr[0][@"sign"]isEqualToString:self.warehouseArr[j][@"country"]]) {
                        self.loadingPlaceId = [NSString stringWithFormat:@"%@",self.warehouseArr[j][@"id"]];
                        break;
                    }
                }

            }else{
                backIv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectShippingArea:)];
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
        [sureBtn addTarget:self action:@selector(sureShippingArea) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceShippingAreaV;
}

//选择国家时改变选中状态
- (void)selectShippingArea:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < self.countryArr.count; i++) {
        UIView *iv = (UIView *)[self.choiceShippingAreaV viewWithTag:i + 3000];
        if (iv.tag == [tap view].tag) {
            iv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.shippingAreaTag = [tap view].tag;
        }else{
            iv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}

//确定发货地后改变ID刷新仓库
- (void)sureShippingArea
{
    self.shippingAreaRightLb.text = self.countryArr[self.shippingAreaTag - 3000][@"name"];
    self.consignmentPlaceId = self.countryArr[self.shippingAreaTag - 3000][@"sign"];

    for (int i = 0; i < self.warehouseArr.count; i++) {
        if ([self.consignmentPlaceId isEqualToString:self.warehouseArr[i][@"country"]]) {
            self.loadingPlaceRightLb.text = self.warehouseArr[i][@"name"];
            self.loadingPlaceId = [NSString stringWithFormat:@"%@",self.warehouseArr[i][@"id"]];
            break;
        }
        self.loadingPlaceRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_loadingPlaceRightLb", nil);
        
    }
    [self.searchWareHouseArr removeAllObjects];
    [self.choiceShippingAreaV removeFromSuperview];
    [self downLoadFreight];
}

//添加集货地选择视图
- (void)selectLoadingPlace
{
    [self.view addSubview:self.choiceWarehouseV];
}

//集货地视图
-(UIView *)choiceWarehouseV
{
    if (_choiceWarehouseV == nil) {
        _choiceWarehouseV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _choiceWarehouseV.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
        UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 160, 300, 320)];
        iv.backgroundColor = [UIColor whiteColor];
        [_choiceWarehouseV addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300 - 40, 40)];
        lb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_selectArea", nil);
        lb.textColor = Main_Color;
        lb.font = [UIFont systemFontOfSize:22 weight:2];
        lb.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lb];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 70, 300 - 30, 1)];
        line.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [iv addSubview:line];
        
        UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 80, 270, 165)];
        backSv.contentSize = CGSizeMake(0, 0);
        [iv addSubview:backSv];
        
        
        
        for (int i = 0 ; i < self.warehouseArr.count; i++) {
            if ([self.consignmentPlaceId isEqualToString:self.warehouseArr[i][@"country"]]) {
                [self.searchWareHouseArr addObject:self.warehouseArr[i]];
            }
        }
        
        for (int i = 0; i < self.searchWareHouseArr.count; i++) {
            UIView *backIv = [[UIView alloc]initWithFrame:CGRectMake(10 + 15 * (i%2) + (i%2) * 115, 10 + ((i/2) * 50), 120, 40)];
            backIv.tag = 2000 + i;
            [backSv addSubview:backIv];
            UILabel *countryLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 110, 30)];
            countryLb.textColor = Main_Color;
            countryLb.text = self.searchWareHouseArr[i][@"name"];
            countryLb.font = [UIFont systemFontOfSize:14];
            countryLb.textAlignment = NSTextAlignmentCenter;
            [backIv addSubview:countryLb];
            if (i == 0) {
                backIv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
                self.warehouseTag = 2000;
            }else{
                backIv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectWarehouse:)];
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
        [sureBtn addTarget:self action:@selector(sureWarehouse) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceWarehouseV;
}

//选择集货地后的处理
- (void)selectWarehouse:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < 10; i++) {
        UIView *iv = (UIView *)[self.choiceWarehouseV viewWithTag:i + 2000];
        if (iv.tag == [tap view].tag) {
            iv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.warehouseTag = [tap view].tag;
            NSLog(@"%ld",(long)self.warehouseTag);
        }else{
            iv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}

//确定仓库后改变仓库ID
- (void)sureWarehouse
{
    if (self.searchWareHouseArr.count == 0) {
        self.loadingPlaceRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_loadingPlaceRightLb", nil);
        self.loadingPlaceId = @"";
    }else{
        self.loadingPlaceRightLb.text = self.searchWareHouseArr[self.warehouseTag - 2000][@"name"];
        [self changeWarehouseId];
    }
    [self.choiceWarehouseV removeFromSuperview];
    self.choiceWarehouseV = nil;
    self.searchWareHouseArr = nil;
    [self downLoadFreight];
}

//改变仓库id
- (void)changeWarehouseId
{
    self.loadingPlaceId = [NSString stringWithFormat:@"%@",self.searchWareHouseArr[self.warehouseTag - 2000][@"id"]];
}

//地区选择视图
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
        backSv.contentSize = CGSizeMake(0, 280);
        [iv addSubview:backSv];
        for (int i = 0; i < self.countryArr.count; i++) {
            UIView *backIv = [[UIView alloc]initWithFrame:CGRectMake(10 + 15 * (i%2) + (i%2) * 115, 10 + ((i/2) * 50), 120, 40)];
            backIv.tag = 1000 + i;
            [backSv addSubview:backIv];
            UILabel *countryLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 120, 30)];
            countryLb.textColor = Main_Color;
            countryLb.text = self.countryArr[i][@"name"];
            countryLb.textAlignment = NSTextAlignmentCenter;
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

//选择地区
- (void)selectAREA
{
    [self.view addSubview:self.choiceCurrencyV];
}

//选择后处理
- (void)selectCurrency:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < 10; i++) {
        UIView *iv = (UIView *)[self.choiceCurrencyV viewWithTag:i + 1000];
        if (iv.tag == [tap view].tag) {
            iv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.countryTag = [tap view].tag;
        }else{
            iv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}


//确定选择
- (void)sureCurrency
{
    self.isChoice = YES;
    [UserDefault setObject:self.countryArr[self.countryTag - 1000][@"currency"] forKey:@"ReceiveCurrency"];
    [UserDefault setObject:self.countryArr[self.countryTag - 1000][@"sign"] forKey:@"ReceiveCurrencySign"];
    [UserDefault setObject:self.countryArr[self.countryTag - 1000][@"name"] forKey:@"AREA"];

//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ReceiveCurrency"]isEqualToString:@"CNY"]) {
//        self.freightRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_ChinaFreight", nil);
//    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ReceiveCurrency"]isEqualToString:@"TWD"]){
//        self.freightRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_TWFreight", nil);
//    }else{
//        self.freightRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_commodityCostRightLb", nil);
//    }
    [self changeId];
    self.receivingAreaRightLb.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"AREA"];
    [self.choiceCurrencyV removeFromSuperview];
    [self downLoadCountry];
}

//收货地id
- (void)changeId
{
    for (int i = 0; i < self.countryArr.count; i++) {
        if ([self.countryArr[i][@"sign"]containsString:[[NSUserDefaults standardUserDefaults] objectForKey:@"ReceiveCurrencySign"]]) {
            self.receivingPlaceId = self.countryArr[i][@"sign"];
            return;
        }else{
            self.receivingPlaceId = @"";
        }
    }
}

//费用合计
- (UIView *)totalV
{
    if (_totalV == nil) {
        _totalV = [[UIView alloc]initWithFrame:CGRectMake(0, self.secondPayDetailsV.frame.origin.y + self.secondPayDetailsV.frame.size.height + 1, [[UIScreen mainScreen] bounds].size.width, 55)];
        _totalV.backgroundColor = [UIColor whiteColor];
        //提示文本
        UILabel *promptLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 35)];
        promptLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_promptLb", nil);
        promptLb.numberOfLines = 0;
        promptLb.font = [UIFont systemFontOfSize:10];
        promptLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        [_totalV addSubview:promptLb];
        //合计
        self.totalLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, 10, 210, 35)];
        self.totalLb.textAlignment = NSTextAlignmentRight;
        self.totalLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_counting", nil);
        self.totalLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [_totalV addSubview:self.totalLb];
    }
    return _totalV;
}

//警告文字
- (UIView *)noticeV
{
    if (_noticeV == nil) {
        _noticeV = [[UIView alloc]initWithFrame:CGRectMake(0, self.totalV.frame.origin.y + self.totalV.frame.size.height + 1, [[UIScreen mainScreen] bounds].size.width, 80)];
        _noticeV.backgroundColor = [UIColor whiteColor];
        //警告文字
        UILabel *noticeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 8,[[UIScreen mainScreen] bounds].size.width - 20, _noticeV.frame.size.height - 16)];
        noticeLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        noticeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_noticeLb", nil);
        noticeLb.numberOfLines = 0;
        if ([[UIScreen mainScreen] bounds].size.width < 360) {
            noticeLb.font = [UIFont systemFontOfSize:10];
        }
        noticeLb.font = [UIFont systemFontOfSize:14];
        [_noticeV addSubview:noticeLb];
    }
    return _noticeV;
}

- (UIView *)whiteColorBackV
{
    if (_whiteColorBackV == nil) {
        _whiteColorBackV = [[UIView alloc]initWithFrame:CGRectMake(0, self.noticeV.frame.origin.y + self.noticeV.frame.size.height, kScreenW, 100)];
        _whiteColorBackV.backgroundColor = [UIColor whiteColor];
    }
    return _whiteColorBackV;
}

//关闭按钮
- (UIView *)closeBackV
{
    if (_closeBackV == nil) {
        _closeBackV = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 90, self.noticeV.frame.origin.y + self.noticeV.frame.size.height + 20, 180, 40)];
        _closeBackV.userInteractionEnabled = YES;
        _closeBackV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick:)];
        tap.numberOfTapsRequired = 1;
        [_closeBackV addGestureRecognizer:tap];
        //关闭
        UILabel *sureLb = [[UILabel alloc]initWithFrame:CGRectMake( 50, 5, _closeBackV.frame.size.width - 100, 30)];
        sureLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_close", nil);
        sureLb.textColor = [UIColor whiteColor];
        sureLb.textAlignment = NSTextAlignmentCenter;
        sureLb.font = [UIFont systemFontOfSize:15 weight:3];
        [_closeBackV addSubview:sureLb];
    }
    return _closeBackV;
}

//显示商品源网页
- (UIView *)shopSourceBackV
{
    if (_shopSourceBackV == nil) {
        _shopSourceBackV = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 +10, self.noticeV.frame.origin.y + self.noticeV.frame.size.height + 20, [[UIScreen mainScreen] bounds].size.width/2 - 20, 50)];
        _shopSourceBackV.userInteractionEnabled = YES;
        _shopSourceBackV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopSourceClick:)];
        tap.numberOfTapsRequired = 1;
        [_shopSourceBackV addGestureRecognizer:tap];
        //加入购物车
        UILabel *sureLb = [[UILabel alloc]initWithFrame:CGRectMake( 50, 10, _shopSourceBackV.frame.size.width - 100, 30)];
        sureLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Commoditydetails", nil);
        sureLb.textColor = [UIColor whiteColor];
        sureLb.textAlignment = NSTextAlignmentCenter;
        sureLb.font = [UIFont systemFontOfSize:15 weight:3];
        [_shopSourceBackV addSubview:sureLb];
    }
    return _shopSourceBackV;
}

//品类选择视图
- (UIScrollView *)categoryV
{
    if (_categoryV == nil) {
        _categoryV = [[UIScrollView alloc]init];
        _categoryV.backgroundColor = Cell_BgColor;
        //_categoryV.layer.cornerRadius = 5;
        for (int i = 0; i < 4; i++) {
            if (i == 0) {
                self.categoryOneV = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - 20)/4 * i, 0, (kScreenW - 20)/4, 40)];
                self.categoryOneV.tag = 500;
                //self.categoryOneV.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:241.0/255.0 blue:208.0/255.0 alpha:1];
                self.categoryOneV.backgroundColor = [UIColor blackColor];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [self.categoryOneV addGestureRecognizer:tap];
                self.categoryOneLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (kScreenW - 20)/4, 40)];
                self.categoryOneLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_1", nil);
                //self.categoryOneLb.textColor = Main_Color;
                self.categoryOneLb.textColor = [UIColor whiteColor];
                self.categoryOneLb.font = [UIFont systemFontOfSize:14 weight:2];
                self.categoryOneLb.textAlignment = NSTextAlignmentCenter;
                [self.categoryOneV addSubview:self.categoryOneLb];
                [_categoryV addSubview:self.categoryOneV];
            }
            
            if (i == 1) {
                self.categoryTwoV = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - 20)/4 * i, 0, (kScreenW - 20)/3, 40)];
                self.categoryTwoV.tag = 501;
                //self.categoryTwoV.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:241.0/255.0 blue:208.0/255.0 alpha:1];
                self.categoryTwoV.backgroundColor = [UIColor blackColor];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [self.categoryTwoV addGestureRecognizer:tap];
                self.categoryTwoLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (kScreenW - 20)/4, 40)];
                self.categoryTwoLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_2", nil);
                self.categoryTwoLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
                self.categoryTwoLb.font = [UIFont systemFontOfSize:14 weight:2];
                self.categoryTwoLb.textAlignment = NSTextAlignmentCenter;
                [self.categoryTwoV addSubview:self.categoryTwoLb];
                [_categoryV addSubview:self.categoryTwoV];
            }
            
            if (i == 2) {
                self.categoryThreeV = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - 20)/4 * i, 0, (kScreenW - 20)/4, 40)];
                self.categoryThreeV.tag = 502;
                //self.categoryThreeV.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:241.0/255.0 blue:208.0/255.0 alpha:1];
                self.categoryThreeV.backgroundColor = [UIColor blackColor];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [self.categoryThreeV addGestureRecognizer:tap];
                self.categoryThreeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (kScreenW - 20)/4, 40)];
                self.categoryThreeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_3", nil);
                self.categoryThreeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
                self.categoryThreeLb.font = [UIFont systemFontOfSize:14 weight:2];
                self.categoryThreeLb.textAlignment = NSTextAlignmentCenter;
                [self.categoryThreeV addSubview:self.categoryThreeLb];
                [_categoryV addSubview:self.categoryThreeV];
            }

            if (i == 3) {
                self.categoryFourV = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - 20)/4 * i, 0, (kScreenW - 20)/4, 40)];
                self.categoryFourV.tag = 503;
                //self.categoryFourV.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:241.0/255.0 blue:208.0/255.0 alpha:1];
                self.categoryFourV.backgroundColor = [UIColor blackColor];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [self.categoryFourV addGestureRecognizer:tap];
                self.categoryFourLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (kScreenW - 20)/4, 40)];
                self.categoryFourLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_4", nil);
                self.categoryFourLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
                self.categoryFourLb.font = [UIFont systemFontOfSize:14 weight:2];
                self.categoryFourLb.textAlignment = NSTextAlignmentCenter;
                [self.categoryFourV addSubview:self.categoryFourLb];
                [_categoryV addSubview:self.categoryFourV];
                
            }
//            if (i > 0) {
//                UIView *line = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - 20)/3 * i, 0, 1, 40)];
//                line.backgroundColor = Cell_BgColor;
//                [_categoryV addSubview:line];
//            }
        }
        self.categoryDetailLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, (kScreenW - 40), 100)];
        self.categoryDetailLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_Entrust_Category_1", nil),NSLocalizedString(@"GlobalBuyer_Entrust_Category_explain_1", nil)];
        self.categoryDetailLb.textColor = Main_Color;
        self.categoryDetailLb.numberOfLines = 0;
        self.categoryDetailLb.font = [UIFont systemFontOfSize:14];
        self.categoryDetailLb.frame = CGRectMake(10 , 50, (kScreenW - 40), [self.categoryDetailLb sizeThatFits:CGSizeMake(self.categoryDetailLb.frame.size.width, MAXFLOAT)].height);
        [_categoryV addSubview:self.categoryDetailLb];
    }
    return _categoryV;
}

//选择品类后处理
- (void)didSelect:(UITapGestureRecognizer *)tap
{
    
    if ([tap view].tag == 500) {
        self.categoryOneLb.textColor = [UIColor whiteColor];
        self.categoryTwoLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryThreeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryFourLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryDetailLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_Entrust_Category_1", nil),NSLocalizedString(@"GlobalBuyer_Entrust_Category_explain_1", nil)];
        self.categoryDetailLb.frame = CGRectMake(10 , 50, (kScreenW - 40), [self.categoryDetailLb sizeThatFits:CGSizeMake(self.categoryDetailLb.frame.size.width, MAXFLOAT)].height);
        self.categoryInt = 1;
    }else if([tap view].tag == 501){
        self.categoryOneLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryTwoLb.textColor = [UIColor whiteColor];
        self.categoryThreeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryFourLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryDetailLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_Entrust_Category_2", nil),NSLocalizedString(@"GlobalBuyer_Entrust_Category_explain_2", nil)];
        self.categoryDetailLb.frame = CGRectMake(10 , 50, (kScreenW - 40), [self.categoryDetailLb sizeThatFits:CGSizeMake(self.categoryDetailLb.frame.size.width, MAXFLOAT)].height);
        self.categoryInt = 2;
    }else if([tap view].tag == 502){
        self.categoryOneLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryTwoLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryThreeLb.textColor = [UIColor whiteColor];
        self.categoryFourLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryDetailLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_Entrust_Category_3", nil),NSLocalizedString(@"GlobalBuyer_Entrust_Category_explain_3", nil)];
        self.categoryDetailLb.frame = CGRectMake(10 , 50, (kScreenW - 40), [self.categoryDetailLb sizeThatFits:CGSizeMake(self.categoryDetailLb.frame.size.width, MAXFLOAT)].height);
        self.categoryInt = 3;
    }else if([tap view].tag == 503){
        self.categoryOneLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryTwoLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryThreeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        self.categoryFourLb.textColor = [UIColor whiteColor];
        self.categoryDetailLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_Entrust_Category_4", nil),NSLocalizedString(@"GlobalBuyer_Entrust_Category_explain_4", nil)];
        self.categoryDetailLb.frame = CGRectMake(10 , 50, (kScreenW - 40), [self.categoryDetailLb sizeThatFits:CGSizeMake(self.categoryDetailLb.frame.size.width, MAXFLOAT)].height);
        self.categoryInt = 6;
    }
    
    [self downLoadCountry];
    
}

//选择公斤
- (UIView *)kgV
{
    if (_kgV == nil) {
        _kgV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
        UIView *reduceV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
        reduceV.layer.borderColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1].CGColor;
        reduceV.layer.borderWidth = 0.8;
        UILabel *reduceLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
        reduceLb.text = @"-";
        reduceLb.textAlignment = NSTextAlignmentCenter;
        reduceLb.font = [UIFont systemFontOfSize:16];
        [reduceV addSubview:reduceLb];
        [_kgV addSubview:reduceV];
        UITapGestureRecognizer *tapRed = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reduceKg)];
        tapRed.numberOfTouchesRequired = 1;
        tapRed.numberOfTapsRequired = 1;
        [reduceV addGestureRecognizer:tapRed];
        [_kgV addSubview:self.kgNumLb];
        UIView *plusV = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 30, 25)];
        plusV.layer.borderWidth = 0.8;
        plusV.layer.borderColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1].CGColor;
        UILabel *plusLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
        plusLb.text = @"+";
        plusLb.font = [UIFont systemFontOfSize:16];
        plusLb.textAlignment = NSTextAlignmentCenter;
        [plusV addSubview:plusLb];
        [_kgV addSubview:plusV];
        UITapGestureRecognizer *tapPlus = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plusKg)];
        tapPlus.numberOfTapsRequired = 1;
        tapPlus.numberOfTouchesRequired = 1;
        [plusV addGestureRecognizer:tapPlus];
    }
    return _kgV;
}

//减公斤
- (void)reduceKg
{
    if ([self.kgNumLb.text isEqualToString:@"1"]) {
        return;
    }
    self.kgNumLb.text = [NSString stringWithFormat:@"%d",[self.kgNumLb.text intValue] - 1];
    [self downLoadCountry];
}

//加公斤
- (void)plusKg
{
    if ([self.kgNumLb.text isEqualToString:@"99"]) {
        return;
    }
    self.kgNumLb.text = [NSString stringWithFormat:@"%d",[self.kgNumLb.text intValue] + 1];
    [self downLoadCountry];
}

//预估重量
- (UILabel *)kgNumLb
{
    if (_kgNumLb == nil) {
        _kgNumLb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 30, 25)];
        _kgNumLb.textAlignment = NSTextAlignmentCenter;
        _kgNumLb.text = @"2";
        _kgNumLb.font = [UIFont systemFontOfSize:13];
        _kgNumLb.layer.borderWidth = 0.8;
        _kgNumLb.layer.borderColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1].CGColor;
        _kgNumLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *kgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kgChange)];
        kgTap.numberOfTapsRequired = 1;
        kgTap.numberOfTouchesRequired = 1;
        [_kgNumLb addGestureRecognizer:kgTap];
    }
    return _kgNumLb;
}

- (void)kgChange{
    self.changeKgNumV.hidden = NO;
}


- (UIView *)changeKgNumV{
    if (_changeKgNumV == nil) {
        _changeKgNumV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _changeKgNumV.hidden = YES;
        _changeKgNumV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UIView *conV = [[UIView alloc]initWithFrame:CGRectMake(30, kScreenH/2 - 100, kScreenW - 60, 200)];
        conV.backgroundColor = [UIColor whiteColor];
        [_changeKgNumV addSubview:conV];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, conV.frame.size.width, 70)];
        title.text = NSLocalizedString(@"GlobalBuyer_Entrust_Estimatedweight", nil);
        title.font = [UIFont systemFontOfSize:17];
        title.textAlignment = NSTextAlignmentCenter;
        [conV addSubview:title];
        
        UIView *kV = [[UIView alloc]initWithFrame:CGRectMake(40, 75, conV.frame.size.width - 80, 50)];
        kV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        kV.layer.borderWidth = 0.7;
        [conV addSubview:kV];
        
        
        self.secondMBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self.secondMBtn setImage:[UIImage imageNamed:@"ic_minus"] forState:UIControlStateNormal];
        [self.secondMBtn setImage:[UIImage imageNamed:@"ic_minus_enabled"] forState:UIControlStateSelected];
        [kV addSubview:self.secondMBtn];
        if ([self.kgNumLb.text intValue] <= 1) {
            self.secondMBtn.selected = YES;
        }
        [self.secondMBtn addTarget:self action:@selector(conkgNumMinus:) forControlEvents:UIControlEventTouchUpInside];
        
        self.secondABtn = [[UIButton alloc]initWithFrame:CGRectMake(kV.frame.size.width - 40, 10, 30, 30)];
        [self.secondABtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        [kV addSubview:self.secondABtn];
        [self.secondABtn addTarget:self action:@selector(conkgNumAdd) forControlEvents:UIControlEventTouchUpInside];
        
        self.secondTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, kV.frame.size.width - 100, 50)];
        self.secondTF.textAlignment = NSTextAlignmentCenter;
        self.secondTF.text = self.kgNumLb.text;
        self.secondTF.keyboardType = UIKeyboardTypeNumberPad;
        self.secondTF.delegate = self;
        [kV addSubview:self.secondTF];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, conV.frame.size.width/2, 50)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [conV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelChangeKgNum) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(conV.frame.size.width/2, 150, conV.frame.size.width/2, 50)];
        sureBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [conV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureChangeKgNum) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeKgNumV;
}

- (void)cancelChangeKgNum{
    self.changeKgNumV.hidden = YES;
}

- (void)sureChangeKgNum{
    self.kgNumLb.text = self.secondTF.text;
    self.changeKgNumV.hidden = YES;
    [self downLoadCountry];
}

- (void)conkgNumMinus:(UIButton *)btn{
    if (btn.selected == YES) {
        return;
    }
    self.secondTF.text = [NSString stringWithFormat:@"%d",[self.secondTF.text intValue]-1];
    if ([self.secondTF.text intValue] <= 1) {
        btn.selected = YES;
    }
}

- (void)conkgNumAdd{
    if ([self.secondTF.text intValue] >= 100) {
        return;
    }
    self.secondTF.text = [NSString stringWithFormat:@"%d",[self.secondTF.text intValue]+1];
    if ([self.secondTF.text intValue] > 1) {
        self.secondTF.selected = NO;
    }
}

//跳转商品详情
- (void)shopSourceClick:(UITapGestureRecognizer *)tap
{
    ShopDetailViewController *shopDeVC = [[ShopDetailViewController alloc]init];
    shopDeVC.link = self.link;
    shopDeVC.showTabbar = NO;
    [self.navigationController pushViewController:shopDeVC animated:YES];
}

//加入购物车
- (UIView *)btnBackV
{
    if (_btnBackV == nil) {
        _btnBackV = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 90, 50 , 180, 40)];
        _btnBackV.userInteractionEnabled = YES;
        _btnBackV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureClick:)];
        tap.numberOfTapsRequired = 1;
        [_btnBackV addGestureRecognizer:tap];
        //加入购物车
        self.sureLb = [[UILabel alloc]initWithFrame:CGRectMake( 10, 5, _btnBackV.frame.size.width - 20, 30)];
        self.sureLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_btn", nil);
        self.sureLb.textColor = [UIColor whiteColor];
        self.sureLb.textAlignment = NSTextAlignmentCenter;
        self.sureLb.font = [UIFont systemFontOfSize:15 weight:3];
        [_btnBackV addSubview:self.sureLb];
    }
    return _btnBackV;
}

//点击确认动作
- (void)sureClick:(UITapGestureRecognizer *)tap
{
    [self.btnBackV removeGestureRecognizer:tap];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.bodyStr,@"bodyStr",self.loadingPlaceId,@"warehouseId",self.numberLb.text,@"goodsUserSetNum", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didSure" object:self userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

//点击关闭动作
- (void)closeClick:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更新价格
- (void)update{
    if ([self.priceOfGoods length] <= 0) {
        commodityCostRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Artificial", nil);
    }else{
        commodityCostRightLb.text = [NSString stringWithFormat:@"%@(%@%@)",[CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue]],NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue]]];
    }
    if (self.exciseTax) {
        self.secondPayDetailsRightLb.text = [NSString stringWithFormat:@"%@(%@%@)",[CurrencyCalculation getcurrencyCalculation:([self.exciseTax floatValue] * [self.numberLb.text floatValue]) currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:1.0],NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:([self.exciseTax floatValue] * [self.numberLb.text floatValue]) moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:1.0]];
        self.secondPayDetailsRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    }else{
        self.secondPayDetailsRightLb.text = @"0";
        self.secondPayDetailsRightLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
    }
    
    
    if ([self.priceOfGoods length] <= 0){
        self.secondPayDetailsRightLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Artificial", nil);
        self.secondPayDetailsRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    }
    
    self.firstPayTotalLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue] freight:0 serviceCharge:[self.serviceCharge floatValue] exciseTax:[self.exciseTax floatValue]]];
    
    NSString *tmpStr = NSLocalizedString(@"GlobalBuyer_Entrust_totalLb", nil);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStr,[CurrencyCalculation calculationCurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue] freight:[yunfei floatValue] serviceCharge:[self.serviceCharge floatValue] exciseTax:[self.exciseTax floatValue]]]];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStr.length+1, [CurrencyCalculation calculationCurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberLb.text floatValue] freight:[yunfei floatValue] serviceCharge:[self.serviceCharge floatValue] exciseTax:[self.exciseTax floatValue]].length)];
    self.totalLb.attributedText = attStr;
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
