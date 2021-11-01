//
//  MineViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "MineViewController.h"
#import "WaterWaveView.h"
#import "LoginViewController.h"
#import "MineTableViewCell.h"
#import "AddressViewController.h"
#import "UserInfoViewController.h"
#import "OrderViewController.h"
#import "MineOrderCell.h"
#import "JPhotoMagenage.h"
#import "AboutViewController.h"
#import "CollectionViewController.h"
#import "BindIDViewController.h"
#import "NoPayViewController.h"
#import "ProcurementViewController.h"
#import "AlreadyPayViewController.h"
#import "AuditStatusViewController.h"
#import "AwaitingDeliveryViewController.h"
#import "AlreadyShippedViewController.h"
#import "ReceivedViewController.h"
#import "MyQRCodeViewController.h"
#import "CooperationProfitViewController.h"
#import "MyFriendViewController.h"
#import "CouponViewController.h"
#import "WalletViewController.h"

#import "NSBundle+Language.h"
#import "AppDelegate+RootController.h"
#import "ShowUserInfoViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>

#import "ApplyExtensionIntroduceViewController.h"

#import "TaobaoLogisticsNumberViewController.h"
#import "TaobaoPackViewController.h"
#import "ReceivingAreaViewController.h"

@interface MineViewController ()<WaterWaveViewDetegate,UITableViewDelegate,UITableViewDataSource,MineOrderCellDelegate>

@property (nonatomic, strong)WaterWaveView *waterWaveView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UserModel *model;
@property (nonatomic, strong)NSMutableArray *dataSoucer;

@property (nonatomic, assign)BOOL isBindWeChat;
@property (nonatomic, assign)BOOL isBindFacebook;

@property (nonatomic, strong)NSString *weChatBindState;
@property (nonatomic, strong)NSString *faceBookBindState;

@property (nonatomic, strong)NSMutableArray *goodsNumDataSource;

@property (nonatomic,strong)NSString *taobaoNumOne;
@property (nonatomic,strong)NSString *taobaoNumTwo;
@property (nonatomic,strong)NSString *taobaoNumThree;
@property (nonatomic,strong)NSString *taobaoNumFour;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉导航栏下面的黑线
//    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
    self.isBindWeChat = NO;
    self.isBindFacebook = NO;
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My", nil);
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay:) name:@"pay" object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark 通知
- (void)pay:(NSNotification*)notification {
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message", nil) message:NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_commodity", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (NSMutableArray *)goodsNumDataSource
{
    if (_goodsNumDataSource == nil) {
        _goodsNumDataSource = [NSMutableArray new];
    }
    return _goodsNumDataSource;
}

#pragma mark 加载数据源
-(NSMutableArray *)dataSoucer {
    if (_dataSoucer ==nil) {
        _dataSoucer = [[NSMutableArray alloc]init];
        
        NSString *str11;
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"WECHATBIND"]isEqualToString:@"NO"] || ![self chenkUserLogin]) {
            str11 = NSLocalizedString(@"GlobalBuyer_My_bindWeChatLogin", nil);
            self.weChatBindState = NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil);
        }else{
            str11 = NSLocalizedString(@"GlobalBuyer_My_unbindWeChatLogin", nil);
            self.weChatBindState = NSLocalizedString(@"GlobalBuyer_My_BindState_YES", nil);
        }
        NSString *str12;
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBIND"]isEqualToString:@"NO"] || ![self chenkUserLogin]) {
            str12 = NSLocalizedString(@"GlobalBuyer_My_bindFaceBookLogin", nil);
            self.faceBookBindState = NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil);
        }else{
            str12 = NSLocalizedString(@"GlobalBuyer_My_unbindFaceBookLogin", nil);
            self.faceBookBindState = NSLocalizedString(@"GlobalBuyer_My_BindState_YES", nil);
        }
        NSString *str19 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Coupon", nil);
        NSString *str9 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Collection", nil);
        NSString *str2 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Wait", nil);
        NSString *str16 = NSLocalizedString(@"GlobalBuyer_My_purchasinggoods_title", nil);
        NSString *str1 = NSLocalizedString(@"GlobalBuyer_My_WaitPack", nil);
        NSString *str3 = NSLocalizedString(@"GlobalBuyer_My_paymentofbalance", nil);
        NSString *str4 = NSLocalizedString(@"GlobalBuyer_My_WaitDeliverGoods", nil);
        NSString *str5 = NSLocalizedString(@"GlobalBuyer_My_Shipped", nil);
        NSString *str15 = NSLocalizedString(@"GlobalBuyer_My_CompletedOrder", nil);
        NSString *str7 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil);
