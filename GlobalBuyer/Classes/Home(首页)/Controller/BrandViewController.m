//
//  BrandViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/27.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "BrandViewController.h"
#import "LoadingView.h"
#import "ShopDetailViewController.h"
#import "BrandSearchViewController.h"

#import "BrandSearchingViewController.h"
#import "HomeSearchWithKeyViewController.h"

#import "DSectionIndexItemView.h"
#import "DSectionIndexView.h"

#import <sys/utsname.h>

@interface BrandViewController ()<DSectionIndexViewDelegate,DSectionIndexViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) DSectionIndexView *sectionIndexView;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UITableView *tabelView;
@property (nonatomic,strong) NSMutableDictionary *dataSorce;
@property (nonatomic,strong) NSMutableArray *AToZDataSource;
@property (nonatomic,strong) LoadingView *loadingView;

@end

#define kSectionIndexWidth 25.f
#define kSectionIndexHeight 400.f

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self downData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tabelView.frame) - kSectionIndexWidth, (CGRectGetHeight(self.tabelView.frame) - kSectionIndexHeight)/2, kSectionIndexWidth, kSectionIndexHeight);
    [_sectionIndexView setBackgroundViewFrame];
}

- (void)_initIndexView
{
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    
    [self.view addSubview:self.sectionIndexView];
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.tabelView.numberOfSections;
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    
    itemView.titleLabel.text = [NSString stringWithFormat:@"%@",[[self.AToZDataSource[section] allKeys] firstObject]];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = [UIColor whiteColor];
    itemView.titleLabel.highlightedTextColor = [UIColor whiteColor];
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    return itemView;
}


- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@",[[self.AToZDataSource[section] allKeys] firstObject]];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (NSMutableDictionary *)dataSorce
{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableDictionary new];
    }
    return _dataSorce;
}

- (NSMutableArray *)AToZDataSource
{
    if (_AToZDataSource == nil) {
        _AToZDataSource = [NSMutableArray new];
    }
    return _AToZDataSource;
}

- (void)downData
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
    //language = @"en";
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"locale":@"zh_CN"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:BrandAToZApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.dataSorce = responseObject[@"data"];
            for (char c = 'A'; c <= 'Z'; c++) {
                if ([self.dataSorce[[NSString stringWithFormat:@"%c",c]] count] != 0) {
                    NSDictionary *dict = @{[NSString stringWithFormat:@"%c",c]:self.dataSorce[[NSString stringWithFormat:@"%c",c]]};
                    [self.AToZDataSource addObject:dict];
                }
            }
        }
        [self.loadingView stopLoading];
        [self.tabelView reloadData];
        [self _initIndexView];
        [self.sectionIndexView reloadItemViews];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleView;

    [self.view addSubview:self.tabelView];
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
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2.5 + kScreenW/5 +10 + 40)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *bannerBackIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20, kScreenW/2.5 - 20)];
        bannerBackIv.userInteractionEnabled = YES;
        bannerBackIv.image = [UIImage imageNamed:@"brandBanner"];
        [_headerView addSubview:bannerBackIv];
        UITapGestureRecognizer *bannerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerClick)];
        bannerTap.numberOfTapsRequired = 1;
        bannerTap.numberOfTouchesRequired = 1;
        [bannerBackIv addGestureRecognizer:bannerTap];
        
        UIImageView *firstIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, kScreenW/2.5 , bannerBackIv.frame.size.width/3 - 5, kScreenW/5)];
        firstIv.userInteractionEnabled = YES;
        firstIv.image = [UIImage imageNamed:@"brandOne.jpg"];
        [_headerView addSubview:firstIv];
        UITapGestureRecognizer *firstIvTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstIvClick)];
        firstIvTap.numberOfTouchesRequired = 1;
        firstIvTap.numberOfTapsRequired = 1;
        [firstIv addGestureRecognizer:firstIvTap];
        
        UIImageView *secondIv = [[UIImageView alloc]initWithFrame:CGRectMake(10 + bannerBackIv.frame.size.width/3 + 5, kScreenW/2.5 , bannerBackIv.frame.size.width/3 - 5, kScreenW/5)];
        secondIv.userInteractionEnabled = YES;
        secondIv.image = [UIImage imageNamed:@"brandTwo.jpg"];
        [_headerView addSubview:secondIv];
        UITapGestureRecognizer *secondIvTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondIvClick)];
        secondIvTap.numberOfTapsRequired = 1;
        secondIvTap.numberOfTouchesRequired = 1;
        [secondIv addGestureRecognizer:secondIvTap];
        
        UIImageView *thirdIv = [[UIImageView alloc]initWithFrame:CGRectMake(10 + bannerBackIv.frame.size.width/3*2 + 5, kScreenW/2.5 , bannerBackIv.frame.size.width/3 - 5, kScreenW/5)];
        thirdIv.userInteractionEnabled = YES;
        thirdIv.image = [UIImage imageNamed:@"brandThree.jpg"];
        [_headerView addSubview:thirdIv];
        UITapGestureRecognizer *thirdIvTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdIvClick)];
        thirdIvTap.numberOfTouchesRequired = 1;
        thirdIvTap.numberOfTapsRequired = 1;
        [thirdIv addGestureRecognizer:thirdIvTap];
        
        
        UIView *brandSearchBackV = [[UIView alloc]initWithFrame:CGRectMake(10, firstIv.frame.origin.y + firstIv.frame.size.height + 5 , kScreenW - 20, 40)];
        brandSearchBackV.backgroundColor = [UIColor lightGrayColor];
        brandSearchBackV.alpha = 0.7;
        [_headerView addSubview:brandSearchBackV];
        
        UIImageView *magnifierIv = [[UIImageView alloc]initWithFrame:CGRectMake(15, firstIv.frame.origin.y + firstIv.frame.size.height + 10, 30, 30)];
        magnifierIv.image = [UIImage imageNamed:@"放大镜"];
        [_headerView addSubview:magnifierIv];
        
        UITextField *brandSearchTv = [[UITextField alloc]initWithFrame:CGRectMake(50, firstIv.frame.origin.y + firstIv.frame.size.height + 5 , kScreenW - 60, 40)];
        brandSearchTv.backgroundColor = [UIColor clearColor];
        brandSearchTv.delegate = self;
        [_headerView addSubview:brandSearchTv];
    }
    return _headerView;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    [self search];
}

