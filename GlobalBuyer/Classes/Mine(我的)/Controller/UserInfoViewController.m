//
//  UserInfoViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "UserInfoViewController.h"

#import "EditUserInfoViewController.h"
@interface UserInfoViewController ()<EditUserInfoViewControllerDelegate>

@property (nonatomic,strong) UIButton *logOffBtn;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
}

-  (void)setupUI{
    [super setupUI];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My_NavRight", nil);
    [self.view addSubview:self.logOffBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_change", nil) style: UIBarButtonItemStylePlain target:self action:@selector(editClick)];
}

- (void)editClick{
    EditUserInfoViewController *editUserInfoVC = [EditUserInfoViewController new];
    editUserInfoVC.model = self.model;
    editUserInfoVC.delegate = self;
    [self.navigationController pushViewController:editUserInfoVC animated:YES];

}

- (void)saveModel:(NSMutableArray *)arr{
    self.dataSource = arr;
    [self.tableView reloadData];

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
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
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
     
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
