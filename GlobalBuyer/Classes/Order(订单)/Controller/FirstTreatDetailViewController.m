//
//  FirstTreatDetailViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/15.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "FirstTreatDetailViewController.h"
#import "FirstTreatCell.h"
#import "StorageCell.h"
#import "TailToBePaidCell.h"
#import "GoodsToBeReceivedCell.h"
@interface FirstTreatDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableDictionary *dic;//创建一个字典进行判断收缩还是展开
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIView * navView;
@property (nonatomic , strong) UILabel * navLabel;
@property (nonatomic , strong) UIButton * leftBtn;
@property (nonatomic , strong) UIView * topView;
@property (nonatomic , strong) UIView * addressView;
@property (nonatomic , strong) UIView * numberView;
@property (nonatomic , strong) UIView * goodsView;
@property (nonatomic , strong) UIView * firstView;
@property (nonatomic , strong) UIView * infoView;
@property (nonatomic , strong) UIView * orderProcessView;
@property (nonatomic , strong) UIView * bottomView;
//首款待付section
@property (nonatomic , strong) UIImageView * firstImg;
@property (nonatomic , strong) UIView * firstLine;
@property (nonatomic , strong) UILabel * firstL;
@property (nonatomic , strong) UILabel * firstTime;
//待入仓section
@property (nonatomic , strong) UIImageView * storageImg;
@property (nonatomic , strong) UIView * storageTopLine;
@property (nonatomic , strong) UIView * storageLine;
@property (nonatomic , strong) UILabel * storageL;
@property (nonatomic , strong) UILabel * storageTime;
//尾款待付
@property (nonatomic , strong) UIImageView * tailImg;
@property (nonatomic , strong) UIView * tailTopLine;
@property (nonatomic , strong) UIView * tailLine;
@property (nonatomic , strong) UILabel * tailL;
@property (nonatomic , strong) UILabel * tailTime;
//待收货
@property (nonatomic , strong) UIImageView * goodsImg;
@property (nonatomic , strong) UIView * goodsLine;
@property (nonatomic , strong) UILabel * goodsL;
@property (nonatomic , strong) UILabel * goodsTime;
//topView UI
@property (nonatomic , strong) UILabel * statusL;//状态 待入仓等
@property (nonatomic , strong) UILabel * behaviorL;//状态  采购中等
@property (nonatomic , strong) UIImageView * statusImg;
//addressView UI
@property (nonatomic , strong) UILabel * nameL;//姓名
@property (nonatomic , strong) UILabel * mobileL;//电话
@property (nonatomic , strong) UILabel * addressL;//地址
@property (nonatomic , strong) UIImageView * addressImg;
//firstView UI
@property (nonatomic , strong) UILabel * orderNumL;//订单编号文字
@property (nonatomic , strong) UILabel * orderNum;//订单编号
@property (nonatomic , strong) UILabel * line0;
@property (nonatomic , strong) UILabel * goodsTotalPrice;//商品总价
@property (nonatomic , strong) UILabel * exciseTax;//消费税
@property (nonatomic , strong) UILabel * serviceCharge;//服务费
@property (nonatomic , strong) UILabel * totalFirstAmount;//首款总额
@property (nonatomic , strong) UILabel * coupon;//优惠券
@property (nonatomic , strong) UILabel * line1;
@property (nonatomic , strong) UILabel * initialPayment;//首款待付
@property (nonatomic , strong) UILabel * markL;//首款待付下方备注信息
//infoView ui
@property (nonatomic , strong) UILabel * creationTime;//创建时间

@property (nonatomic , strong) UIButton * cancelBtn;
@property (nonatomic , strong) UIButton * paymentBtn;


@end

