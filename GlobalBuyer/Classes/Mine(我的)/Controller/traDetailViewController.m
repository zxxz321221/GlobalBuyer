//
//  traDetailViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/28.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "traDetailViewController.h"
#define Gray_Color [UIColor grayColor]
@interface traDetailViewController ()
@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,strong) UIView * topView;//头部view
@property (nonatomic,strong) UIView * goodsInfoView;//商品信息view
@property (nonatomic,strong) UIView * costInfoView;//商品费用信息view
@property (nonatomic,strong) UIView * freightInfoView;//运费信息view
@property (nonatomic,strong) UIView * paymentInfoView;//付款方式信息view

@property (nonatomic,strong) UILabel * orderL;//头部view标题label  （订单首款、订单尾款）
@property (nonatomic,strong) UILabel * placeL;//付款金额

@property (nonatomic,strong) UILabel * goodsSum;//商品总价
@property (nonatomic,strong) UILabel * expenseTax;//消费税
@property (nonatomic,strong) UILabel * serveTax;//服务费
@property (nonatomic,strong) UILabel * firstSum;//首款总额
@property (nonatomic,strong) UILabel * actualSum;//实付首款
@property (nonatomic,strong) UILabel * instruction;//费用说明

@property (nonatomic,strong) UILabel * localFreight;//当地运费
@property (nonatomic,strong) UILabel * internationFreight;//国际运费
@property (nonatomic,strong) UILabel * serveTallage;//消费税
@property (nonatomic,strong) UILabel * tariff;//关税
@property (nonatomic,strong) UILabel * goodsPrice;//商品差价
@property (nonatomic,strong) UILabel * appreciation;//增值服务费
@property (nonatomic,strong) UILabel * finalSum;//尾款总额
@property (nonatomic,strong) UILabel * actualFinalSum;//实付尾款

@property (nonatomic,strong) UILabel * paymentFs;//付款方式
@property (nonatomic,strong) UILabel * createDate;//创建时间
@property (nonatomic,strong) UILabel * paymentDate;//付款时间


@end

