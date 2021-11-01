//
//  ClassifyViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ClassifyGoodsViewController.h"
#import "SGPageView.h"
#import "ClassifyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "CategoryTitleModel.h"
#import "FileArchiver.h"
#import "MessageViewController.h"
#import "GlobalShopDetailViewController.h"
@interface ClassifyGoodsViewController ()<SGPageContentViewDelegare,SGPageTitleViewDelegate,ClassifyDetailViewControllerDetegate>

@property(nonatomic,strong)SGPageContentView *pageContentView;
@property(nonatomic,strong)SGPageTitleView *pageTitleView;
@property(nonatomic,strong)NSMutableArray *titleArr;

@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSString *countryId;

@end

@implementation ClassifyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    

    
    [self setupUI];
    [self readClassifyTitle:@"ClassifyTitle"];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = Main_Color;
    self.navigationController.navigationBar.backgroundColor = Main_Color;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPushNoPayView"] isEqualToString:@"YES"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"IsPushProcurementView"] isEqualToString:@"YES"]) {
        self.tabBarController.selectedIndex = 3;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshGoodsNum" object:nil];
    
    
//    UIButton * _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_rightButton setFrame:CGRectMake(0.0, 10.0, 25.0, 25.0)];
//    [_rightButton setBackgroundImage:[UIImage imageNamed:@"msg"] forState:UIControlStateNormal];
//    [_rightButton addTarget:self action:@selector(msgBtn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;

}
- (void)msgBtn{
    MessageViewController * msg = [MessageViewController new];
    msg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msg animated:YES];
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
        
        
        [FileArchiver writeFileArchiver:@"ClassifyTitle" withArray:self.titleArr];
        
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
    NSLog(@"分类标题接口 %@",params);
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
        
        
        [FileArchiver writeFileArchiver:@"ClassifyTitle" withArray:self.titleArr];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

-(void)addPageContentView{

    NSMutableArray *vcArr = [NSMutableArray new];
    for (int i = 0; i < self.titleArr.count; i++) {
        ClassifyDetailViewController *vc = [[ClassifyDetailViewController alloc] init];
        vc.delegate = self;
        CategoryTitleModel *model = self.titleArr[i];
        vc.signId = model.name;
        NSLog(@"chuan %@",model.name);
        vc.countryId = self.countryId;
        [vcArr addObject: vc];
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    for ( CategoryTitleModel *model in self.titleArr) {
        [arr addObject:model.name];
    }
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self titleNames:arr];
    [self.view addSubview:_pageTitleView];
    CGFloat contentViewHeight = self.view.frame.size.height - LL_TabbarHeight;
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:vcArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    [self downloadNewCategoryData];
}


-(void)addTitleView {
 

}

#pragma mark 创建UI
- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Classification", nil);

}

#pragma mark SGPageContentViewDelegare和SGPageTitleViewDelegate
- (void)SGPageContentView:(SGPageContentView *)SGPageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
   
}

- (void)SGPageTitleView:(SGPageTitleView *)SGPageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
    
}

#pragma mark ClassifyDetailViewControllerDetegate
- (void)selectAtIndexInClassifyDetailViewController:(CategoryModel *)model WithSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"ebay :%@",model.link);
//        if ([model.link isEqualToString:@"http://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_ff3=1&pub=5575490065&toolid=10001&campid=5338507482&customid=1&ipn=psmain&icep_vectorid=229466&kwid=902099&mtid=824&kw=lg"]) {
//            GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
//            shopDetail.hidesBottomBarWhenPushed = YES;
//            shopDetail.link = model.link;
//            shopDetail.websiteName = model.name;
//            shopDetail.websiteIntroductionStr = model.introduction;
//            shopDetail.isShowText = YES;
//            if (model.guide) {
//                shopDetail.guideMessage = model.guide;
//            }else{
//                int value = [self arc4random];
//                NSString * str = [NSString stringWithFormat:@"GlobalBuyer_LoadingView_message_%d",value];
//                shopDetail.guideMessage = NSLocalizedString(str, nil);
//            }
//            //        shopDetail.guideMessage = model.guide;
//            [self.navigationController pushViewController:shopDetail animated:YES];
//        }else{
            ShopDetailViewController *shopDetail = [ShopDetailViewController new];
            shopDetail.hidesBottomBarWhenPushed = YES;
            shopDetail.link = model.link;
            shopDetail.websiteName = model.name;
            shopDetail.websiteIntroductionStr = model.introduction;
            if (model.guide) {
                shopDetail.guideMessage = model.guide;
            }else{
                int value = [self arc4random];
                NSString * str = [NSString stringWithFormat:@"GlobalBuyer_LoadingView_message_%d",value];
                shopDetail.guideMessage = NSLocalizedString(str, nil);
            }
            [self.navigationController pushViewController:shopDetail animated:YES];
//        }
        
    }else{
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = model.link;
        shopDetail.websiteName = model.name;
        shopDetail.websiteIntroductionStr = model.introduction;
        if (model.guide) {
            shopDetail.guideMessage = model.guide;
        }else{
            int value = [self arc4random];
            NSString * str = [NSString stringWithFormat:@"GlobalBuyer_LoadingView_message_%d",value];
            shopDetail.guideMessage = NSLocalizedString(str, nil);
        }
//        shopDetail.guideMessage = model.guide;
        [self.navigationController pushViewController:shopDetail animated:YES];
    }
    
}
//10内随机数1和3不要
- (int)arc4random{
    int value = (arc4random() % 10) + 1;
    if (value == 1 || value == 3) {
        return 6;
    }
    return value;
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
