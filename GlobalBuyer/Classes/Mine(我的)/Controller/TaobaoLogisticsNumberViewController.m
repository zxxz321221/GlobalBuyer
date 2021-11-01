//
//  TaobaoLogisticsNumberViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/16.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "TaobaoLogisticsNumberViewController.h"
#import "TaobaoLogisticsTableViewCell.h"

@interface TaobaoLogisticsNumberViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *expressDataSource;

@property (nonatomic,strong)NSString *productNum;
@property (nonatomic,strong)NSString *expressId;
@property (nonatomic,strong)NSString *expressNum;

@property (nonatomic, strong) UIView *botomView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *DetermineBtn;

@property (nonatomic, strong) UIView *fillInExpressBackV;
@property (nonatomic, strong) UILabel *expressLb;
@property (nonatomic, strong) UITextField *expressNumTf;

@property (nonatomic, assign) NSInteger clickNum;

@end

@implementation TaobaoLogisticsNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self downData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showAlert];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)expressDataSource
{
    if (_expressDataSource == nil) {
        _expressDataSource = [[NSMutableArray alloc]init];
    }
    return _expressDataSource;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ExpressOrderNumberToBeFilled", nil);
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)showAlert{
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ExpressOrderAlert", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-(kNavigationBarH + kStatusBarH)) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 100;
    }
    return _tableView;
}

- (void)downData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"secret_key":api_token};
    
    [manager GET:TaobaoTransshipmentParcelApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.dataSource addObject:responseObject[@"data"][i]];
            }
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
                [self.tableView reloadData];
                [self downLoadLogistics];
            }

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)gotoHomePage
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"GotoHomeMark"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)downLoadLogistics
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN
                             };
    
    [manager GET:ExpressListApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.expressDataSource addObject:responseObject[@"data"][i]];
            }
            [self.pickerView reloadAllComponents];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSDictionary *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp) {
        if ([tmp isKindOfClass:[NSArray class]]) {
            return tmp;
        } else if([tmp isKindOfClass:[NSString class]] || [tmp isKindOfClass:[NSDictionary class]]) {
            return tmp;
        } else {
            return nil;
        }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaobaoLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taobaocell"];
    if (cell == nil) {
        cell = [[TaobaoLogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taobaocell"];
    }
    NSDictionary *dict = [self stringToJSON:self.dataSource[indexPath.section][@"body"]];
    
    [cell.goodIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"picture"]]]];
    cell.titleLb.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    cell.subTitleLb.text = [NSString stringWithFormat:@"%@",dict[@"class"]];
    cell.qtyLb.text = [NSString stringWithFormat:@"x%@",dict[@"qty"]];
    cell.priceLb.text = [NSString stringWithFormat:@"CNY%@",dict[@"price"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc]init];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    iv.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 120, 10, 100, 30)];
    btn.backgroundColor = [UIColor blackColor];
    btn.tag = section;
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ExpressOrderNumberToBeFilling", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [iv addSubview:btn];
    [btn addTarget:self action:@selector(clickFillInId:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 230, 10, 100, 30)];
    btn1.backgroundColor = [UIColor blackColor];
    btn1.tag = section;
    [btn1 setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ExpressOrderNumberToBeDelete", nil) forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [iv addSubview:btn1];
    [btn1 addTarget:self action:@selector(deleteFillInId:) forControlEvents:UIControlEventTouchUpInside];
    return iv;
}
- (void)deleteFillInId:(UIButton *)btn{
    NSLog(@"%@",self.dataSource[btn.tag]);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"trans_id":self.dataSource[btn.tag][@"id"]};
    
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/cart/transport/webapi/delete" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"] isEqualToString:@"success"])  {
            [self.dataSource removeObjectAtIndex:btn.tag];
            [self.tableView reloadData];
        }
        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud1.mode = MBProgressHUDModeText;
        hud1.label.text = NSLocalizedString(responseObject[@"message"], @"HUD message title");
        hud1.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud1 hideAnimated:YES afterDelay:3.f];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];

    }];
    
}
- (void)clickFillInId:(UIButton *)btn
{
    NSDictionary *dict = self.dataSource[btn.tag];
    self.clickNum = btn.tag;
    self.expressId = [NSString stringWithFormat:@"%@",self.expressDataSource[0][@"id"]];
    self.productNum = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
    [self.view addSubview:self.fillInExpressBackV];
    [self.view addSubview:self.botomView];
}

