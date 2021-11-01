//
//  MineOrderViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/9.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "MineOrderViewController.h"
#import "AllOrderViewController.h"
#import "FirstOrderViewController.h"
#import "StorageOrderViewController.h"
#import "TailOrderViewController.h"
#import "GoodsOrderViewController.h"
@interface MineOrderViewController ()<UIScrollViewDelegate>
{
    NSArray * topArray;
    CGFloat W;//头部scrollview最大滑动距离
}
@property (nonatomic , strong) UIScrollView * topScrollView;

@property (nonatomic , strong) UIButton * allBtn;
@property (nonatomic , strong) UIImageView * allImg;
@property (nonatomic , strong) UIButton * firstBtn;
@property (nonatomic , strong) UIImageView * firstImg;
@property (nonatomic , strong) UIButton * storageBtn;
@property (nonatomic , strong) UIImageView * storageImg;
@property (nonatomic , strong) UIButton * tailBtn;
@property (nonatomic , strong) UIImageView * tailImg;
@property (nonatomic , strong) UIButton * goodsBtn;
@property (nonatomic , strong) UIImageView * goodsImg;

@property (nonatomic , strong) UIScrollView * scrollView;
@end

@implementation MineOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    W =0.0;
    // Do any additional setup after loading the view.
    topArray = @[@"全部订单",@"首款待付",@"待入仓",@"尾款待付",@"待收货"];
    [self creareUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [Unity getColor:@"#f0f0f0"];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)creareUI{
    [self.view addSubview:self.topScrollView];
    [self.view addSubview:self.scrollView];
    
    [self setupChildViewController];
    
    for (int i=0; i<5; i++) {
        [self showVc:i];
    }
    [self topTitleColor:self.tap];
    CGFloat offsetX = self.tap * SCREEN_WIDTH;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);

}
- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        for (int i=0; i<topArray.count; i++) {
            W = W+[Unity widthOfString:topArray[i] OfFontSize:15 OfHeight:[Unity countcoordinatesH:40]];
        }
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:40])];
        _topScrollView.delegate = self;
        _topScrollView.tag = 10000;
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.scrollEnabled = YES;
        _topScrollView.userInteractionEnabled = YES;
        _topScrollView.contentSize =  CGSizeMake(W+[Unity countcoordinatesW:160], 0);
        // 没有弹簧效果
//        _topScrollView.bounces = NO;
        // 隐藏水平滚动条
        _topScrollView.showsHorizontalScrollIndicator = NO;
        [_topScrollView addSubview:self.allBtn];
        [_topScrollView addSubview:self.firstBtn];
        [_topScrollView addSubview:self.storageBtn];
        [_topScrollView addSubview:self.tailBtn];
        [_topScrollView addSubview:self.goodsBtn];
    }
    return _topScrollView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _topScrollView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight-[Unity countcoordinatesH:40])];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, 0);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.tag = 10001;
        // 开启分页
        _scrollView.pagingEnabled = YES;
        // 没有弹簧效果
        _scrollView.bounces = NO;
        // 隐藏水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}
