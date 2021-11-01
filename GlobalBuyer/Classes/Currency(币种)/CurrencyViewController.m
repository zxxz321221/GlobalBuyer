//
//  CurrencyViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/23.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "CurrencyViewController.h"
#import "CurrencyView.h"
@interface CurrencyViewController ()<CurrencyViewDelegate>
@property (nonatomic, strong)CurrencyView *currencyView;
@end

@implementation CurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI界面
- (void)setupUI {
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"frist"]];
    bgImgView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.view addSubview:bgImgView];
    UIButton*btn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW - 150)/2, (kScreenH / 3) * 2, 150, 40)];
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_Selectcurrency", nil) forState:UIControlStateNormal];
    [btn setTitleColor:Main_Color forState:UIControlStateNormal];
    //btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(showCurrencyView) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = Main_Color.CGColor;
    btn.layer.borderWidth = 1;
    [self.view addSubview:btn];
    [self.view addSubview:self.currencyView];

}

- (CurrencyView *)currencyView {
    if (_currencyView == nil) {
        _currencyView = [CurrencyView currencyView];
        _currencyView.delegate = self;
    }
    return _currencyView;
}

#pragma mark view生命周期
- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)showCurrencyView {
    [self.currencyView showCurrencyView];
}

- (void)goTo {
    [self.delegate gotoHomeVC];
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
