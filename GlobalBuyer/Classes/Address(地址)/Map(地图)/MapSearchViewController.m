//
//  MapSearchViewController.m
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "MapSearchViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapView.h"
@interface MapSearchViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)NSMutableArray *dataSoucer;
@property (nonatomic, strong)AMapSearchAPI *search;
@property(nonatomic, strong)UIView *bootomView;
@end

@implementation MapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = self.searchStr;
    request.requireExtension    = YES;
    [self.search AMapPOIKeywordsSearch:request];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI
- (void)setupUI {
    [self setNavigationBackBtn];
    self.title = NSLocalizedString(@"GlobalBuyer_Map_PlaceRst", nil);
    [self.view addSubview:self.tabelView];
}

- (UITableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -kNavigationBarH + kStatusBarH) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.tableFooterView = [[UIView alloc]init];
    }
    return _tabelView;
}

#pragma mark 初始化数据
- (NSMutableArray *)dataSoucer {
    if (_dataSoucer == nil) {
        _dataSoucer = [NSMutableArray new];
    }
    return _dataSoucer;
}

#pragma mark AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
        return;
    }
    for (AMapPOI *poi in response.pois) {
        [self.dataSoucer addObject:poi];
    }
    [self.tabelView reloadData];
}

#pragma mark tabelView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoucer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = TableViewCellDequeueInit(@"mapCell");
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mapCell"];
    }
    AMapPOI *poi = self.dataSoucer[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",poi.province,poi.city,poi.district,poi.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.delegate showInMap:self.dataSoucer[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
