//
//  GlobalClassifyGoodsViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/7/24.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "GlobalClassifyGoodsViewController.h"
#import "SGPageView.h"
#import "GlobalClassifyDetailViewController.h"
#import "GlobalShopDetailViewController.h"
#import "CategoryTitleModel.h"
#import "FileArchiver.h"

@interface GlobalClassifyGoodsViewController ()<SGPageContentViewDelegare,SGPageTitleViewDelegate,GlobalClassifyDetailViewControllerDetegate,UIScrollViewDelegate>

@property(nonatomic,strong)SGPageContentView *pageContentView;
@property(nonatomic,strong)SGPageTitleView *pageTitleView;
@property(nonatomic,strong)NSMutableArray *titleArr;

@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSString *countryId;

@property (nonatomic, strong)NSString *websiteIntroductionStr;
@property (nonatomic, strong)UIView *websiteIntroductionBackV;
@property (nonatomic,strong)UIScrollView *websiteIntroductionSV;
@property (nonatomic,strong)NSTimer *websiteIntroductionTimer;
@property (nonatomic,assign)NSInteger websiteIntroductionHeight;

@end

@implementation GlobalClassifyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 执⾏耗时的异步操作...
//        
//        NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
//        NSData *data = [NSData dataWithContentsOfURL:ipURL];
//        NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
//            self.countryId = ipDic[@"data"][@"country_id"];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.hud hideAnimated:YES];
//            [self setupUI];
//            [self readClassifyTitle:@"ClassifyTitle"];
//            
//        });
//        
//    });
    [self setupUI];
    [self downloadCategoryData];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(NSMutableArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray new];
    }
    return _titleArr;
}

- (void)readClassifyTitle:(NSString *)fileName
{
    NSArray *array = [FileArchiver readFileArchiver:fileName];
    if (array) {
        for (int i = 0; i < array.count; i++) {
            [self.titleArr addObject:array[i]];
        }
        [self addPageContentView];
    }else{
        [self downloadCategoryData];
    }
}

- (void)downloadCategoryData{
    
    [self.titleArr removeAllObjects];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    self.hud.label.text= NSLocalizedString(@"GlobalBuyer_Loading", nil);
    
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
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"locale":language};
    
    [manager  POST: CategoryTitleApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count == 0) {
            return ;
        }
        for (NSDictionary *dict in dataArr) {
            CategoryTitleModel  *categoryTitleModel = [[CategoryTitleModel alloc]initWithDictionary:dict error:nil];
            categoryTitleModel.Id = dict[@"id"];
            [self.titleArr addObject:categoryTitleModel];
        }
        
        
        [self.hud hideAnimated:YES];
        [self addPageContentView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)downloadNewCategoryData{
    
    [self.titleArr removeAllObjects];
    
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
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"locale":language};
    
    [manager  POST: CategoryTitleApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        if (dataArr.count == 0) {
            return ;
        }
        for (NSDictionary *dict in dataArr) {
            CategoryTitleModel  *categoryTitleModel = [[CategoryTitleModel alloc]initWithDictionary:dict error:nil];
            categoryTitleModel.Id = dict[@"id"];
            [self.titleArr addObject:categoryTitleModel];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)addPageContentView{
    
    NSMutableArray *vcArr = [NSMutableArray new];
    for (int i = 0; i < self.titleArr.count; i++) {
        GlobalClassifyDetailViewController *vc = [[GlobalClassifyDetailViewController alloc] init];
        vc.delegate = self;
        CategoryTitleModel *model = self.titleArr[i];
        vc.signId = model.name;
        vc.countryId = self.countryId;
        [vcArr addObject: vc];
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    for ( CategoryTitleModel *model in self.titleArr) {
        [arr addObject:model.name];
    }
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self titleNames:arr];
    [self.view addSubview:_pageTitleView];
    CGFloat contentViewHeight = self.view.frame.size.height - 108;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:vcArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    [self downloadNewCategoryData];
}


-(void)addTitleView {
    
    
}

#pragma mark 创建UI
- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Home_GlobalClassification", nil);
    self.websiteIntroductionStr = NSLocalizedString(@"GlobalBuyer_GlobalBuyer_Dis", nil);
    [self.tabBarController.view addSubview:self.websiteIntroductionBackV];
}

