//
//  CooperationProfitViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/1.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "CooperationProfitViewController.h"
#import "LoadingView.h"
#import "CooperationProfitCell.h"


@interface CooperationProfitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSorce;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UILabel *totalNumLb;
@property (nonatomic,strong)NSString *totalNum;
@property (nonatomic,strong)UILabel *friendNumLb;
@property (nonatomic,strong)NSString *friendNum;

@property (nonatomic,strong)UIView *historyBackV;
@property (nonatomic,assign)NSInteger currentMonth;
@property (nonatomic,assign)NSInteger tmpMonth;

@end

@implementation CooperationProfitViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tmpMonth = 0;
    self.currentMonth = 0;
    [self createUI];
    [self downData];
}

- (NSMutableArray *)dataSorce
{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableArray new];
    }
    return _dataSorce;
}

- (void)createUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_Profit", nil);
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.titleView;
    [self.view addSubview:self.tableView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"提现", nil) style:UIBarButtonItemStylePlain target:self action:@selector(WithdrawMoneyClick)];
}



- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
        _titleView.backgroundColor = Main_Color;
        
        UILabel *titleTotalNumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenW/2, 30)];
        titleTotalNumLb.textAlignment = NSTextAlignmentCenter;
        titleTotalNumLb.textColor = [UIColor whiteColor];
        titleTotalNumLb.font = [UIFont systemFontOfSize:16];
        titleTotalNumLb.text = NSLocalizedString(@"GlobalBuyer_Profit_Title_lift", nil);
        [_titleView addSubview:titleTotalNumLb];
        
        self.totalNumLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kScreenW/2, 60)];
        self.totalNumLb.textAlignment = NSTextAlignmentCenter;
        self.totalNumLb.textColor = [UIColor whiteColor];
        self.totalNumLb.font = [UIFont systemFontOfSize:30];
        self.totalNumLb.text = @"0";
        [_titleView addSubview:self.totalNumLb];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, 10, 1, 100 - 20)];
        line.backgroundColor = [UIColor whiteColor];
        [_titleView addSubview:line];
        
        
        UILabel *titlefriendNumLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2, 10, kScreenW/2, 30)];
        titlefriendNumLb.textAlignment = NSTextAlignmentCenter;
        titlefriendNumLb.textColor = [UIColor whiteColor];
        titlefriendNumLb.font = [UIFont systemFontOfSize:16];
        titlefriendNumLb.text = NSLocalizedString(@"GlobalBuyer_Profit_Title_right", nil);
        [_titleView addSubview:titlefriendNumLb];
        
        
        self.friendNumLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2, 40, kScreenW/2, 60)];
        self.friendNumLb.textAlignment = NSTextAlignmentCenter;
        self.friendNumLb.textColor = [UIColor whiteColor];
        self.friendNumLb.font = [UIFont systemFontOfSize:30];
        self.friendNumLb.text = @"0";
        [_titleView addSubview:self.friendNumLb];

    }
    return _titleView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.sectionFooterHeight = 0;
    }
    return _tableView;
}

