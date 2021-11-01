//
//  PackChoosePayViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "PackChoosePayViewController.h"
#import "ChoosePayCell.h"

#import "ShopCartHeaderView.h"
@interface PackChoosePayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)NSArray *paytypeName;
@property (nonatomic,strong)NSArray *paytype;
@property (nonatomic, strong)ShopCartHeaderView *shopCartHeaderView;
@end

@implementation PackChoosePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)initData{
    self.paytypeName = @[@[NSLocalizedString(@"GlobalBuyer_PayView_paytype_1", nil),NSLocalizedString(@"GlobalBuyer_PayView_paytype_2", nil)],@[NSLocalizedString(@"GlobalBuyer_PayView_paytype_3", nil),NSLocalizedString(@"GlobalBuyer_PayView_paytype_4", nil)]];;
    self.paytype =  @[@[@"CREDIT",@"CVS"],@[@"APMP",@"UP"]];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_PayView_choespaytype", nil);
    [self.view addSubview:self.tabelView];
    [self setNavigationBackBtn];
    
}

- (UITableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH)) style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
       _tabelView.tableHeaderView = self.shopCartHeaderView;
    }
    return _tabelView;
}

#pragma mark 创建UI界面
- (ShopCartHeaderView *)shopCartHeaderView {
    if (_shopCartHeaderView == nil) {
        _shopCartHeaderView = [[ShopCartHeaderView alloc]init];
        _shopCartHeaderView.frame =CGRectMake(0, 64, kScreenW, [_shopCartHeaderView getH]);
    }
    return _shopCartHeaderView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 2;
    }
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return NSLocalizedString(@"GlobalBuyer_PayView_taiwan", nil);
    }else{
        return NSLocalizedString(@"GlobalBuyer_PayView_dalu", nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePayCell *cell = TableViewCellDequeueInit(NSStringFromClass([ChoosePayCell class]));
    
    TableViewCellDequeueXIB(cell, ChoosePayCell);
   
    cell.textLabel.text = self.paytypeName[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *urlString ;
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSString *paytype = self.paytype[indexPath.section][indexPath.row];
//    if (indexPath.section == 0) {
//        urlString = [NSString stringWithFormat:TransportPayApi,userToken,paytype,self.idsStr];
//    }else{
//        urlString = [NSString stringWithFormat:MomotransportPayApi,userToken,paytype,self.idsStr];
//        
//    }
    
    PackPayViewController *payVC = [[PackPayViewController alloc]init];
    payVC.urlString = urlString;
    payVC.OrderVC = self.OrderVC;
    [self.navigationController pushViewController:payVC animated:YES];
    
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
