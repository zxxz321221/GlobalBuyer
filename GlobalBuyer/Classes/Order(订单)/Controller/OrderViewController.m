//
//  OrderViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTopView.h"
#import "OrderModel.h"
#import "AllOrderCell.h"
#import "PackChoosePayViewController.h"
#import "AddressOrderViewController.h"
#import "TrackViewController.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartDetailViewController.h"
#import "ObjectAndString.h"
@interface OrderViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AllOrderCellDelegate, OrderTopViewDelegate,AddressViewControllerDelegate>

@property (nonatomic, strong)OrderTopView *orderTopView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *allTableView;
@property (nonatomic, strong)UITableView *nopayTableView;
@property (nonatomic, strong)UITableView *addAddressTableView;
@property (nonatomic, strong)UITableView *purchaseTableView;
@property (nonatomic, strong)UITableView *purchTableView;
@property (nonatomic, strong)UITableView *sendGoodsTableView;
@property (nonatomic, strong)NSMutableArray *allDataSoucer;
@property (nonatomic, strong)NSMutableArray *nopayDataSoucer;
@property (nonatomic, strong)NSMutableArray *purchaseDataSoucer;
@property (nonatomic, strong)NSMutableArray *purchDataSoucer;
@property (nonatomic, strong)NSMutableArray *sendGoodsDataSoucer;
@property (nonatomic, strong)OrderModel *model;
@property (nonatomic, strong)NSMutableArray *packArr;
@property (nonatomic, strong)NSArray *payArr;
@property (nonatomic, strong)NSMutableArray *moneytypeArr;
@property (nonatomic, strong)NSMutableArray *addAddressDataSoucer;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotif:) name:@"payPack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payGoods:) name:@"pay" object:nil];
    [self downloadMoneytype];
    // Do any additional setup after loading the view.
}