@implementation traDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScrollView];
    
}
//头部view
- (void)createTopView{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:160])];
    _topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [Unity imageviewAddsuperview_superView:_topView _subViewFrame:CGRectMake((kScreenW-[Unity countcoordinatesH:60])/2, [Unity countcoordinatesH:20], [Unity countcoordinatesH:60], [Unity countcoordinatesH:55]) _imageName:@"" _backgroundColor:nil];
    imageView.image = [UIImage imageNamed:@"已付首款"];
    
    _orderL = [Unity lableViewAddsuperview_superView:_topView _subViewFrame:CGRectMake(0, imageView.bottom+[Unity countcoordinatesH:20], kScreenW, [Unity countcoordinatesH:20]) _string:@"订单首款" _lableFont:[UIFont systemFontOfSize:18] _lableTxtColor:nil _textAlignment:NSTextAlignmentCenter];
    
    _placeL = [Unity lableViewAddsuperview_superView:_topView _subViewFrame:CGRectMake(0, _orderL.bottom+[Unity countcoordinatesH:5], kScreenW, [Unity countcoordinatesH:30]) _string:@"-2856.00" _lableFont:[UIFont systemFontOfSize:30] _lableTxtColor:nil _textAlignment:NSTextAlignmentCenter];
}
//商品信息
- (void)createGoodsView{
    _goodsInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom+[Unity countcoordinatesH:7], kScreenW, [Unity countcoordinatesH:250])];
    _goodsInfoView.backgroundColor = [UIColor whiteColor];
    
    UILabel * orderInfoL = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], 0,kScreenW-[Unity countcoordinatesW:10] , [Unity countcoordinatesH:38]) _string:NSLocalizedString(@"GlobalBuyer_CashView_transactionDetails_navTitle", nil) _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
    UILabel * line = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake(0, orderInfoL.bottom, kScreenW, 2) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentLeft];
    line.backgroundColor = [Unity getColor:@"#f5f5f5"];
    for (int i =0; i<2; i++) {
        UILabel * orderNumL = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], line.bottom+(i*[Unity countcoordinatesH:105])+[Unity countcoordinatesH:5], [Unity countcoordinatesW:60], [Unity countcoordinatesH:20]) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Order_number", nil) _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
        UILabel * orderNumberL = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:100], orderNumL.top, kScreenW-[Unity countcoordinatesW:105], orderNumL.height) _string:@"Y13048834590" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
        UIImageView * imageView = [Unity imageviewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake(orderNumL.left, orderNumberL.bottom+[Unity countcoordinatesH:5], [Unity countcoordinatesH:70], [Unity countcoordinatesH:70]) _imageName:@"" _backgroundColor:[UIColor redColor]];
        imageView.layer.cornerRadius = 7;
        UILabel * contentL = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake(imageView.right+[Unity countcoordinatesW:5], imageView.top, [Unity countcoordinatesW:170], [Unity countcoordinatesH:40]) _string:@"创意兔子硅胶小夜灯婴儿喂奶睡眠拍拍查电护眼卧室床头台灯少京东方卡垃圾分类可视对讲" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
        contentL.lineBreakMode = NSLineBreakByWordWrapping;
        contentL.numberOfLines = 0;
        
        UILabel * goodsNumL = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:265], contentL.top, [Unity countcoordinatesW:50], [Unity countcoordinatesH:20]) _string:@"X2" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
        UILabel * placeL = [Unity lableViewAddsuperview_superView:_goodsInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:100], goodsNumL.bottom+[Unity countcoordinatesH:30], kScreenW-[Unity countcoordinatesW:105], [Unity countcoordinatesH:20]) _string:@"¥350.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentRight];
    }
}
//商品费用信息
- (void)createCostView{
    _costInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _goodsInfoView.bottom, kScreenW, [Unity countcoordinatesH:150])];
    _costInfoView.backgroundColor = [UIColor whiteColor];
    
    UILabel * goodsSumL = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], 0, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"商品总价" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _goodsSum = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], goodsSumL.top, kScreenW-[Unity countcoordinatesW:155], goodsSumL.height) _string:@"¥2840.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * expenseL = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], goodsSumL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"消费税" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _expenseTax = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], expenseL.top, kScreenW-[Unity countcoordinatesW:155], expenseL.height) _string:@"¥9.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * serveL = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], expenseL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"服务费" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _serveTax = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], serveL.top, kScreenW-[Unity countcoordinatesW:155], serveL.height) _string:@"¥3.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * firstL = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], serveL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"首款总额" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
    _firstSum = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], firstL.top, kScreenW-[Unity countcoordinatesW:155], firstL.height) _string:@"¥2856.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentRight];
    
    UILabel * line = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake(0, firstL.bottom+3, kScreenW, 2) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentRight];
    line.backgroundColor = [Unity getColor:@"#f5f5f5"];
    
    UILabel * actualSumL = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], line.bottom, firstL.width, firstL.height) _string:@"实付首款" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
    _actualSum = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], actualSumL.top, kScreenW-[Unity countcoordinatesW:155], actualSumL.height) _string:@"¥2856.00" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:[UIColor redColor] _textAlignment:NSTextAlignmentRight];
    _instruction = [Unity lableViewAddsuperview_superView:_costInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], actualSumL.bottom, kScreenW-[Unity countcoordinatesW:10], [Unity countcoordinatesH:20]) _string:@"(含消费税¥9.00含服务费¥3.00)" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[UIColor redColor] _textAlignment:NSTextAlignmentRight];
    
}
//运费信息
- (void)createFreightView{
    _freightInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _goodsInfoView.bottom, kScreenW, [Unity countcoordinatesH:220])];
    _freightInfoView.backgroundColor = [UIColor whiteColor];
    
    UILabel * localFreightL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], 0, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"当地运费" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _localFreight = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], localFreightL.top, kScreenW-[Unity countcoordinatesW:155], localFreightL.height) _string:@"¥6.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * internationFreightL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], localFreightL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"国际运费" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _internationFreight = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], internationFreightL.top, kScreenW-[Unity countcoordinatesW:155], internationFreightL.height) _string:@"¥12.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * serveTallageL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], internationFreightL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"消费税" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _serveTallage = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], serveTallageL.top, kScreenW-[Unity countcoordinatesW:155], serveTallageL.height) _string:@"¥5.12" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * tariffL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], serveTallageL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"关税" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _tariff = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], tariffL.top, kScreenW-[Unity countcoordinatesW:155], tariffL.height) _string:@"¥4.28" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * goodsPriceL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], tariffL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"商品差价" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _goodsPrice = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], goodsPriceL.top, kScreenW-[Unity countcoordinatesW:155], goodsPriceL.height) _string:@"¥5.78" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * appreciationL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], goodsPriceL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"增值服务费" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _appreciation = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], appreciationL.top, kScreenW-[Unity countcoordinatesW:155], appreciationL.height) _string:@"¥11.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * finalSumL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], appreciationL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"尾款总额" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
    _finalSum = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], finalSumL.top, kScreenW-[Unity countcoordinatesW:155], finalSumL.height) _string:@"¥32.18" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentRight];
    
    UILabel * line = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake(0, finalSumL.bottom+3, kScreenW, 2) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentLeft];
    line.backgroundColor = [Unity getColor:@"#f5f5f5"];
    
    UILabel * actualFinalSumL = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], line.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:40]) _string:@"实付尾款" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
    _actualFinalSum = [Unity lableViewAddsuperview_superView:_freightInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], actualFinalSumL.top, kScreenW-[Unity countcoordinatesW:155], actualFinalSumL.height) _string:@"¥32.18" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:[UIColor redColor] _textAlignment:NSTextAlignmentRight];
    
}
//付款方式
- (void)paymentView{
    _paymentInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _freightInfoView.bottom+[Unity countcoordinatesH:7], kScreenW, [Unity countcoordinatesH:75])];
    _paymentInfoView.backgroundColor = [UIColor whiteColor];
    
    UILabel * paymentFsL=[Unity lableViewAddsuperview_superView:_paymentInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], 0, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"付款方式" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _paymentFs = [Unity lableViewAddsuperview_superView:_paymentInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], paymentFsL.top, kScreenW-[Unity countcoordinatesW:155], paymentFsL.height) _string:@"银联" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * createDateL = [Unity lableViewAddsuperview_superView:_paymentInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], paymentFsL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashDetails_Withdrawal_Creation_time", nil) _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _createDate = [Unity lableViewAddsuperview_superView:_paymentInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], createDateL.top, kScreenW-[Unity countcoordinatesW:155], createDateL.height) _string:@"2019.03.25 09:33:35" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
    UILabel * paymentDateL = [Unity lableViewAddsuperview_superView:_paymentInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], createDateL.bottom, [Unity countcoordinatesW:100], [Unity countcoordinatesH:25]) _string:@"付款时间" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentLeft];
    _paymentDate = [Unity lableViewAddsuperview_superView:_paymentInfoView _subViewFrame:CGRectMake([Unity countcoordinatesW:150], paymentDateL.top, kScreenW-[Unity countcoordinatesW:155], paymentDateL.height) _string:@"2019.03.25 15:22:55" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:Gray_Color _textAlignment:NSTextAlignmentRight];
    
}
- (void)loadScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self createTopView];
    [self createGoodsView];
    [self createCostView];
    [self createFreightView];
    [self paymentView];
    /*将ui添加到scrollView数组中*/
    [self.scrollView sd_addSubviews:@[_topView,_goodsInfoView,_freightInfoView,_paymentInfoView]];
    
    // scrollview自动contentsize
    [self.scrollView setupAutoContentSizeWithBottomView:_paymentInfoView bottomMargin:0];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = [Unity getColor:@"#f5f5f5"];
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
