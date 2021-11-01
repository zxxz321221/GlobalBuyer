//
//  CashDetailViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/27.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "CashDetailViewController.h"

@interface CashDetailViewController ()
@property (nonatomic,strong) UIView * backV;//顶部view
@property (nonatomic,strong) UIView * cashDetailV;//提现详情底部view

@property (nonatomic,strong) UILabel * paymentDate;//付款成功日期
@property (nonatomic,strong) UILabel * bankDate;//银行处理中日期
@property (nonatomic,strong) UILabel * accountDate;//到账日期

@property (nonatomic,strong) UILabel * cashWay;//提现方式
@property (nonatomic,strong) UILabel * createTime;//创建时间
@property (nonatomic,strong) UILabel * orderNum;//订单编号
@property (nonatomic,strong) UILabel * cashL;//提现详情：提现到   充值详情：付款方式


@end

@implementation CashDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self cashDetailView];
    [self detailInfo];
}
- (void)createUI{
    _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:185])];
    [self.view addSubview:_backV];
    
    UIImageView * imageView = [Unity imageviewAddsuperview_superView:_backV _subViewFrame:CGRectMake((kScreenW-[Unity countcoordinatesH:60])/2, [Unity countcoordinatesH:20], [Unity countcoordinatesH:60], [Unity countcoordinatesH:60]) _imageName:@"" _backgroundColor:nil];
    imageView.image = [UIImage imageNamed:@"提现成功"];
    
    UILabel * title = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(0, imageView.bottom+[Unity countcoordinatesH:20], kScreenW, [Unity countcoordinatesH:20]) _string:@"钱包提现成功" _lableFont:[UIFont systemFontOfSize:18] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    
    UILabel * placeL = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(0, title.bottom+[Unity countcoordinatesH:5], kScreenW, [Unity countcoordinatesH:30]) _string:@"981.00" _lableFont:[UIFont systemFontOfSize:30] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    
    UILabel * line = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(0, placeL.bottom+[Unity countcoordinatesH:20], kScreenW, [Unity countcoordinatesH:10]) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentCenter];
    line.backgroundColor = [Unity getColor:@"#f0f0f0"];
    
}
- (void)cashDetailView{
    UILabel * infoL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake([Unity countcoordinatesW:5], _backV.bottom, kScreenW-[Unity countcoordinatesW:10], [Unity countcoordinatesH:40]) _string:NSLocalizedString(@"GlobalBuyer_CashView_transactionDetails_navTitle", nil) _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
    
    UILabel * line1 = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(0, infoL.bottom, kScreenW, 2) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentLeft];
    line1.backgroundColor = [Unity getColor:@"#f0f0f0"];
    
    UILabel * progressL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(infoL.left, line1.bottom+[Unity countcoordinatesH:7], [Unity countcoordinatesW:60], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Processing_progress", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
    
    UIImageView * imgView = [Unity imageviewAddsuperview_superView:self.view _subViewFrame:CGRectMake(progressL.right+[Unity countcoordinatesW:40], progressL.top+[Unity countcoordinatesH:10], [Unity countcoordinatesW:7], [Unity countcoordinatesH:55]) _imageName:@"" _backgroundColor:nil];
    imgView.image = [UIImage imageNamed:@"成功提现"];
    
    UILabel * paymentSuccL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(imgView.right+[Unity countcoordinatesW:5], progressL.top, [Unity countcoordinatesW:73], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Payment_success", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#b444c8"] _textAlignment:NSTextAlignmentLeft];
    
    _paymentDate = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(paymentSuccL.right+[Unity countcoordinatesW:5], paymentSuccL.top,[Unity countcoordinatesW:120], [Unity countcoordinatesH:25]) _string:@"2019.02.08 08:56:42" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
    
    UILabel * bankL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(paymentSuccL.left, paymentSuccL.bottom, [Unity countcoordinatesW:70], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_BankProcessing", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#b444c8"] _textAlignment:NSTextAlignmentLeft];
    
    _bankDate = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(_paymentDate.left, _paymentDate.bottom,[Unity countcoordinatesW:120], [Unity countcoordinatesH:25]) _string:@"2019.02.08 08:56:42" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
    
    UILabel * accountL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(bankL.left, bankL.bottom, [Unity countcoordinatesW:70], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Arrival_account", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#b444c8"] _textAlignment:NSTextAlignmentLeft];
    
    _accountDate = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(_bankDate.left, _bankDate.bottom,[Unity countcoordinatesW:120], [Unity countcoordinatesH:25]) _string:@"2019.02.08 16:30:21" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
}
- (void)detailInfo{
    _cashL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake([Unity countcoordinatesW:5], _accountDate.bottom, [Unity countcoordinatesW:60], _accountDate.height) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_To_cash", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
    
    _cashWay = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake([Unity countcoordinatesW:115], _cashL.top, [Unity countcoordinatesW:200], _cashL.height) _string:@"银联" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
    
    UILabel * createDateL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(_cashL.left, _cashL.bottom, _cashL.width, _cashL.height) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Creation_time", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
    
    _createTime = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(_cashWay.left, createDateL.top, _cashWay.width, _cashWay.height) _string:@"2019.02.08 09:00:00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
    
    UILabel * orderNumL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(createDateL.left, _createTime.bottom, createDateL.width, createDateL.height) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Order_number", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
    
    _orderNum = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(_createTime.left, orderNumL.top, _createTime.width, _createTime.height) _string:@"180113099034859" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_CashView_transactionDetails_navTitle", nil);
    
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction:)];
    self.navigationItem.leftBarButtonItem = itemleft;
    
}
- (void)popAction:(UIBarButtonItem *)barButtonItem
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
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
