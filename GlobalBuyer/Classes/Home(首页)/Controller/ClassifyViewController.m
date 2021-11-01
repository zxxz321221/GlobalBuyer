//
//  ClassifyViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ClassifyViewController.h"

#import "BannerModel.h"
#import "CountryBannerCell.h"
#import "FileArchiver.h"
#import "HearderView.h"
#import "ShopDetailViewController.h"
#import "CountryClassifyCell.h"
@interface ClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HearderViewDelegate,CountryBannerCellDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *goodsArr;
@property (nonatomic,strong) NSMutableArray *bannerArr;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) NSArray *direction;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *directionStr;
@property (nonatomic,assign) BOOL newBannerData;
@property (nonatomic,assign) BOOL newGoodsData;
@property (nonatomic, assign) BOOL showLoading;
@property (nonatomic,strong) HearderView *headView;
@property (nonatomic, strong) NSMutableArray *webLinkArr;


@property (nonatomic, assign) BOOL moreWebLink;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupUI];
    [self setNavigationBackBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:@"enterForeground" object:nil];

    [self downLoadWebData];
    [self readBannerFile:self.BannerFileName];
    [self readGoodsFile:self.GoodsFileName];
//    [self.collectionView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark enterForeground通知
-(void)enterForeground:(NSNotification*)notification{
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        if (self.showLoading) {
            [LZBLoadingView showLoadingViewFourRoundInView:self.view];
        }
    }
}

#pragma mark enterBackground通知
-(void)enterBackground:(NSNotification*)notification{
    NSDictionary *dict = [notification userInfo];
    BOOL state  = [dict[@"state"] boolValue];
    if (state) {
        [LZBLoadingView dismissLoadingView];
    }
}

-(void)readBannerFile:(NSString *)fileName{
    NSArray *array = [FileArchiver readFileArchiver:fileName];
    if (array) {
        [self bannerArrToModel:array];
        self.showLoading = NO;
    }else{
        self.showLoading = YES;
        
    }
}

-(void)readGoodsFile:(NSString *)fileName{
    
    NSArray *array = [FileArchiver readFileArchiver:fileName];
    
    if (array) {
        [self goodsArrToMode:array];
        self.showLoading = NO;
    }else{
        self.showLoading = YES;
    }
}
-(void)goodsArrToMode:(NSArray *)arr{
    
    for (NSDictionary *dict in arr) {
        GoodsModel *model = [[GoodsModel alloc]initWithDictionary:dict error:nil];
        model.image = [NSString stringWithFormat:@"%@%@",PictureApi,model.image];
        if ([self.directionStr isEqualToString:@"goodsDisc"]) {
            model.discount = @"goodsDisc";
        }else{
            model.discount = nil;
        }
        [self.goodsArr addObject:model];
    }
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];

    self.collectionView.mj_footer.hidden = NO;
    self.collectionView.mj_header.hidden = NO;
}

-(void)bannerArrToModel:(NSArray *)arr{
    for (NSDictionary *dict in arr) {
        BannerModel *model = [[BannerModel alloc]initWithDictionary:dict error:nil];
        [self.bannerArr addObject:model];
    }
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
    }];
 
    self.collectionView.mj_footer.hidden = NO;
    
    self.collectionView.mj_header.hidden = NO;
}

-(NSMutableArray *)bannerArr{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray new];
    }
    return _bannerArr;
}

-(NSMutableArray *)goodsArr{
    if (_goodsArr == nil) {
        _goodsArr = [NSMutableArray new];
    }
    return _goodsArr;
}

- (NSMutableArray *)webLinkArr
{
    if (_webLinkArr == nil) {
        _webLinkArr = [NSMutableArray new];
    }
    return _webLinkArr;
}

-(void)dowloadNewData{
    [self.collectionView.mj_header endRefreshing];
    self.newGoodsData = YES;
    self.newBannerData = YES;
    [_headView resastBtn];
    [self downloadBannerData];
}

