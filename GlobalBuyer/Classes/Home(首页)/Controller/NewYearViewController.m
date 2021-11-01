//
//  NewYearViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/26.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "NewYearViewController.h"
#import "NewYearCell.h"
#import "ShopDetailViewController.h"
#import "FileArchiver.h"
@interface NewYearViewController ()<UITableViewDelegate,UITableViewDataSource,NewYearCellDelegate>

@property (nonatomic,strong)NSMutableArray *goodsDataSource;
@property (nonatomic,strong)UIView *titleBtnV;
@property (nonatomic,strong)UIView *bannerV;
@property (nonatomic,strong)UIImageView *bannerIv;
@property (nonatomic,strong)UITableView *tableView;


@end

@implementation NewYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.tableView.tableHeaderView = self.bannerV;
    [self.tableView.mj_header beginRefreshing];
}

- (UIView *)bannerV{
    if (_bannerV == nil) {
        _bannerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
        self.bannerIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
        if(self.dataSource.count>0){
            [self.bannerIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.dataSource[self.currentPage][@"pic"]]]];
        }
        
        [_bannerV addSubview:self.bannerIv];
    }
    return _bannerV;
}

- (NSMutableArray *)goodsDataSource{
    if (_goodsDataSource == nil) {
        _goodsDataSource = [[NSMutableArray alloc]init];
    }
    return _goodsDataSource;
}

- (void)createUI
{
    self.title = @"主题活动";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleBtnV];
    [self.view addSubview:self.tableView];
}

- (UIView *)titleBtnV{
    if (_titleBtnV == nil) {
        _titleBtnV = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenW, 50)];
        _titleBtnV.backgroundColor = [UIColor lightGrayColor];
        for (int i = 0; i < self.dataSource.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0 + i * (kScreenW/self.dataSource.count), 0, kScreenW/self.dataSource.count, 50)];
            btn.tag = i;
            [btn setTitle:[NSString stringWithFormat:@"%@",self.dataSource[i][@"title"]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setBackgroundImage:[UIImage imageNamed:@"theme_line.jpg"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_titleBtnV addSubview:btn];
            if (i == self.currentPage) {
                btn.selected = YES;
            }
            [btn addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _titleBtnV;
}

- (void)changeData:(UIButton *)btn{

    self.currentPage = btn.tag;
    [self.titleBtnV removeFromSuperview];
    self.titleBtnV = nil;
    [self.bannerIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.dataSource[self.currentPage][@"pic"]]]];
    [self.view addSubview:self.titleBtnV];
    [self.tableView.mj_header beginRefreshing];
}

- (void)downLoadData{
    
    if (self.dataSource.count == 0) {
        return;
    }
    
    NSArray * array = [FileArchiver readFileArchiver:[NSString stringWithFormat:@"zhuti%@",self.dataSource[self.currentPage][@"id"]]];
    if (array) {
        [self.goodsDataSource removeAllObjects];
        self.goodsDataSource = [NSMutableArray arrayWithArray:array];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"id"] = [NSString stringWithFormat:@"%@",self.dataSource[self.currentPage][@"id"]];
    
    [manager GET:HomeYearDetApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.goodsDataSource removeAllObjects];
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.goodsDataSource addObject:responseObject[@"data"][i]];
            }
        }
        if ([self.goodsDataSource isEqualToArray:array]) {
            return ;
        }
        [FileArchiver writeFileArchiver:[NSString stringWithFormat:@"zhuti%@",self.dataSource[self.currentPage][@"id"]] withArray:self.goodsDataSource];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight + 50, kScreenW, kScreenH - NavBarHeight - 50)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 280;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downLoadData)];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStatePulling", nil) forState:MJRefreshStatePulling];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateRefreshing", nil) forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.arrowView.hidden = YES;
        
        _tableView.mj_header = header;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewYearCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YearCell"];
    if (cell == nil) {
        cell = [[NewYearCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YearCell"];
    }
    [cell.titleIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.goodsDataSource[indexPath.row][@"pic"]]]];
    cell.titleLb.text = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"name"]];
    cell.titleLink = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"link"]];
    for (int i = 0 ; i < [self.goodsDataSource[indexPath.row][@"goods"] count]; i++) {
        if (i == 0) {
            [cell.goodsIvOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_pic"]]]];
            cell.goodsTitleOne.text = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_name"]];
            cell.goodsPriceOne.text = [NSString stringWithFormat:@"%@%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_currency"],self.goodsDataSource[indexPath.row][@"goods"][i][@"good_price"]];
            cell.goodsOneLink = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_link"]];
        }
        if (i == 1) {
            [cell.goodsIvTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_pic"]]]];
            cell.goodsTitleTwo.text = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_name"]];
            cell.goodsPriceTwo.text = [NSString stringWithFormat:@"%@%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_currency"],self.goodsDataSource[indexPath.row][@"goods"][i][@"good_price"]];
            cell.goodsTwoLink = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_link"]];
        }
        if (i == 2) {
            [cell.goodsIvThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_pic"]]]];
            cell.goodsTitleThree.text = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_name"]];
            cell.goodsPriceThree.text = [NSString stringWithFormat:@"%@%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_currency"],self.goodsDataSource[indexPath.row][@"goods"][i][@"good_price"]];
            cell.goodsThreeLink = [NSString stringWithFormat:@"%@",self.goodsDataSource[indexPath.row][@"goods"][i][@"good_link"]];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (void)clickNewYearWithLink:(NSString *)link{
    ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
    vc.link = link;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
