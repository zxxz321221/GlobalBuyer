//
//  ProcurementViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/12/20.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "ProcurementViewController.h"
#import "LoadingView.h"
#import "AlreadyPayTableViewCell.h"
#import "CurrencyCalculation.h"


@interface ProcurementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LoadingView *loadingView;

@end

@implementation ProcurementViewController

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
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"IsPushProcurementView"];
    [self downData];
    [self createUI];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}


- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_purchasinggoods_title", nil);
    self.navigationItem.titleView = titleLabel;
    
}



- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (void)downData
{
    [self.dataSource removeAllObjects];
    [self.loadingView startLoading];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:AlreadyPayApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *orderCompleteArr = [[NSMutableArray alloc]init];
        NSMutableArray *buyCompleteArr = [[NSMutableArray alloc]init];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                NSString *str = [NSString stringWithFormat:@"%@",dict[@"product_status"]];
                if ([str isEqualToString:@"BUY_WAIT"]) {
                    [orderCompleteArr addObject:dict];
                }
                if ([str isEqualToString:@"PAY_ORDER_COMPLETE"]) {
                    [buyCompleteArr addObject:dict];
                }
            }
            
            [self.dataSource addObject:buyCompleteArr];
            [self.dataSource addObject:orderCompleteArr];
            
            [self.loadingView stopLoading];
            if ([self.dataSource[0] count] == 0 && [self.dataSource[1] count] == 0) {
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
            //            [self.view addSubview:self.tableView];
            //            [self.tableView reloadData];
            
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        if ([self.dataSource[section] count] == 0) {
            return nil;
        }
        //return nil;
        return NSLocalizedString(@"GlobalBuyer_My_purchasinggoods", nil);
    }
    
    if (section == 1) {
        if ([self.dataSource[section] count] == 0) {
            return nil;
        }
        return NSLocalizedString(@"GlobalBuyer_My_Procuredgoods", nil);
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0.1;
//    }
    if ([self.dataSource[section] count] == 0) {
        return 0.1;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0;
//    }
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlreadyPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlreadyPayCell"];
    if (cell == nil) {
        cell = [[AlreadyPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlreadyPayCell"];
    }
    
    NSLog(@"%@",self.dataSource[indexPath.section][indexPath.row][@"quantity"]);
    NSData *JSONData = [self.dataSource[indexPath.section][indexPath.row][@"body"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    cell.lb.text = responseJSON[@"name"];
    
    NSString *pictureUrl;
    
    NSMutableString *pictureStr = responseJSON[@"picture"];
    NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
    if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
        pictureUrl = pictureStr;
    }else{
        NSMutableString *tmpStr = responseJSON[@"link"];
        NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
        NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
        if (tmpHttpArr.count > 0) {
            pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
        }else if(tmpHttpsArr.count > 0){
            pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
        }
    }
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
//    if (indexPath.section == 1) {
//        [cell.btn setImage:nil forState:UIControlStateNormal];
//        cell.btn = nil;
//        cell.pickLimitV.hidden = YES;
//    }
    [cell.btn setImage:nil forState:UIControlStateNormal];
    cell.btn = nil;
    cell.pickLimitV.hidden = YES;
    cell.numLb.text = [NSString stringWithFormat:@"x%@",self.dataSource[indexPath.section][indexPath.row][@"quantity"]];
    cell.priceLb.text = [CurrencyCalculation getcurrencyCalculation:[self.dataSource[indexPath.section][indexPath.row][@"price"] floatValue] currentCommodityCurrency:responseJSON[@"currency"] numberOfGoods:[responseJSON[@"quantity"] floatValue]];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