// 添加所有子控制器
- (void)setupChildViewController {
    
    AllOrderViewController *oneVC = [[AllOrderViewController alloc] init];
    [self addChildViewController:oneVC];
    
    FirstOrderViewController *twoVC = [[FirstOrderViewController alloc] init];
    [self addChildViewController:twoVC];
    
    StorageOrderViewController * sVC = [[StorageOrderViewController alloc]init];
    [self addChildViewController:sVC];
    
    TailOrderViewController * fVC = [[TailOrderViewController alloc]init];
    [self addChildViewController:fVC];
    
    GoodsOrderViewController * eVC = [[GoodsOrderViewController alloc]init];
    [self addChildViewController:eVC];
    
}
- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], 0, [Unity widthOfString:topArray[0] OfFontSize:15 OfHeight:[Unity countcoordinatesH:40]], [Unity countcoordinatesH:40])];
        [_allBtn setTitle:topArray[0] forState:UIControlStateNormal];
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_allBtn setTitleColor:[Unity getColor:@"#4b0e69"] forState:UIControlStateNormal];
        [_allBtn addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    
        _allImg = [Unity imageviewAddsuperview_superView:_allBtn _subViewFrame:CGRectMake(0, [Unity countcoordinatesH:38], _allBtn.width, [Unity countcoordinatesH:2]) _imageName:@"msgline" _backgroundColor:nil];
    }
    return _allBtn;
}
- (UIButton *)firstBtn{
    if (!_firstBtn) {
        _firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(_allBtn.right+[Unity countcoordinatesW:30], 0, [Unity widthOfString:topArray[1] OfFontSize:15 OfHeight:[Unity countcoordinatesH:40]], [Unity countcoordinatesH:40])];
        [_firstBtn setTitle:topArray[1] forState:UIControlStateNormal];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_firstBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        [_firstBtn addTarget:self action:@selector(firstClick) forControlEvents:UIControlEventTouchUpInside];
        
        _firstImg = [Unity imageviewAddsuperview_superView:_firstBtn _subViewFrame:CGRectMake(0, [Unity countcoordinatesH:38], _firstBtn.width, [Unity countcoordinatesH:2]) _imageName:@"msgline" _backgroundColor:nil];
        _firstImg.hidden=YES;
    }
    return _firstBtn;
}
- (UIButton *)storageBtn{
    if (!_storageBtn) {
        _storageBtn = [[UIButton alloc]initWithFrame:CGRectMake(_firstBtn.right+[Unity countcoordinatesW:30], 0, [Unity widthOfString:topArray[2] OfFontSize:15 OfHeight:[Unity countcoordinatesH:40]], [Unity countcoordinatesH:40])];
        [_storageBtn setTitle:topArray[2] forState:UIControlStateNormal];
        _storageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_storageBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        [_storageBtn addTarget:self action:@selector(storageClick) forControlEvents:UIControlEventTouchUpInside];
        
        _storageImg = [Unity imageviewAddsuperview_superView:_storageBtn _subViewFrame:CGRectMake(0, [Unity countcoordinatesH:38], _storageBtn.width, [Unity countcoordinatesH:2]) _imageName:@"msgline" _backgroundColor:nil];
        _storageImg.hidden=YES;
    }
    return _storageBtn;
}
- (UIButton *)tailBtn{
    if (!_tailBtn) {
        _tailBtn = [[UIButton alloc]initWithFrame:CGRectMake(_storageBtn.right+[Unity countcoordinatesW:30], 0, [Unity widthOfString:topArray[3] OfFontSize:15 OfHeight:[Unity countcoordinatesH:40]], [Unity countcoordinatesH:40])];
        [_tailBtn setTitle:topArray[3] forState:UIControlStateNormal];
        _tailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tailBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        [_tailBtn addTarget:self action:@selector(tailClick) forControlEvents:UIControlEventTouchUpInside];
        
        _tailImg = [Unity imageviewAddsuperview_superView:_tailBtn _subViewFrame:CGRectMake(0, [Unity countcoordinatesH:38], _tailBtn.width, [Unity countcoordinatesH:2]) _imageName:@"msgline" _backgroundColor:nil];
        _tailImg.hidden=YES;
    }
    return _tailBtn;
}
- (UIButton *)goodsBtn{
    if (!_goodsBtn) {
        _goodsBtn = [[UIButton alloc]initWithFrame:CGRectMake(_tailBtn.right+[Unity countcoordinatesW:30], 0, [Unity widthOfString:topArray[4] OfFontSize:15 OfHeight:[Unity countcoordinatesH:40]], [Unity countcoordinatesH:40])];
        [_goodsBtn setTitle:topArray[4] forState:UIControlStateNormal];
        _goodsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_goodsBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        [_goodsBtn addTarget:self action:@selector(goodsClick) forControlEvents:UIControlEventTouchUpInside];
        
        _goodsImg = [Unity imageviewAddsuperview_superView:_goodsBtn _subViewFrame:CGRectMake(0, [Unity countcoordinatesH:38], _goodsBtn.width, [Unity countcoordinatesH:2]) _imageName:@"msgline" _backgroundColor:nil];
        _goodsImg.hidden=YES;
    }
    return _goodsBtn;
}
// 显示控制器的view
- (void)showVc:(NSInteger)index {
    CGFloat offsetX = index * SCREEN_WIDTH;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight-[Unity countcoordinatesH:40]);
}
- (void)topTitleColor:(NSInteger)index{
    if (index == 0) {
        [self.allBtn setTitleColor:[Unity getColor:@"#4b0e69"] forState:UIControlStateNormal];
        self.allImg.hidden = NO;
        [self.firstBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.firstImg.hidden = YES;
        [self.storageBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.storageImg.hidden=YES;
        [self.tailBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.tailImg.hidden = YES;
        [self.goodsBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.goodsImg.hidden=YES;
    }else if (index == 1){
        [self.allBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.allImg.hidden = YES;
        [self.firstBtn setTitleColor:[Unity getColor:@"#4b0e69"] forState:UIControlStateNormal];
        self.firstImg.hidden = NO;
        [self.storageBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.storageImg.hidden=YES;
        [self.tailBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.tailImg.hidden = YES;
        [self.goodsBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.goodsImg.hidden=YES;
    }else if (index == 2){
        [self.allBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.allImg.hidden = YES;
        [self.firstBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.firstImg.hidden = YES;
        [self.storageBtn setTitleColor:[Unity getColor:@"#4b0e69"] forState:UIControlStateNormal];
        self.storageImg.hidden=NO;
        [self.tailBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.tailImg.hidden = YES;
        [self.goodsBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.goodsImg.hidden=YES;
    }else if (index == 3){
        [self.allBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.allImg.hidden = YES;
        [self.firstBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.firstImg.hidden = YES;
        [self.storageBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.storageImg.hidden=YES;
        [self.tailBtn setTitleColor:[Unity getColor:@"#4b0e69"] forState:UIControlStateNormal];
        self.tailImg.hidden = NO;
        [self.goodsBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.goodsImg.hidden=YES;
    }else{
        [self.allBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.allImg.hidden = YES;
        [self.firstBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.firstImg.hidden = YES;
        [self.storageBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.storageImg.hidden=YES;
        [self.tailBtn setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        self.tailImg.hidden = YES;
        [self.goodsBtn setTitleColor:[Unity getColor:@"#4b0e69"] forState:UIControlStateNormal];
        self.goodsImg.hidden=NO;
    }
}
//头部scrollview点击
- (void)topScrollView:(NSInteger)index{
    // 1 计算滚动的位置
    CGFloat offsetX = index * SCREEN_WIDTH;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 10001) {
        // 计算滚动到哪一页
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (index == 3) {
            [self.topScrollView setContentOffset:CGPointMake(W+[Unity countcoordinatesW:160]-kScreenW, 0) animated:YES];
            self.topScrollView.bouncesZoom = NO;
        }
        if (index == 1) {
            [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.topScrollView.bouncesZoom = NO;
        }
        // 1.添加子控制器view
        [self showVc:index];
        
        // 2.把对应的标题选中
        [self topTitleColor:index];
    }
}
//topsd事件
- (void)allClick{
    [self topTitleColor:0];
    [self topScrollView:0];
}
- (void)firstClick{
    [self topTitleColor:1];
    [self topScrollView:1];
    [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.topScrollView.bouncesZoom = NO;
}
- (void)storageClick{
    [self topTitleColor:2];
    [self topScrollView:2];
}
- (void)tailClick{
    [self topTitleColor:3];
    [self topScrollView:3];
    [self.topScrollView setContentOffset:CGPointMake(W+[Unity countcoordinatesW:160]-kScreenW, 0) animated:YES];
    self.topScrollView.bouncesZoom = NO;
}
- (void)goodsClick{
    [self topTitleColor:4];
    [self topScrollView:4];
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
