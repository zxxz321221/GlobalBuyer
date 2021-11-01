//
//  PurchaseInformationViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/24.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "PurchaseInformationViewController.h"
#import "PurchaseInformationCollectionViewCell.h"
#import "LoadingView.h"
#import "PurchaseInformationDetailViewControllerr.h"

@interface PurchaseInformationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) LoadingView *loadingView;
@property (nonatomic,strong) NSMutableArray *dataSorce;


@end

@implementation PurchaseInformationViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (NSMutableArray *)dataSorce
{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableArray new];
    }
    return _dataSorce;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downLoadData];
    
}

- (void)downLoadData
{
    [self.loadingView startLoading];

    
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
    }
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"locale":language,@"field":@"keyword",@"position":@"haitao"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:CountryAndSpecialDetailApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.dataSorce addObject:dict];
            }
        }
        [self.loadingView stopLoading];
        [self createUI];
        [self.collectionView reloadData];
        
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//
//        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)createUI
{
    self.navigationItem.titleView = self.titleView;
    self.view.backgroundColor = Cell_BgColor;
    [self.view addSubview:self.collectionView];
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

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , kScreenW, 70)];
        UILabel *headerTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, 5, 100, 40)];
        headerTitleLb.text = NSLocalizedString(@"GlobalBuyer_Amazon_OverseasShoppingInformation", nil);
        headerTitleLb.textAlignment = NSTextAlignmentCenter;
        headerTitleLb.font = [UIFont systemFontOfSize:24];
        [_headerView addSubview:headerTitleLb];
        UIView *leftLineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 50 - 90, _headerView.frame.size.height/2 - 10, 80, 1)];
        leftLineV.backgroundColor = [UIColor blackColor];
        [_headerView addSubview:leftLineV];
        UIView *rightLineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 + 50 + 10, _headerView.frame.size.height/2 - 10, 80 , 1)];
        rightLineV.backgroundColor = [UIColor blackColor];
        [_headerView addSubview:rightLineV];
        
        UIImageView *subtitleBackIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 60, 40, 120, 20)];
        subtitleBackIv.image = [UIImage imageNamed:@"单品标题"];
        UILabel *subtitleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        subtitleLb.textAlignment = NSTextAlignmentCenter;
        subtitleLb.textColor = [UIColor whiteColor];
        subtitleLb.font = [UIFont systemFontOfSize:10 weight:1];
        subtitleLb.text = NSLocalizedString(@"GlobalBuyer_Amazon_NewInformation", nil);
        [subtitleBackIv addSubview:subtitleLb];
        [_headerView addSubview:subtitleBackIv];
    }
    return _headerView;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH , kScreenW ,  kScreenH - kNavigationBarH - kStatusBarH  ) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = Cell_BgColor;
        [_collectionView registerClass:[PurchaseInformationCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PurchaseInformationCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSorce.count+1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        return CGSizeMake(kScreenW , 70);
    }else{
        return CGSizeMake(kScreenW , 260);
    }

    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 0;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"  forIndexPath:indexPath];
        [cell addSubview:self.headerView];
        return cell;
    }else{
        PurchaseInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PurchaseInformationCollectionViewCell class])  forIndexPath:indexPath];
        cell.titleLb.text = [NSString stringWithFormat:@"%@",self.dataSorce[indexPath.row-1][@"title"]];
        cell.describeLb.text = [NSString stringWithFormat:@"%@",self.dataSorce[indexPath.row-1][@"sub_title1"]];
        [cell.informationImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebPictureApi,self.dataSorce[indexPath.row-1][@"image"]]]];
        cell.fromLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Amazon_From", nil),self.dataSorce[indexPath.row-1][@"sub_title2"]];
        return cell;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return;
    }
    
    PurchaseInformationDetailViewControllerr *pIDVC = [[PurchaseInformationDetailViewControllerr alloc]init];
    pIDVC.htmlStr = self.dataSorce[indexPath.row-1][@"description"];
    pIDVC.navTitle = self.dataSorce[indexPath.row-1][@"title"];
    pIDVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pIDVC animated:YES];
    
    
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
