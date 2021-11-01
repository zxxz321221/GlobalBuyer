//
//  ApplyExtensionIntroduceViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/26.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ApplyExtensionIntroduceViewController.h"
#import "ApplyExtensionViewController.h"

@interface ApplyExtensionIntroduceViewController ()

@property (nonatomic,strong)UIScrollView *backSV;
@property (nonatomic,strong)UIImageView *allBackIV;
@property (nonatomic,strong)UIButton *applyBtn;

@property (nonatomic) CGPoint inputPoint0;//底部背景渐变颜色参数
@property (nonatomic) CGPoint inputPoint1;
@property (nonatomic) UIColor *inputColor0;
@property (nonatomic) UIColor *inputColor1;

@end

@implementation ApplyExtensionIntroduceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self checkState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
}

- (void)checkState
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = [NSDictionary new];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    params = @{@"api_id":API_ID,
               @"api_token":TOKEN,
               @"secret_key":userToken};
    
    [manager POST:PersonalDataSubmissionStatusApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                self.applyBtn.selected = YES;
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit_Success", nil) forState:UIControlStateNormal];
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit_Success", nil) forState:UIControlStateHighlighted];
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit_Success", nil) forState:UIControlStateSelected];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:@"DistributorBoss"];
            }
            
            
            if ([responseObject[@"status"]isEqualToString:@"under_review"]) {
                self.applyBtn.selected = YES;
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit", nil) forState:UIControlStateNormal];
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit", nil) forState:UIControlStateHighlighted];
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit", nil) forState:UIControlStateSelected];
            }
            
            if ([responseObject[@"status"]isEqualToString:@"false"]) {
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit_Fail", nil) forState:UIControlStateNormal];
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit_Fail", nil) forState:UIControlStateHighlighted];
                [self.applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Wallet_AuditStatus_Audit_Fail", nil) forState:UIControlStateSelected];
            }
            
            if ([responseObject[@"status"]isEqualToString:@"cannot_register"]) {
                self.applyBtn.selected = YES;
                [self.applyBtn setTitle:NSLocalizedString(@"不满足申请条件", nil) forState:UIControlStateNormal];
                [self.applyBtn setTitle:NSLocalizedString(@"不满足申请条件", nil) forState:UIControlStateHighlighted];
                [self.applyBtn setTitle:NSLocalizedString(@"不满足申请条件", nil) forState:UIControlStateSelected];
            }
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backSV];
    [self.view addSubview:self.applyBtn];
}

- (UIScrollView *)backSV
{
    if (_backSV == nil) {
        _backSV = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [_backSV addSubview:self.allBackIV];
        _backSV.contentSize = CGSizeMake(0, kScreenW*2.5);
    }
    return _backSV;
}

- (UIImageView *)allBackIV
{
    if (_allBackIV == nil) {
        _allBackIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*2.5)];
        _allBackIV.image = [UIImage imageNamed:@"应用推广介绍.jpg"];
    }
    return _allBackIV;
}

- (UIButton *)applyBtn
{
    if (_applyBtn == nil) {
        _applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
        [_applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_ApplicationForDistribution", nil) forState:UIControlStateNormal];
        self.inputColor0 = [UIColor colorWithRed:202.0/255.0 green:24.0/255.0 blue:254.0/255.0 alpha:1];
        self.inputColor1 = [UIColor colorWithRed:246.0/255.0 green:18.0/255.0 blue:240.0/255.0 alpha:1];
        self.inputPoint0 = CGPointMake(0, 1);
        self.inputPoint1 = CGPointMake(1, 1);
        CAGradientLayer *layer1 = [CAGradientLayer new];
        layer1.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
        layer1.startPoint = _inputPoint0;
        layer1.endPoint = _inputPoint1;
        layer1.frame = _applyBtn.bounds;
        [_applyBtn.layer addSublayer:layer1];
        [_applyBtn addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (void)applyClick
{
    if (self.applyBtn.selected == YES) {
        return;
    }
    ApplyExtensionViewController *applyExtensionVC = [[ApplyExtensionViewController alloc]init];
    [self.navigationController pushViewController:applyExtensionVC animated:YES];
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
