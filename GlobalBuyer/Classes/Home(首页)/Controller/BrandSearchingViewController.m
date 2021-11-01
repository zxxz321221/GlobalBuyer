//
//  BrandSearchingViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/12/25.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "BrandSearchingViewController.h"
#import "BrandSearchViewController.h"

@interface BrandSearchingViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *searchingDataSource;

@end

@implementation BrandSearchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"GlobalBuyer_Searching", nil);
    [self createUI];
}

- (NSMutableArray *)searchingDataSource
{
    if (_searchingDataSource == nil) {
        _searchingDataSource = [[NSMutableArray alloc]init];
    }
    return _searchingDataSource;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *brandSearchBackV = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + NavBarHeight, kScreenW - 20, 40)];
    brandSearchBackV.backgroundColor = [UIColor lightGrayColor];
    brandSearchBackV.alpha = 0.7;
    [self.view addSubview:brandSearchBackV];
    
    UIImageView *magnifierIv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15 + NavBarHeight, 30, 30)];
    magnifierIv.image = [UIImage imageNamed:@"放大镜"];
    [self.view addSubview:magnifierIv];
    
    UITextField *brandSearchTv = [[UITextField alloc]initWithFrame:CGRectMake(50, 10 + NavBarHeight, kScreenW - 50, 40)];
    brandSearchTv.delegate = self;
    brandSearchTv.returnKeyType = UIReturnKeySearch;
    brandSearchTv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:brandSearchTv];
    
    [self.view addSubview:self.tableView];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    [self downLoadSearchDataWithQstring:textField.text];
    return YES;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight+60, kScreenW, kScreenH - NavBarHeight+60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)downLoadSearchDataWithQstring:(NSString *)qstring
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"qString"] = qstring;
    
    [manager POST:BrandSearchApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            NSArray *arr = responseObject[@"data"];
            if (arr.count == 0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_Queryfailed",nil);
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
                return ;
            }
            [self.searchingDataSource removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                [self.searchingDataSource addObject:arr[i]];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_Queryfailed",nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchingDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchingCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchingCell"];
    }
    
    cell.textLabel.text = self.searchingDataSource[indexPath.row][@"name"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandSearchViewController *brandSearch = [[BrandSearchViewController alloc]init];
    brandSearch.keyWords = self.searchingDataSource[indexPath.row][@"search"];
    brandSearch.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Amazon_Fixedprice", nil);

    brandSearch.keyWords = self.searchingDataSource[indexPath.row][@"name"];
    brandSearch.keyWordsTw = self.searchingDataSource[indexPath.row][@"search-tw"];
    brandSearch.keyWordsJp = self.searchingDataSource[indexPath.row][@"search-ja"];
    brandSearch.keyWordsEn =
    self.searchingDataSource[indexPath.row][@"search-en"];
    brandSearch.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Amazon_Fixedprice", nil);
    [self.navigationController pushViewController:brandSearch animated:YES];

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