//        NSString *str10 = NSLocalizedString(@"GlobalBuyer_My_BindID", nil);
        NSString *str13 = NSLocalizedString(@"GlobalBuyer_My_shareinthewechat", nil);
        NSString *str8 = NSLocalizedString(@"GlobalBuyer_My_About_Version", nil);
        NSString *str14 = NSLocalizedString(@"GlobalBuyer_My_Profit", nil);
        NSString *str17 = NSLocalizedString(@"GlobalBuyer_My_QRCode", nil);
        NSString *str18 = NSLocalizedString(@"GlobalBuyer_My_MyFriend", nil);
        //NSString *str20 = NSLocalizedString(@"GlobalBuyer_My_SetLanguage", nil);
        NSString *str21 = NSLocalizedString(@"GlobalBuyer_My_Wallet", nil);
        
        NSString *str22 = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ExpressOrderNumberToBeFilled", nil);
        NSString *str23 = NSLocalizedString(@"GlobalBuyer_My_WaitPack", nil);
        NSString *str24 = NSLocalizedString(@"GlobalBuyer_My_paymentofbalance", nil);
        NSString *str25 = NSLocalizedString(@"GlobalBuyer_My_WaitDeliverGoods", nil);
        NSString *str26 = NSLocalizedString(@"GlobalBuyer_My_ModifyAddress", nil);
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"DistributorBoss"]isEqualToString:@"true"]) {
            _dataSoucer = [[NSMutableArray alloc]initWithArray:@[@[@{@"img":@"ic_qrcode",@"name":str17},@{@"img":@"ic_profit",@"name":str14},@{@"img":@"ic_friend",@"name":str18},@{@"img":@"钱包",@"name":str21},@{@"img":@"优惠券",@"name":str19},@{@"img":@"ic_xin",@"name":str9},@{@"img":@"bindw",@"name":str11},@{@"img":@"bindF",@"name":str12}],@[@{@"img":@"ic_unpaid",@"name":str22},@{@"img":@"mine_order",@"name":str23},@{@"img":@"ic_up_address",@"name":str24},@{@"img":@"ic_purchase",@"name":str25}],@[@{@"img":@"ic_unpaid",@"name":str2},@{@"img":@"ic_Procurement",@"name":str16},@{@"img":@"mine_order",@"name":str1},@{@"img":@"ic_up_address",@"name":str3},@{@"img":@"ic_purchase",@"name":str4},@{@"img":@"ic_shipments",@"name":str15},@{@"img":@"售后中心",@"name":str5}],@[@{@"img":@"address",@"name":str7},@{@"img":@"更改地区",@"name":str26}],@[@{@"img":@"nil",@"name":str13}],@[@{@"img":@"nil",@"name":str8}]]];
        }else{
            _dataSoucer = [[NSMutableArray alloc]initWithArray:@[@[@{@"img":@"钱包",@"name":str21},@{@"img":@"优惠券",@"name":str19},@{@"img":@"ic_xin",@"name":str9},@{@"img":@"bindw",@"name":str11},@{@"img":@"bindF",@"name":str12}],@[@{@"img":@"ic_unpaid",@"name":str22},@{@"img":@"mine_order",@"name":str23},@{@"img":@"ic_up_address",@"name":str24},@{@"img":@"ic_purchase",@"name":str25}],@[@{@"img":@"ic_unpaid",@"name":str2},@{@"img":@"ic_Procurement",@"name":str16},@{@"img":@"mine_order",@"name":str1},@{@"img":@"ic_up_address",@"name":str3},@{@"img":@"ic_purchase",@"name":str4},@{@"img":@"ic_shipments",@"name":str15},@{@"img":@"售后中心",@"name":str5}],@[@{@"img":@"address",@"name":str7},@{@"img":@"更改地区",@"name":str26}],@[@{@"img":@"nil",@"name":str13}],@[@{@"img":@"nil",@"name":str8}]]];
        }

    }
    return _dataSoucer;
}