- (UIView *)botomView {
    if (_botomView == nil) {
        _botomView = [UIView new];
        _botomView.frame = CGRectMake(0, kScreenH , kScreenW, 240);
        _botomView.backgroundColor = [UIColor lightGrayColor];
        [_botomView addSubview:self.cancelBtn];
        [_botomView addSubview:self.pickerView];
        [_botomView addSubview:self.DetermineBtn];
    }
    return _botomView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(5, 0, 50, 40);
        [_cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH;
        self.botomView.frame = frame;
    } completion:^(BOOL finished) {
        [self.botomView removeFromSuperview];
        self.botomView = nil;
    }];
}

- (void)determineBtnAction:(UIButton *)btn {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH;
        self.botomView.frame = frame;
    } completion:^(BOOL finished) {
        [self.botomView removeFromSuperview];
        self.botomView = nil;
    }];
    
}

- (UIButton *)DetermineBtn {
    if (!_DetermineBtn) {
        _DetermineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _DetermineBtn.frame = CGRectMake(kScreenW - 50, 0, 50, 40);
        [_DetermineBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_DetermineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DetermineBtn;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.expressDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.expressDataSource[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.expressId = [NSString stringWithFormat:@"%@",self.expressDataSource[row][@"id"]];
    self.expressLb.text = [NSString stringWithFormat:@"%@",self.expressDataSource[row][@"name"]];
}

- (UIView *)fillInExpressBackV
{
    if (_fillInExpressBackV == nil) {
        _fillInExpressBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _fillInExpressBackV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(20, 130, kScreenW - 40, 160)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 1;
        [_fillInExpressBackV addSubview:backV];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 40, 50)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ExpressOrderNumberToBeFilling", nil);
        title.font = [UIFont systemFontOfSize:15];
        [backV addSubview:title];
        UIView *cornerRadiusV = [[UIView alloc]initWithFrame:CGRectMake(30, 55, backV.frame.size.width - 60, 40)];
        cornerRadiusV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cornerRadiusV.layer.borderWidth = 0.5;
        cornerRadiusV.layer.cornerRadius = 8;
        [backV addSubview:cornerRadiusV];
        self.expressLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        self.expressLb.textAlignment = NSTextAlignmentCenter;
        self.expressLb.font = [UIFont systemFontOfSize:13];
        self.expressLb.text = self.expressDataSource[0][@"name"];
        self.expressLb.userInteractionEnabled = YES;
        [cornerRadiusV addSubview:self.expressLb];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectExpressName)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self.expressLb addGestureRecognizer:tap];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(80, 0, 0.5, 40)];
        lineV.backgroundColor = [UIColor lightGrayColor];
        [cornerRadiusV addSubview:lineV];
        self.expressNumTf = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, cornerRadiusV.frame.size.width - 80, 40)];
        [cornerRadiusV addSubview:self.expressNumTf];
        [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 120, backV.frame.size.width/2, 40)];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(backV.frame.size.width/2, 120, backV.frame.size.width/2, 40)];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1];
        [backV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(commitExpress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fillInExpressBackV;
}

- (void)selectExpressName
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH - 240;
        self.botomView.frame = frame;
    }];
}

- (void)cancelSelect
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH;
        self.botomView.frame = frame;
    } completion:^(BOOL finished) {
        [self.fillInExpressBackV removeFromSuperview];
        self.fillInExpressBackV = nil;
        [self.botomView removeFromSuperview];
        self.botomView = nil;
    }];
    
}

- (void)commitExpress
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":api_token,
                             @"product_num":self.productNum,
                             @"express_id":self.expressId,
                             @"express_num":[NSString stringWithFormat:@"%@", self.expressNumTf.text]
                             };
    [manager POST:FillTheExpressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.dataSource removeObjectAtIndex:self.clickNum];
            [self.tableView reloadData];
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = self.botomView.frame;
                frame.origin.y = kScreenH;
                self.botomView.frame = frame;
            } completion:^(BOOL finished) {
                [self.fillInExpressBackV removeFromSuperview];
                self.fillInExpressBackV = nil;
                [self.botomView removeFromSuperview];
                self.botomView = nil;
            }];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            // Move to bottm center.
            hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
