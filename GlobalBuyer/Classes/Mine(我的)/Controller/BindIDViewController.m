//
//  BindIDViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/14.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "BindIDViewController.h"
#import "BindIDTableViewCell.h"
#import "FillInIDViewController.h"
#import "LoadingView.h"

@interface BindIDViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)LoadingView *loadingView;

@end

@implementation BindIDViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downData];
}

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
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
//    [self downData];
    [self createUI];
}

- (void)downData
{
    [self.loadingView startLoading];
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:GetAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.dataSource removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.dataSource addObject:dict];
            }
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
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_BindID", nil);
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
    BindIDTableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexPath];
    
    if ([cell.lbstate.text isEqualToString:@""]) {
        return;
    }
    
    FillInIDViewController *fillVc = [[FillInIDViewController alloc]init];
    fillVc.hidesBottomBarWhenPushed = YES;
    fillVc.address_id = self.dataSource[indexPath.row][@"id"];
    fillVc.id_cardFUrl = [NSString stringWithFormat:@"%@%@",WebPictureApi,self.dataSource[indexPath.row][@"get_customer_idcard"][@"idcard_front"]];
    fillVc.id_cardBUrl = [NSString stringWithFormat:@"%@%@",WebPictureApi,self.dataSource[indexPath.row][@"get_customer_idcard"][@"idcard_back"]];
    [self.navigationController pushViewController:fillVc animated:YES];
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
