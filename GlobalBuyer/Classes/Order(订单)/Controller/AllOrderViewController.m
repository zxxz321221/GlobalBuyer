//
//  AllOrderViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "AllOrderViewController.h"
#import "ALLOrderTableViewCell.h"
#import "tableFootView.h"
#import "OrderAlertView.h"
#import "OrderDeleteView.h"
#import "OrderDetailViewController.h"//待入仓详情
#import "CloseOrderDetailViewController.h"//交易关闭详情
#import "FirstTreatDetailViewController.h"//首款待付详情
#import "TailToBePaidDetailViewController.h"//尾款待付详情
#import "ReceivingGoodsViewController.h"//待收货详情
#import "SuccessOrderDetailViewController.h"//成功的订单详情
@interface AllOrderViewController ()<UITableViewDelegate,UITableViewDataSource,TableFooterViewDelegate,orderAlertViewDelegate,orderDltViewDelegate>
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) OrderAlertView * orderAlertView;
@property (nonatomic , strong) OrderDeleteView * dltView;
@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Unity getColor:@"#e0e0e0"];
    [self creareUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)creareUI{
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight-[Unity countcoordinatesH:40]) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = FALSE;
        _tableView.showsHorizontalScrollIndicator = FALSE;
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //没有数据时不显示cell
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[tableFootView class] forHeaderFooterViewReuseIdentifier:@"cityFooterSectionID"];
        
    }
    return _tableView;
}
#pragma mark - tableView  搭理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [Unity countcoordinatesH:90];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row) {
//
//    }
    ALLOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ALLOrderTableViewCell class])];
    if (cell == nil) {
        cell = [[ALLOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ALLOrderTableViewCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        cell.delegate = self;
    return cell;
}
#pragma mark - 自定义headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:50])];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
    view.backgroundColor  = [UIColor whiteColor];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
    view.layer.masksToBounds = YES;
    view.layer.mask = maskLayer;
    [header addSubview:view];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], 0, [Unity countcoordinatesW:200], [Unity countcoordinatesH:40])];
    lab.text = @"订单编号:123154893279419";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [Unity getColor:@"#333333"];
    lab.font = [UIFont systemFontOfSize:14];
    [view addSubview:lab];
    UILabel * rightL = [[UILabel alloc]initWithFrame:CGRectMake(lab.right, 0, [Unity countcoordinatesW:80], lab.height)];
    rightL.text = @"订单状态";
    rightL.textAlignment = NSTextAlignmentRight;
    rightL.textColor = [Unity getColor:@"#b445c8"];
    rightL.font = [UIFont systemFontOfSize:14];
    [view addSubview:rightL];
    
    
    header.backgroundColor = [UIColor clearColor];
    
    
    return header;
    
}
//section 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [Unity countcoordinatesH:50];
}
#pragma mark - 自定义footerView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [Unity countcoordinatesH:95];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *footerSectionID = @"cityFooterSectionID";
    
    tableFootView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerSectionID];
    if (footerView == nil) {
        footerView = [[tableFootView alloc]initWithReuseIdentifier:footerSectionID];
    }
    [footerView configWithSection:section];
    footerView.delegate = self;
    return footerView;
}
//付款
- (void)paymentClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//取消订单
- (void)cancelOrderClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
    [self.orderAlertView showAlertView];
}
//订单详情
- (void)detailClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
    if (section == 0) {
        FirstTreatDetailViewController * ovc = [[FirstTreatDetailViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }
    if (section == 1) {
        OrderDetailViewController * ovc = [[OrderDetailViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }else if (section == 5){
        CloseOrderDetailViewController * ovc = [[CloseOrderDetailViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }
    if (section == 2) {
        TailToBePaidDetailViewController * ovc = [[TailToBePaidDetailViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }
    if (section == 3) {
        ReceivingGoodsViewController * ovc = [[ReceivingGoodsViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }
    if (section == 4) {
        SuccessOrderDetailViewController * ovc = [[SuccessOrderDetailViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
}
//查看物流
- (void)logisticsClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//验货照片
- (void)checkClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//尾款支付
- (void)tailPaymentClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//查看验货照片
- (void)ccheckImgClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//确认收货
- (void)confirmClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//配送物流信息
- (void)shippingInfoClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//删除订单
- (void)deleteOrderClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
    [self.dltView showDltView];
}
- (OrderAlertView *)orderAlertView{
    if (!_orderAlertView) {
        _orderAlertView = [OrderAlertView setOrderAlertView:self.view];
        _orderAlertView.delegate = self;
    }
    return _orderAlertView;
}
//取消订单弹出框‘确认’事件
- (void)confim:(NSString *)reason{
    NSLog(@"%@",reason);
}
- (OrderDeleteView *)dltView{
    if (!_dltView) {
        _dltView = [OrderDeleteView setOrderDeleteView:self.view];
        _dltView.delegate = self;
    }
    return _dltView;
}
//deleteView 确定删除
- (void)confirmTheDeletion{
    NSLog(@"确定");
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