- (void)downData
{
    [self.loadingView startLoading];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:GetUserProfitApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            self.totalNum = [NSString stringWithFormat:@"%@",responseObject[@"total"]];
            self.friendNum = [NSString stringWithFormat:@"%@",responseObject[@"friend_count"]];
            
            self.totalNumLb.text = self.totalNum;
            self.friendNumLb.text = self.friendNum;
            
            NSMutableArray *tmpKeyArr = [NSMutableArray new];
            for (int i = 0 ; i < [responseObject[@"profit_info"] count]; i++) {
                NSArray *arr = [responseObject[@"profit_info"][i] allKeys];
                [tmpKeyArr addObject:arr[0]];
            }
            
            for (int i = 0 ; i < tmpKeyArr.count; i++) {
                NSMutableArray *tmpArr = [NSMutableArray new];
                for (int j = 0 ; j < [responseObject[@"profit_info"][i][tmpKeyArr[i]] count]; j++) {
                    [tmpArr addObject:responseObject[@"profit_info"][i][tmpKeyArr[i]][j]];
                }
                NSDictionary *dict = @{tmpKeyArr[i]:tmpArr};
                [self.dataSorce addObject:dict];
            }
        
//            NSArray *monthArr = [responseObject[@"profit_info"] allKeys];
//            
//            for (int i = 0; i < monthArr.count; i++) {
//                NSMutableArray *tmpArr = [NSMutableArray new];
//                for (int j = 0;  j < [responseObject[@"profit_info"][monthArr[i]] count]; j++) {
//                    [tmpArr addObject:responseObject[@"profit_info"][monthArr[i]][j]];
//                }
//                NSDictionary *dict = @{monthArr[i]:tmpArr};
//                [self.dataSorce addObject:dict];
//            }
            [self.loadingView stopLoading];
            [self.view addSubview:self.historyBackV];
            [self.tableView reloadData];
            [self.loadingView stopLoading];
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//
//                
//            }];
        }

        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSorce.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSorce.count) {
        NSArray *arr = [self.dataSorce[self.currentMonth] allKeys];
        return [self.dataSorce[self.currentMonth][arr[0]] count];
    }
    return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableViewSectionHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    
    NSArray *arr = [self.dataSorce[self.currentMonth] allKeys];
    UILabel *monthLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    monthLb.textColor = [UIColor grayColor];
    monthLb.text = arr[0];
    [tableViewSectionHeaderV addSubview:monthLb];
    
    UIButton *historyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 10, 80, 20)];
    [historyBtn setTitle:NSLocalizedString(@"GlobalBuyer_Profit_History", nil) forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    historyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    historyBtn.layer.cornerRadius = 10;
    historyBtn.layer.borderWidth = 0.7;
    historyBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [tableViewSectionHeaderV addSubview:historyBtn];
    [historyBtn addTarget:self action:@selector(lookAtHistory) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.currentMonth != 0) {
        UIButton *nowMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 200, 10, 80, 20)];
        [nowMonthBtn setTitle:NSLocalizedString(@"GlobalBuyer_Profit_NowMonth", nil) forState:UIControlStateNormal];
        [nowMonthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        nowMonthBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        nowMonthBtn.layer.cornerRadius = 10;
        nowMonthBtn.layer.borderWidth = 0.7;
        nowMonthBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [tableViewSectionHeaderV addSubview:nowMonthBtn];
        [nowMonthBtn addTarget:self action:@selector(nowMonth) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return tableViewSectionHeaderV;
    
}

- (void)nowMonth
{
    self.tmpMonth = self.currentMonth;
    self.currentMonth = 0;
    [self.tableView reloadData];
}

- (void)lookAtHistory
{
    self.currentMonth = self.tmpMonth;
    self.historyBackV.hidden = NO;
}

- (UIView *)historyBackV
{
    if (_historyBackV == nil) {
        _historyBackV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 140, kScreenH/2 - 140, 280, 280)];
        _historyBackV.hidden = YES;
        _historyBackV.backgroundColor = [UIColor whiteColor];
        
        UILabel *historyTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _historyBackV.frame.size.width, 40)];
        historyTitleLb.text = NSLocalizedString(@"GlobalBuyer_Profit_SelectMonth", nil);
        historyTitleLb.textColor = Main_Color;
        historyTitleLb.textAlignment = NSTextAlignmentCenter;
        [_historyBackV addSubview:historyTitleLb];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, historyTitleLb.frame.size.height, _historyBackV.frame.size.width, 1)];
        line.backgroundColor = Main_Color;
        [_historyBackV addSubview:line];
        
        //日期选择
        UIScrollView *historySv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, _historyBackV.frame.size.width, _historyBackV.frame.size.height - 81)];
        [_historyBackV addSubview:historySv];
        historySv.contentSize = CGSizeMake(0, 20 + 50*(self.dataSorce.count/2) + 50);
        
        for (int i = 0 ; i < self.dataSorce.count; i++) {
            NSArray *arr = [self.dataSorce[i] allKeys];
            UILabel *btn = [[UILabel alloc]initWithFrame:CGRectMake(20 + 140*(i%2), 20+50*(i/2), 100, 30)];
            btn.tag = i + 100;
            btn.text = arr[0];
            btn.textColor = [UIColor grayColor];
            btn.textAlignment = NSTextAlignmentCenter;
            btn.layer.cornerRadius = 15;
            btn.clipsToBounds = YES;
            btn.userInteractionEnabled = YES;
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            if (i == 0) {
                btn.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            }else{
                btn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
            }
            [historySv addSubview:btn];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectMonth:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [btn addGestureRecognizer:tap];
        }
        
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _historyBackV.frame.size.height - 40, _historyBackV.frame.size.width, 40)];
        sureBtn.backgroundColor = Main_Color;
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_historyBackV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(refreshMonth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyBackV;
}

- (void)selectMonth:(UITapGestureRecognizer *)tap
{
    for (int i = 0 ; i < self.dataSorce.count; i++) {
        UILabel *allBtn = [self.historyBackV viewWithTag:100+i];
        if ([tap view].tag == allBtn.tag) {
            allBtn.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.currentMonth = allBtn.tag - 100;
        }else{
            allBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}

- (void)refreshMonth
{
    self.historyBackV.hidden = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CooperationProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CooperationProfitCell"];
    if (cell == nil) {
        cell = [[CooperationProfitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CooperationProfitCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arr = [self.dataSorce[self.currentMonth] allKeys];
    
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.dataSorce[self.currentMonth][arr[0]][indexPath.row][@"avatar"]]] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.userName.text = [NSString stringWithFormat:@"%@",self.dataSorce[self.currentMonth][arr[0]][indexPath.row][@"name"]];
    cell.profitNum.text = [NSString stringWithFormat:@"%@",self.dataSorce[self.currentMonth][arr[0]][indexPath.row][@"profit"]];
    
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
