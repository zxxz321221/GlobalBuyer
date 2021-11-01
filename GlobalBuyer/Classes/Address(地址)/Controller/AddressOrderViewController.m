//
//  AddressRootViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AddressOrderViewController.h"
#import "EditAdderssViewController.h"
#import "AddressOrderCell.h"
#import "AddressModel.h"
@interface AddressOrderViewController ()<UITableViewDelegate,UITableViewDataSource,EditAdderssViewControllerDelegate,AddressOrderCellDelegate>
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UIButton *addAddressBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) AddressModel *oldModel;
@property (nonatomic, assign) NSInteger index;
@end

@implementation AddressOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Address_title", nil);
    [self setupUI];
    [self dowloadData];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI界面
- (void)setupUI {
    [self setNavigationBackBtn];
    [self.view addSubview:self.tabelView];
    [self.view addSubview:self.addAddressBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIBarButtonItemStylePlain target:self action: @selector(selectAdress)];
}

-(void)selectAdress{
    if (!self.oldModel) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_NoAddmessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil ];
        [alertView show];
        
    }else{
    [self.delegate sendAdressModel:self.oldModel ];
    [self.navigationController popViewControllerAnimated:YES];
   }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UITableView *)tabelView{
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW , kScreenH  - kTabBarH - (kNavigationBarH + kStatusBarH)) style:UITableViewStylePlain];
        _tabelView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.rowHeight = 90;
        _tabelView.tableFooterView = [[UIView alloc]init];
    }
    return _tabelView;
}

/*
 添加新地址按钮
**/
- (UIButton *)addAddressBtn {
    if (_addAddressBtn == nil) {
        _addAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  kScreenH - 49, kScreenW,49)];
        _addAddressBtn.backgroundColor = Main_Color;
        [_addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addAddressBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_AddNewAdd", nil) forState:UIControlStateNormal];
        [_addAddressBtn addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressBtn;
}

#pragma mark 添加新地址按钮点击事件
-(void)addAddressClick {
    
    EditAdderssViewController *addAdderssVC = [EditAdderssViewController new];
    addAdderssVC.delegate = self;
    addAdderssVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAdderssVC animated:YES];
    
}

-(void)addAddressModel:(AddressModel *)addressModel{
    [self.dataSource removeAllObjects];
    [self dowloadData];
}
    
#pragma mark tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressOrderCell *cell = TableViewCellDequeueInit(NSStringFromClass([AddressOrderCell class]));
    TableViewCellDequeue(cell, AddressOrderCell, NSStringFromClass([AddressOrderCell class]));
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressModel *model = self.dataSource[indexPath.row];
    return [model cellH];
}

-(void)select:(AddressModel *)model{
    NSLog(@"选择了");
    self.oldModel = model;
    for (AddressModel *addressModel in self.dataSource) {
        if ([model isEqual:addressModel]) {
            addressModel.isSelect = @YES;
          
        }else {
          addressModel.isSelect = @NO;
        }
    }
    [self.tabelView reloadData];
}
    
- (void)delectAddress:(AddressModel *)model{
    NSLog(@"删除地址");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_deleteAdd", nil);
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"api_token":api_token,@"address_id":model.Id};
    
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
    
    NSDictionary *api_token =UserDefaultObjectForKey(USERTOKEN) ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_token":api_token};
    
    [manager POST:GetAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dict in data) {
                
                AddressModel *model = [[AddressModel alloc]initWithDictionary:dict error:nil];
                
                model.Id = dict[@"id"];
                model.Default = dict[@"default"];
                if ([model.Default boolValue]) {
                    model.isSelect = @YES;
                    self.oldModel = model;
                    
                }
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

-(void)editAddress:(AddressModel *)model{
    NSLog(@"编辑地址");
    EditAdderssViewController *addAdderssVC = [EditAdderssViewController new];
    addAdderssVC.hidesBottomBarWhenPushed = YES;
    addAdderssVC.model = model;
    addAdderssVC.delegate = self;
    [self.navigationController pushViewController:addAdderssVC animated:YES];
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
