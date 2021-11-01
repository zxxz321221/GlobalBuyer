//
//  MsgPageViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/20.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MsgPageViewController.h"
#import "MsgCell1.h"
#import "MsgCell2.h"
#import "MsgCell3.h"
#import "MsgModel1.h"
#import "MsgModel2.h"
#import "UIView+SDAutoLayout.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
@interface MsgPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)BOOL isFrist;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic , strong) NSMutableArray * activityArry;//活动消息
@property (nonatomic , strong) NSMutableArray * orderArry;//订单进度
@property (nonatomic , strong) NSMutableArray * systemArry;//系统通知
@property (nonatomic , strong) NSMutableArray * ortherArry;//其他消息
@property (nonatomic , strong) NSMutableArray * listArry;
@property (nonatomic , strong) NSArray * arr;//测试数组

@end

@implementation MsgPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFrist=false;
    
    _arr = @[@{@"title":@"1"},@{@"title":@"1"},@{@"title":@"1"}];
    [self createUI];
}
- (void)createUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-50)];
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    //没有数据时不显示cell
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = 0;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 创建一个通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center postNotificationName:@"cesuo" object:[NSString stringWithFormat:@"%d",_tag] userInfo:nil];
    if(!_isFrist){
        //第一次进入,自动加载数据
        NSLog(@"第一次进入--%d",_tag);

        _isFrist=true;
    }else{
        //不是第一次进入,不加载数据
        NSLog(@"第二次进入--%d",_tag);
    }
}
-(NSMutableArray *)activityArry{
    
    if (!_activityArry) {
        _activityArry = [[NSMutableArray alloc] init];
    }
    return _activityArry;
}
-(NSMutableArray *)orderArry{
    
    if (!_orderArry) {
        _orderArry = [[NSMutableArray alloc] init];
    }
    return _orderArry;
}
-(NSMutableArray *)systemArry{
    
    if (!_systemArry) {
        _systemArry = [[NSMutableArray alloc] init];
    }
    return _systemArry;
}
-(NSMutableArray *)ortherArry{
    
    if (!_ortherArry) {
        _ortherArry = [[NSMutableArray alloc] init];
    }
    return _ortherArry;
}
-(NSMutableArray *)listArry{
    
    if (!_listArry) {
        _listArry = [[NSMutableArray alloc] init];
    }
    return _listArry;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    /*
    //     普通版也可实现一步设置搞定高度自适应，不再推荐使用此套方法，具体参看“UITableView+SDAutoTableViewCellHeight”头文件
    //     [self.tableView startAutoCellHeightWithCellClasses:@[[DemoVC7Cell class], [DemoVC7Cell2 class]] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    //     */
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    Class currentClass = [MsgCell1 class];
    MsgCell1 *cell = nil;
    
    if (indexPath.row == 1) {
        currentClass = [MsgCell2 class];
    }
    if (indexPath.row == 2) {
        currentClass = [MsgCell3 class];
    }
    
    
    //    HomeModel *model = self.listArry[indexPath.row];
    //    if (model.imageArr.count > 1) {
    //        currentClass = [HomeCell2 class];
    //    }
    if (!cell) {
        cell = [[currentClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    //不显示多余的空Cell
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    cell.model = model;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgModel1 * model = self.arr[indexPath.row];
    Class currentClass = [MsgCell1 class];
    if (indexPath.row == 1) {
        MsgModel2 * model = self.arr[indexPath.row];
        currentClass = [MsgCell2 class];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    if (indexPath.row == 2) {
        MsgModel2 * model = self.arr[indexPath.row];
        currentClass = [MsgCell3 class];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    
    //    HomeModel *model = self.listArry[indexPath.row];
    //
    //    if (model.imageArr.count > 1) {
    //
    //        currentClass = [HomeCell2 class];
    //    }
    
    //因为cell高度不确定 tableview是总高度也不确定 因而写下下面这段代码(通过返回的每个cell高度想加 计算出 所有cell的总高度S 重新设置tableview的frame 充值 scrollView的contentSize高度)
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
