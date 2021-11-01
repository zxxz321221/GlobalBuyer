//
//  SpecialDetailViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/2.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "SpecialDetailViewController.h"

#import "ShopDetailViewController.h"
#import "SpecialClassifyCell.h"
#import "SpecialBannerCell.h"
#import "BannerModel.h"
#import "SpecialTableViewCell.h"


@interface SpecialDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) NSMutableArray *bannerData;
@property (nonatomic,strong) NSMutableArray *goodData;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *recommendV;

@end

@implementation SpecialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self initData];
}

- (NSMutableArray *)bannerData
{
    if (_bannerData == nil) {
        _bannerData = [NSMutableArray new];
    }
    return _bannerData;
}

- (NSMutableArray *)goodData
{
    if (_goodData == nil) {
        _goodData = [NSMutableArray new];
    }
    return _goodData;
}

- (void)initData
{
    NSDictionary *dict = @{@"image":self.noticeUrl};
    BannerModel *model = [[BannerModel alloc]initWithDictionary:dict error:nil];
    [self.bannerData addObject:model];
    
    for (NSDictionary *dic in self.dataSource) {
        GoodsModel *mode = [[GoodsModel alloc]initWithDictionary:dic error:nil];
        [self.goodData addObject:mode];
    }
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleView;
    //[self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 150;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, 190, 30)];
        
        UIImageView *titleIv = [[UIImageView alloc]initWithFrame:self.titleView.bounds];
        
        
        NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
        // 取得 iPhone 支持的所有语言设置
        NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
        NSLog (@"%@", languages);
        
        // 获得当前iPhone使用的语言
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            titleIv.image = [UIImage imageNamed:@"NavTitle_j"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            titleIv.image = [UIImage imageNamed:@"NavTitle_f"];
        }else if([currentLanguage isEqualToString:@"en"]){
            titleIv.image = [UIImage imageNamed:@"NavTitle_en"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            titleIv.image = [UIImage imageNamed:@"NavTitle_f"];
        }else{
            titleIv.image = [UIImage imageNamed:@"NavTitle_j"];
        }
        
        [_titleView addSubview:titleIv];
        
        //        UILabel *titleLa = [UILabel new];
        //        titleLa.frame = CGRectMake(0, 4, 150, 17);
        //        titleLa.textAlignment = NSTextAlignmentCenter;
        //        titleLa.font = [UIFont systemFontOfSize:18];
        //        titleLa.textColor = [UIColor whiteColor];
        //        titleLa.text = NSLocalizedString(@"GlobalBuyer_Home_title", nil);
        //        [_titleView addSubview:titleLa];
        //        UILabel *subTitleLa = [UILabel new];
        //        subTitleLa.frame = CGRectMake(0, 21, 150, 21);
        //        subTitleLa.textAlignment = NSTextAlignmentCenter;
        //        subTitleLa.font = [UIFont boldSystemFontOfSize:10];
        //        subTitleLa.textColor = [UIColor whiteColor];
        //        subTitleLa.text = @"Dayanghang Global Buyers";
        //        [_titleView addSubview:subTitleLa];

    }
    return _titleView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2.5 + 100)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *bannerIv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreenW - 10, kScreenW /2.2)];
    [bannerIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.noticeUrl]]];
    [view addSubview:bannerIv];
    [view addSubview:self.recommendV];
    return view;
}

- (UIView *)recommendV
{
    if (_recommendV == nil) {
        _recommendV = [[UIView alloc]initWithFrame:CGRectMake( 5 , kScreenW/2.5 + 20, kScreenW - 10, 80)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(50, 34, 80, 1)];
        lineV.backgroundColor = [UIColor blackColor];
        [_recommendV addSubview:lineV];
        UIView *lineRightV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50 - 80, 34, 80, 1)];
        lineRightV .backgroundColor = [UIColor blackColor];
        [_recommendV addSubview:lineRightV];
        UILabel *webTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(lineV.frame.origin.x + lineV.frame.size.width, 20, lineRightV.frame.origin.x - (lineV.frame.origin.x + lineV.frame.size.width), 30)];
        webTitleLb.text = NSLocalizedString(@"GlobalBuyer_Special_HotRecommendation", nil);
        webTitleLb.textAlignment = NSTextAlignmentCenter;
        webTitleLb.font = [UIFont systemFontOfSize:21];
        [_recommendV addSubview:webTitleLb];
        UIImageView *sellingIv = [[UIImageView alloc]initWithFrame:CGRectMake(webTitleLb.frame.origin.x, webTitleLb.frame.origin.y + 30 + 1, webTitleLb.frame.size.width, 25)];
        sellingIv.image = [UIImage imageNamed:@"单品标题"];
        [_recommendV addSubview:sellingIv];
        UILabel *bodyLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, sellingIv.frame.size.width - 20, 24)];
        bodyLb.font = [UIFont systemFontOfSize:11];
        bodyLb.text = NSLocalizedString(@"GlobalBuyer_Special_Discount", nil);
        bodyLb.textAlignment = NSTextAlignmentCenter;
        bodyLb.textColor = [UIColor whiteColor];
        [sellingIv addSubview:bodyLb];
    }
    return _recommendV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenW/2.5+100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialTableViewCell"];
    if (cell == nil) {
        cell = [[SpecialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpecialTableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =  self.goodData[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *model = self.goodData[indexPath.row];
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    shopDetailVC.link = model.href;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

//-(UICollectionView *)collectionView{
//    if (_collectionView == nil) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,  kScreenH) collectionViewLayout:flowLayout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        [_collectionView registerClass:[SpecialClassifyCell class] forCellWithReuseIdentifier:NSStringFromClass([SpecialClassifyCell class])];
//        [_collectionView registerClass:[SpecialBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([SpecialBannerCell class])];
//        _collectionView.bounces = NO;
//        
//    }
//    return _collectionView;
//}
//
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 2;
//}
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    
//    if (section == 0) {
//        return  1;
//    }else{
//        return self.dataSource.count;
//    }
//    
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 0);
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 0) {
//        return CGSizeMake(kScreenW, kScreenW/2.5 + 100);
//    }else{
//        return CGSizeMake(kScreenW, 150);
//    }
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }else if (section == 1){
//        return 0;
//    }else{
//        return 0;
//    }
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }else{
//        return 0;
//    }
//}
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 0) {
//        SpecialBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ SpecialBannerCell class]) forIndexPath:indexPath];
//        cell.imgArr = self.bannerData;
//        return cell;
//    }else{
//        SpecialClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SpecialClassifyCell class]) forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[SpecialClassifyCell alloc]init];
//        }
//        cell.model = self.goodData[indexPath.row];
//        return cell;
//    }
//    
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        GoodsModel *model = self.goodData[indexPath.row];
//        
//        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//        shopDetailVC.hidesBottomBarWhenPushed = YES;
//        shopDetailVC.link = model.href;
//        [self.navigationController pushViewController:shopDetailVC animated:YES];
//    }
//}


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