#pragma mark 下载汇率数据
- (void)downloadMoneytype {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:moneyTypeApi parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject[@"data"];
        NSArray *name = [dict allKeys];
        NSArray *rate = [dict allValues];
        
        for (int i = 0; i <name.count ; i++) {
            NSDictionary *dict = @{@"name":name[i],@"rate":rate[i]};
            [self.moneytypeArr addObject:dict];
        }
        
        [self dowloadData];
        [self dowloadPackbageData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 下载数据
- (void)dowloadData {
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSLog(@"%@",userToken);
    if (userToken == nil) {
        return;
    }
    NSDictionary *params = @{@"api_token":userToken};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            
            [self.allDataSoucer removeAllObjects];
            [self.nopayDataSoucer removeAllObjects];
            [self.sendGoodsDataSoucer removeAllObjects];
            [self.purchaseDataSoucer removeAllObjects];
            [self.addAddressDataSoucer removeAllObjects];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dict in data) {
                OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
                model.Id = dict[@"id"];
                NSData *datas = [dict[@"body"] dataUsingEncoding:NSUTF8StringEncoding ];
                NSDictionary *bodyDict = [NSJSONSerialization JSONObjectWithData:datas options:0 error:nil];
                ShopCartModel *shopCartModel = [[ShopCartModel alloc]initWithDictionary:bodyDict error:nil];
                model.body = shopCartModel;
                [self.allDataSoucer addObject:model];
                model.shop_source = model.body.shopSource;
                for (NSDictionary *dict in self.moneytypeArr) {
                    if ([dict[@"name"] isEqualToString:model.body.moneyType]) {
                        model.body.rate = dict[@"rate"];
                    }
                }
                
                if ([model.product_status isEqualToString:@"PAY_STATUS_WAIT"]) {
                    [self.nopayDataSoucer addObject:model];
                }
                
                if ([model.product_status isEqualToString:@"PAY_STATUS_COMPLETE"]) {
                    [self.addAddressDataSoucer addObject:model];
                }
                
                if ([model.product_status isEqualToString:@"PAY_PLAG_COMPLETE" ] && model.express_no) {
                    [self.sendGoodsDataSoucer addObject:model];
                }
                
                if ([model.product_status isEqualToString:@"PAY_PLAG_WAIT"] && [model.interfreight_finish isEqual:@0]) {
                    [self.purchaseDataSoucer addObject:model];
                }
                
            }
            self.nopayDataSoucer= [self getOrderModel:self.nopayDataSoucer];
            [self.allTableView reloadData];
            [self.nopayTableView reloadData];
            [self.purchaseTableView reloadData];
            [self.sendGoodsTableView reloadData];
            [self.addAddressTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (NSMutableArray *)getOrderModel:(NSMutableArray *)modelArr {
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (OrderModel *model in modelArr) {
        [arr addObject:[ObjectAndString getObjectData:model]];
    }
    return  [self classifyData:arr];
}

- (NSMutableArray *)classifyData:(NSMutableArray *)arr {
    
    // 获取array中所有index值
    NSArray *indexArray = [arr valueForKey:@"shopSource"];
    
    // 将array装换成NSSet类型
    NSSet *indexSet = [NSSet setWithArray:indexArray];
    
    // 新建array，用来存放分组后的array
    NSMutableArray *resultArray = [NSMutableArray array];
    
    // NSSet去重并遍历
    [[indexSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 根据NSPredicate获取array
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shopSource == %@",obj];
        NSArray *indexArray = [arr filteredArrayUsingPredicate:predicate];
        
        // 将查询结果加入到resultArray中
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in indexArray) {
            OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
            [arr addObject:model];
        }
        
        [resultArray addObject:arr];
    }];
    return  resultArray;
    
}

#pragma mark 初始化数据
- (NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}

- (NSMutableArray *)sendGoodsDataSoucer {
    if (_sendGoodsDataSoucer == nil) {
        _sendGoodsDataSoucer = [[NSMutableArray alloc]init];
    }
    return _sendGoodsDataSoucer;
}

- (NSMutableArray *)purchaseDataSoucer {
    if (_purchaseDataSoucer == nil) {
        _purchaseDataSoucer = [[NSMutableArray alloc]init];
    }
    return _purchaseDataSoucer;
}

- (NSMutableArray *)purchDataSoucer {
    
    if (_purchDataSoucer == nil) {
        _purchDataSoucer = [[NSMutableArray alloc]init];
    }
    return _purchDataSoucer;
}

- (NSMutableArray *)nopayDataSoucer {
    
    if (_nopayDataSoucer == nil) {
        _nopayDataSoucer = [[NSMutableArray alloc]init];
    }
    return _nopayDataSoucer;
}

- (NSMutableArray *)addAddressDataSoucer {
    if (_addAddressDataSoucer == nil) {
        _addAddressDataSoucer = [[NSMutableArray alloc]init];
    }
    return _addAddressDataSoucer;
}

- (NSMutableArray *)allDataSoucer {
    if (_allDataSoucer == nil) {
        _allDataSoucer = [[NSMutableArray alloc]init];
    }
    return _allDataSoucer;
}

#pragma mark 支付商品成功通知
- (void)payGoods:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_commodity", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [self dowloadData];
        [self dowloadPackbageData];
    }
}

#pragma mark 支付运费成功通知
- (void)payNotif:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_freight", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        [self dowloadData];
        [self dowloadPackbageData];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payPack" object:self];
}

#pragma mark 下载包裹数据
- (void)dowloadPackbageData {
//    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
//    NSDictionary *params = @{@"api_token":userToken};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:PackageApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if ([responseObject[@"code"] isEqualToString:@"success"]) {
//            [self.purchDataSoucer removeAllObjects];
//            NSDictionary *dict = responseObject[@"data"];
//            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
//                return ;
//            }
//            NSArray *arr = [dict allValues];
//            self.packArr = [[NSMutableArray alloc]initWithArray:[dict allKeys]];
//            for (NSArray *arr1 in arr) {
//                NSMutableArray *arr2 = [[NSMutableArray alloc]init];
//                for (NSDictionary *dict in arr1) {
//                    OrderModel *model = [[OrderModel alloc]initWithDictionary:dict error:nil];
//                    NSString *bodyStr = dict[@"body"];
//                    NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                    ShopCartModel *models =[[ShopCartModel alloc]initWithDictionary:dict error:nil];
//                    model.body = models;
//                    if ([model.product_status isEqualToString:@"PAY_PLAG_WAIT"]) {
//                        [arr2 addObject:model];
//                    }
//                    if ([model.interfreight_finish isEqual:@1] && ![model.product_status isEqualToString:@"PAY_PLAG_COMPLETE"]) {
//                        [arr2 addObject:model];
//                    }
//                }
//                [self.purchDataSoucer addObject:arr2];
//            }
//            [self.purchTableView reloadData];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
}

