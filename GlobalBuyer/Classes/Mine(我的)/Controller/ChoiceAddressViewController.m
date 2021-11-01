//
//  ChoiceAddressViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/15.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "ChoiceAddressViewController.h"
#import "LoadingView.h"
#import "BindIDTableViewCell.h"

@interface ChoiceAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *goodsID;

@end

@implementation ChoiceAddressViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (NSMutableArray *)goodsID
{
    if (_goodsID == nil) {
        _goodsID = [NSMutableArray new];
    }
    return _goodsID;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self downData];
    [self createUI];
}

- (void)initData
{
    for (int i = 0; i < self.pickSource.count; i++) {
        [self.goodsID addObject:self.pickSource[i][@"id"]];
    }
}

- (void)downData
{
    
    [self.loadingView startLoading];
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:GetAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.dataSource addObject:dict];
            }
        }
        
        if (self.dataSource.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputAdd", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
            [alert show];
        }
        
        [self.loadingView stopLoading];
        [self.view addSubview:self.tableV];
        [self.tableV reloadData];
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//
//        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableV
{
    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.rowHeight = 80;
        _tableV.tableFooterView = [[UIView alloc] init];//去掉多于的cell分割线
    }
    return _tableV;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_SelectAdd", nil);
    self.navigationItem.titleView = titleLabel;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BindIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindIDCell"];
    if (cell == nil) {
        cell = [[BindIDTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BindIDCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lbname.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil),self.dataSource[indexPath.row][@"address"]];
    
    if ([self.dataSource[indexPath.row][@"get_customer_idcard"] count] != 0) {
        cell.lbstate.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_BindState", nil),NSLocalizedString(@"GlobalBuyer_My_BindState_YES", nil)];
    }else{
        cell.lbstate.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_BindState", nil),NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BindIDTableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexPath];
    
//    if ([cell.lbstate.text isEqualToString:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_BindState", nil),NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil)]]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_NOBindId", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"正在打包", nil);
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.valueAddedServiceSource options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];


    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":api_token,
                             @"productIds":self.goodsID,
                             @"customerAddressId":self.dataSource[indexPath.row][@"id"],
                             @"customerIdcardId":[NSString stringWithFormat:@"%@",self.dataSource[indexPath.row][@"get_customer_idcard"][@"id"]],
                             @"addition":jsonString};
    
    
    [manager POST:PickApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"打包成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            [self.delegate RefreshAdd];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"打包失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"打包失败!", @"HUD message title");
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
