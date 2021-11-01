//
//  NoticeViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/5.
//  Copyright © 2017年 薛铭. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeDetailsViewController.h"

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *noticeTab;

@end

@implementation NoticeViewController

//隐藏tabbar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//显示tabbar
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}


//创建公告列表
- (void)createUI{
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Home_Notice", nil);
    self.noticeTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64 - 48) style:UITableViewStylePlain];
    self.noticeTab.dataSource = self;
    self.noticeTab.delegate = self;
    [self.view addSubview:self.noticeTab];
}

//数据源初始化
-(NSMutableArray *)noticeArr
{
    if (_noticeArr == nil) {
        _noticeArr = [NSMutableArray new];
    }
    return _noticeArr;
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.noticeArr[indexPath.row][@"news_title"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeDetailsViewController *noticeDetail = [[NoticeDetailsViewController alloc]init];
    noticeDetail.noticeTitle = self.noticeArr[indexPath.row][@"news_title"];
    noticeDetail.noticeBody = self.noticeArr[indexPath.row][@"news_comment"];
    [self.navigationController pushViewController:noticeDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
