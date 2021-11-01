//
//  RefundFillInTheAmountViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/21.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "RefundFillInTheAmountViewController.h"
#import "PasswordViewSuper.h"

@interface RefundFillInTheAmountViewController ()<PasswordViewSuperDelegate>

@property (nonatomic,strong)UIScrollView *amountBackSV;
@property (nonatomic,strong)UIView *amountBackV;
@property (nonatomic,strong)UILabel *backVTitle;
@property (nonatomic,strong)UILabel *revaluedCurrencyLb;
@property (nonatomic,strong)UITextField *amountTf;

@end

@implementation RefundFillInTheAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = Cell_BgColor;
    
    [self.view addSubview:self.amountBackSV];
}

- (UIScrollView *)amountBackSV
{
    if (_amountBackSV == nil) {
        _amountBackSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [_amountBackSV addSubview:self.amountBackV];
    }
    return _amountBackSV;
}

- (UIView *)amountBackV
{
    if (_amountBackV == nil) {
        _amountBackV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, 50, 300, 240)];
        _amountBackV.backgroundColor = [UIColor whiteColor];
        
        self.backVTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 300, 30)];
        self.backVTitle.textAlignment = NSTextAlignmentCenter;
        self.backVTitle.font = [UIFont systemFontOfSize:18];
        self.backVTitle.text = self.backVTitleStr;
        [_amountBackV addSubview:self.backVTitle];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(20, 55, 260, 1)];
        lineV.backgroundColor = Main_Color;
        [_amountBackV addSubview:lineV];
        
        self.revaluedCurrencyLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 300, 30)];
        self.revaluedCurrencyLb.textAlignment = NSTextAlignmentCenter;
        self.revaluedCurrencyLb.font = [UIFont systemFontOfSize:15];
        self.revaluedCurrencyLb.text = self.revaluedCurrencyStr;
        [_amountBackV addSubview:self.revaluedCurrencyLb];
        
        self.amountTf = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 260, 40)];
        self.amountTf.layer.borderColor = Main_Color.CGColor;
        self.amountTf.layer.borderWidth = 0.7;
        self.amountTf.font = [UIFont systemFontOfSize:18 weight:2];
        
        [_amountBackV addSubview:self.amountTf];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 300, 40)];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        sureBtn.backgroundColor = Main_Color;
        [_amountBackV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(surePayClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _amountBackV;
}

- (void)surePayClick
{
    PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithAlertTitle:NSLocalizedString(@"GlobalBuyer_LoginView_inputPW", nil) AlertMessageTitle:[NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"GlobalBuyer_My_Wallet_TheAmountOfTheRefunds", nil),[self.amountTf.text floatValue]] AlertAmount:@""];
    passwordVS.delegate = self;
    passwordVS.setOrEnter = @"enter";
    [passwordVS show];
}

- (void)didEnterPWD:(NSString *)pwd withType:(NSString *)type
{
    if ([type isEqualToString:@"enter"]) {
        NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
        NSDictionary *params = @{@"api_id":API_ID,
                                 @"api_token":TOKEN,
                                 @"secret_key":api_token,
                                 @"password":pwd,
                                 @"amount":[NSString stringWithFormat:@"%.2f",[self.amountTf.text floatValue]]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:PurseRefundApplicationApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject[@"code"]isEqualToString:@"success"]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = responseObject[@"message"];
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:1.f];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = responseObject[@"message"];
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:1.f];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
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
