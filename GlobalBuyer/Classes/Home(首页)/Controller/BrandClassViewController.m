//
//  BrandClassViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "BrandClassViewController.h"
#import "BrandViewController.h"
#import "NewSearchViewController.h"
@interface BrandClassViewController ()
@property (nonatomic,strong) UIView * navV;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIButton * classBtn;
@property (nonatomic, strong) UIButton * brandBtn;
@property (nonatomic, strong) UILabel * classLine;
@property (nonatomic, strong) UILabel * brandLine;

@property NSInteger pageIndex;
@end

@implementation BrandClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, NavBarHeight)];
    _navV.backgroundColor = Main_Color;
    [self.view addSubview:_navV];
    [self createBackBtn];
    [self createPageBtn];
    
    // 1.添加所有子控制器
    [self setupChildViewController];

    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, NavBarHeight, kScreenW, kScreenH-NavBarHeight);
    _mainScrollView.contentSize = CGSizeMake(kScreenW * _titles.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
//    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];

    //默认
    NewSearchViewController *nvc = [[NewSearchViewController alloc] init];
    [self.mainScrollView addSubview:nvc.view];

    /*方式默认子controller首次进入时不执行  加上这个就OK了*/
    [self showVc:0];
    
    [self switchBtn_color:1];
}
- (void)createBackBtn{
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, StatusBarHeight+11, 22, 22)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_navV addSubview:backBtn];
}
- (void)createPageBtn{
    _classBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-176)/2, StatusBarHeight, 88, 44)];
    [_classBtn setTitle:NSLocalizedString(@"GlobalBuyer_Home_Brand_Classification", nil) forState:UIControlStateNormal];
    
    [_classBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_classBtn addTarget:self action:@selector(classButton) forControlEvents:UIControlEventTouchUpInside];
    [_navV addSubview:_classBtn];
    _classLine = [[UILabel alloc]initWithFrame:CGRectMake(24, 39, 40, 1)];
    _classLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    [_classBtn addSubview:_classLine];
    
    _brandBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-176)/2+88, StatusBarHeight, 88, 44)];
    [_brandBtn setTitle:NSLocalizedString(@"GlobalBuyer_Home_Brand_Brand", nil) forState:UIControlStateNormal];
    [_brandBtn addTarget:self action:@selector(brandButton) forControlEvents:UIControlEventTouchUpInside];
    [_navV addSubview:_brandBtn];
    _brandLine = [[UILabel alloc]initWithFrame:CGRectMake(24, 39, 40, 1)];
    _brandLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    _brandLine.hidden = YES;
    [_brandBtn addSubview:_brandLine];
}
- (void)switchBtn_color:(NSInteger)tag{
    if (tag == 1) {
        [_classBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
        _classLine.hidden = NO;
        [_brandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _brandLine.hidden = YES;
    }else{
        [_classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _classLine.hidden = YES;
        [_brandBtn setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1] forState:UIControlStateNormal];
        _brandLine.hidden = NO;
    }
}
- (void)classButton{
    self.pageIndex = 0;
    [self switchBtn_color:1];
    // 1 计算滚动的位置
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    // 2.给对应位置添加对应子控制器
    [self showVc:0];
}
- (void)brandButton{
    self.pageIndex = 1;
    [self switchBtn_color:2];
    // 1 计算滚动的位置
    self.mainScrollView.contentOffset = CGPointMake(kScreenW, 0);
    // 2.给对应位置添加对应子控制器
    [self showVc:1];
}
- (void)back:(UIButton *)btn{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"123123");
    self.mainScrollView.contentOffset = CGPointMake(kScreenW*self.pageIndex, 0);
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.mainScrollView.contentOffset = CGPointMake(kScreenW*self.pageIndex, 0);
}

// 添加所有子控制器
- (void)setupChildViewController {
    // 分类
    NewSearchViewController *nvc = [[NewSearchViewController alloc] init];
    [self addChildViewController:nvc];

    // 品牌
    BrandViewController *bvc = [[BrandViewController alloc] init];
    [self addChildViewController:bvc];
}
// 显示控制器的view
- (void)showVc:(NSInteger)index {
    self.pageIndex = index;
    CGFloat offsetX = index * self.view.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];

    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;

    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, kScreenW, kScreenH);
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
