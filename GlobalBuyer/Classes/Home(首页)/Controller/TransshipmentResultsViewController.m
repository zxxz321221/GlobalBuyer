//
//  TransshipmentResultsViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/3.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "TransshipmentResultsViewController.h"
#import "TaobaoAddressViewController.h"
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface TransshipmentResultsViewController ()


@property (nonatomic , retain)UIView *tipShadowView;

@property (nonatomic , retain)UIImageView *tipImgV;

@end

@implementation TransshipmentResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(UIView *)tipShadowView{
    if (!_tipShadowView) {
        _tipShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tipShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _tipImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(15), NAVIGATION_BAR_HEIGHT + kWidth(40), kWidth(345), kWidth(403))];
        [_tipImgV setImage:[UIImage imageNamed:@"复制收货地址"]];
        [_tipShadowView addSubview:_tipImgV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipShadowViewClicked)];
        [_tipShadowView addGestureRecognizer:tap];
    }
    
    return _tipShadowView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![UserDefault valueForKey:@"transfromTip"]) {
        [self.navigationController.view addSubview:self.tipShadowView];
    }
}

-(void)tipShadowViewClicked{
    if ([self.tipImgV.image isEqual:[UIImage imageNamed:@"复制收货地址"]]) {
        [self.tipImgV setImage:[UIImage imageNamed:@"去结算"]];
        self.tipImgV.frame = CGRectMake(kWidth(15), 490, kWidth(345), kWidth(208));
    }
    else{
        [UserDefault setObject:@"1" forKey:@"transfromTip"];
        [self.tipShadowView removeFromSuperview];
    }
    
}


