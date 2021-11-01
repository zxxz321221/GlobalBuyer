//
//  UserInfoRootViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "UserInfoRootViewController.h"


@interface UserInfoRootViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation UserInfoRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    [self setNavigationBackBtn];
    [self.view addSubview:self.tableView];
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(void)initData{
    
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setValue:self.model.fullname forKey:@"value"];
    [dict1 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_nickname", nil) forKey:@"key"];
    [self.dataSource addObject:dict1];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary new];
    
    if ([self.model.sex isEqual:@0]) {
        [dict3 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil) forKey:@"value"];
    }
    
    if ([self.model.sex isEqual:@1]) {
        [dict3 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_nv", nil) forKey:@"value"];
    }
  
    [dict3 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_Gender", nil) forKey:@"key"];
    [self.dataSource addObject:dict3];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary new];
    [dict4 setValue:self.model.mobile_phone forKey:@"value"];
    [dict4 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_phone", nil) forKey:@"key"];
    [self.dataSource addObject:dict4];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary new];
    [dict5 setValue:self.model.currency forKey:@"value"];
    [dict5 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil) forKey:@"key"];
    [self.dataSource addObject:dict5];
    
    NSMutableDictionary *dict6 = [NSMutableDictionary new];
    [dict6 setValue:self.model.email_name forKey:@"value"];
    [dict6 setValue:@"Email" forKey:@"key"];
    [self.dataSource addObject:dict6];

}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW, kScreenH - kTabBarH -(kNavigationBarH + kStatusBarH)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoCell *cell = TableViewCellDequeueInit(NSStringFromClass([UserInfoCell  class]));
    
    TableViewCellDequeueXIB(cell, UserInfoCell);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.titileLa.text = dict[@"key"];
    cell.detailLa.text = dict[@"value"];
    cell.nextView.hidden = YES;
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