#pragma mark 设置UI界面
- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My_Tabview_HeaderTitle", nil);
    [self setNavigationBackBtn];
    [self.view addSubview:self.orderTopView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.allTableView];
    [self.scrollView addSubview:self.nopayTableView];
    [self.scrollView addSubview:self.addAddressTableView];
    [self.scrollView addSubview:self.purchaseTableView];
    [self.scrollView addSubview:self.purchTableView];
    [self.scrollView addSubview:self.sendGoodsTableView];
    [self.orderTopView.collectionView reloadData];
}

- (UITableView *)sendGoodsTableView {
    if (_sendGoodsTableView == nil) {
        _sendGoodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW * 5, 0, kScreenW, kScreenH-CGRectGetMaxY(self.orderTopView.frame)) style:UITableViewStyleGrouped];
        _sendGoodsTableView.dataSource = self;
        _sendGoodsTableView.delegate = self;
    }
    return _sendGoodsTableView;
}

- (UITableView *)purchTableView {
    if (_purchTableView == nil) {
        _purchTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW * 4, 0, kScreenW, kScreenH-CGRectGetMaxY(self.orderTopView.frame)) style:UITableViewStyleGrouped];
        _purchTableView.dataSource = self;
        _purchTableView.delegate= self;
    }
    return _purchTableView;
    
}

- (UITableView *)purchaseTableView{
    if (_purchaseTableView == nil) {
        _purchaseTableView  = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW * 3, 0, kScreenW, kScreenH - CGRectGetMaxY(self.orderTopView.frame)) style:UITableViewStyleGrouped];
        _purchaseTableView.dataSource = self;
        _purchaseTableView.delegate = self;
    }
    return _purchaseTableView;
}
- (UITableView *)addAddressTableView {
    if (_addAddressTableView == nil) {
        _addAddressTableView =  [[UITableView alloc]initWithFrame:CGRectMake(kScreenW * 2, 0, kScreenW, kScreenH - CGRectGetMaxY(self.orderTopView.frame)) style:UITableViewStyleGrouped];
        _addAddressTableView.delegate = self;
        _addAddressTableView.dataSource = self;
    }
    return _addAddressTableView;
}
- (UITableView *)nopayTableView {
    
    if (_nopayTableView == nil) {
        _nopayTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, kScreenH- CGRectGetMaxY(self.orderTopView.frame) ) style:UITableViewStyleGrouped];
        _nopayTableView.dataSource = self;
        _nopayTableView.delegate= self;
    }
    return _nopayTableView;
}
- (UITableView *)allTableView {
    if (_allTableView == nil) {
        _allTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - CGRectGetMaxY(self.orderTopView.frame)) style:UITableViewStyleGrouped];
        _allTableView.delegate = self;
        _allTableView.dataSource = self;
    }
    return _allTableView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.orderTopView.frame), kScreenW, kScreenH - CGRectGetMaxY(self.orderTopView.frame));
        _scrollView.contentSize = CGSizeMake(kScreenW * 6, 0);
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