#pragma mark 创建UI
- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.waterWaveView setName:NSLocalizedString(@"GlobalBuyer_My_Login", nil)];
    self.tableView.tableHeaderView = self.waterWaveView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_My_NavRight", nil) style: UIBarButtonItemStylePlain target:self action:@selector(userInfoClick)];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH) -kTabBarH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 0;
    }

    return _tableView;
}
//禁止 tableView 下拉 允许上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = _tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    _tableView.contentOffset = offset;
}
- (WaterWaveView *)waterWaveView {
    if (_waterWaveView == nil) {
        _waterWaveView = [[WaterWaveView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 200)];
        _waterWaveView.backgroundColor =[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1];
        _waterWaveView.delegate = self;
    }
    return _waterWaveView;
}

#pragma mark tableView代理
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSoucer[section] count];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSoucer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 88;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 88)];
        UIView *applyV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        applyV.backgroundColor = [UIColor whiteColor];
        [headerInSection addSubview:applyV];
        UIImageView *applyIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 44, 44)];
        applyIV.image = [UIImage imageNamed:@"分销申请"];
        [headerInSection addSubview:applyIV];
        applyV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WithdrawMoneyClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [applyV addGestureRecognizer:tap];
        UILabel *lla = [[UILabel alloc]initWithFrame:CGRectMake(74, 0, 200, 44)];
        lla.text = NSLocalizedString(@"GlobalBuyer_My_DistributionActivities", nil);
        lla.font = [UIFont systemFontOfSize:12];
        [headerInSection addSubview:lla];
        
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(10, 44, 100, 44);
        la.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Order", nil);
        la.font = [UIFont systemFontOfSize:13];
        la.textColor = [UIColor grayColor];
        [headerInSection addSubview:la];
        return headerInSection;
    }else if (section == 1){
        UIView *headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(10, 0, 100, 44);
        la.text = NSLocalizedString(@"淘宝转运", nil);
        la.font = [UIFont systemFontOfSize:13];
        la.textColor = [UIColor grayColor];
        [headerInSection addSubview:la];
        return headerInSection;
    }else if (section == 2) {
        UIView *headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(10, 0, 100, 44);
        la.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_HeaderTitle", nil);
        la.font = [UIFont systemFontOfSize:13];
        la.textColor = [UIColor grayColor];
        [headerInSection addSubview:la];
        return headerInSection;
    }else if(section == 3){
        UIView *headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(10, 0, 140, 44);
        la.text = NSLocalizedString(@"GlobalBuyer_My_Addmanagement", nil);
        la.font = [UIFont systemFontOfSize:13];
        la.textColor = [UIColor grayColor];
        [headerInSection addSubview:la];
        return headerInSection;
    }else if (section == 4){
        UIView *headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(10, 0, 100, 44);
        la.text = NSLocalizedString(@"GlobalBuyer_My_Share", nil);
        la.font = [UIFont systemFontOfSize:13];
        la.textColor = [UIColor grayColor];
        [headerInSection addSubview:la];
        return headerInSection;
    }else if(section == 5){
        UIView *headerInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UILabel *la = [[UILabel alloc]init];
        la.frame = CGRectMake(10, 0, 100, 44);
        la.text = NSLocalizedString(@"GlobalBuyer_My_About", nil);
        la.font = [UIFont systemFontOfSize:13];
        la.textColor = [UIColor grayColor];
        [headerInSection addSubview:la];
        return headerInSection;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineTableViewCell *cell = TableViewCellDequeueInit(NSStringFromClass([MineTableViewCell class]));

    TableViewCellDequeueXIB(cell, MineTableViewCell);
    
    NSDictionary *dict = self.dataSoucer[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"DistributorBoss"]isEqualToString:@"true"]) {
            cell.iconImgView.image = [UIImage imageNamed:dict[@"img"]] ;
            cell.nameLa.text = dict[@"name"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == 6) {
                cell.statusLab.text = self.weChatBindState;
                cell.statusLab.hidden = NO;
            }
            else if (indexPath.row == 7) {
                cell.statusLab.text = self.faceBookBindState;
                cell.statusLab.hidden = NO;
            }else{
                cell.statusLab.hidden = YES;
            }
        }else{
            cell.iconImgView.image = [UIImage imageNamed:dict[@"img"]] ;
            cell.nameLa.text = dict[@"name"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (indexPath.row == 3) {
                cell.statusLab.text = self.weChatBindState;
                cell.statusLab.hidden = NO;
            }
            else if (indexPath.row == 4) {
                cell.statusLab.text = self.faceBookBindState;
                cell.statusLab.hidden = NO;
            }else{
                cell.statusLab.hidden = YES;
            }
        }


    }
    
    if (indexPath.section == 1) {
        cell.iconImgView.image = [UIImage imageNamed:dict[@"img"]] ;
        cell.nameLa.text = dict[@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLab.hidden = YES;
        
        cell.numLb.layer.backgroundColor = [UIColor whiteColor].CGColor;
        cell.numLb.layer.cornerRadius = 7.5;
        cell.numLb.font = [UIFont systemFontOfSize:8];
        cell.numLb.textAlignment = NSTextAlignmentCenter;
        cell.numLb.textColor = [UIColor redColor];
        cell.numLb.layer.borderColor = [UIColor redColor].CGColor;
        cell.numLb.layer.borderWidth = 0.6;
        
        if (indexPath.row == 0) {
            if ([self.taobaoNumOne intValue] != 0) {
                cell.numLb.text = self.taobaoNumOne;
                cell.numLb.hidden = NO;
            }else{
                cell.numLb.hidden = YES;
            }
        }
        if (indexPath.row == 1) {
            if ([self.taobaoNumTwo intValue] != 0) {
                cell.numLb.text = self.taobaoNumTwo;
                cell.numLb.hidden = NO;
            }
            else{
                cell.numLb.hidden = YES;
            }
        }
        if (indexPath.row == 2) {
            if ([self.taobaoNumThree intValue] != 0) {
                cell.numLb.text = self.taobaoNumThree;
                cell.numLb.hidden = NO;
            }
            else{
                cell.numLb.hidden = YES;
            }
        }
        if (indexPath.row == 3) {
            if ([self.taobaoNumFour intValue] != 0) {
                cell.numLb.text = self.taobaoNumFour;
                cell.numLb.hidden = NO;
            }
            else{
                cell.numLb.hidden = YES;
            }
        }
    }
    
    if (indexPath.section == 2) {
        cell.iconImgView.image = [UIImage imageNamed:dict[@"img"]] ;
        cell.nameLa.text = dict[@"name"];
        cell.statusLab.hidden = YES;
        cell.numLb.layer.backgroundColor = [UIColor whiteColor].CGColor;
        cell.numLb.layer.cornerRadius = 7.5;
        cell.numLb.font = [UIFont systemFontOfSize:8];
        cell.numLb.textAlignment = NSTextAlignmentCenter;
        cell.numLb.textColor = [UIColor redColor];
        cell.numLb.layer.borderColor = [UIColor redColor].CGColor;
        cell.numLb.layer.borderWidth = 0.6;
        if (self.goodsNumDataSource.count == 0 || [self.goodsNumDataSource[indexPath.row]isEqualToString:@"0"]) {
            cell.numLb.hidden = YES;
        }else{
            if (![self.goodsNumDataSource[indexPath.row] isEqualToString:@""]) {
                cell.numLb.text = self.goodsNumDataSource[indexPath.row];
                cell.numLb.hidden = NO;
            }
            
            if (indexPath.row == 5) {
                cell.numLb.hidden = YES;
            }else{
                cell.numLb.hidden = NO;
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 3) {
        cell.iconImgView.image = [UIImage imageNamed:dict[@"img"]] ;
        cell.nameLa.text = dict[@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLab.hidden = YES;
    }

    if (indexPath.section == 4) {
        cell.textLabel.text = dict[@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.iconImgView.image = nil;
        cell.nameLa.text = nil;
        cell.statusLab.hidden = YES;
    }
    if (indexPath.section == 5) {
        cell.textLabel.text = dict[@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.iconImgView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLa.text = nil;
        cell.statusLab.hidden = YES;
    }
    //实时刷新 数量角标  不登录隐藏
    if (![self chenkUserLogin]) {
        cell.numLb.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            AboutViewController *aboutVC = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            return;
        }
        if (indexPath.row == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            
            UIAlertAction *chinaJ = [UIAlertAction actionWithTitle:@"简体中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                    [NSBundle setLanguage:@"zh-Hans"];
                
                
                [[NSUserDefaults standardUserDefaults]setObject:@"zh-Hans" forKey:@"UserSelectLanguage"];
                
                    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
                    for (NSString *fileName in enumerator) {
                        [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
                    }
                
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate gotoHomeVC];
                
            }];
            [alert addAction:chinaJ];
            
            UIAlertAction *chinaF = [UIAlertAction actionWithTitle:@"繁體中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [NSBundle setLanguage:@"zh-Hant"];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"zh-Hant" forKey:@"UserSelectLanguage"];
                
                    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
                    for (NSString *fileName in enumerator) {
                        [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
                    }
                
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate gotoHomeVC];
            }];
            [alert addAction:chinaF];
            
            UIAlertAction *en = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [NSBundle setLanguage:@"en"];
                
                  [[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"UserSelectLanguage"];
                
                    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
                    for (NSString *fileName in enumerator) {
                        [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
                    }
                
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate gotoHomeVC];
            }];
            [alert addAction:en];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }

    }
    
    if (indexPath.section == 4) {
        NSString *text = NSLocalizedString(@"GlobalBuyer_My_Share_text", nil);
        UMSocialMessageObject *message = [[UMSocialMessageObject alloc]init];
        UMShareWebpageObject *url = [[UMShareWebpageObject alloc]init];
        url.title = text;
        url.thumbImage = [UIImage imageNamed:@"logIcon.png"];
        url.webpageUrl = REURL;
        message.shareObject = url;
        [[UMSocialManager defaultManager]shareToPlatform:UMSocialPlatformType_WechatSession messageObject:message currentViewController:self completion:^(id result, NSError *error) {
            
        }];
    }
    
    if (![self chenkUserLogin]) {
        [self loginClick];
        return;
    }
    
    if (indexPath.section == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"DistributorBoss"]isEqualToString:@"true"]) {
            if (indexPath.row == 6) {
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"WECHATBIND"] isEqualToString:@"NO"]) {
                    [self weChatClick];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureWeChat", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                    alert.tag = 666;
                    [alert show];
                }
                
            }
            
            if (indexPath.row == 7) {
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBIND"] isEqualToString:@"NO"]) {
                    [self facebookClick];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureFaceBook", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                    alert.tag = 888;
                    [alert show];
                }
            }
            
            if (indexPath.row == 4) {
                CouponViewController *couponVC = [[CouponViewController alloc]init];
                couponVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:couponVC animated:YES];
            }
            
            if (indexPath.row == 5) {
                CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
            
            //二维码
            if (indexPath.row == 0) {
                MyQRCodeViewController *myQRCodeV = [[MyQRCodeViewController alloc]init];
                myQRCodeV.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myQRCodeV animated:YES];
            }
            
            //利润
            if (indexPath.row == 1) {
                CooperationProfitViewController *coopProfitVC = [[CooperationProfitViewController alloc]init];
                coopProfitVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:coopProfitVC animated:YES];
            }
            
            //我的朋友
            if (indexPath.row == 2) {
                MyFriendViewController *myFirendV = [[MyFriendViewController alloc]init];
                myFirendV.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myFirendV animated:YES];
            }
            
            //钱包
            if (indexPath.row == 3) {
                WalletViewController *walletVC = [[WalletViewController alloc]init];
                walletVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walletVC animated:YES];
            }
            
        }else{
            
            if (indexPath.row == 0) {
                WalletViewController *walletVC = [[WalletViewController alloc]init];
                walletVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walletVC animated:YES];
            }
            
            if (indexPath.row == 1) {
                CouponViewController *couponVC = [[CouponViewController alloc]init];
                couponVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:couponVC animated:YES];
            }
            
            if (indexPath.row == 2) {
                CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
            
            if (indexPath.row == 3) {
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"WECHATBIND"] isEqualToString:@"NO"]) {
                    [self weChatClick];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureWeChat", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                    alert.tag = 666;
                    [alert show];
                }
                
            }
            
            if (indexPath.row == 4) {
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBIND"] isEqualToString:@"NO"]) {
                    [self facebookClick];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureFaceBook", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                    alert.tag = 888;
                    [alert show];
                }
            }
            

        }

    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TaobaoLogisticsNumberViewController *vc = [[TaobaoLogisticsNumberViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            TaobaoPackViewController *vc = [[TaobaoPackViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            AuditStatusViewController *auditVC =[[AuditStatusViewController alloc]init];
            auditVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:auditVC animated:YES];
        }
        if (indexPath.row == 3) {
            AlreadyShippedViewController *alreadySVC = [[AlreadyShippedViewController alloc]init];
            alreadySVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:alreadySVC animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
//        OrderViewController *orderVC = [OrderViewController new];
//        orderVC.hidesBottomBarWhenPushed = YES;
//        orderVC.index = indexPath.row;
//        [self.navigationController pushViewController:orderVC animated:YES];
        if (indexPath.row == 0) {
            NoPayViewController *nopayVC = [[NoPayViewController alloc]init];
            nopayVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nopayVC animated:YES];
        }
        if (indexPath.row == 1) {
            ProcurementViewController *procurementVC = [[ProcurementViewController alloc]init];
            procurementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:procurementVC animated:YES];
        }
        if (indexPath.row == 2) {
            AlreadyPayViewController *alreadyVC = [[AlreadyPayViewController alloc]init];
            alreadyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:alreadyVC animated:YES];
        }
        if (indexPath.row == 3) {
            AuditStatusViewController *auditVC =[[AuditStatusViewController alloc]init];
            auditVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:auditVC animated:YES];
        }
        if (indexPath.row == 4) {
            AlreadyShippedViewController *alreadySVC = [[AlreadyShippedViewController alloc]init];
            alreadySVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:alreadySVC animated:YES];
        }
        if (indexPath.row == 5) {
            ReceivedViewController *receivedVC = [[ReceivedViewController alloc]init];
            receivedVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:receivedVC animated:YES];
        }
        if (indexPath.row == 6) {
            AwaitingDeliveryViewController *awaitingVC = [[AwaitingDeliveryViewController alloc]init];
            awaitingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:awaitingVC animated:YES];
        }
    }
 
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            AddressViewController *addressVC = [AddressViewController new];
            addressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
