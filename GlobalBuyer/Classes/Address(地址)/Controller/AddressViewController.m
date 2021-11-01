//
//  AddressViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/25.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AddressViewController.h"
#import "EditAdderssViewController.h"
#import "AddressCell.h"
#import "NewAddressManagementViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddressCellDelegate,EditAdderssViewControllerDelegate>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UIButton *addAddressBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Address_AddAdmin", nil);
    [self setupUI];
    [self dowloadData];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI界面
- (void)setupUI {
    [self setNavigationBackBtn];
    [self.view addSubview:self.tabelView];
    [self.view addSubview:self.addAddressBtn];
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UITableView *)tabelView{
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH  - (kNavigationBarH + kStatusBarH) - kTabBarH) style:UITableViewStylePlain];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.rowHeight = 90;
    }
    return _tabelView;
}

/*
 添加新地址按钮
**/
- (UIButton *)addAddressBtn {
    if (_addAddressBtn == nil) {
        _addAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  kScreenH - NavBarHeight- 49, kScreenW,49)];
        _addAddressBtn.backgroundColor = Main_Color;
        [_addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addAddressBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_AddNewAdd", nil) forState:UIControlStateNormal];
        [_addAddressBtn addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}

#pragma mark tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressCell *cell =  TableViewCellDequeueInit(NSStringFromClass([AddressCell class]));
    TableViewCellDequeueXIB(cell, AddressCell);
    
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.hideBtn = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    [self dowloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isShopCart) {
        [self.delegate sendAdressModel:self.dataSource[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (_istrue) {
        [self.delegate changeAddress:self.dataSource[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self.taobao isEqualToString:@"1"]) {
        [self.delegate changeAddress:self.dataSource[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
//    EditAdderssViewController *editAdderssVC = [EditAdderssViewController new];
//    [self.navigationController pushViewController:editAdderssVC animated:YES];

}

#pragma mark 添加新地址按钮点击事件
-(void)addAddressClick {

    NewAddressManagementViewController *addAdderssVC = [NewAddressManagementViewController new];
//    addAdderssVC.delegate = self;
    addAdderssVC.editType = @"New";
    addAdderssVC.title = NSLocalizedString(@"GlobalBuyer_Address_AddNewAdd", nil);
    addAdderssVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAdderssVC animated:YES];

}

-(void)addAddressModel:(AddressModel *)addressModel{
    [self.dataSource removeAllObjects];
    [self dowloadData];
}

#pragma mark AddressCellDelegate代理方法
- (void)editAddress:(AddressModel *)model{
    NSLog(@"编辑地址");
//    EditAdderssViewController *addAdderssVC = [EditAdderssViewController new];
//    addAdderssVC.hidesBottomBarWhenPushed = YES;
//    addAdderssVC.model = model;
//    addAdderssVC.delegate = self;
//    [self.navigationController pushViewController:addAdderssVC animated:YES];
    
    NewAddressManagementViewController *addAdderssVC = [NewAddressManagementViewController new];
    //    addAdderssVC.delegate = self;
    addAdderssVC.editType = @"Edit";
    addAdderssVC.model = model;
    addAdderssVC.title = NSLocalizedString(@"GlobalBuyer_Address_AddAdmin", nil);
    addAdderssVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAdderssVC animated:YES];
   
}

- (void)delectAddress:(AddressModel *)model{
    NSLog(@"删除地址");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_deleteAdd", nil);
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"address_id":model.Id};
    
    [manager POST:DeleteAddressApi parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
        
            [self.dataSource removeObject:model];
            [self.tabelView reloadData];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        
        }else{
    
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

#pragma mark 获取地址
- (void)dowloadData{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_getAdd", nil);
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:GetAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [hud hideAnimated:YES];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            [self.dataSource removeAllObjects];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dict in data) {
                
                AddressModel *model = [[AddressModel alloc]initWithDictionary:dict error:nil];
                model.idcard_front = [NSString stringWithFormat:@"%@%@",WebPictureApi,dict[@"get_customer_idcard"][@"idcard_front"]];
                model.idcard_back = [NSString stringWithFormat:@"%@%@",WebPictureApi,dict[@"get_customer_idcard"][@"idcard_back"]];
                model.idCardNum = dict[@"get_customer_idcard"][@"idcard_num"];
                model.Id = dict[@"id"];
                
                model.Default = dict[@"default"];
                [self.dataSource addObject:model];
            }
            [self.tabelView reloadData];
        }else{
           
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"获取信息失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"获取信息失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
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