@implementation FirstTreatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dic = [NSMutableDictionary dictionary];
    NSDictionary * dict = @{@"1":@"1",@"2":@"0",@"3":@"0",@"4":@"0"};
    dic = [dict mutableCopy];
    [self creareUI];
}
- (void)creareUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.navLabel];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.bottomView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = [Unity getColor:@"#e0e0e0"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-[Unity countcoordinatesH:50]) style:UITableViewStyleGrouped];
        self.extendedLayoutIncludesOpaqueBars = YES;
        
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        //去除所有cell分割线
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-[Unity countcoordinatesH:50], kScreenW, [Unity countcoordinatesH:50])];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:1])];
        line.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_bottomView addSubview:line];
        [_bottomView addSubview:self.cancelBtn];
        [_bottomView addSubview:self.paymentBtn];
    }
    return _bottomView;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, NavBarHeight)];
        _navView.backgroundColor = Main_Color;
        _navView.alpha = 0.01;
    }
    return _navView;
}
- (UILabel *)navLabel{
    if (!_navLabel) {
        _navLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-100)/2, StatusBarHeight, 100, 44)];
        _navLabel.text = @"订单详情";
        _navLabel.textColor = [UIColor whiteColor];
        _navLabel.textAlignment = NSTextAlignmentCenter;
        _navLabel.font = [UIFont systemFontOfSize:17];
    }
    return _navLabel;
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, StatusBarHeight+10, 24, 24)];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 5;
}
//section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [Unity countcoordinatesH:562]+NavBarHeight+[Unity countcoordinatesH:90];
    }
    return [Unity countcoordinatesH:40];
}
//sectionview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    if (section == 0) {
        view.frame = CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:772]+NavBarHeight);
        [view addSubview:self.topView];
        [view addSubview:self.addressView];
        [view addSubview:self.numberView];
        [view addSubview:self.goodsView];
        [view addSubview:self.firstView];
        [view addSubview:self.infoView];
        [view addSubview:self.orderProcessView];
    }else if(section == 1){
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:40])];
        view.backgroundColor = [UIColor whiteColor];
        self.firstLine = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], [Unity countcoordinatesH:20], [Unity countcoordinatesW:2], [Unity countcoordinatesH:20])];
        self.firstLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [view addSubview:self.firstLine];
        self.firstImg = [Unity imageviewAddsuperview_superView:view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:13], [Unity countcoordinatesW:14], [Unity countcoordinatesH:14]) _imageName:@"进度" _backgroundColor:nil];
        self.firstL = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(self.firstImg.right+[Unity countcoordinatesW:15], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:20]) _string:@"首款待付" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
        self.firstTime = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(kScreenW/2, self.firstL.top, kScreenW/2-[Unity countcoordinatesW:10], [Unity countcoordinatesH:20]) _string:@"2019.09.09 18.00.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
    }else if (section == 2){
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:40])];
        view.backgroundColor = [UIColor whiteColor];
        self.storageTopLine = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], 0, [Unity countcoordinatesW:2], [Unity countcoordinatesH:20])];
        self.storageTopLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [view addSubview:self.storageTopLine];
        self.storageLine = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], [Unity countcoordinatesH:20], [Unity countcoordinatesW:2], [Unity countcoordinatesH:20])];
        self.storageLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [view addSubview:self.storageLine];
        self.storageImg = [Unity imageviewAddsuperview_superView:view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:13], [Unity countcoordinatesW:14], [Unity countcoordinatesH:14]) _imageName:@"进度灰" _backgroundColor:nil];
        
        self.storageL = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(self.storageImg.right+[Unity countcoordinatesW:15], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:20]) _string:@"待入仓" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
        self.storageTime = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(kScreenW/2, self.storageL.top, kScreenW/2-[Unity countcoordinatesW:10], [Unity countcoordinatesH:20]) _string:@"2019.09.09 18.00.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
    }else if (section == 3){
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:40])];
        view.backgroundColor = [UIColor whiteColor];
        self.tailTopLine = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], 0, [Unity countcoordinatesW:2], [Unity countcoordinatesH:20])];
        self.tailTopLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [view addSubview:self.tailTopLine];
        self.tailLine = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16],  [Unity countcoordinatesH:20], [Unity countcoordinatesW:2], [Unity countcoordinatesH:20])];
        self.tailLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [view addSubview:self.tailLine];
        self.tailImg = [Unity imageviewAddsuperview_superView:view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:13], [Unity countcoordinatesW:14], [Unity countcoordinatesH:14]) _imageName:@"进度灰" _backgroundColor:nil];
        self.tailL = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(self.tailImg.right+[Unity countcoordinatesW:15], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:20]) _string:@"尾款待付" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
        self.tailTime = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(kScreenW/2, self.tailL.top, kScreenW/2-[Unity countcoordinatesW:10], [Unity countcoordinatesH:20]) _string:@"2019.09.09 18.00.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
    }else{
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:40])];
        view.backgroundColor = [UIColor whiteColor];
        self.goodsLine = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], 0, [Unity countcoordinatesW:2], [Unity countcoordinatesH:20])];
        self.goodsLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [view addSubview:self.goodsLine];
        self.goodsImg = [Unity imageviewAddsuperview_superView:view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:13], [Unity countcoordinatesW:14], [Unity countcoordinatesH:14]) _imageName:@"进度灰" _backgroundColor:nil];
        self.goodsL = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(self.goodsImg.right+[Unity countcoordinatesW:15], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:20]) _string:@"待收货" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
        self.goodsTime = [Unity lableViewAddsuperview_superView:view _subViewFrame:CGRectMake(kScreenW/2, self.goodsL.top, kScreenW/2-[Unity countcoordinatesW:10], [Unity countcoordinatesH:20]) _string:@"2019.09.09 18.00.00" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
    }
    //创建一个手势进行点击，这里可以换成button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
    view.tag = 300 + section;
    [view addGestureRecognizer:tap];
    return view;
}

