//
//  PurseViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "PurseViewController.h"
#import "WalletTableViewCell.h"
#import "CashViewController.h"
#import "traDetailViewController.h"
#import "AroundAnimation.h"
#import "RechargeViewController.h"
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT  ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))
@interface PurseViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    int index;
    BOOL isShow;//yes 余额显示数字  no 余额显示*
    NSString * balanceNum;
}
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray *walletLogDataSource;//所有记录
@property (nonatomic,strong)NSMutableArray *incomeLogDataSource;//充值记录
@property (nonatomic,strong)NSMutableArray *expensesLogDataSource;//消费记录

@property (nonatomic,strong)UIButton * allBtn;//全部记录
@property (nonatomic,strong)UIButton * consumeBtn;//消费记录
@property (nonatomic,strong)UIButton * rechargeBtn;//充值记录

@property (nonatomic,strong)UIImageView * allLine;
@property (nonatomic,strong)UIImageView * consumeLine;
@property (nonatomic,strong)UIImageView * rechargeLine;

@property (nonatomic,strong)NSString *currencyOfTheBalance;

@property (nonatomic,strong)NSString *currentQuery;

@property (nonatomic,strong)NSString *purseState;

@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UILabel *titleL;//账户余额（币种）
@property (nonatomic,strong)UILabel * balance;//余额
@property (nonatomic,strong)UIButton * eyesBtn;//眼睛

@property (nonatomic,strong)AroundAnimation * around;
@end

