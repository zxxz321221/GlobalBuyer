//
//  HelpListViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/28.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "HelpListViewController.h"
#import "HelpDetailViewController.h"

@interface HelpListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *helpListTv;

@end

@implementation HelpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (UITableView *)helpListTv
{
    if (_helpListTv == nil) {
        _helpListTv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStylePlain];
        _helpListTv.delegate = self;
        _helpListTv.dataSource = self;
    }
    return _helpListTv;
    
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.helpListTv];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bodyTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCellList"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"helpCellList"];
    }
    
    cell.textLabel.text = self.bodyTitleArr[indexPath.row][@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpDetailViewController *helpDetailVC = [HelpDetailViewController new];
    helpDetailVC.hidesBottomBarWhenPushed = YES;
    helpDetailVC.bodyStr = self.bodyTitleArr[indexPath.row][@"body"];
    helpDetailVC.navigationItem.title = self.bodyTitleArr[indexPath.row][@"title"];
    [self.navigationController pushViewController:helpDetailVC animated:YES];
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