- (void)createUI
{
    self.title = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TransportDetails", nil);
    self.view.backgroundColor = Cell_BgColor;
    
    UIImageView *arrowIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 35, NavBarHeight+16, 70, 70)];
    arrowIv.image = [UIImage imageNamed:@"ic_taobao_order_success"];
    [self.view addSubview:arrowIv];
    UILabel *successLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 100, 170, 200, 40)];
    successLb.textAlignment = NSTextAlignmentCenter;
    successLb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_OrderSuccess", nil);
    successLb.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:successLb];
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 230, kScreenW, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineV];
    
    UIView *circleV = [[UIView alloc]initWithFrame:CGRectMake(10, 250, 10, 10)];
    circleV.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1];
    circleV.layer.cornerRadius = 5;
    [self.view addSubview:circleV];
    UILabel *subtitleLb = [[UILabel alloc]initWithFrame:CGRectMake(40, 246, 260, 20)];
    subtitleLb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_AdoptAndSettlement", nil);
    subtitleLb.font = [UIFont systemFontOfSize:13];
    subtitleLb.numberOfLines =0;
    [subtitleLb sizeToFit];
    [self.view addSubview:subtitleLb];
    
    UIView *detailV = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, kScreenW - 60, 180)];
    detailV.userInteractionEnabled = YES;
    detailV.layer.borderWidth = 0.5;
    detailV.layer.cornerRadius = 5;
    detailV.layer.borderColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1].CGColor;
    [self.view addSubview:detailV];
    UIView *alertTitleV = [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenW - 60,40)];
    alertTitleV.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1];
    [detailV addSubview:alertTitleV];
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:alertTitleV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = alertTitleV.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    alertTitleV.layer.mask = maskLayer;
    
    UIImageView *addressIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    addressIv.image = [UIImage imageNamed:@"address"];
    [alertTitleV addSubview:addressIv];
    UILabel *addressLb = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 40)];
    addressLb.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil);
    addressLb.font = [UIFont systemFontOfSize:13];
    addressLb.textColor = [UIColor whiteColor];
    [alertTitleV addSubview:addressLb];
    
    UILabel *leftAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 40)];
    leftAddress.font = [UIFont systemFontOfSize:13];
    leftAddress.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_DetailedAddress", nil);
    [detailV addSubview:leftAddress];
    UILabel *leftName = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 80, 40)];
    leftName.font = [UIFont systemFontOfSize:13];
    leftName.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Addressee", nil);
    [detailV addSubview:leftName];
    UILabel *leftPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 80, 40)];
    leftPhone.font = [UIFont systemFontOfSize:13];
    leftPhone.text = NSLocalizedString(@"GlobalBuyer_UserInfo_phone", nil);
    [detailV addSubview:leftPhone];
    
    UILabel *rightAddress = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, detailV.frame.size.width - 180, 40)];
    rightAddress.font = [UIFont systemFontOfSize:10];
    rightAddress.numberOfLines = 0;
    rightAddress.text = [NSString stringWithFormat:@"%@(%@)",self.address,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserLoginId"]];
    [detailV addSubview:rightAddress];
    UILabel *rightName = [[UILabel alloc]initWithFrame:CGRectMake(100, 90, 120, 40)];
    rightName.font = [UIFont systemFontOfSize:13];
    rightName.text = self.receiver;
    [detailV addSubview:rightName];
    UILabel *rightPhone = [[UILabel alloc]initWithFrame:CGRectMake(100, 130, 120, 40)];
    rightPhone.font = [UIFont systemFontOfSize:13];
    rightPhone.text = self.telPhone;
    [detailV addSubview:rightPhone];
    
    UIButton *btnThree = [[UIButton alloc]initWithFrame:CGRectMake(detailV.frame.size.width - 60, 50, 40, 40)];
    [btnThree setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Copy", nil) forState:UIControlStateNormal];
    [btnThree setTitleColor:[UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnThree.titleLabel.font = [UIFont systemFontOfSize:13];
    [detailV addSubview:btnThree];
    [btnThree addTarget:self action:@selector(clickThree) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnOne = [[UIButton alloc]initWithFrame:CGRectMake(detailV.frame.size.width - 60, 90, 40, 40)];
    [btnOne setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Copy", nil) forState:UIControlStateNormal];
    [btnOne setTitleColor:[UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnOne.titleLabel.font = [UIFont systemFontOfSize:13];
    [detailV addSubview:btnOne];
    [btnOne addTarget:self action:@selector(clickOne) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnTwo = [[UIButton alloc]initWithFrame:CGRectMake(detailV.frame.size.width - 60, 130, 40, 40)];
    [btnTwo setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Copy", nil) forState:UIControlStateNormal];
    [btnTwo setTitleColor:[UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1] forState:UIControlStateNormal];
    btnTwo.titleLabel.font = [UIFont systemFontOfSize:13];
    [detailV addSubview:btnTwo];
    [btnTwo addTarget:self action:@selector(clickTwo) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
//    UIButton *taobaoSettlement = [[UIButton alloc]initWithFrame:CGRectMake(detailV.frame.origin.x, 470, detailV.frame.size.width/2 - 20, 40)];
//    taobaoSettlement.layer.borderWidth = 0.5;
//    taobaoSettlement.layer.borderColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1].CGColor;
//    taobaoSettlement.layer.cornerRadius = 5;
//    [taobaoSettlement setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TaobaoSettlement", nil) forState:UIControlStateNormal];
//    [taobaoSettlement setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:taobaoSettlement];
//    [taobaoSettlement addTarget:self action:@selector(gotoTaobaoApp) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *appSettlement = [[UIButton alloc]initWithFrame:CGRectMake(detailV.frame.origin.x, 490, kScreenW-60, 40)];
    appSettlement.layer.borderWidth = 0.5;
    appSettlement.layer.borderColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1].CGColor;
    appSettlement.layer.cornerRadius = 5;
    [appSettlement setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_InAppSettlement", nil) forState:UIControlStateNormal];
    [appSettlement setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:appSettlement];
    [appSettlement addTarget:self action:@selector(appSettlementClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.type ==4) {
        appSettlement.hidden= YES;
    }

}

- (void)clickOne
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.receiver;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Success" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)clickTwo
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.telPhone;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Success" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)clickThree
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@(%@)",self.address,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserLoginId"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Success" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)gotoTaobaoApp
{
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    [[[AlibcTradeSDK sharedInstance] tradeService]show:self.navigationController webView:nil page:[AlibcTradePageFactory myCartsPage] showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        
    }];
}

- (void)appSettlementClick{
//    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
//    showParam.openType = AlibcOpenTypeH5;
    TaobaoAddressViewController *vc = [[TaobaoAddressViewController alloc]init];
    vc.telPhone = self.telPhone;
    vc.receiver = self.receiver;
    vc.address = self.address;
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
//    [[[AlibcTradeSDK sharedInstance] tradeService]show:vc webView:self.taobaoWeb page:[AlibcTradePageFactory myCartsPage] showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//    }];
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
