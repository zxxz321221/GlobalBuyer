//
//  Help_CustomerViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/21.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "Help_CustomerViewController.h"
#import "HelpCell.h"
#import "HelpCell1.h"
#import "ActivityWebViewController.h"
#import "ServiceHotlineViewController.h"
#import "ServiceViewController.h"
@interface Help_CustomerViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,HelpCell1Delegate>
{
    BOOL isActive;
    UIView *header ;
    NSArray * arr;
}
@property (nonatomic,retain) UISearchController *searchController;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView * bottomView;
@property(nonatomic,assign) CGFloat width;

@property (nonatomic , strong) UIView * maskView;
@end

@implementation Help_CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isActive = NO;
    arr = @[@{@"name":@"新手指南",@"list":@[@"购物流程",@"实名认证",@"买前必读",@"常见问题"]},@{@"name":@"物流问题",@"list":@[@"配送方式",@"关税说明",@"配送要求及费用",@"增值服务"]},@{@"name":@"支付问题",@"list":@[@"支付方式",@"付款失败",@"钱包使用说明",@"关于退款"]},@{@"name":@"订单问题",@"list":@[@"修改订单",@"取消订单",@"订单被取消",@"发票服务"]},@{@"name":@"优惠券",@"list":@[@"优惠券获取途径",@"优惠券使用规则",@"优惠券使用限制",@"下单忘记使用优惠券"]},@{@"name":@"售后问题",@"list":@[@"关于换货",@"退货政策",@"退货流程",@"超大商品服务细则"]},@{@"name":@"会员制度",@"list":@[@"超级会员",@"会员等级",@"会员特权",@"会员成长值"]},@{@"name":@"服务政策",@"list":@[@"服务协议",@"商务合作",@"隐私政策",@"意见公告"]}];
    [self creareUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"帮助与客服";
    self.navigationController.navigationBar.translucent=YES;
    self.view.backgroundColor = [Unity getColor:@"#f0f0f0"];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREEN_WIDTH / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)creareUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.maskView];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight,kScreenW ,kScreenH-NavBarHeight-[Unity countcoordinatesH:80]) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if (@available(iOS 11,*)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
//        _tableView.scrollEnabled=NO;
        //隐藏tableViewCell下划线 隐藏所有分割线
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        
        // 添加 searchbar 到 headerview
        _tableView.tableHeaderView = self.searchController.searchBar;
        //#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
        self.definesPresentationContext=YES;
    }
    return _tableView;
}
- (UISearchController *)searchController{
    if (!_searchController) {
        //创建UISearchController
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        //设置代理
        _searchController.delegate= self;
        _searchController.searchBar.delegate = self;
        _searchController.searchResultsUpdater = self;
        
        //去掉上下黑线
        UISearchBar *searchBar = _searchController.searchBar;
        UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor = [Unity getColor:@"#f0f0f0"].CGColor;
        barImageView.layer.borderWidth = 1;
        
        //包着搜索框外层的颜色
        
        _searchController.searchBar.barTintColor = [Unity getColor:@"#f0f0f0"];
        
        //提醒字眼
        _searchController.searchBar.placeholder= @"有问题搜索一下~";
        //搜索框光标和按钮取消的文字颜色
        _searchController.searchBar.tintColor = [Unity getColor:@"#666666"];
        
        
        //设置UISearchController的显示属性，以下3个属性默认为YES
        //搜索时，背景变暗色
        _searchController.dimsBackgroundDuringPresentation = NO;
        //搜索时，背景变模糊
//        self.searchController.obscuresBackgroundDuringPresentation = YES;
        //点击搜索的时候,是否隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = NO;
        
        //位置
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 60.0);
        _searchController.searchBar.layer.cornerRadius = _searchController.searchBar.height/2;
        
        if(@available(iOS 11.0, *)){

            UITextField *textField = [_searchController.searchBar valueForKey:@"searchField"];

            [textField sizeToFit];

            //记录一下这个时候的宽度

            _width= textField.frame.size.width;

            [_searchController.searchBar setPositionAdjustment:UIOffsetMake((_searchController.searchBar.width-_width-20)/2.0,0)forSearchBarIcon:UISearchBarIconSearch];
            UIOffset offset = {(_searchController.searchBar.width-_width)/2+10.0,0};
            
            _searchController.searchBar.searchTextPositionAdjustment = offset;

        }
    }
    return _searchController;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-[Unity countcoordinatesH:80], kScreenW, [Unity countcoordinatesH:80])];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        line.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_bottomView addSubview:line];
        NSArray * arr = @[@{@"icon":@"咨询电话",@"time":@"(周一至周五9:00-18:00)"},@{@"icon":@"在线客服",@"time":@"(9:00-23:30)"}];
        for (int i=0; i<2; i++) {
            UIButton * btn = [Unity buttonAddsuperview_superView:_bottomView _subViewFrame:CGRectMake(i*(kScreenW/2), 0, kScreenW/2, [Unity countcoordinatesH:80]) _tag:self _action:@selector(bottomClick:) _string:@"" _imageName:@""];
            btn.tag = 2000+i;
            UIImageView * icon = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake((btn.width-[Unity countcoordinatesH:30])/2, [Unity countcoordinatesH:5], [Unity countcoordinatesH:30], [Unity countcoordinatesH:30]) _imageName:[arr[i]objectForKey:@"icon"] _backgroundColor:nil];
            UILabel * name = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(0, icon.bottom+[Unity countcoordinatesH:5], btn.width, [Unity countcoordinatesH:20]) _string:[arr[i]objectForKey:@"icon"] _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
            UILabel * time = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(0, name.bottom, name.width, name.height) _string:[arr[i]objectForKey:@"time"] _lableFont:[UIFont systemFontOfSize:12] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
        }
    }
    return _bottomView;
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight+60, kScreenW, kScreenH-(NavBarHeight+60))];
        _maskView.backgroundColor = [UIColor whiteColor];
        _maskView.alpha = 0.5;
        _maskView.hidden=YES;
    }
    return _maskView;
}
//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //    //修改"Cancle"退出字眼,这样修改,按钮一开始就直接出现,而不是搜索的时候再出现
    //    searchController.searchBar.showsCancelButton = YES;
    //    for(id sousuo in [searchController.searchBar subviews])
    //    {
    //
    //        for (id zz in [sousuo subviews])
    //        {
    //
    //            if([zz isKindOfClass:[UIButton class]]){
    //                UIButton *btn = (UIButton *)zz;
    //                [btn setTitle:@"搜索" forState:UIControlStateNormal];
    //                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //            }
    //
    //
    //        }
    //    }
    
    NSLog(@"updateSearchResultsForSearchController");