//        if (indexPath.row == 1) {
//            BindIDViewController *bindIdVc = [[BindIDViewController alloc]init];
//            bindIdVc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:bindIdVc animated:YES];
//        }
        if (indexPath.row == 1) {
            ReceivingAreaViewController *receivingAreaVC = [[ReceivingAreaViewController alloc]init];
            receivingAreaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:receivingAreaVC animated:YES];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 666) {
        [self cancelWeChat];
    }
    
    if (buttonIndex == 1 && alertView.tag == 888) {
        [self cancelFacebook];
    }
}

- (void)weChatClick {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession  currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (error) {
            
        }else{
            if (resp.originalResponse[@"errcode"]) {
                NSLog(@"无效的openid");
                [self weChatClick];
            }else{
                [self bindWeChatWithUnionid:resp.originalResponse[@"unionid"] headImgUrl:resp.originalResponse[@"headimgurl"]];
            }
        }
    }];
}

- (void)bindWeChatWithUnionid:(NSString *)unionid headImgUrl:(NSString *)headImgUrl
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_binding", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"unionid"] = unionid;
    parameters[@"weixinAvatar"] = headImgUrl;
    
    [manager POST:BindWeChatApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"WECHATBIND"];
            self.isBindWeChat = YES;
            [self.dataSoucer removeAllObjects];
            self.dataSoucer = nil;
            [self.tableView reloadData];
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            

            [[NSUserDefaults standardUserDefaults]setObject:headImgUrl forKey:@"UserHeadImgUrl"];
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"]) {
                [self.waterWaveView.iconView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"] placeholderImage:[UIImage imageNamed:@"icon"]];
            }
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_Hasbind", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (void)cancelWeChat
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_unbinding", nil);
    
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:CancelBindWeChatApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
            self.isBindWeChat = NO;
            [self.dataSoucer removeAllObjects];
            self.dataSoucer = nil;
            [self.tableView reloadData];

            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}


