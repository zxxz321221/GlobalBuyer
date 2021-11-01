//
//  DomesticLogisticsViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/2/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "DomesticLogisticsViewController.h"
#import "LoadingView.h"
#import "LogisticsTableViewCell.h"

@interface DomesticLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation DomesticLogisticsViewController

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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH - 30) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self downData];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_Order_title", nil);
    self.navigationItem.titleView = titleLabel;
    
}

- (void)downData
{
    [self.loadingView startLoading];
    
    NSDictionary *params = @{@"api_id":LogisticsAPI_ID,
                             @"api_token":LogisticsTOKEN,
                             @"expressNum":self.packageNum,
                             @"expressName":self.packageName};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:DomesticLogisticsApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.dataSource addObject:responseObject[@"data"][i]];
            }
        }
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        [self.loadingView stopLoading];
        if ([responseObject[@"code"]isEqualToString:@"error"] || self.dataSource.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_thereisnologisticsdata", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
            [alert show];
        }
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logisCell"];
    if (cell == nil) {
        cell = [[LogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logisCell"];
    }
    
    for (int i = 0 ; i < 3; i++) {
        if (i == 0) {
            cell.dateLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Date", nil),self.dataSource[indexPath.row][@"time"]];
        }
        if (i == 1) {
            cell.serviceLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_ServiceLocation", nil),self.dataSource[indexPath.row][@"location"]];
        }
        if (i == 2) {
            cell.detailLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Detailed", nil),self.dataSource[indexPath.row][@"context"]];
        }
    }
    
    
    
    return cell;
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
