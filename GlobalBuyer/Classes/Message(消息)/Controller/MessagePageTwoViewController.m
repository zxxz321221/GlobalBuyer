//
//  MessagePageTwoViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/24.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "MessagePageTwoViewController.h"
#import "MsgCell2.h"
#import "MsgModel2.h"
#import "UIView+SDAutoLayout.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
@interface MessagePageTwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic , strong) NSArray * arr;//测试数组

@end

@implementation MessagePageTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _arr = @[@{@"title":@"1"},@{@"title":@"1"},@{@"title":@"1"}];
    NSLog(@"2");
    [self createUI];
}
- (void)createUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-NavBarHeight-40-49)];
    self.tableView.backgroundColor = [Unity getColor:@"#f0f0f0"];
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
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    /*
    //     普通版也可实现一步设置搞定高度自适应，不再推荐使用此套方法，具体参看“UITableView+SDAutoTableViewCellHeight”头文件
    //     [self.tableView startAutoCellHeightWithCellClasses:@[[DemoVC7Cell class], [DemoVC7Cell2 class]] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    //     */
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    Class currentClass = [MsgCell2 class];
    MsgCell2 *cell = nil;

    
    
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
    MsgModel2 * model = self.arr[indexPath.row];
    Class currentClass = [MsgCell2 class];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
