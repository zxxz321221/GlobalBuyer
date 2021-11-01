//
//  PaySuccessViewController.m
//  GlobalBuyer
//
//  Created by 赵祥 on 2021/9/13.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "WalletViewController.h"
#import "PurseRechargeViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"GlobalBuyer_CashView_transactionDetails_navTitle", nil);
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_Message_commodity", nil);
    titleLab.textColor = [Unity getColor:@"#333333"];
    titleLab.font = [UIFont boldSystemFontOfSize:kWidth(24)];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kWidth(35));
        make.centerX.equalTo(self.view).mas_offset(kWidth(30));
    }];
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"支付成功"]];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.right.equalTo(titleLab.mas_left).mas_offset(kWidth(-20));
        make.width.height.mas_offset(kWidth(30));
    }];
    
    UIButton *doneBtn = [[UIButton alloc]init];
    [doneBtn setTitle:NSLocalizedString(@"GlobalBuyer_Done", nil) forState:UIControlStateNormal];
    [doneBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(16)];
    doneBtn.backgroundColor = [UIColor whiteColor];
    doneBtn.layer.borderColor = [Unity getColor:@"#666666"].CGColor;
    doneBtn.layer.borderWidth = 1;
    doneBtn.layer.cornerRadius = kWidth(15);
    [doneBtn addTarget:self action:@selector(paySuccessDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLab.mas_bottom).mas_offset(kWidth(35));
        make.width.mas_offset(kWidth(80));
        make.height.mas_offset(kWidth(30));
    }];
    
}

-(void)paySuccessDoneClicked{
    if ([self.payType isEqualToString:@"fillInAmount"]) {
        BOOL isPop = NO;
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[WalletViewController class]]) {
                isPop = YES;
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
            
        }
        if (!isPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if ([self.payType isEqualToString:@"auditStatus"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsAlreadyShipped"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IsPushProcurementView"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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