- (void)facebookClick {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Facebook currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        NSLog(@" originalResponse: %@", resp);
        if (!error) {
            
            [self bindfacebookLoginApi:resp.originalResponse[@"id"]];
        }
    }];
}

-(void)bindfacebookLoginApi:(NSString *)fbid
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_binding", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"fid"] = fbid;
    
    [manager POST:BindFaceBookApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"FACEBIND"];
            self.isBindFacebook = YES;
            [self.dataSoucer removeAllObjects];
            self.dataSoucer = nil;
            [self.tableView reloadData];
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_Hasbind", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (void)cancelFacebook
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_unbinding", nil);
    
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:CancelBindFaceBookApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
            self.isBindFacebook = NO;
            [self.dataSoucer removeAllObjects];
            self.dataSoucer = nil;
            [self.tableView reloadData];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

#pragma mark 个人信息按钮事件
- (void)userInfoClick {
    
    if ([self chenkUserLogin]) {
        
        ShowUserInfoViewController *showUserInfoVC = [[ShowUserInfoViewController alloc]init];
        showUserInfoVC.hidesBottomBarWhenPushed = YES;
        showUserInfoVC.model = self.model;
        [self.navigationController pushViewController:showUserInfoVC animated:YES];
//
//        UserInfoViewController *userInfoVC = [UserInfoViewController new];
//        userInfoVC.hidesBottomBarWhenPushed = YES;
//        userInfoVC.model = self.model;
//        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else{
         [self loginClick];
    }
    
}

