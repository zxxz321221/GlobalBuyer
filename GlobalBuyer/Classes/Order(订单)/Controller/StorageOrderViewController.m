//
//  StorageOrderViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "StorageOrderViewController.h"
#import "ALLOrderTableViewCell.h"
#import "StorageOrderFooterView.h"
@interface StorageOrderViewController ()<UITableViewDelegate,UITableViewDataSource,StorageFooterViewDelegate>
@property (nonatomic , strong) UITableView * tableView;

@end

@implementation StorageOrderViewController

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
        [_tableView registerClass:[StorageOrderFooterView class] forHeaderFooterViewReuseIdentifier:@"cityFooterSectionID"];
        
    }
    return _tableView;
}
#pragma mark - tableView  搭理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [Unity countcoordinatesH:90];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        
    }
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
    rightL.text = @"待入仓";
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
    
    StorageOrderFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerSectionID];
    if (footerView == nil) {
        footerView = [[StorageOrderFooterView alloc]initWithReuseIdentifier:footerSectionID];
    }
    [footerView configWithSection:section];
    footerView.delegate = self;
    return footerView;
}
//订单详情
- (void)detailClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//查看物流
- (void)logisticsClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
}
//验货照片
- (void)checkClick:(NSInteger)section{
    NSLog(@"点击了第%ld个模型",(long)section);
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
