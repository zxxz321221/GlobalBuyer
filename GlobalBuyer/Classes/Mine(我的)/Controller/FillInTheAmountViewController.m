//
//  FillInTheAmountViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/8.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "FillInTheAmountViewController.h"
#import "PayViewController.h"

@interface FillInTheAmountViewController ()

@property (nonatomic,strong)UIScrollView *amountBackSV;
@property (nonatomic,strong)UIView *amountBackV;
@property (nonatomic,strong)UILabel *backVTitle;
@property (nonatomic,strong)UILabel *revaluedCurrencyLb;
@property (nonatomic,strong)UITextField *amountTf;

@end

@implementation FillInTheAmountViewController

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
    NSString *urlString ;
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSString *payCurrency = self.currency;
    NSString *paytype = self.pay_type;
    NSString *payMed = self.pay_menthod;
    urlString = [NSString stringWithFormat:PurseRechargeApi,API_ID,TOKEN,userToken,self.amountTf.text,payCurrency,payMed,paytype];
    
    PayViewController *payVC = [[PayViewController alloc]init];
    payVC.urlString = urlString;
    payVC.shopCartVC = self;
    payVC.type = @"fillInAmount";
    [self.navigationController pushViewController:payVC animated:YES];
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
