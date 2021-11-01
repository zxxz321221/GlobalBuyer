//
//  ShoppingCartViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShopCartCellHeaderview.h"
#import "ShopCartHeaderView.h"
#import "ShopDetailViewController.h"
#import "ShopCartModel.h"
#import "OrderModel.h"
#import "ShoppingCartDetailViewController.h"
#import "NoLoginViewController.h"
#import "ObjectAndString.h"
#import "ShopCartFirstCell.h"
#import "ChoosePayViewController.h"
#import "NoPayViewController.h"
#import "PopLoginViewController.h"
#import "NavigationController.h"

#import "LoginRootViewController.h"


@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ShopCartHeaderView *shopCartHeaderView;
@property (nonatomic, strong)NSMutableArray *moneytypeArr;
@property (nonatomic, strong)NoLoginViewController *noLoginVC;
@property (nonatomic, strong)NSString *serviceCharge;


@property (nonatomic, strong)UIView *noGoodsV;

@property (nonatomic, strong)UIView *expiredHintV;

@end

@implementation ShoppingCartViewController{
    BOOL isPushFlag; //是否已经自动跳转购物车标识位 .
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isPushFlag = NO;
    [self setupUI];
    self.navigationController.navigationBar.backgroundColor = Main_Color;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay:) name:@"pay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCart:) name:@"shopCart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isLogin:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"reloadShoppingCart" object:nil];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_ShoppingCart", nil);
    [self downloadMoneytype];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
    

}

#pragma mark 登录事件
- (void)goLoginClick {
    PopLoginViewController *popLogin = [PopLoginViewController new];
    popLogin.pop = YES;
    NavigationController *popLoginNa = [[NavigationController alloc]initWithRootViewController:popLogin];
    [self presentViewController:popLoginNa animated:YES completion:nil];
}



#pragma mark 通知
- (void)pay:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_commodity", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [self downloadData];
    }
}

- (void)isLogin:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        [self downloadData];
    }
}

- (void)shopCart:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        [self downloadData];
    }
}

#pragma mark 初始化
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}

- (NSMutableArray *)dataSoucer {
    if (_dataSoucer == nil) {
        _dataSoucer = [NSMutableArray new];
    }
    return _dataSoucer;
}

#pragma mark 下载汇率
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
        [self downLoadServiceCharge];
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
            self.serviceCharge = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"service"] floatValue]];
            //self.purchasingRightLb.text = [CurrencyCalculation getcurrencyCalculation:[self.serviceCharge floatValue] currentCommodityCurrency:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"] numberOfGoods:1.0];
        }
        
        [self downloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}


#pragma mark 下载数据
- (void)downloadData{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken == nil) {
        return;
    }
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"所有返回来的是%@",responseObject);
        [self.dataSoucer removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        for (OrderModel *model in self.dataSoucer) {
            model.body.iSelect = @NO;
        }
        NSDictionary *dictData = responseObject[@"data"];
        NSArray *arrTitle = [dictData allKeys];
        NSMutableArray *arrBody = [[NSMutableArray alloc]init];
        for (int i = 0; i < arrTitle.count; i++) {
            for (int j = 0 ; j < [dictData[arrTitle[i]] count]; j++) {
                [arrBody addObject:dictData[arrTitle[i]][j]];
            }
        }
//        NSArray *data = responseObject[@"data"];
        
        for (NSDictionary *dict in arrBody) {
            OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
            model.Id = dict[@"id"];
            NSData *datas = [dict[@"body"] dataUsingEncoding:NSUTF8StringEncoding ];
            NSDictionary *bodyDict = [NSJSONSerialization JSONObjectWithData:datas options:0 error:nil];
            ShopCartModel *shopCartModel = [[ShopCartModel alloc]initWithDictionary:bodyDict error:nil];
            model.body = shopCartModel;
            
            
            model.shop_source = model.body.shopSource;
            if ([model.product_status isEqualToString:@"CART_WAIT"]) {
                [self.dataSoucer addObject:model];
            }
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (NSInteger idx =0 ; idx != [self.dataSoucer count] ;idx ++) {
           // OrderModel *model in self.dataSoucer
            OrderModel *model = self.dataSoucer[idx];
            [arr addObject:[ObjectAndString getObjectData:model]];
           
        }
        self.dataSoucer = arr;
        [self classifyData];
        if (self.dataSoucer.count == 0) {
            self.noGoodsV.hidden = NO;
        }else{
            self.noGoodsV.hidden = YES;
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
//        NSInteger checkAutoJumpRet = -1; //是否需要自动跳转到购物车.
        
        if (isPushFlag) {
            return;  //不知道为啥(不是我做的) 这个方法要走好多遍,所以跳转页面需要增加标志位. 接坑的兄弟注意了.
        }
        
        for (NSInteger idx =0; idx != [self.dataSoucer count]; idx++) {  //之前验证数据有去重操作.不能在前面的循环中判断位置
            OrderModel *model = self.dataSoucer[idx][0];
            if (self.shopSource.length != 0 && [model.shop_source isEqualToString:self.shopSource]) {
                isPushFlag = YES;
                [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                break;
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 创建UI
- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noLoginVC.view];
    [self.view addSubview:self.noGoodsV];
    [self.noLoginVC.loginBtn addTarget:self action:@selector(goLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.expiredHintV];
}

- (UIView *)expiredHintV
{
    if (_expiredHintV == nil) {
        _expiredHintV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        _expiredHintV.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:0.7];
        UILabel *expiredHintLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        expiredHintLb.textAlignment = NSTextAlignmentCenter;
        expiredHintLb.textColor = [UIColor whiteColor];
        expiredHintLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_ExpiredHint", nil);
        expiredHintLb.font = [UIFont systemFontOfSize:13];
        [_expiredHintV addSubview:expiredHintLb];
    }
    return _expiredHintV;
}

-(NoLoginViewController *)noLoginVC {
    if (_noLoginVC == nil) {
        _noLoginVC = [NoLoginViewController new];
        [self addChildViewController:_noLoginVC];
    }
    return _noLoginVC;
}

- (UITableView *)tableView {
    if (_tableView ==nil ) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH -(kNavigationBarH + kStatusBarH) - 40) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downloadMoneytype)];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStatePulling", nil) forState:MJRefreshStatePulling];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateRefreshing", nil) forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_header = header;
    }
    return _tableView;
}

