//
//  ReceivedViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/12/7.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "ReceivedViewController.h"
#import "LoadingView.h"
#import "NoPayTableViewCell.h"
#import "ShopDetailViewController.h"

@interface ReceivedViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ReceivedViewController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
    }
    return _tableView;
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
    [self downData];
    [self createUI];
}

- (void)downData
{
    [self.loadingView startLoading];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],@"status":@"packageComplete"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PackageApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            for (NSDictionary *dict  in responseObject[@"data"]){
                NSString *delivery_status = [NSString stringWithFormat:@"%@",dict[@"delivery_status"]];
                if ([delivery_status isEqualToString:@"1"]) {
                    [self.dataSource addObject:dict];
                }
            }
            
            for (NSDictionary *dict  in responseObject[@"data"]){
                NSString *pay_status = [NSString stringWithFormat:@"%@",dict[@"pay_status"]];
                NSString *delivery_status = [NSString stringWithFormat:@"%@",dict[@"delivery_status"]];
                if ([pay_status isEqualToString:@"1"] && [delivery_status isEqualToString:@"0"]) {
                    [self.dataSource addObject:dict];
                }
            }
            
            [self.loadingView stopLoading];
            if (self.dataSource.count == 0) {
                UIImageView *emptyIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, kScreenH/2 - 50, 100, 100)];
                emptyIv.image = [UIImage imageNamed:@"my_Empty"];
                [self.view addSubview:emptyIv];
                UILabel *emptyLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 130, kScreenH/2 + 70, 260, 40)];
                emptyLb.text = NSLocalizedString(@"GlobalBuyer_My_Empty", nil);
                emptyLb.textColor = [UIColor lightGrayColor];
                emptyLb.font = [UIFont systemFontOfSize:16];
                emptyLb.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:emptyLb];
                UIButton *emptyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, kScreenH/2 + 120, 100, 30)];
                emptyBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                emptyBtn.layer.borderWidth = 0.7;
                [emptyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_BrowseTheHomePage", nil) forState:UIControlStateNormal];
                [emptyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [self.view addSubview:emptyBtn];
                [emptyBtn addTarget:self action:@selector(gotoHomePage) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [self.view addSubview:self.tableView];
                [self.tableView reloadData];
            }
            
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//                [self.loadingView stopLoading];
//                
//                
//                [UIView animateWithDuration:2 animations:^{
//                    self.loadingView.imgView.animationDuration = 3*0.15;
//                    self.loadingView.imgView.animationRepeatCount = 0;
//                    [self.loadingView.imgView startAnimating];
//                    self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//                } completion:^(BOOL finished) {
//                    NSLog(@"%d",finished);
//
//                }];
//                
//            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)gotoHomePage
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"GotoHomeMark"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_CompletedOrder", nil);
    self.navigationItem.titleView = titleLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section][@"get_package_product"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deCell"];
    if (cell == nil) {
        cell = [[NoPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deCell"];
    }
    
    NSString *string = self.dataSource[indexPath.section][@"get_package_product"][indexPath.row][@"get_pay_product"][@"body"];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSString *pictureUrl;
    NSMutableString *pictureStr = jsonDict[@"picture"];
    NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
    if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
        pictureUrl = pictureStr;
    }else{
        NSMutableString *tmpStr = jsonDict[@"link"];
        NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
        NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
        if (tmpHttpArr.count > 0) {
            pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
        }else if(tmpHttpsArr.count > 0){
            pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
        }
    }
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
    cell.lb.text = jsonDict[@"name"];
    cell.numLb.text = [NSString stringWithFormat:@"x%@",self.dataSource[indexPath.section][@"get_package_product"][indexPath.row][@"get_pay_product"][@"quantity"]];
    NSLog(@"body=====>%@",jsonDict[@"link"]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0,0 , kScreenW, 30)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 270, 20)];
    lb.font = [UIFont systemFontOfSize:12];
    lb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_PackagesNum", nil),self.dataSource[section][@"package_unique"]];
    [iv addSubview:lb];
    
    return iv;
}


//获取http OR https
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
            
        {
            
            if (0 == i) {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }else
                
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = self.dataSource[indexPath.section][@"get_package_product"][indexPath.row][@"get_pay_product"][@"body"];
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    ShopDetailViewController *vc = [ShopDetailViewController new];
    vc.link = jsonDict[@"link"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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