-(void)downloadBannerData{
    if (![FileArchiver readFileArchiver:@"homeBanner"]) {
        self.page = 1;
        self.showLoading = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.alpha = 0;
        } completion:^(BOOL finished) {
            self.collectionView.hidden = YES;
            [LZBLoadingView showLoadingViewFourRoundInView:self.view];
        }];
    }
    
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"locale"] = language;
    params[@"field"] = @"symbol";
    params[@"position"] = self.bannerName;
    
    [manager POST:CountryAndSpecialDetailApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSArray *data = responseObject[@"data"];
        if (data.count == 0) {
            self.showLoading = NO;
            self.collectionView.hidden = NO;
            _collectionView.mj_header.hidden = NO;
            [self.collectionView.mj_header endRefreshing];
            [LZBLoadingView dismissLoadingView];
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            [self downloadNewGoodsData];
            return ;
        }
        NSArray *banner = [NSArray arrayWithArray:data];
        if (self.newBannerData) {
            [self.bannerArr removeAllObjects];
            NSLog(@"%ld",self.bannerArr.count);
        }
     
        [FileArchiver writeFileArchiver:self.BannerFileName  withArray:banner];
        
        self.newBannerData = NO;
        [self bannerArrToModel:banner];
        NSLog(@"%ld",self.bannerArr.count);
        [self downloadNewGoodsData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.showLoading = NO;
        self.collectionView.hidden = NO;
        _collectionView.mj_header.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)downLoadWebData
{
    [self.webLinkArr removeAllObjects];
    
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"field"] = @"country";
    params[@"locale"] = language;
    params[@"name"] = self.goodsName;
    
    [manager POST:CountryWebLink parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *data = responseObject[@"data"];
        if (data.count == 0) {
            self.showLoading = NO;
            self.collectionView.hidden = NO;
            _collectionView.mj_header.hidden = NO;
            [self.collectionView.mj_header endRefreshing];
            [LZBLoadingView dismissLoadingView];
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            [self downloadNewGoodsData];
            return ;
        }
        
        for (int i = 0; i < data.count; i++) {
            [self.webLinkArr addObject:data[i]];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.showLoading = NO;
        self.collectionView.hidden = NO;
        _collectionView.mj_header.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)downloadNewGoodsData{
    
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
    self.page = 1;
    self.directionStr = @"created_at";
    [self downloadDataWithPage:self.page LocaleLa:language Direction:@"desc" Sort:@"created_at"];
    
}
-(void)downloadDataWithPage:(NSInteger)page LocaleLa:(NSString *)LocaleLua Direction:(NSString *)direction Sort:(NSString *)sort{
    if (![FileArchiver readFileArchiver:self.GoodsFileName]) {
        self.page = 1;
        self.showLoading = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.alpha = 0;
        } completion:^(BOOL finished) {
            self.collectionView.hidden = YES;
            [LZBLoadingView showLoadingViewFourRoundInView:self.view];
        }];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"locale"] = LocaleLua;
    params[@"page"] = @(page);
    params[@"field"] = @"symbol";
    params[@"direction"] = direction;
    params[@"sort"] = sort;
    params[@"position"] = self.goodsName;
    
    [manager POST:CountryAndSpecialDetailApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![FileArchiver readFileArchiver:self.GoodsFileName]) {
            self.collectionView.hidden = NO;
            [LZBLoadingView dismissLoadingView];
            
            
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
            self.showLoading = NO;
            
        }
        
        NSArray *arr = responseObject[@"data"];
        if (arr.count == 0) {
            self.showLoading = NO;
            self.collectionView.hidden = NO;
            _collectionView.mj_header.hidden = NO;
            [self.collectionView.mj_header endRefreshing];
            [LZBLoadingView dismissLoadingView];
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            return ;
        }        @synchronized (self) {
            if (self.newGoodsData) {
                [self.goodsArr removeAllObjects];
                [FileArchiver writeFileArchiver:self.GoodsFileName withArray:arr];
                
            }
        }
      
        [self goodsArrToMode:arr];
        self.newGoodsData = NO;
        self.page = [responseObject[@"page"] integerValue];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSInteger pageCount = [responseObject[@"pageCount"] integerValue];
        NSInteger page = [responseObject[@"page"] integerValue];
        if (page == pageCount - 1 ) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer resetNoMoreData];
        }
        
        self.collectionView.mj_footer.hidden = NO;
        NSLog(@"%lf",self.collectionView.contentOffset.y);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.showLoading = NO;
        self.collectionView.hidden = NO;
        _collectionView.mj_header.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
        [LZBLoadingView dismissLoadingView];
        [UIView animateWithDuration:0.2 animations:^{
            self.collectionView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

-(void)setupUI{
    self.navigationItem.titleView = self.titleView;
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

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW,  kScreenH - kNavigationBarH - kStatusBarH - kTabBarH) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CountryClassifyCell class] forCellWithReuseIdentifier:NSStringFromClass([CountryClassifyCell class])];
        [_collectionView registerClass:[CountryBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([CountryBannerCell class])];
        [_collectionView registerClass:[HearderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HearderView class])];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dowloadNewData)];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStatePulling", nil) forState:MJRefreshStatePulling];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateRefreshing", nil) forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.arrowView.hidden = YES;
        
        _collectionView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dowloadMoreData)];
        
        // 设置文字
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStatePulling", nil) forState:MJRefreshStateRefreshing];
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateRefreshing", nil) forState:MJRefreshStateNoMoreData];
        
        _collectionView.mj_footer = footer;
        _collectionView.mj_footer.hidden = YES;
        _collectionView.mj_header.hidden = YES;
        
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return  1;
    }else{
        return self.goodsArr.count;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(60, 30);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {

        if (_headView == nil) {
            _headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                           withReuseIdentifier:NSStringFromClass([HearderView class])
                                                                  forIndexPath:indexPath];
            _headView.delegate = self;
        }
        
        return self.headView;
    }else{
        return nil;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.moreWebLink == NO) {
            return CGSizeMake(kScreenW, kScreenW/2.5 + 260);
        }else{
            if (self.webLinkArr.count%4 == 0) {
                return CGSizeMake(kScreenW, kScreenW/2.5 + 50 + 100 + self.webLinkArr.count/4*50);
            }else{
                return CGSizeMake(kScreenW, kScreenW/2.5 + 50 + 100 + (self.webLinkArr.count/4 + 1)*50);
            }
            
        }

    }else{
        return CGSizeMake(kScreenW, 151);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 0;
    }else{
        return 5;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 5;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CountryBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ CountryBannerCell class]) forIndexPath:indexPath];
        cell.imgArr = self.bannerArr;
        cell.delegate = self;
        if (self.webLinkArr.count != 0) {
            [cell setWebLinkWithData:self.webLinkArr];
        }
        return cell;
    }else{
        CountryClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CountryClassifyCell class]) forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CountryClassifyCell alloc]init];
        }
        
        cell.model = self.goodsArr[indexPath.row];
    
        return cell;
    }
    
}