#pragma mark tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoucer.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartDetailViewController *shoppingCartDetailVC = [ShoppingCartDetailViewController new];
    shoppingCartDetailVC.dataSoucer = [NSMutableArray arrayWithArray:self.dataSoucer[indexPath.row]];
    shoppingCartDetailVC.vc = self;
    shoppingCartDetailVC.moneytypeArr = self.moneytypeArr;
    shoppingCartDetailVC.serviceCharge = self.serviceCharge;
    shoppingCartDetailVC.hidesBottomBarWhenPushed = YES;
    shoppingCartDetailVC.isAutoPush = self.shopSource.length?YES:NO;
    OrderModel *model = self.dataSoucer[indexPath.row][0];
    shoppingCartDetailVC.title = model.shop_source;
    [self.navigationController pushViewController:shoppingCartDetailVC animated:self.shopSource.length?NO:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cart";
    OrderModel *model = self.dataSoucer[indexPath.row][0];

    ShopCartFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ShopCartFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.logoLb.text = [NSString stringWithFormat:@"%@",model.shop_source];
    [cell.logoIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",WebLogoApi,model.shop_source]] placeholderImage:nil];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark 分类
- (void)classifyData {
    
    // 获取array中所有index值
    NSArray *indexArray = [self.dataSoucer valueForKey:@"shop_source"];
    
    // 将array装换成NSSet类型
    NSSet *indexSet = [NSSet setWithArray:indexArray];
    // 新建array，用来存放分组后的array
    NSMutableArray *resultArray = [NSMutableArray array];
    // NSSet去重并遍历
    [[indexSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 根据NSPredicate获取array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shop_source == %@",obj];
        NSArray *indexArray = [self.dataSoucer filteredArrayUsingPredicate:predicate];
        
        // 将查询结果加入到resultArray中
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in indexArray) {
            OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
            [arr addObject:model];
        }
        [resultArray addObject:arr];
    }];
    self.dataSoucer = resultArray;
}


#pragma mark 创建UI界面
- (ShopCartHeaderView *)shopCartHeaderView {
    if (_shopCartHeaderView == nil) {
        _shopCartHeaderView = [[ShopCartHeaderView alloc]init];
        _shopCartHeaderView.frame =CGRectMake(0, 64, kScreenW, [_shopCartHeaderView getH]);
    }
    return _shopCartHeaderView;
}

#pragma mark view 生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadView];

}



- (void)reloadView{
    self.navigationController.navigationBar.translucent = NO;
//    if (isPushFlag && self.shopSource) { //如果是自动跳转返回
//        [self.navigationController popViewControllerAnimated:NO];
//        return;
//    }
    
    [self downloadMoneytype];
    [self.tableView.mj_header beginRefreshing];
    if (UserDefaultObjectForKey(USERTOKEN)) {
        self.noLoginVC.view.hidden = YES;
        self.tableView.hidden = NO;
        self.noGoodsV.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.noLoginVC.view.hidden = NO;
        self.noGoodsV.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshGoodsNum" object:nil];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPushNoPayView"] isEqualToString:@"YES"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPushProcurementView"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 3;
    }
    
}

- (UIView *)noGoodsV
{
    if (_noGoodsV == nil) {
        _noGoodsV = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 50, kScreenW, kScreenH - 64 - 49 - 50)];
        UILabel *noticeLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 120, kScreenH/2 - 50, 240, 60)];
        noticeLb.textColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1];
        noticeLb.font = [UIFont systemFontOfSize:15 weight:1];
        noticeLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NoGoodsNotice", nil);
        noticeLb.textAlignment = NSTextAlignmentCenter;
        noticeLb.numberOfLines = 0;
        [_noGoodsV addSubview:noticeLb];
        UIImageView *shopcartImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 45, kScreenH/2 - 160, 90, 90)];
        shopcartImg.image = [UIImage imageNamed:@"NoGoodsCart"];
        [_noGoodsV addSubview:shopcartImg];
    }
    return _noGoodsV;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pay" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shopCart" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:self];
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
