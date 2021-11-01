//
//  NoLoginViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/19.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "NoLoginViewController.h"
#import "ShopCartHeaderView.h"
#import "PopLoginViewController.h"
#import "NavigationController.h"
@interface NoLoginViewController ()
@property (nonatomic, strong)ShopCartHeaderView *shopCartHeaderView;
@property (nonatomic, strong)UILabel *detailLa;

@end

@implementation NoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 创建视图
- (void)setupUI {

    //[self.view addSubview:self.shopCartHeaderView];
    [self.view addSubview:self.detailLa];
    [self.view addSubview:self.loginBtn];

}

- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW - 160)/2, kScreenH - 180-(LL_iPhoneX ? 80.f : 0.f), 160, 50)];
        //_loginBtn.layer.cornerRadius = 10;
        [_loginBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_login", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:Main_Color];
//        [_loginBtn addTarget:self action:@selector(goLoginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)detailLa {
    if (_detailLa == nil) {
        _detailLa = [UILabel new];
        _detailLa.frame = CGRectMake(0,  kScreenH - 250-(LL_iPhoneX ? 80.f : 0.f), kScreenW, 30);
        _detailLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Nologin", nil);
        _detailLa.font = [UIFont systemFontOfSize:13];
        _detailLa.textAlignment = NSTextAlignmentCenter;
        _detailLa.textColor = [UIColor grayColor];
    }
    return _detailLa;
}

- (ShopCartHeaderView *)shopCartHeaderView {
    if (_shopCartHeaderView == nil) {
        _shopCartHeaderView = [[ShopCartHeaderView alloc]init];
        _shopCartHeaderView.frame =CGRectMake(0, 64, kScreenW, [_shopCartHeaderView getH]);
    }
    return _shopCartHeaderView;
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