//网站介绍
- (UIView *)websiteIntroductionBackV
{
    if (_websiteIntroductionBackV == nil) {
        _websiteIntroductionBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _websiteIntroductionBackV.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        
        self.websiteIntroductionSV = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenW/2 - 140, kScreenH/2 - 150, 280 , 300)];
        self.websiteIntroductionSV.delegate = self;
        [_websiteIntroductionBackV addSubview:self.websiteIntroductionSV];
        
        
        UILabel *websiteIntroductionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 280, 1000)];
        websiteIntroductionLb.text = [NSString stringWithFormat:@"%@",self.websiteIntroductionStr];
        websiteIntroductionLb.font = [UIFont systemFontOfSize:16];
        websiteIntroductionLb.textColor = [UIColor whiteColor];
        websiteIntroductionLb.numberOfLines = 0;
        [websiteIntroductionLb sizeToFit];
        
        [self.websiteIntroductionSV addSubview:websiteIntroductionLb];
        
        self.websiteIntroductionSV.contentSize = CGSizeMake(0, 300+websiteIntroductionLb.frame.size.height);
        
        self.websiteIntroductionHeight = 0;
        
        self.websiteIntroductionTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(websiteIntroductionRoll) userInfo:nil repeats:YES];
        [self.websiteIntroductionTimer setFireDate:[NSDate distantPast]];
        [[NSRunLoop currentRunLoop] addTimer:self.websiteIntroductionTimer forMode:NSRunLoopCommonModes];
        
        UIButton *noLongerBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.websiteIntroductionSV.frame.origin.x, self.websiteIntroductionSV.frame.origin.y + self.websiteIntroductionSV.frame.size.height + 10, 130 , 40)];
        noLongerBtn.layer.borderWidth = 0.7;
        noLongerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [noLongerBtn setTitle:NSLocalizedString(@"GlobalBuyer_Amazon_NoPrompt", nil) forState:UIControlStateNormal];
        [noLongerBtn addTarget:self action:@selector(noLongerClick) forControlEvents:UIControlEventTouchUpInside];
        [_websiteIntroductionBackV addSubview:noLongerBtn];
        
        UIButton *knowBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.websiteIntroductionSV.frame.origin.x + 150, self.websiteIntroductionSV.frame.origin.y + self.websiteIntroductionSV.frame.size.height + 10, 130, 40)];
        knowBtn.layer.borderWidth = 0.7;
        knowBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [knowBtn setTitle:NSLocalizedString(@"GlobalBuyer_Amazon_OK", nil) forState:UIControlStateNormal];
        [knowBtn addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
        [_websiteIntroductionBackV addSubview:knowBtn];
    }
    return _websiteIntroductionBackV;
}

- (void)noLongerClick
{
    [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:[NSString stringWithFormat:@"GlobalWebREAD"]];
    [self.websiteIntroductionBackV removeFromSuperview];
    self.websiteIntroductionBackV = nil;
}

- (void)knowClick
{
    [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
    [self.websiteIntroductionBackV removeFromSuperview];
    self.websiteIntroductionBackV = nil;
}

- (void)websiteIntroductionRoll
{
    if (self.websiteIntroductionHeight >= self.websiteIntroductionSV.contentSize.height) {
        [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
    }
    self.websiteIntroductionSV.contentOffset = CGPointMake(0, self.websiteIntroductionHeight++);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.websiteIntroductionTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark SGPageContentViewDelegare和SGPageTitleViewDelegate
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
}

#pragma mark ClassifyDetailViewControllerDetegate
- (void)selectAtIndexInClassifyDetailViewController:(CategoryModel *)model {
    GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
    shopDetail.hidesBottomBarWhenPushed = YES;
    shopDetail.link = model.link;
    shopDetail.websiteName = model.name;
    shopDetail.websiteIntroductionStr = model.introduction;
    shopDetail.guideMessage = model.guide;
    [self.navigationController pushViewController:shopDetail animated:YES];
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