//    NSString *searchString = [self.searchController.searchBar text];
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    if (self.searchListArry!= nil) {
//        [self.searchListArry removeAllObjects];
//    }
//    //过滤数据
//    self.searchListArry= [NSMutableArray arrayWithArray:[self.dataListArry filteredArrayUsingPredicate:preicate]];
//    //刷新表格
//    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    self.maskView.hidden=YES;
    isActive = YES;
    [self.tableView reloadData];

}

#pragma mark - UISearchControllerDelegate代理
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController1");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    //搜索框获取焦点的时候
//    [self.tableView reloadData];
    
    NSLog(@"didPresentSearchController2");
    self.maskView.hidden=NO;
    
    
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController3");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController4");
    self.maskView.hidden=YES;
    isActive = NO;
    //点击取消的时候
    if(@available(iOS 11.0, *)){
        
        if(!self.searchController.searchBar.text.length) {
            
            [self.searchController.searchBar setPositionAdjustment:UIOffsetMake((self.searchController.searchBar.width-_width-20)/2.0,0) forSearchBarIcon:UISearchBarIconSearch];
            UIOffset offset = {(_searchController.searchBar.width-_width)/2+10.0,0};
            
            _searchController.searchBar.searchTextPositionAdjustment = offset;
            
        }
        
    }
    [self.tableView reloadData];
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController5");

}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(@available(iOS 11.0, *)){

        [self.searchController.searchBar setPositionAdjustment:UIOffsetMake(0,0)forSearchBarIcon:UISearchBarIconSearch];
        UIOffset offset = {20.0,0};
        
        _searchController.searchBar.searchTextPositionAdjustment = offset;

    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if(@available(iOS 11.0, *)){

        if(!self.searchController.searchBar.text.length) {

            [self.searchController.searchBar setPositionAdjustment:UIOffsetMake((self.searchController.searchBar.width-_width-20)/2.0,0) forSearchBarIcon:UISearchBarIconSearch];
            UIOffset offset = {(_searchController.searchBar.width-_width)/2+10.0,0};
            
            _searchController.searchBar.searchTextPositionAdjustment = offset;

        }

    }
}
#pragma mark - tableView  搭理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isActive) {
        return 9;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isActive) {
        if (indexPath.row == 0) {
            return [Unity countcoordinatesH:262];
        }else{
            return [Unity countcoordinatesH:96];
        }
    }
    return [Unity countcoordinatesH:30];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isActive) {
        if (indexPath.row == 0) {
            HelpCell1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HelpCell1 class])];
            if (cell == nil) {
                cell = [[HelpCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HelpCell1 class])];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else{
            static NSString *CellIdentifier = @"Cell";
            HelpCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
            if (cell == nil) {
                cell = [[HelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configWithData:arr[indexPath.row-1]];
            //    cell.delegate = self;
            return cell;
        }
    }else{
        static NSString *flag=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        [cell.textLabel setText:@"1"];
        return cell;
    }
    
}
#pragma mark - 自定义headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    header = [UIView new];
    header.backgroundColor = [Unity getColor:@"#f0f0f0"];
    return header;
}
//section 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

#pragma mark - 自定义footerView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!isActive) {
        return [Unity countcoordinatesH:15];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [UIView new];
    footer.backgroundColor = [Unity getColor:@"#f0f0f0"];
    return footer;
}
- (void)headerButtonClick:(NSInteger)index{
    
}
- (void)bottomClick:(UIButton *)sender{
    if (sender.tag == 2000) {
        ServiceHotlineViewController *serviceHotlineVC = [[ServiceHotlineViewController alloc]init];
        serviceHotlineVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:serviceHotlineVC animated:YES];
    }else{
        [self Service];
    }
}
- (void)Service
{
    ServiceViewController * svc = [[ServiceViewController alloc]init];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
//    ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
//    // 获得当前iPhone使用的语言
//    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
//    NSLog(@"当前使用的语言：%@",currentLanguage);
//    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else if([currentLanguage isEqualToString:@"en"]){
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else{
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }
//    webService.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webService animated:YES];
    
    //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    //    [chatViewManager pushMQChatViewControllerInViewController:self];
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