#pragma mark  tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.nopayTableView == tableView) {
        return 60;
    }else{
    
        return 100;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.allTableView) {
        return self.allDataSoucer.count;
    }else if (tableView == self.nopayTableView) {
        return 1;
    }else if (tableView == self.purchTableView) {
        return self.purchDataSoucer.count;
    }else if (tableView == self.purchaseTableView) {
        return self.purchaseDataSoucer.count;
    }else if (tableView == self.sendGoodsTableView) {
        return self.sendGoodsDataSoucer.count;
    }else if(tableView == self.addAddressTableView){
        return self.addAddressDataSoucer.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.purchTableView == tableView) {
        return [self.purchDataSoucer[section] count];
    }  if (self.nopayTableView == tableView) {
        return  self.nopayDataSoucer.count;
    }else{
    
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.purchTableView) {
        if ([self.purchDataSoucer[section] count] == 0) {
            return 0.1;
        }
        return 30;
    } else {
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.purchTableView) {
        if ([self.purchDataSoucer[section] count] == 0) {
            return nil;
        }
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 63, 4, 55, 22)];
        btn.tag = section + 10;
        [btn setBackgroundColor:[UIColor colorWithRed:0.07 green:0.56 blue:0.33 alpha:1]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Paytransport", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:btn];
        return headerView;
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.allTableView) {
        AllOrderCell *cell = TableViewCellDequeueInit(NSStringFromClass([AllOrderCell class]));
        TableViewCellDequeueXIB(cell, AllOrderCell);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell hideBtn:YES];
        cell.model =  self.allDataSoucer[indexPath.section];
        return cell;
    }else if(tableView == self.nopayTableView){
        UITableViewCell *cell = TableViewCellDequeueInit(@"orderCell");
        if (!cell) {
            TableViewCellDequeue(cell, UITableViewCell, @"orderCell");
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OrderModel *model = self.nopayDataSoucer[indexPath.row][0];
        //cell.textLabel.text =  model.shopSource;
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 100, 20)];
        lb.font = [UIFont systemFontOfSize:16];
        lb.textColor = [UIColor blackColor];
        lb.text = [NSString stringWithFormat:@"%@",model.shop_source];
        [cell addSubview:lb];
        
        //现在的网站字符改logo图片
        UIImageView *logoIm = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 100, 50)];
        [cell addSubview:logoIm];
        [logoIm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",WebLogoApi,model.shop_source]] placeholderImage:nil];
        
        return cell;
    }else if (tableView == self.purchaseTableView){
        AllOrderCell *cell =TableViewCellDequeueInit(NSStringFromClass([AllOrderCell class]));
        TableViewCellDequeueXIB(cell, AllOrderCell);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model =  self.purchaseDataSoucer[indexPath.section];
        return cell;
    }else if (tableView == self.purchTableView){
        AllOrderCell *cell = TableViewCellDequeueInit(NSStringFromClass([AllOrderCell class]));
        TableViewCellDequeueXIB(cell, AllOrderCell);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell hideBtn:YES];
        cell.model =  self.purchDataSoucer[indexPath.section][indexPath.row];
        return cell;
        
    }else if(tableView == self.sendGoodsTableView){
        AllOrderCell *cell = TableViewCellDequeueInit(NSStringFromClass([AllOrderCell class]));
        TableViewCellDequeueXIB(cell, AllOrderCell);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model =  self.sendGoodsDataSoucer[indexPath.section];
        return cell;
    }else {
        AllOrderCell *cell = TableViewCellDequeueInit(NSStringFromClass([AllOrderCell class]));
        TableViewCellDequeueXIB(cell, AllOrderCell);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model =  self.addAddressDataSoucer[indexPath.section];
        [cell hideBtn:NO];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.sendGoodsTableView) {
        OrderModel *model = self.sendGoodsDataSoucer[indexPath.section];
        TrackViewController *trackVC = [[TrackViewController alloc]init];
        trackVC.num = model.express_no;
        trackVC.express_name = model.express_name;
        [self.navigationController pushViewController:trackVC  animated:YES];
    }
    if (tableView == self.nopayTableView) {
        ShoppingCartDetailViewController *shoppingCartDetailVC = [ShoppingCartDetailViewController new];
        shoppingCartDetailVC.dataSoucer = self.nopayDataSoucer[indexPath.row];
        shoppingCartDetailVC.vc = self;
        shoppingCartDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shoppingCartDetailVC animated:YES];
    }
    if (tableView == self.addAddressTableView) {
        self.model = self.addAddressDataSoucer[indexPath.row];
         AddressOrderViewController *addressVC = [ AddressOrderViewController new];
        addressVC.delegate = self;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    
    //在全部订单页面，点击商品自动跳到对应的状态（会员中心）
    if (tableView == self.allTableView) {
        AllOrderCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
        if ([selectCell.model.product_status isEqualToString:@"PAY_STATUS_WAIT"]) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.nopayTableView.frame.origin.x, 0)];
                [self.orderTopView setOrderTopViewLaState:1];
            }];
        }
        if ([selectCell.model.product_status isEqualToString:@"PAY_STATUS_COMPLETE"]) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.addAddressTableView.frame.origin.x, 0)];
                [self.orderTopView setOrderTopViewLaState:2];
            }];
        }
        if ([selectCell.model.product_status isEqualToString:@"PAY_PLAG_WAIT"]) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.purchaseTableView.frame.origin.x, 0)];
                [self.orderTopView setOrderTopViewLaState:3];
            }];
        }
        if ([selectCell.model.product_status isEqualToString:@"PAY_PLAG_WAIT"] &&
            [selectCell.model.interfreight_finish isEqual:@0]) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.purchTableView.frame.origin.x, 0)];
                [self.orderTopView setOrderTopViewLaState:4];
            }];
        }
        if ([selectCell.model.product_status isEqualToString:@"PAY_PLAG_COMPLETE"]) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.sendGoodsTableView.frame.origin.x, 0)];
                [self.orderTopView setOrderTopViewLaState:5];
            }];
        }
    }
}