#pragma mark 登录事件
- (void)loginClick {

    LoginViewController *loginVC = [LoginViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark 设置 nameLa
-(void)userInfo:(UserModel *)model {

    [self.waterWaveView setName:model.fullname];
}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);;
    NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
    self.model = [[UserModel alloc]initWithDictionary:dict error:nil];
    
    if (userToken) {
        if ([self.model.fullname isEqualToString: @""] || !self.model.fullname) {
            [self.waterWaveView setName:@"未命名"];
        }else{
            [self userInfo:self.model];
        }
        
//        NSString *imgName = UserDefaultObjectForKey(USERTOKEN);
//        NSString *path_sandox = NSHomeDirectory();
//        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat: @"/Documents/%@.png",imgName]];
//        
//        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
//        if (img) {
//            self.waterWaveView.iconView.image = img;
//        }
        NSString *imgName = UserDefaultObjectForKey(USERTOKEN);
        NSLog(@"touken = %@",imgName);
        NSString *path_sandox = NSHomeDirectory();
        
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat: @"/Documents/%@.png",imgName]];
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        self.waterWaveView.iconView.image = img;
//        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"]) {
//            [self.waterWaveView.iconView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"] placeholderImage:[UIImage imageNamed:@"icon"]];
//        }
        
        self.waterWaveView.nameLa.userInteractionEnabled = NO;
        
        [self.dataSoucer removeAllObjects];
        self.dataSoucer = nil;
        [self.tableView reloadData];
        
        [self downLoadNumOfGoods];
    }else{
    
        [self.waterWaveView setName:NSLocalizedString(@"GlobalBuyer_My_Login", nil)];
        self.waterWaveView.iconView.image = [UIImage imageNamed:@"icon"];
        self.waterWaveView.nameLa.userInteractionEnabled = YES;
        
        [self.goodsNumDataSource removeAllObjects];
        [self.dataSoucer removeAllObjects];
        self.dataSoucer = nil;
        [self.tableView reloadData];
    }
    [self.waterWaveView readyToBegin];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshGoodsNum" object:nil];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(delayMethodHome) withObject:nil afterDelay:0.5];
}

