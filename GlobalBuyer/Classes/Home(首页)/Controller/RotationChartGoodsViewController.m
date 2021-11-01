//
//  RotationChartGoodsViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/12/5.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "RotationChartGoodsViewController.h"
#import "NewSearchCollectionViewCell.h"
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"
@interface RotationChartGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *allDataSource;
@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation RotationChartGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self downloadMoneytype];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSMutableArray *)allDataSource{
    if (_allDataSource == nil) {
        _allDataSource = [[NSMutableArray alloc]init];
    }
    return _allDataSource;
}

- (NSMutableArray *)moneytypeArr
{
    if (_moneytypeArr == nil) {
        _moneytypeArr = [[NSMutableArray alloc]init];
    }
    return _moneytypeArr;
}

//下载汇率
- (void)downloadMoneytype {
    NSDictionary *param = @{@"api_id":API_ID,@"api_token":TOKEN};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:moneyTypeApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.moneytypeArr removeAllObjects];
        NSDictionary *dict = responseObject[@"data"];
        NSArray *fromArr = dict[@"from"];
        NSArray *toArr = dict[@"to"];
        for (int i = 0 ; i < fromArr.count; i++) {
            [self.moneytypeArr addObject:fromArr[i]];
        }
        for (int j = 0 ; j < toArr.count; j++) {
            [self.moneytypeArr addObject:toArr[j]];
        }
        [self downData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downData{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;

    [manager GET:self.apiUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.allDataSource removeAllObjects];
            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
                [self.allDataSource addObject:responseObject[@"data"][i]];
            }
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((kScreenW-10)/2, (kScreenW-10)/2+50);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.headerReferenceSize =CGSizeMake(kScreenW,kScreenW/2.5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 , kScreenW, kScreenH  - kNavigationBarH - kStatusBarH ) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Cell_BgColor;
        _collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[NewSearchCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, kScreenW - 10, kScreenW/2.5)];
    [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.imgUrl]]];
    [header addSubview:iv];
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.price.font = [UIFont systemFontOfSize:12];
    cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.allDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.allDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.allDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
    //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
    if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"amazon-us"]) {
        cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"tmall"]){
        cell.source.image = [UIImage imageNamed:@"天猫分类"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"taobao"]){
        cell.source.image = [UIImage imageNamed:@"淘宝分类"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"jingdong"]){
        cell.source.image = [UIImage imageNamed:@"京东分类"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"6pm"]){
        cell.source.image = [UIImage imageNamed:@"6pm"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"rakuten"]){
        cell.source.image = [UIImage imageNamed:@"乐天"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"macys"]){
        cell.source.image = [UIImage imageNamed:@"梅西百货"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"Nissen"]){
        cell.source.image = [UIImage imageNamed:@"日线"];
    }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"ebay"]){
        cell.source.image = [UIImage imageNamed:@"Ebay"];
    }
    
    cell.nameasd.text = self.allDataSource[indexPath.row][@"good_name"];
    cell.goodsLink = self.allDataSource[indexPath.row][@"good_link"];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];

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
