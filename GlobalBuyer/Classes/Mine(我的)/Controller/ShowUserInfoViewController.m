//
//  ShowUserInfoViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/5/21.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ShowUserInfoViewController.h"
#import "ShowUserInfoTableViewCell.h"


@interface ShowUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *logOffBtn;

@property (nonatomic, assign)BOOL canEdit;

@property (nonatomic, strong)NSString *passWord;

@end

@implementation ShowUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    [self createUI];
}

- (void)initDataSource
{
    self.canEdit = NO;
    
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My_NavRight", nil);
    [self.view addSubview:self.logOffBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_change", nil) style: UIBarButtonItemStylePlain target:self action:@selector(editClick)];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    
    NSLog(@"kScreenW%f",kScreenW);
    NSLog(@"kScreenH%f",kScreenH);
    NSLog(@"LL_StatusBarAndNavigationBarHeight%f",LL_StatusBarAndNavigationBarHeight);
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - LL_StatusBarAndNavigationBarHeight - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.scrollEnabled = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (UIButton *)logOffBtn {
    if (_logOffBtn == nil) {
        _logOffBtn = [[UIButton alloc]init];
        _logOffBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenW, 49);
        [_logOffBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOffBtn setTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_exit", nil) forState:UIControlStateNormal];
        [_logOffBtn setBackgroundColor:Main_Color];
        [_logOffBtn addTarget:self action:@selector(logOffClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOffBtn;
}

- (void)logOffClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_Alert_title", nil) message:NSLocalizedString(@"GlobalBuyer_UserInfo_Alert_message", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"api_id"] = API_ID;
        params[@"api_token"] = TOKEN;
        params[@"secret_key"] = userToken;
        
        [manager POST:UnbundlingJPushApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths    objectAtIndex:0];
            NSLog(@"path = %@",path);
            NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
            NSFileManager *defaultManager = [NSFileManager defaultManager];
            [defaultManager removeItemAtPath:filename error:nil];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
            UserDefaultRemoveObjectForKey(USERTOKEN);
            
            [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_Facebook   completion:^(id result, NSError *error) {
                
            }];
            [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
            [[NSUserDefaults standardUserDefaults]setObject:@"false" forKey:@"DistributorBoss"];
            [self refreshGoodsNum];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"APriceRule"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)createUI{
    
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.canEdit == YES) {
        return 5;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowUserInfoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell  = [[ShowUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.inputTF.tag = indexPath.row+1;
    [cell.inputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (indexPath.row == 0) {
        cell.nameLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_nickname", nil);
        cell.inputTF.text = self.model.fullname;
    }
    if (indexPath.row == 1) {
        cell.nameLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_Gender", nil);
        if ([[NSString stringWithFormat:@"%@",self.model.sex] isEqualToString:@"1"]) {
            cell.inputTF.text = NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil);
        }else if([[NSString stringWithFormat:@"%@",self.model.sex] isEqualToString:@"2"]){
            cell.inputTF.text = NSLocalizedString(@"GlobalBuyer_UserInfo_nv", nil);
        }
    }
    if (indexPath.row == 2) {
        cell.nameLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_phone", nil);
        cell.inputTF.text = self.model.mobile_phone;
    }
    if (indexPath.row == 3) {
        cell.nameLb.text = @"Email";
        cell.inputTF.text = self.model.email_name;
    }
    if (indexPath.row == 4) {
        cell.nameLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_changePW", nil);
        [cell.inputTF setSecureTextEntry:YES];
    }
    
    
    if (self.canEdit) {
        if (indexPath.row == 1) {
            cell.inputTF.userInteractionEnabled = NO;
        }else{
            cell.inputTF.userInteractionEnabled = YES;
            cell.inputTF.layer.borderWidth = 1;
        }
        
    }else{
        [cell.inputTF resignFirstResponder];
        cell.inputTF.userInteractionEnabled = NO;
        cell.inputTF.layer.borderWidth = 0;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        if (self.canEdit == NO) {
            return;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:cancel];
            
            UIAlertAction *libray = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.model.sex = @1;
                [self.tableView reloadData];
                
            }];
            [alert addAction:libray];
            
            UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_nv", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.model.sex = @2;
                [self.tableView reloadData];
                
            }];
            [alert addAction:takePhoto];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)inputTF
{
    NSLog(@"%ld",(long)inputTF.tag);
    if (inputTF.tag == 1) {
        self.model.fullname = inputTF.text;
    }
    
    if (inputTF.tag == 3) {
        self.model.mobile_phone = inputTF.text;
    }
    
    if (inputTF.tag == 4) {
        self.model.email_name = inputTF.text;
    }
    
    if (inputTF.tag == 5) {
        self.passWord = inputTF.text;
    }
}

- (void)editClick
{
    self.canEdit = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Address_Save", nil) style: UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    [self.tableView reloadData];
}

- (void)saveClick
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"secret_key"] = userToken;
    params[@"password"] = self.passWord;
    params[@"fullname"] = self.model.fullname;
    params[@"sex"] = self.model.sex;
    params[@"mobile_phone"] = self.model.mobile_phone;
    params[@"email_name"] = self.model.email_name;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Saveing", nil);
    
    [manager POST:UserInfoEditApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject=========>\n%@",responseObject[@"message"]);
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"保存成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, 260.0f);
            [hud hideAnimated:YES afterDelay:2.f];
            
            self.canEdit = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_change", nil) style: UIBarButtonItemStylePlain target:self action:@selector(editClick)];
            [self.tableView reloadData];
            
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths    objectAtIndex:0];
            NSLog(@"path = %@",path);
            NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
            NSFileManager* fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            //NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
            
            //创建一个dic，写到plist文件里
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.model.email,@"email",self.model.fullname,@"fullname",self.model.email_name,@"email_name",self.model.mobile_phone,@"mobile_phone",self.model.sex,@"sex",nil];
            
            [dic writeToFile:filename atomically:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"保存失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"保存失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];

    }];
    

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
