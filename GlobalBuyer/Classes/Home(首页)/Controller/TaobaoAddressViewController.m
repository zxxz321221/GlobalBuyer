//
//  TaobaoAddressViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/16.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "TaobaoAddressViewController.h"
#import <WebKit/WebKit.h>
@interface TaobaoAddressViewController ()

@property (nonatomic,strong)UIView *backV;
@property (nonatomic,strong)UIView *addressV;
@property (nonatomic , strong) WKWebView * wkWebView;

@end

@implementation TaobaoAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI
{
    if (self.type == 0) {
        self.title = @"TaobaoCart";
    }else if (self.type == 1){
        self.title = @"JingDongCart";
    }else{
        self.title = @"YanXuanCart";
    }
    
    
    [self.view addSubview:self.wkWebView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_ViewReceiptInformation", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (WKWebView *)wkWebView{
    if(!_wkWebView){
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight)];
        NSString * webStr;
        //京东：https://p.m.jd.com/cart/cart.action?fromnav=1
        //网易：http://m.you.163.com/cart
        //淘宝：https://h5.m.taobao.com/mlapp/cart.html
        if (self.type == 0) {
            webStr = @"https://h5.m.taobao.com/mlapp/cart.html";
        }else if (self.type == 1){
            webStr = @"https://p.m.jd.com/cart/cart.action?fromnav=1";
        }else{
            webStr = @"http://m.you.163.com/cart";
        }
        
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", webStr]]]];
    }
    return _wkWebView;
}
- (void)onClickedOKbtn
{
    [self.view addSubview:self.backV];
    [self.view addSubview:self.addressV];
}

- (UIView *)backV
{
    if (_backV == nil) {
        _backV = [[UIView alloc]initWithFrame:self.view.bounds];
        _backV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _backV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBackV)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_backV addGestureRecognizer:tap];
    }
    return _backV;
}

- (void)closeBackV
{
    [self.addressV removeFromSuperview];
    self.addressV = nil;
    [self.backV removeFromSuperview];
    self.backV = nil;
}

- (UIView *)addressV
{
    if (_addressV == nil) {
        _addressV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 100, 300, 180)];
        _addressV.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil);
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor colorWithRed:146.0/255.0 green:69.0/255.0 blue:207.0/255.0 alpha:1];
        [_addressV addSubview:title];
        
        UILabel *leftAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 40)];
        leftAddress.font = [UIFont systemFontOfSize:13];
        leftAddress.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_DetailedAddress", nil);
        [_addressV addSubview:leftAddress];
        UILabel *leftName = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 60, 40)];
        leftName.font = [UIFont systemFontOfSize:13];
        leftName.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Addressee", nil);
        [_addressV addSubview:leftName];
        UILabel *leftPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 60, 40)];
        leftPhone.font = [UIFont systemFontOfSize:13];
        leftPhone.text = NSLocalizedString(@"GlobalBuyer_UserInfo_phone", nil);
        [_addressV addSubview:leftPhone];
        
        
        UILabel *lbThree = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, _addressV.frame.size.width - 60 - 80, 40)];
        lbThree.numberOfLines = 0;
        lbThree.font = [UIFont systemFontOfSize:12];
        lbThree.text = [NSString stringWithFormat:@"%@(%@)",self.address,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserLoginId"]];
        [_addressV addSubview:lbThree];
        UILabel *lbOne = [[UILabel alloc]initWithFrame:CGRectMake(80, 90, _addressV.frame.size.width - 60 - 80, 40)];
        lbOne.numberOfLines = 0;
        lbOne.font = [UIFont systemFontOfSize:12];
        lbOne.text = self.receiver;
        [_addressV addSubview:lbOne];
        UILabel *lbTwo = [[UILabel alloc]initWithFrame:CGRectMake(80, 130, _addressV.frame.size.width - 60 - 80, 40)];
        lbTwo.numberOfLines = 0;
        lbTwo.font = [UIFont systemFontOfSize:12];
        lbTwo.text = self.telPhone;
        [_addressV addSubview:lbTwo];
        
        UIButton *btnThree = [[UIButton alloc]initWithFrame:CGRectMake(_addressV.frame.size.width - 60, 50, 40, 40)];
        [btnThree setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Copy", nil) forState:UIControlStateNormal];
        [btnThree setTitleColor:[UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1] forState:UIControlStateNormal];
        btnThree.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addressV addSubview:btnThree];
        [btnThree addTarget:self action:@selector(clickThree) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnOne = [[UIButton alloc]initWithFrame:CGRectMake(_addressV.frame.size.width - 60, 90, 40, 40)];
        [btnOne setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Copy", nil) forState:UIControlStateNormal];
        [btnOne setTitleColor:[UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1] forState:UIControlStateNormal];
        btnOne.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addressV addSubview:btnOne];
        [btnOne addTarget:self action:@selector(clickOne) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *btnTwo = [[UIButton alloc]initWithFrame:CGRectMake(_addressV.frame.size.width - 60, 130, 40, 40)];
        [btnTwo setTitle:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Copy", nil) forState:UIControlStateNormal];
        [btnTwo setTitleColor:[UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:88.0/255.0 alpha:1] forState:UIControlStateNormal];
        btnTwo.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addressV addSubview:btnTwo];
        [btnTwo addTarget:self action:@selector(clickTwo) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return _addressV;
}

- (void)clickOne
{
    [self.addressV removeFromSuperview];
    self.addressV = nil;
    [self.backV removeFromSuperview];
    self.backV = nil;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.receiver;
}

- (void)clickTwo
{
    [self.addressV removeFromSuperview];
    self.addressV = nil;
    [self.backV removeFromSuperview];
    self.backV = nil;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.telPhone;
}

- (void)clickThree
{
    [self.addressV removeFromSuperview];
    self.addressV = nil;
    [self.backV removeFromSuperview];
    self.backV = nil;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@(%@)",self.address,[[NSUserDefaults standardUserDefaults]objectForKey:@"UserLoginId"]];
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