- (void)action_tap:(UIGestureRecognizer *)tap{
    NSLog(@"点击的是 %ld",tap.view.tag-300);
    if (tap.view.tag-300>0 && tap.view.tag-300<5) {
        NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 300];
        if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
//            [dic setObject:@"1" forKey:str];
            dic[str] = @"1";
        }else{//反之关闭cell
//            [dic setObject:@"0" forKey:str];
            dic[str] = @"0";
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]]withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    if (section>0 && section<5) {
        if ([dic[string] integerValue] == 1 ) {  //打开cell返回数组的count
            //        NSArray *array = [NSArray arrayWithArray:dataArray[section]];
            return 1;
        }else{
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return [Unity countcoordinatesH:150];
    }else if (indexPath.section == 2){
        return [Unity countcoordinatesH:300];
    }else if (indexPath.section == 3){
        return [Unity countcoordinatesH:60];
    }else {
        return [Unity countcoordinatesH:90];
    }
    //    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        FirstTreatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FirstTreatCell class])];
        if (cell == nil) {
            cell = [[FirstTreatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FirstTreatCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){
        StorageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StorageCell class])];
        if (cell == nil) {
            cell = [[StorageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([StorageCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 3){
        TailToBePaidCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TailToBePaidCell class])];
        if (cell == nil) {
            cell = [[TailToBePaidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TailToBePaidCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
        return cell;
    }else{
        GoodsToBeReceivedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsToBeReceivedCell class])];
        if (cell == nil) {
            cell = [[GoodsToBeReceivedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GoodsToBeReceivedCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
        return cell;
    }
}
#pragma mark  --topView--
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, NavBarHeight+[Unity countcoordinatesH:110])];
        UILabel * backLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, kScreenW, NavBarHeight+[Unity countcoordinatesH:110])];
        CAGradientLayer *layerG = [CAGradientLayer new];
        layerG.colors=@[(__bridge id)[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
        layerG.startPoint = CGPointMake(0.5, 0);
        layerG.endPoint = CGPointMake(0.5, 1);
        layerG.frame = backLabel.bounds;
        [backLabel.layer addSublayer:layerG];
        [_topView addSubview:backLabel];
        
        [_topView addSubview:self.statusL];
        [_topView addSubview:self.behaviorL];
        [_topView addSubview:self.statusImg];
    }
    return _topView;
}
- (UILabel *)statusL{
    if (!_statusL) {
        _statusL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], NavBarHeight+[Unity countcoordinatesH:25], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20])];
        _statusL.text = @"首款待付";
        _statusL.font = [UIFont systemFontOfSize:20];
        _statusL.textColor = [UIColor whiteColor];
        _statusL.textAlignment = NSTextAlignmentLeft;
    }
    return _statusL;
}
- (UILabel *)behaviorL{
    if (!_behaviorL) {
        _behaviorL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], _statusL.bottom+[Unity countcoordinatesH:20], [Unity countcoordinatesW:180], [Unity countcoordinatesH:20])];
        _behaviorL.text = @"剩23小时59分59秒自动关闭";
        _behaviorL.font = [UIFont systemFontOfSize:15];
        _behaviorL.textColor = [UIColor whiteColor];
        _behaviorL.textAlignment = NSTextAlignmentLeft;
    }
    return _behaviorL;
}
- (UIImageView *)statusImg{
    if (!_statusImg) {
        _statusImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:105], NavBarHeight+[Unity countcoordinatesH:15], [Unity countcoordinatesW:85], [Unity countcoordinatesH:80])];
        _statusImg.image = [UIImage imageNamed:@"待付尾款"];
    }
    return _statusImg;
}
#pragma mark  --addressView--
- (UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom, kScreenW, [Unity countcoordinatesH:80])];
        _addressView.backgroundColor = [UIColor whiteColor];
        
        [_addressView addSubview:self.addressImg];
        [_addressView addSubview:self.nameL];
        [_addressView addSubview:self.mobileL];
        [_addressView addSubview:self.addressL];
    }
    return _addressView;
}
- (UIImageView *)addressImg{
    if (!_addressImg) {
        _addressImg = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], [Unity countcoordinatesW:40], [Unity countcoordinatesH:40])];
        _addressImg.image = [UIImage imageNamed:@"地址"];
    }
    return _addressImg;
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(_addressImg.right+[Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20])];
        _nameL.text = @"尼古拉斯";
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.textColor = [Unity getColor:@"#333333"];
        _nameL.font = [UIFont systemFontOfSize:15];
        [_nameL sizeToFit];
    }
    return _nameL;
}
- (UILabel *)mobileL{
    if (!_mobileL) {
        _mobileL = [[UILabel alloc]initWithFrame:CGRectMake(_nameL.right+[Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20])];
        _mobileL.text = @"15888888888";
        _mobileL.textAlignment = NSTextAlignmentLeft;
        _mobileL.textColor = [Unity getColor:@"#999999"];
        _mobileL.font = [UIFont systemFontOfSize:15];
        [_mobileL sizeToFit];
    }
    return _mobileL;
}
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], _nameL.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:70], [Unity countcoordinatesH:40])];
        _addressL.text = @"辽宁省大连市沙河口区金玉星海533-3号2单元701室";
        _addressL.textAlignment = NSTextAlignmentLeft;
        _addressL.textColor = [Unity getColor:@"#333333"];
        _addressL.font = [UIFont systemFontOfSize:15];
        _addressL.numberOfLines = 0;
    }
    return _addressL;
}
- (UIView *)numberView{
    if (!_numberView) {
        _numberView =[[UIView alloc]initWithFrame:CGRectMake(0, _addressView.bottom+[Unity countcoordinatesH:10], kScreenW, [Unity countcoordinatesH:41])];
        _numberView.backgroundColor = [UIColor whiteColor];
        [_numberView addSubview:self.orderNumL];
        [_numberView addSubview:self.orderNum];
        [_numberView addSubview:self.line0];
    }
    return _numberView;
}
- (UIView *)goodsView{
    if (!_goodsView) {
        _goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, _numberView.bottom, kScreenW, [Unity countcoordinatesH:90])];
        _goodsView.backgroundColor = [UIColor whiteColor];
        for (int i=0; i<1; i++) {
            UIButton * btn = [Unity buttonAddsuperview_superView:_goodsView _subViewFrame:CGRectMake(0, i*[Unity countcoordinatesH:90], kScreenW, [Unity countcoordinatesH:90]) _tag:self _action:@selector(goodsClick:) _string:@"" _imageName:@""];
            btn.tag = 1000+i;
            UIImageView * goodsIcon = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:70]) _imageName:@"" _backgroundColor:[UIColor redColor]];
            goodsIcon.layer.cornerRadius = 8;
            goodsIcon.layer.masksToBounds = YES;
            UILabel * goodsTitle = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:90], [Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:130], [Unity countcoordinatesH:40]) _string:@"创意兔子硅胶小夜灯英文喂奶睡眠拍拍插电护眼卧室床头灯少..." _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
            goodsTitle.numberOfLines = 0;
            UILabel * goodsNum = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW- [Unity countcoordinatesW:30], goodsTitle.top, [Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"X2" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
            UILabel * goodsPrice = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW - [Unity countcoordinatesW:110], goodsNum.bottom+[Unity countcoordinatesH:40], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]) _string:@"¥350.00" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
            goodsPrice.backgroundColor = [UIColor clearColor];
        }
    }
    return _goodsView;
}
#pragma mark  --firstView--
- (UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc]initWithFrame:CGRectMake(0, _goodsView.bottom, kScreenW, [Unity countcoordinatesH:221])];
        _firstView.backgroundColor = [UIColor whiteColor];
        
        NSArray * arr =@[@"商品总价",@"消费税",@"服务费",@"首款总额",@"优惠券"];
        for (int i=0; i<5; i++) {
            UILabel * label = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], (i+1)*[Unity countcoordinatesH:10]+i*[Unity countcoordinatesH:20], [Unity countcoordinatesH:80], [Unity countcoordinatesH:20]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
            if (i>=3) {
                label.textColor = [Unity getColor:@"#333333"];
            }
        }
        _goodsTotalPrice = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"¥2840.00" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        _exciseTax = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], _goodsTotalPrice.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"¥9.31" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        _serviceCharge = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], _exciseTax.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"¥7.00" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        _totalFirstAmount = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], _serviceCharge.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"¥2863.31" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
        _coupon = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], _totalFirstAmount.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"-¥7.00" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
        UILabel * line = [[UILabel  alloc]initWithFrame:CGRectMake(0, _coupon.bottom+[Unity countcoordinatesH:10], kScreenW, [Unity countcoordinatesH:1])];
        line.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_firstView addSubview:line];
        UILabel * firstPrice = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], line.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]) _string:@"首款待付" _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _initialPayment = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], firstPrice.top, [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"¥2856.31" _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[Unity getColor:@"#d00000"] _textAlignment:NSTextAlignmentRight];
        _markL = [Unity lableViewAddsuperview_superView:_firstView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _initialPayment.bottom, kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"(含消费税¥9.31含服务费¥0.00)" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#d00000"] _textAlignment:NSTextAlignmentRight];
        
    }
    return _firstView;
}