-(void)downLoadSelcetData:(NSInteger)index{
    self.direction = @[@"created_at",@"created_at",@"placeholder3",@"placeholder2"];
    self.collectionView.mj_footer.hidden = YES;
    [self.goodsArr removeAllObjects];
    [self.collectionView reloadData];
    
    self.page = 1;
    NSString *direction =  self.direction[index - 100];
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
    if (index == 100) {
        self.directionStr = direction;
        [self downloadDataWithPage:self.page LocaleLa:language Direction: @"desc" Sort:self.directionStr];
    }else{
        self.directionStr = direction;
        [self downloadDataWithPage:self.page LocaleLa:language Direction: @"asc" Sort:self.directionStr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dowloadMoreData{
    
    self.page ++;
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
    
    if ([self.directionStr isEqualToString:@"created_at"]) {
        [self downloadDataWithPage:self.page LocaleLa:language Direction: @"desc" Sort:self.directionStr];
        return;
    }
    [self downloadDataWithPage:self.page LocaleLa:language Direction: @"asc" Sort:self.directionStr];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.showLoading) {
        [LZBLoadingView showLoadingViewFourRoundInView:self.view];
    }else{
        [LZBLoadingView dismissLoadingView];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        GoodsModel *model = self.goodsArr[indexPath.row];
        
        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
        shopDetailVC.hidesBottomBarWhenPushed = YES;
        shopDetailVC.link = model.href;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    }
}

-(void)cellImgClickWithLink:(NSString *)urlString{
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = urlString;
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

- (void)cellImgClickWebMore
{
    self.headView = nil;
    self.moreWebLink = YES;
    [self.collectionView reloadData];
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
