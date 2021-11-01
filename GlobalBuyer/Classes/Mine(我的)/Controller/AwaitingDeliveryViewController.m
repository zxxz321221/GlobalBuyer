//
//  AwaitingDeliveryViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/15.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "AwaitingDeliveryViewController.h"
#import "LoadingView.h"
#import "NoPayTableViewCell.h"


@interface AwaitingDeliveryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation AwaitingDeliveryViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}


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
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:RefundOfReturn parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSMutableArray *REFUNDarr = [[NSMutableArray alloc]init];
//            for (NSDictionary *dict  in responseObject[@"data"]){
//                //退款
//                if ([dict[@"product_status"]isEqualToString:@"REFUND"]) {
//                    [REFUNDarr addObject:dict];
//                }
//            }
            
            NSMutableArray *BACK_PRODUCTarr = [[NSMutableArray alloc]init];
//            for (NSDictionary *dict  in responseObject[@"data"]){
//                //退货
//                if ([dict[@"product_status"]isEqualToString:@"BACK_PRODUCT"]) {
//                    [BACK_PRODUCTarr addObject:dict];
//                }
//            }
            
            [self.dataSource addObject:REFUNDarr];
            [self.dataSource addObject:BACK_PRODUCTarr];
            
            [self.loadingView stopLoading];
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
            
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//                
//                
//
//                
//                //[self.view addSubview:self.tableView];
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
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_Shipped", nil);
    self.navigationItem.titleView = titleLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"退款商品";
    }
    
    if (section == 1) {
        return @"退货商品";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deCell"];
    if (cell == nil) {
        cell = [[NoPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deCell"];
    }
    
    return cell;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
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