#pragma mark 支付运费按钮事件
- (void)pay:(UIButton*)btn {
    NSInteger index = btn.tag - 10;
   OrderModel *model = self.purchDataSoucer[index][0];
    if ([model.interfreight_finish isEqual:@1]) {
        NSString *packId = self.packArr[index];
        PackChoosePayViewController *choosePayVC = [[PackChoosePayViewController alloc]init];
        choosePayVC .hidesBottomBarWhenPushed = YES;
        choosePayVC.OrderVC = self;
        choosePayVC.idsStr = packId;
        [self.navigationController pushViewController:choosePayVC animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_Incalculation", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark 顶部界面
- (OrderTopView *)orderTopView {
    if (_orderTopView == nil) {
        _orderTopView = [[OrderTopView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 35)];
        _orderTopView.delegate = self;
    }
    return _orderTopView;
}

#pragma mark orderTopView代理事件
- (void)clickAtIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake((index-10) *kScreenW, 0) animated:YES];
}

#pragma mark  scrollView代理事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.scrollView.contentOffset.x/kScreenW;
    [self.orderTopView setOrderTopViewLaState:index];
}

- (void)sendAdressModel:(AddressModel *)model {
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSMutableDictionary *orderDict = [[NSMutableDictionary alloc]init];
    orderDict[@"user_address_id"] = model.Id;
    orderDict[@"id"] = self.model.Id;
    NSData *data=[NSJSONSerialization dataWithJSONObject:orderDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"api_token":userToken,@"orderUpdate":jsonStr};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_AddAdd", nil);
//    [manager POST:UpdateOrderApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//          [hud hideAnimated:YES];
//        if ([responseObject[@"code"] isEqualToString:@"success"]) {
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"添加地址成功!", @"HUD message title");
//            // Move to bottm center.
//            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//            [hud hideAnimated:YES afterDelay:3.f];
//            [self dowloadData];
//        } else {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = NSLocalizedString(@"添加地址失败!", @"HUD message title");
//            // Move to bottm center.
//            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//            [hud hideAnimated:YES afterDelay:3.f];
//        }
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = NSLocalizedString(@"添加地址失败!", @"HUD message title");
//        // Move to bottm center.
//        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//        [hud hideAnimated:YES afterDelay:3.f];
//    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.index > 0) {
        self.scrollView.contentOffset = CGPointMake(kScreenW * self.index, 0);
        [self.orderTopView setOrderTopViewLaState:self.index];
    }
 
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
