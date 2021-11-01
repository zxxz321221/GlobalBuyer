//
//  MapViewController.m
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "MapViewController.h"
#import "PYSearchViewController.h"
#import "MapSearchViewController.h"
#import "MapView.h"
#import "NavigationController.h"
@interface MapViewController ()<UISearchBarDelegate,MapViewDelegate,UITableViewDelegate,UITableViewDataSource,MapSearchViewControllerDelegate>

@property (strong, nonatomic)  UISearchBar *searchBar;
@property ( nonatomic , strong ) UIView *headerView;
@property(nonatomic,strong)UILabel *addressLa;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MapView *mapView;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,assign)CGFloat oldY;
@property (nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,strong)NSString *adderss;
@property(nonatomic,strong)NSString *addressDetail;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
}

#pragma mark 创建UI
- (void)setupUI {
    [self setNavigationBackBtn];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    [self.view addSubview:self.tableView];
}

- (MapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MapView alloc]initWithFrame:CGRectMake(0,  0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/3 * 2 )];
        _mapView.delegate = self;
        
    }
    return _mapView;
}

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        _searchBar.placeholder = NSLocalizedString(@"GlobalBuyer_Map_SearchPlace", nil);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- kNavigationBarH + kStatusBarH)  style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

#pragma mark tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.oldY == 0) {
        return [UIScreen mainScreen].bounds.size.height/3 * 2 ;
    }else{
        return  self.oldY;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.mapView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = TableViewCellDequeueInit(@"addressCellId");
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"addressCellId"];
    }
    
    if ([self.addressArr[indexPath.row] isKindOfClass:[AMapAddressComponent class]]) {
        AMapAddressComponent *addressComponent = self.addressArr[indexPath.row];
        if (self.addressArr.count>1) {
            AMapPOI *poi = self.addressArr[1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",addressComponent.district, poi.name];
            cell.detailTextLabel.text = @"";
        }
    }
    
    if ([self.addressArr[indexPath.row] isKindOfClass:[AMapPOI class]]) {
        AMapPOI *poi = self.addressArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", poi.name];
        AMapAddressComponent *addressComponent = self.addressArr[0];
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@%@%@%@",addressComponent.province,addressComponent.city,addressComponent.district, poi.address];
    }
    
    NSMutableDictionary *dict = self.selectArr[indexPath.row];
    if ([dict[@"isSelect"] boolValue]) {
        if ([cell.textLabel.text isEqualToString: @""]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.addressArr[indexPath.row] isKindOfClass:[AMapAddressComponent class]]) {
        AMapAddressComponent *addressComponent = self.addressArr[0];
        AMapPOI *poi = self.addressArr[1];
        self.addressDetail = [NSString stringWithFormat:@"%@%@",addressComponent.district, poi.name];
        [self.mapView moveMap];
    }
    
    if ([self.addressArr[indexPath.row] isKindOfClass:[AMapPOI class]]) {
        AMapPOI *poi = self.addressArr[indexPath.row];
        self.addressDetail =  [NSString stringWithFormat:@"%@", poi.address];
        [self.mapView moveMap:poi.location];
        
    }
    
    for (int i=0; i<self.selectArr.count; i++) {
        NSMutableDictionary *dict = self.selectArr[i];
        if (i==indexPath.row) {
            dict[@"isSelect"] = @YES;
        }else{
            dict[@"isSelect"] = @NO;
        }
    }
    [self.tableView reloadData];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if ([UIScreen mainScreen].bounds.size.height/3 > scrollView.contentOffset.y) {
            self.oldY = ([UIScreen mainScreen].bounds.size.height/3 * 2) - (scrollView.contentOffset.y);
            [self.tableView reloadData];
        }
        NSLog(@"--------%lf---------",scrollView.contentOffset.y);
    }
}

#pragma rightBarButtonClick
- (void)sureClick {
    [self.delegate addAddress:self.adderss addressDetail:self.addressDetail];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark searchBar代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES ] ;
    NSArray *hotSeaches = @[NSLocalizedString(@"GlobalBuyer_Map_beijing", nil), NSLocalizedString(@"GlobalBuyer_Map_shanghai", nil), NSLocalizedString(@"GlobalBuyer_Map_guangzhou", nil), NSLocalizedString(@"GlobalBuyer_Map_shenzhen", nil),
        NSLocalizedString(@"GlobalBuyer_Map_xiamen", nil),
        NSLocalizedString(@"GlobalBuyer_Map_dalian", nil),
        NSLocalizedString(@"GlobalBuyer_Map_aomen", nil),
        NSLocalizedString(@"GlobalBuyer_Map_xianggang", nil),
        NSLocalizedString(@"GlobalBuyer_Map_taiwan", nil)];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入地点", @"搜索地点") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        MapSearchViewController * mapSearchVC =  [[MapSearchViewController alloc] init];
        mapSearchVC.searchStr = searchText;
        mapSearchVC.delegate = self;
        [searchViewController.navigationController pushViewController:mapSearchVC animated:YES];
    }];
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
    searchViewController.navigationController.navigationBar.barTintColor = Main_Color;
    searchViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
    return NO;
}

#pragma MapSearchViewControllerDelegate
- (void)showInMap:(PoisModel *)poisModel {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES ] ;
    AMapGeoPoint *point = [AMapGeoPoint new];
    point.latitude = poisModel.location.latitude ;
    point.longitude = poisModel.location.longitude;
    [self.mapView showInSearch:point];
}

#pragma mark MapViewDelegate
- (void)addressArr:(NSMutableArray *)array {
    self.addressArr = array;
    AMapAddressComponent *addressComponent = self.addressArr[0];
    if (self.addressArr.count>1) {
        AMapPOI *poi = self.addressArr[1];
        self.addressDetail = [NSString stringWithFormat:@"%@%@",addressComponent.district, poi.name];
    }
    self.adderss = [NSString stringWithFormat:@"%@ %@ %@",addressComponent.province,addressComponent.city,addressComponent.district];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict;
        if (i == 0) {
             dict = [[NSMutableDictionary alloc]initWithDictionary:@{@"isSelect":@YES}];
        }else{
            dict = [[NSMutableDictionary alloc]initWithDictionary:@{@"isSelect":@NO}];
        }
        [arr addObject:dict];
       
    }
    self.selectArr  = arr;
    [self.tableView reloadData];
}

#pragma mark 初始化
- (NSMutableArray *)addressArr {
    if (_addressArr == nil) {
        _addressArr = [NSMutableArray new];
        
    }
    return _addressArr;
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}

#pragma mark view生命周期
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView.locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent ];
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