- (void)downLoadNumOfGoods
{

    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:GetAllStateGoodsApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.goodsNumDataSource removeAllObjects];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"payWaitOrder"]]];
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"buyWaitProduct"]]];
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"packWaitProduct"]]];
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"payWaitPackage"]]];
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"completePackage"]]];
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"receiveCompletePackage"]]];
            [self.goodsNumDataSource addObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"afterSale"]]];
            self.taobaoNumOne = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"updateExpressProducts"]];
            self.taobaoNumTwo = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"transportStoragePackage"]];
            self.taobaoNumThree = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"payWaitPackage"]];
            self.taobaoNumFour = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"completePackage"]];
            [self.tableView reloadData];
        }
        
        //[self judgeVipMember];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self judgeVipMember];
    }];
}

- (void)judgeVipMember
{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:JudgeVipMemberApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)delayMethod
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPushNoPayView"] isEqualToString:@"YES"]) {
        NoPayViewController *nopayVC = [[NoPayViewController alloc]init];
        nopayVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nopayVC animated:YES];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPushProcurementView"] isEqualToString:@"YES"]) {
        ProcurementViewController *VC = [[ProcurementViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsAlreadyShipped"] isEqualToString:@"YES"]) {
        AlreadyShippedViewController *VC = [[AlreadyShippedViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (void)delayMethodHome
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"GotoHomeMark"]isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"GotoHomeMark"];
        self.tabBarController.selectedIndex = 0;
    }
}