- (UILabel *)orderNumL{
    if (!_orderNumL) {
        _orderNumL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], 0, [Unity countcoordinatesW:80], [Unity countcoordinatesH:40])];
        _orderNumL.text = @"订单编号";
        _orderNumL.textAlignment = NSTextAlignmentLeft;
        _orderNumL.textColor = [Unity getColor:@"#333333"];
        _orderNumL.font = [UIFont systemFontOfSize:15];
    }
    return _orderNumL;
}
- (UILabel *)orderNum{
    if (!_orderNum) {
        _orderNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], 0, [Unity countcoordinatesW:150], [Unity countcoordinatesH:40])];
        _orderNum.text = @"Y123042230523";
        _orderNum.textAlignment = NSTextAlignmentRight;
        _orderNum.textColor = [Unity getColor:@"#333333"];
        _orderNum.font = [UIFont systemFontOfSize:15];
    }
    return _orderNum;
}
- (UILabel *)line0{
    if (!_line0) {
        _line0 = [[UILabel alloc]initWithFrame:CGRectMake(0, _orderNumL.bottom, kScreenW, [Unity countcoordinatesH:1])];
        _line0.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _line0;
}
#pragma mark  --infoView--
- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, _firstView.bottom+[Unity countcoordinatesH:10], kScreenW, [Unity countcoordinatesH:40])];
        _infoView.backgroundColor = [UIColor whiteColor];
        
        UILabel * label = [Unity lableViewAddsuperview_superView:_infoView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:110], [Unity countcoordinatesH:20]) _string:@"创建时间" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
            label.backgroundColor = [UIColor clearColor];

        _creationTime = [Unity lableViewAddsuperview_superView:_infoView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"2019.05.13 13:00:00" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        
    }
    return _infoView;
}
- (UIView *)orderProcessView{
    if (!_orderProcessView) {
        _orderProcessView = [[UIView alloc]initWithFrame:CGRectMake(0, _infoView.bottom+[Unity countcoordinatesH:10], kScreenW, [Unity countcoordinatesH:40])];
        _orderProcessView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [Unity lableViewAddsuperview_superView:_orderProcessView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], 0, kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]) _string:@"订单流程" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        label.backgroundColor = [UIColor clearColor];
    }
    return _orderProcessView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat maxAlphaOffset = NavBarHeight+[Unity countcoordinatesH:110];
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset/maxAlphaOffset;
    if (alpha<=0) {
        alpha = 0;
    }else if(alpha >=0.99){
        alpha = 0.99;
    }
    _navView.alpha = alpha;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:160], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = [[Unity getColor:@"#333333"] CGColor];
        _cancelBtn.layer.borderWidth = 1.0f;
        [_cancelBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = [Unity countcoordinatesH:15];
        _cancelBtn.layer.masksToBounds=YES;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _cancelBtn;
}
- (UIButton *)paymentBtn{
    if (!_paymentBtn) {
        _paymentBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:80], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_paymentBtn addTarget:self action:@selector(paymentClick) forControlEvents:UIControlEventTouchUpInside];
        _paymentBtn.backgroundColor = [Unity getColor:@"#b445c8"];
        [_paymentBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_paymentBtn setTitleColor:[Unity getColor:@"#ffffff"] forState:UIControlStateNormal];
        _paymentBtn.layer.cornerRadius = [Unity countcoordinatesH:15];
        _paymentBtn.layer.masksToBounds=YES;
        _paymentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _paymentBtn;
}
- (void)cancelClick{
    NSLog(@"删除订单");
}
- (void)paymentClick{
    NSLog(@"付款");
}
- (void)goodsClick:(UIButton *)btn{
    NSLog(@"%ld",btn.tag-1000);
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
