//
//  HistorySearchViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/12/14.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "HistorySearchViewController.h"
#import "FileArchiver.h"
#import "HomeSearchWithKeyViewController.h"
#import "NewSearchList1ViewController.h"

@interface HistorySearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UITextField *searchTf;
@property (nonatomic,strong)UIImageView *magnifierV;
@property (nonatomic,strong)UIView *filletV;
@property (nonatomic,strong)UIButton *searchBtn;
@property (nonatomic,strong)NSString *sourceNum;
@property (nonatomic,strong)NSMutableArray *historyDataSource;
@property (nonatomic,strong)UIView *lineV;
@property (nonatomic,strong)UIView *deleteV;

@end

@implementation HistorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.put intValue] != 1) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self initHistoryData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.searchTf.text = @"";
    if ([self.put intValue] != 1) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (NSMutableArray *)historyDataSource{
    if (_historyDataSource == nil) {
        _historyDataSource = [[NSMutableArray alloc]init];
    }
    return _historyDataSource;
}

- (void)initHistoryData{
    self.historyDataSource = [NSMutableArray arrayWithArray:[FileArchiver readFileArchiver:@"HistorySearch"]];
    if (self.historyDataSource.count == 0) {
        self.deleteV.hidden = YES;
    }else{
        self.deleteV.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.filletV];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.magnifierV];
    [self.view addSubview:self.searchTf];
    [self.view addSubview:self.lineV];
    [self.view addSubview:self.tableView];
}

//初始化输入框
- (UITextField *)searchTf
{
    if (_searchTf == nil) {
        _searchTf = [[UITextField alloc]initWithFrame:CGRectMake( 70 , 35, kScreenW - 140, 30)];
        _searchTf.font = [UIFont systemFontOfSize:12];
        NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"GlobalBuyer_SearchViewController_placeholder", nil)
                                                                        attributes:@{NSFontAttributeName:self.searchTf.font                                                                               }];
        _searchTf.attributedPlaceholder = attrString;
        _searchTf.delegate = self;
        _searchTf.returnKeyType = UIReturnKeySearch;
    }
    return _searchTf;
}

- (UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 40, 20, 20)];
        [_backBtn setImage:[UIImage imageNamed:@"历史搜索返回"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(gobackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)gobackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)filletV{
    if (_filletV == nil) {
        _filletV = [[UIView alloc]initWithFrame:CGRectMake(40, 35, kScreenW - 100, 30 )];
        _filletV.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
        _filletV.layer.cornerRadius = 15;
    }
    return _filletV;
}

- (UIButton *)searchBtn{
    if (_searchBtn == nil) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 60, 40, 60, 20)];
        [_searchBtn setTitle:NSLocalizedString(@"GlobalBuyer_Searching", nil) forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_searchBtn addTarget:self action:@selector(gotoSearchPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIImageView *)magnifierV{
    if (_magnifierV == nil) {
        _magnifierV = [[UIImageView alloc]initWithFrame:CGRectMake(50, 40, 20, 20)];
        _magnifierV.image = [UIImage imageNamed:@"历史搜索放大镜"];
    }
    return _magnifierV;
}

- (UIView *)deleteV{
    if (_deleteV == nil) {
        _deleteV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 80, 0, 160, 30)];
        _deleteV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteHistory)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_deleteV addGestureRecognizer:tap];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        iv.image = [UIImage imageNamed:@"历史搜索删除"];
        [_deleteV addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 130, 30)];
        lb.textColor = [UIColor lightGrayColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = NSLocalizedString(@"GlobalBuyer_Home_Search_deleteHis", nil);
        [_deleteV addSubview:lb];
    }
    return _deleteV;
}

- (void)deleteHistory{
    [self.historyDataSource removeAllObjects];
    [FileArchiver writeFileArchiver:@"HistorySearch" withArray:self.historyDataSource];
    [self.tableView reloadData];
    self.deleteV.hidden = YES;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenW, kScreenH - 70) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 30)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
    lb.text = NSLocalizedString(@"GlobalBuyer_Profit_History", nil);
    [iv addSubview:lb];
    return iv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 30)];
    [iv addSubview:self.deleteV];
    return iv;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.historyDataSource[indexPath.row]];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)lineV{
    if (_lineV == nil) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 68, kScreenW, 1)];
        _lineV.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    }
    return _lineV;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        int tmp = 0;
        for (int i = 0; i < self.historyDataSource.count; i++) {
            if ([textField.text isEqualToString:self.historyDataSource[i]]) {
                tmp++;
            }
        }
        if (tmp == 0) {
            [self.historyDataSource insertObject:textField.text atIndex:0];
            [FileArchiver writeFileArchiver:@"HistorySearch" withArray:self.historyDataSource];
        }
    }
    
    if ([self.put intValue] == 1) {
        NewSearchList1ViewController * vc = [[NewSearchList1ViewController alloc]init];
        vc.keyWords = [NSString stringWithFormat:@"%@",textField.text];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HomeSearchWithKeyViewController *vc = [[HomeSearchWithKeyViewController alloc]init];
        vc.keyWords = [NSString stringWithFormat:@"%@",textField.text];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBar.translucent = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

- (void)gotoSearchPage{
    if (self.searchTf.text.length > 0) {
        int tmp = 0;
        for (int i = 0; i < self.historyDataSource.count; i++) {
            if ([self.searchTf.text isEqualToString:self.historyDataSource[i]]) {
                tmp++;
            }
        }
        if (tmp == 0) {
            [self.historyDataSource insertObject:self.searchTf.text atIndex:0];
            [FileArchiver writeFileArchiver:@"HistorySearch" withArray:self.historyDataSource];
        }
    }
    if ([self.put intValue] == 1) {
        NewSearchList1ViewController * vc = [[NewSearchList1ViewController alloc]init];
        vc.keyWords = [NSString stringWithFormat:@"%@",self.searchTf.text];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HomeSearchWithKeyViewController *vc = [[HomeSearchWithKeyViewController alloc]init];
        vc.keyWords = [NSString stringWithFormat:@"%@",self.searchTf.text];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.put intValue] == 1) {
        NewSearchList1ViewController * vc = [[NewSearchList1ViewController alloc]init];
        vc.keyWords = [NSString stringWithFormat:@"%@",self.historyDataSource[indexPath.row]];
        vc.hidesBottomBarWhenPushed = YES;
        NSString *str = [NSString stringWithFormat:@"%@",self.historyDataSource[indexPath.row]];
        [self.historyDataSource removeObjectAtIndex:indexPath.row];
        [self.historyDataSource insertObject:str atIndex:0];
        [FileArchiver writeFileArchiver:@"HistorySearch" withArray:self.historyDataSource];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HomeSearchWithKeyViewController *vc = [[HomeSearchWithKeyViewController alloc]init];
        vc.keyWords = [NSString stringWithFormat:@"%@",self.historyDataSource[indexPath.row]];
        vc.hidesBottomBarWhenPushed = YES;
        NSString *str = [NSString stringWithFormat:@"%@",self.historyDataSource[indexPath.row]];
        [self.historyDataSource removeObjectAtIndex:indexPath.row];
        [self.historyDataSource insertObject:str atIndex:0];
        [FileArchiver writeFileArchiver:@"HistorySearch" withArray:self.historyDataSource];
        [self.navigationController pushViewController:vc animated:YES];
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
