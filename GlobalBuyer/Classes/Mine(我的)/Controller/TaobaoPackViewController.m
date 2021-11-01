//
//  TaobaoPackViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/17.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "TaobaoPackViewController.h"
#import "TaobaoPackTableViewCell.h"

@interface TaobaoPackViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *selectDataSouce;

@property (nonatomic,strong)NSString *nodeStr;
@property (nonatomic,strong)NSString *storageStr;

@end

@implementation TaobaoPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self downData];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)selectDataSouce
{
    if (_selectDataSouce == nil) {
        _selectDataSouce = [[NSMutableArray alloc]init];
    }
    return _selectDataSouce;
}

- (void)createUI
{
    self.title = [NSString stringWithFormat:@"Taobao%@",NSLocalizedString(@"GlobalBuyer_My_WaitPack", nil)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_My_Pack", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)onClickedOKbtn
{
    if (self.selectDataSouce.count == 0) {
        return;
    }
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
    for (int i = 0;  i < self.selectDataSouce.count; i++) {
        [dataDict setObject:self.selectDataSouce[i][@"package_num"] forKey:[NSString stringWithFormat:@"%@",self.selectDataSouce[i][@"id"]]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"secret_key":api_token,
                             @"data":jsonString
                             };
    
    [manager POST:UserTaobaoPackApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (int i = 0; i < self.selectDataSouce.count; i++) {
                [self.dataSource removeObject:self.selectDataSouce[i]];
            }
            [self.selectDataSouce removeAllObjects];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 100;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    [manager GET:UserTaobaoPakageApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaobaoPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taobaocell"];
    if (cell == nil) {
        cell = [[TaobaoPackTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taobaocell"];
    }
    NSDictionary *dict = [self stringToJSON:self.dataSource[indexPath.row][@"body"]];
    
    [cell.goodIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"picture"]]]];
    cell.titleLb.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    cell.subTitleLb.text = [NSString stringWithFormat:@"%@",dict[@"class"]];
    cell.qtyLb.text = [NSString stringWithFormat:@"x%@",dict[@"qty"]];
    cell.priceLb.text = [NSString stringWithFormat:@"CNY%@",dict[@"price"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int tmpI = 0;
    for (int i = 0 ; i < self.selectDataSouce.count; i++) {
        if (self.selectDataSouce[i] == self.dataSource[indexPath.row]) {
            cell.selectBtn.selected = YES;
            tmpI++;
            break;
        }
    }
    
    if (tmpI == 0) {
        cell.selectBtn.selected = NO;
    }
    
    if (self.selectDataSouce.count != 0) {
        if ([self.dataSource[indexPath.row][@"node"]isEqualToString:self.nodeStr] &&
            [self.dataSource[indexPath.row][@"storage"]isEqualToString:self.storageStr]) {
            cell.userInteractionEnabled = YES;
            cell.coverV.hidden = YES;
        }else{
            cell.userInteractionEnabled = NO;
            cell.coverV.hidden = NO;
        }
    }else{
        cell.userInteractionEnabled = YES;
        cell.coverV.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tmpI = 0;
    for (int i = 0 ; i < self.selectDataSouce.count; i++) {
        if (self.selectDataSouce[i] == self.dataSource[indexPath.row]) {
            [self.selectDataSouce removeObject:self.dataSource[indexPath.row]];
            tmpI++;
        }
    }
    
    if (tmpI == 0) {
        [self.selectDataSouce addObject:self.dataSource[indexPath.row]];
        self.nodeStr = self.dataSource[indexPath.row][@"node"];
        self.storageStr = self.dataSource[indexPath.row][@"storage"];
    }
    
    if (self.selectDataSouce.count == 0) {
        self.nodeStr = @"";
        self.storageStr = @"";
    }
    
    [self.tableView reloadData];
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
