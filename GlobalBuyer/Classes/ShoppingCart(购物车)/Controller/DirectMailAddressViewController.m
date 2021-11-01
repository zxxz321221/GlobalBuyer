//
//  DirectMailAddressViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/12/13.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "DirectMailAddressViewController.h"
#import "BindIDTableViewCell.h"


@interface DirectMailAddressViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *tableV;

@end

@implementation DirectMailAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}


- (UITableView *)tableV
{
    if (_tableV == nil) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH ) style:UITableViewStylePlain];
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
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_SelectAdd", nil);
    self.navigationItem.titleView = titleLabel;
    
    
    [self.view addSubview:self.tableV];
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
    
//    if ([self.dataSource[indexPath.row][@"get_customer_idcard"] count] != 0) {
//        cell.lbstate.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_BindState", nil),NSLocalizedString(@"GlobalBuyer_My_BindState_YES", nil)];
//    }else{
//        cell.lbstate.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_BindState", nil),NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil)];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BindIDTableViewCell *cell = [self.tableV cellForRowAtIndexPath:indexPath];
//
//    if ([cell.lbstate.text isEqualToString:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_BindState", nil),NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil)]]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_NOBindId", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    [self.delegate changeAddress:self.dataSource[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
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