@implementation PurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShow = NO;
    [self loadTableView];
    [self.view addSubview:[self header]];
    index = 1;
}
- (void)downData
{
    [self.around startAround];
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:WalletRecordApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            if ([responseObject[@"data"][@"walletLog"] count] != 0) {
                 [self.around stopAround];
                [self.walletLogDataSource removeAllObjects];
                [self.incomeLogDataSource removeAllObjects];
                [self.expensesLogDataSource removeAllObjects];
                
                NSArray *walletLogArr = responseObject[@"data"][@"walletLog"];
                self.walletLogDataSource = [NSMutableArray arrayWithArray:walletLogArr];
                NSArray *incomeLogArr = responseObject[@"data"][@"incomeLog"];
                self.incomeLogDataSource = [NSMutableArray arrayWithArray:incomeLogArr];
                NSArray *expensesLogArr = responseObject[@"data"][@"expensesLog"];
                self.expensesLogDataSource = [NSMutableArray arrayWithArray:expensesLogArr];
                balanceNum = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"walletAmount"] floatValue]];
                _titleL.text = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),responseObject[@"data"][@"currency"]];
                self.currencyOfTheBalance = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"currency"]];
                self.currentQuery = @"walletLog";
                
                [self.tableView reloadData];
            }
            
            self.purseState = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"sign"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)loadTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(kScreenH*0.5, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
    
    //没有数据时不显示cell
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
- (UIView *)header{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH*0.5)];
    _headerView.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];
    
    UILabel * backLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH*0.5*0.5)];
    CAGradientLayer *layerG = [CAGradientLayer new];
    layerG.colors=@[(__bridge id)[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
    layerG.startPoint = CGPointMake(0.5, 0);
    layerG.endPoint = CGPointMake(0.5, 1);
    layerG.frame = backLabel.bounds;
    [backLabel.layer addSublayer:layerG];
    [_headerView addSubview:backLabel];
    
    UIView * backV = [[UIView alloc]initWithFrame:CGRectMake(10, kScreenH*0.5*0.5*0.5, kScreenW-20, kScreenH*0.5*0.5)];
    backV.layer.cornerRadius = 10;
    backV.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:backV];
    
    _titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenW-20, (kScreenH*0.5*0.5)/4)];
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.textColor = [UIColor lightGrayColor];
    [backV addSubview:_titleL];
    
    _balance = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenH*0.5*0.5)/4, backV.width, (kScreenH*0.5*0.5)/2)];
    _balance.text = @"＊＊＊＊";
    _balance.textAlignment = NSTextAlignmentCenter;
    _balance.font = [UIFont systemFontOfSize:40];
    [backV addSubview:_balance];
    
    _eyesBtn = [[UIButton alloc]initWithFrame:CGRectMake((backV.width-[Unity countcoordinatesW:20])/2, kScreenH*0.5*0.5*0.75, [Unity countcoordinatesW:20], 15)];
    [_eyesBtn setBackgroundImage:[UIImage imageNamed:@"close_eyes"] forState:UIControlStateNormal];
    [_eyesBtn addTarget:self action:@selector(eyesClick) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:_eyesBtn];
    
    UIButton * cashBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,(kScreenH*0.5*0.75)+((kScreenH*0.5/4-50)/2), kScreenW/2-15, 50)];
    cashBtn.layer.cornerRadius = 25;
    [cashBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Cash", nil) forState:UIControlStateNormal];
    [cashBtn setTitleColor:[UIColor py_colorWithHexString:@"#b444c8"] forState:UIControlStateNormal];
    cashBtn.backgroundColor = [UIColor clearColor];
    [cashBtn.layer setBorderColor:[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
    [cashBtn.layer setBorderWidth:1.0];
    [cashBtn addTarget:self action:@selector(cashClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:cashBtn];
    
    UIButton * rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2+5, (kScreenH*0.5*0.75)+((kScreenH*0.5/4-50)/2), kScreenW/2-15, 50)];
    rechargeBtn.layer.cornerRadius = 25;
    [rechargeBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil) forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.backgroundColor = [UIColor py_colorWithHexString:@"#b444c8"];
    [rechargeBtn addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:rechargeBtn];
    return _headerView;
}
- (void)cashClick{
    CashViewController * CVC = [[CashViewController alloc]init];
    CVC.balance = balanceNum;
    CVC.currencyOfTheBalance = self.currencyOfTheBalance;
    CVC.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.barTintColor = Main_Color;
    [self.navigationController pushViewController:CVC animated:YES];
}
- (void)rechargeClick{
    RechargeViewController * RVC = [[RechargeViewController alloc]init];
    RVC.currencyOfTheBalance = self.currencyOfTheBalance;
    RVC.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.barTintColor = Main_Color;
    [self.navigationController pushViewController:RVC animated:YES];
}
- (void)eyesClick{
    if (!isShow) {
        _balance.text = balanceNum;
        [_eyesBtn setBackgroundImage:[UIImage imageNamed:@"open_eyes"] forState:UIControlStateNormal];
        isShow = YES;
    }else{
        _balance.text = @"＊＊＊＊";
        [_eyesBtn setBackgroundImage:[UIImage imageNamed:@"close_eyes"] forState:UIControlStateNormal];
        isShow = NO;
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableViewSectionHeaderV = [UIView new];

        tableViewSectionHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        tableViewSectionHeaderV.backgroundColor = [UIColor whiteColor];
        _allBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW/3, 48)];
        [_allBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Allrecords", nil) forState:UIControlStateNormal];
        [_allBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tableViewSectionHeaderV addSubview:_allBtn];
        
        _consumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/3, 0, kScreenW/3, 48)];
        [_consumeBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Recordsofconsumption", nil) forState:UIControlStateNormal];
        [_consumeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_consumeBtn addTarget:self action:@selector(consumeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tableViewSectionHeaderV addSubview:_consumeBtn];
        
        _rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/3*2, 0, kScreenW/3, 48)];
        [_rechargeBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_Rechargerecord", nil) forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [tableViewSectionHeaderV addSubview:_rechargeBtn];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, kScreenW, 1)];
        line.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        [tableViewSectionHeaderV addSubview:line];
        
        _allLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 48, kScreenW/3, 2)];
        _allLine.image = [UIImage imageNamed:@"msgline"];
        [tableViewSectionHeaderV addSubview:_allLine];
        
        _consumeLine = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/3, 48, kScreenW/3, 2)];
        _consumeLine.image = [UIImage imageNamed:@"msgline"];
        [tableViewSectionHeaderV addSubview:_consumeLine];
        
        _rechargeLine = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/3*2, 48, kScreenW/3, 2)];
        _rechargeLine.image = [UIImage imageNamed:@"msgline"];
        [tableViewSectionHeaderV addSubview:_rechargeLine];
        
        if (index ==1) {
            [_allBtn setTitleColor:Main_Color forState:UIControlStateNormal];
            [_consumeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_rechargeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _allLine.hidden = NO;
            _consumeLine.hidden = YES;
            _rechargeLine.hidden = YES;
        }else if (index == 2){
            [_allBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_consumeBtn setTitleColor:Main_Color forState:UIControlStateNormal];
            [_rechargeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _allLine.hidden = YES;
            _consumeLine.hidden = NO;
            _rechargeLine.hidden = YES;
        }else{
            [_allBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_consumeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_rechargeBtn setTitleColor:Main_Color forState:UIControlStateNormal];
            _allLine.hidden = YES;
            _consumeLine.hidden = YES;
            _rechargeLine.hidden = NO;
        }
    return tableViewSectionHeaderV;
}
- (void)allBtnClick{
    index = 1;
    self.currentQuery = @"walletLog";
    [self.tableView reloadData];
}
- (void)consumeBtnClick{
    index = 2;
    self.currentQuery = @"expensesLog";
    [self.tableView reloadData];
}

- (void)rechargeBtnClick{
    index = 3;
    self.currentQuery = @"incomeLog";
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletCell"];
    if (cell == nil) {
        cell = [[WalletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WalletCell"];
    }
    
//    if (indexPath.section) {
        if ([self.currentQuery isEqualToString:@"walletLog"]) {//全部记录
            
            
            cell.balanceLb.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),[self.walletLogDataSource[indexPath.row][@"after_amount"] floatValue]];
            cell.dateLb.text = self.walletLogDataSource[indexPath.row][@"change_time"];
            
            if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"recharge"]) {//充值
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
                cell.userName.textColor = [UIColor redColor];
                cell.numIdLb.text = @"";
//                cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"+%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
            }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"order"]){//支付订单
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentorder", nil);
                cell.userName.textColor = [UIColor greenColor];
                cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.walletLogDataSource[indexPath.row][@"body"][@"payNum"]];
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
            }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"package"]){//支付包裹
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentoffreight", nil);
                cell.userName.textColor = [UIColor greenColor];
                cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.walletLogDataSource[indexPath.row][@"body"][@"payNum"]];
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
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
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
            }else if ([self.walletLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund-fail"]){
                cell.numIdLb.text = @"";
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil);
                cell.userName.textColor = [UIColor redColor];
//                cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"+%.2f",[self.walletLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
            }
            
        }else if ([self.currentQuery isEqualToString:@"incomeLog"]){//收入记录
            
            cell.dateLb.text = self.incomeLogDataSource[indexPath.row][@"change_time"];
            cell.balanceLb.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),[self.incomeLogDataSource[indexPath.row][@"after_amount"] floatValue]];
            
            if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"recharge"]) {//充值

                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
                cell.userName.textColor = [UIColor redColor];
                cell.numIdLb.text = @"";
                NSString * profitNum = [NSString stringWithFormat:@"+%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                    cell.profitNum.attributedText = str;
            }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"order"]){//支付订单
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentorder", nil);
                cell.userName.textColor = [UIColor greenColor];
                cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.incomeLogDataSource[indexPath.row][@"body"][@"payNum"]];
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
            }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"package"]){//支付包裹
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentoffreight", nil);
                cell.userName.textColor = [UIColor greenColor];
                cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.incomeLogDataSource[indexPath.row][@"body"][@"payNum"]];
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
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
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
            }else if ([self.incomeLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund-fail"]){
                cell.numIdLb.text = @"";
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil);
                cell.userName.textColor = [UIColor redColor];
//                cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"+%.2f",[self.incomeLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
            }
            
        }else if ([self.currentQuery isEqualToString:@"expensesLog"]){//支出记录
            
            cell.dateLb.text = self.expensesLogDataSource[indexPath.row][@"change_time"];
            cell.balanceLb.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_Balance", nil),[self.expensesLogDataSource[indexPath.row][@"after_amount"] floatValue]];
            
            if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"recharge"]) {//充值
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
                cell.userName.textColor = [UIColor redColor];
                cell.numIdLb.text = @"";
//                cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"+%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
            }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"order"]){//支付订单
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentorder", nil);
                cell.userName.textColor = [UIColor greenColor];
                cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.expensesLogDataSource[indexPath.row][@"body"][@"payNum"]];
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
            }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"package"]){//支付包裹
                
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_Paymentoffreight", nil);
                cell.userName.textColor = [UIColor greenColor];
                cell.numIdLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Wallet_PayNumber", nil),self.expensesLogDataSource[indexPath.row][@"body"][@"payNum"]];
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
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
//                cell.profitNum.text = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
                
            }else if ([self.expensesLogDataSource[indexPath.row][@"source"]isEqualToString:@"refund-fail"]){
                cell.numIdLb.text = @"";
                cell.userName.text = NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Fail", nil);
                cell.userName.textColor = [UIColor redColor];
//                cell.profitNum.text = [NSString stringWithFormat:@"+%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSString * profitNum = [NSString stringWithFormat:@"+%.2f",[self.expensesLogDataSource[indexPath.row][@"amount"] floatValue]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:profitNum];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
                cell.profitNum.attributedText = str;
            }
        }
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@=%ld",self.currentQuery,(long)indexPath.row);
    
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My_Wallet", nil);
    
    [self downData];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self navGradient:0];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self navGradient:0.99];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <=0 && scrollView.contentOffset.y>=0-kScreenH*0.5) {
        CGFloat headerH = scrollView.contentOffset.y+kScreenH*0.5;
        _headerView.frame = CGRectMake(0, 0-headerH, kScreenW, kScreenH*0.5);
    }
    CGFloat sectionHeaderHeight = kScreenH*0.5;
    if (scrollView.contentOffset.y<=(0-STATUS_AND_NAVIGATION_HEIGHT) && scrollView.contentOffset.y>=0-sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(0-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=(0-STATUS_AND_NAVIGATION_HEIGHT)) {
        scrollView.contentInset = UIEdgeInsetsMake(STATUS_AND_NAVIGATION_HEIGHT, 0, 0, 0);
    }

    
    CGFloat minAlphaOffset = STATUS_AND_NAVIGATION_HEIGHT;
    CGFloat maxAlphaOffset = kScreenH*0.5;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = 0.99-((0-offset-minAlphaOffset) / (maxAlphaOffset-minAlphaOffset));
//    NSLog(@"%f",alpha);
    if (alpha<=0) {
        alpha = 0;
    }else if(alpha >=0.99){
        alpha = 0.99;
    }
    [self navGradient:alpha];
}
- (void)navGradient:(CGFloat)alpha{
    //把颜色生成图片
    UIColor *alphaColor = [UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:alpha];
    //把颜色生成图片
    UIImage *alphaImage = [self imageWithColor:alphaColor];
    //修改导航条背景图片
    [self.navigationController.navigationBar setBackgroundImage:alphaImage forBarMetrics:UIBarMetricsDefault];
}
// 颜色转为图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}
- (AroundAnimation *)around{
    if (_around == nil) {
        _around = [AroundAnimation AroundAnimationViewSetView:self.view];
    }
    return _around;
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