- (void)orderClick:(NSInteger)index{
    if (![self chenkUserLogin]) {
        [self loginClick];
        return;
    }
    OrderViewController *orderVC = [OrderViewController new];
    orderVC.hidesBottomBarWhenPushed = YES;
    orderVC.index = index + 1;
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

-(void)changeIcon{
    if (![self chenkUserLogin]) {
        return;
    }

    [JPhotoMagenage getOneImageInController:self finish:^(UIImage *images) {
        NSLog(@"%@",images);
      
        NSData *data =UIImageJPEGRepresentation(images, 0.5);
        UIImage *img = [UIImage imageWithData:data];
        NSString *imgName = UserDefaultObjectForKey(USERTOKEN);
        
        NSString *path_sandox = NSHomeDirectory();
        
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat: @"/Documents/%@.png",imgName]];
        
        [UIImagePNGRepresentation(img) writeToFile:imagePath atomically:YES];
        
        self.waterWaveView.iconView.image = img;
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        hud.label.text= NSLocalizedString(@"正在上传", nil);
        
        NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSData *dataAvatar;
        if (UIImagePNGRepresentation(images) == nil) {
            
            dataAvatar = UIImageJPEGRepresentation(images, 1);
            
        } else {
            
            dataAvatar = UIImagePNGRepresentation(images);
        }
        
        
        NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
        [manager POST:UploadAvatarApi parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:dataAvatar name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];
            
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hideAnimated:YES];
            
            if ([responseObject[@"code"]isEqualToString:@"success"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"上传成功!", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"上传失败!", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }];
        
        
    } cancel:^{
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pay" object:self];
}

- (void)WithdrawMoneyClick
{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken) {
        ApplyExtensionIntroduceViewController *applyExtensionIntroduce = [[ApplyExtensionIntroduceViewController alloc]init];
        applyExtensionIntroduce.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:applyExtensionIntroduce animated:YES];
    }else{
        [self loginClick];
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