- (void)search
{
    BrandSearchingViewController *searchingVC = [[BrandSearchingViewController alloc]init];
    searchingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchingVC animated:YES];
}

- (void)bannerClick
{
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
    shopVC.link = @"https://www.amazon.com";
    shopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)firstIvClick
{
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
    shopVC.link = @"https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=+adidas&rh=i%3Aaps%2Ck%3A+adidas";
    shopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)secondIvClick
{
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
    shopVC.link = @"https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=calvin+klein&rh=i%3Aaps%2Ck%3Acalvin+klein";
    shopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)thirdIvClick
{
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
    shopVC.link = @"https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=kindle";
    shopVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (UITableView *)tabelView
{
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-NavBarHeight) style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.tableHeaderView = self.headerView;
        _tabelView.sectionIndexBackgroundColor = [UIColor colorWithRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:0.6];
    }
    return _tabelView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [NSString stringWithFormat:@"%@",[[self.AToZDataSource[section] allKeys] firstObject]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.AToZDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.AToZDataSource[section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[section] allKeys] firstObject]]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
//    for (int i = 0; i < self.AToZDataSource.count; i++) {
//        
//        struct utsname systemInfo;
//        uname(&systemInfo);
//        NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
//        
//        
//        if([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"] || [platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"] || [platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"]){
//            
//            [resultArray addObject:[NSString stringWithFormat:@"%@",[[self.AToZDataSource[i] allKeys] firstObject]]];
//            
//        }else{
//            
//            [resultArray addObject:[NSString stringWithFormat:@"\t%@\t",[[self.AToZDataSource[i] allKeys] firstObject]]];
//            
//        }
//        
//        
//
//    }
//    return resultArray;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brandCell"];
    }
    
    
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage isEqualToString:@"en"]){
        cell.textLabel.text = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-en"];
    }
    else if ([currentLanguage isEqualToString:@"zh-Hant"]){
        cell.textLabel.text = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-tw"];
    }
    else if ([currentLanguage isEqualToString:@"Japanese"]){
        cell.textLabel.text = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-ja"];
    }else{
        cell.textLabel.text = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-cn"];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
//    HomeSearchWithKeyViewController *brandSearch = [[HomeSearchWithKeyViewController alloc]init];
//    brandSearch.keyWords = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-cn"];
//    brandSearch.twKeyWords = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-tw"];
//    brandSearch.jpKeyWords = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-ja"];
//    brandSearch.enKeyWords = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-en"];
//    brandSearch.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Amazon_Fixedprice", nil);
    
    BrandSearchViewController *brandSearch = [[BrandSearchViewController alloc]init];
    brandSearch.keyWords = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-cn"];
    brandSearch.keyWordsTw = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-tw"];
    brandSearch.keyWordsJp = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-ja"];
    brandSearch.keyWordsEn = self.AToZDataSource[indexPath.section][[NSString stringWithFormat:@"%@",[[self.AToZDataSource[indexPath.section] allKeys] firstObject]]][indexPath.row][@"search-en"];
    brandSearch.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Amazon_Fixedprice", nil);
    [self.navigationController pushViewController:brandSearch animated:YES];
    
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
