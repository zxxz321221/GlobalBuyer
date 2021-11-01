//
//  AppDelegate+RootController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "MineViewController.h"
#import "ClassifyGoodsViewController.h"
#import "TabBarController.h"
#import "NavigationController.h"
#import "HelpViewController.h"
#import "MyViewController.h"
#import "ReceivingAreaViewController.h"
#import "NewMessageViewController.h"
@implementation AppDelegate (RootController)
- (void)setAppWindows {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

#pragma mark 货币选择界面
- (void)setRootViewController{
        CurrencyViewController *currencyVC = [[CurrencyViewController alloc]init];
        currencyVC.delegate = self;
        self.window.rootViewController = currencyVC;
}
    
#pragma mark - 引导页
- (void)createLoadingScrollView{
    //引导页
    UIScrollView *pageSc = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    pageSc.pagingEnabled = YES;
    pageSc.bounces = NO;
    pageSc.delegate = self;
    pageSc.showsHorizontalScrollIndicator = NO;
    pageSc.showsVerticalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:pageSc];

    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);

    
    NSArray *arr;
    
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        arr = @[@"guide1-j.png",@"guide2-j.png",@"guide3-j.png",@"guide4-j.png"];
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        arr = @[@"guide1-f.png",@"guide2-f.png",@"guide3-f.png",@"guide4-f.png"];
    }else if([currentLanguage isEqualToString:@"en"]){
        arr = @[@"guide1-en.png",@"guide2-en.png",@"guide3-en.png",@"guide4-en.png"];
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        arr = @[@"guide1-jp.png",@"guide2-jp.png",@"guide3-jp.png",@"guide4-jp.png"];
    }else{
        arr = @[@"guide1-j.png",@"guide2-j.png",@"guide3-j.png",@"guide4-j.png"];
    }
    
    for (NSInteger i = 0; i<arr.count; i++){
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, self.window.frame.size.height)];
        img.image = [UIImage imageNamed:arr[i]];
        [pageSc addSubview:img];
        img.userInteractionEnabled = YES;
        if (i < arr.count - 1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goNextPage:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            img.userInteractionEnabled = YES;
            [img addGestureRecognizer:tap];
        }
        if (i == arr.count - 1){
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake((self.window.frame.size.width)-40, 30, 30, 30);
//            btn.titleLabel.font = [UIFont systemFontOfSize:12];
//            [btn setTitle:NSLocalizedString(@"GlobalBuyer_Close", nil) forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
//            [img addSubview:btn];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            //btn.layer.cornerRadius = 15;
//            btn.layer.borderWidth = 1;
//            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToMain)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            img.userInteractionEnabled = YES;
            [img addGestureRecognizer:tap];
            
            
        }
    }
    pageSc.contentSize = CGSizeMake(kScreenW*arr.count, self.window.frame.size.height);
}

- (void)goNextPage:(UITapGestureRecognizer *)tap
{
    UIScrollView *tmpSv = (UIScrollView *)[[tap view] superview];
    [UIView animateWithDuration:0.5 animations:^{
        tmpSv.contentOffset = CGPointMake(tmpSv.contentOffset.x+kScreenW, 0);
    }];
    
}
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>kScreenW *4+30){
        [self goToMain];
    }
}

#pragma mark 进人主页
- (void)goToMain{
    ReceivingAreaViewController *vc = [[ReceivingAreaViewController alloc]init];
    self.window.rootViewController = vc;
    
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user setObject:@"isOne" forKey:@"isOne"];
//        [user synchronize];
//        [self setRoot];
        //self.window.rootViewController = self.viewController;
}

- (void)setRoot {
  
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    homeVC.tabBarItem.title = NSLocalizedString(@"GlobalBuyer_Homepage", nil);
    homeVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_home"];
    NavigationController *homeNaVC = [[NavigationController alloc]initWithRootViewController:homeVC];
    
    ClassifyGoodsViewController *classifyVC = [ClassifyGoodsViewController new];
    classifyVC.tabBarItem.title = NSLocalizedString(@"GlobalBuyer_Classification", nil);
    classifyVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_classify"];
    NavigationController *classifyNaVC = [[NavigationController alloc]initWithRootViewController:classifyVC];
    
//    NewMessageViewController * msgVC = [[NewMessageViewController alloc]init];
//    msgVC.tabBarItem.title = @"消息";
//    msgVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_help"];
//    NavigationController *msgNaVC = [[NavigationController alloc]initWithRootViewController:msgVC];
    
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    shoppingCartVC.tabBarItem.title = NSLocalizedString(@"GlobalBuyer_ShoppingCart", nil);
    shoppingCartVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_shopCar"];
    NavigationController *shoppingCartNaVC = [[NavigationController alloc]initWithRootViewController:shoppingCartVC];
    
//    MyViewController *mineVC = [[MyViewController alloc]init];
    MineViewController *mineVC = [[MineViewController alloc]init];
    mineVC.tabBarItem.title = NSLocalizedString(@"GlobalBuyer_My", nil);
    mineVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_mine"];
    NavigationController *mineNaVC = [[NavigationController alloc]initWithRootViewController:mineVC];
    
//    MyViewController *helpVC = [[MyViewController alloc]init];
//    MineViewController *helpVC = [[MineViewController alloc]init];
    HelpViewController *helpVC = [[HelpViewController alloc]init];
    helpVC.tabBarItem.title = NSLocalizedString(@"GlobalBuyer_Help", nil);
    helpVC.tabBarItem.image = [UIImage imageNamed:@"tabBar_help"];
    NavigationController *helpNaVC = [[NavigationController alloc]initWithRootViewController:helpVC];
    
    NSArray *vcArr = @[homeNaVC,classifyNaVC,shoppingCartNaVC,mineNaVC,helpNaVC];
    TabBarController *tabBarVC = [[TabBarController alloc]init];
    tabBarVC.viewControllers = vcArr;
    self.window.rootViewController = tabBarVC;
}

#pragma mark 判断是否是第一次安装
-(void)gotoHomeVC{
    NSLog(@"%@",[UserDefault objectForKey:@"isOne"]);
    if ([UserDefault objectForKey:@"isOne"])
    {
        //不是第一次安装
        //[self checkBlack];
        [self setRoot];
    } else {
        UIViewController *emptyView = [[ UIViewController alloc ]init ];
        self. window .rootViewController = emptyView;
        [self createLoadingScrollView];
    }
    
}
@end
