//
//  MyViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/13.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MyViewController.h"
#import "MyViewCollectionViewCell.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "JPhotoMagenage.h"
#import "NoPayViewController.h"
#import "ProcurementViewController.h"
#import "AuditStatusViewController.h"
#import "AlreadyShippedViewController.h"
#import "TaobaoLogisticsNumberViewController.h"
#import "TaobaoPackViewController.h"
#import "CouponViewController.h"
#import "CollectionViewController.h"
#import "AddressViewController.h"
#import "PurseViewController.h"
#import "AwaitingDeliveryViewController.h"
#import "PersonalCenterViewController.h"
#import "FootprintViewController.h"
#import "SetViewController.h"
#import "MineOrderViewController.h"
#import "BindViewController.h"
#import "Help_CustomerViewController.h"
NSString *const kMyViewOrderCellID = @"kMyViewOrderCellID";
NSString *const kMyViewTaobaoCellID = @"kMyViewTaobaoCellID";
NSString *const kMyViewServiceCellID = @"kMyViewServiceCellID";
@interface MyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,SetViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic , strong) UIView * navView;
@property (nonatomic , strong) UILabel * navLabel;

@property (nonatomic,strong)UIView * headerView;//头部view
@property (nonatomic,strong)UIView * orderView;//我的订单view
@property (nonatomic,strong)UIView * taobaoView;//淘宝转运view
@property (nonatomic,strong)UIView * partnerView;//合伙人view
@property (nonatomic,strong)UIView * serviceView;//我的服务view

//@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)UIImageView * headImageView;//头像
@property (nonatomic,strong)UIButton * loginBtn;//登录按钮
@property (nonatomic,strong)UILabel * nameL;//姓名
@property (nonatomic,strong)UILabel * EmailL;//邮箱

@property (nonatomic,strong)NSMutableArray * orderList;//我的订单数组
@property (nonatomic,strong)NSMutableArray * taobaoList;//淘宝转运数组
@property (nonatomic,strong)NSMutableArray * serviceList;//我的服务数组
@property (nonatomic,strong)UICollectionView * orderCollection;//我的订单collection
@property (nonatomic,strong)UICollectionView * taobaoCollection;//淘宝转运collection
@property (nonatomic, strong)UserModel *model;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Unity getColor:@"#f0f0f0"];
    [self setupUI];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.navLabel];
}
- (void)setupUI{
    _scrollView = [UIScrollView new];
    _scrollView.delegate=self;
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setHeaderView];
    [self setOrderView];
    [self setTaobaoView];
    [self setpartnerView];
    [self setServiceView];
    
//    self.serviceView.frame = CGRectMake(0, _taobaoView.bottom+[Unity countcoordinatesH:7], kScreenW, Unity conh)
    /*将ui添加到scrollView数组中*/
    [self.scrollView sd_addSubviews:@[_headerView,_orderView,_taobaoView,_serviceView]];
    
    // scrollview自动contentsize
    [self.scrollView setupAutoContentSizeWithBottomView:_serviceView bottomMargin:0];
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, NavBarHeight)];
        _navView.backgroundColor = Main_Color;
        _navView.alpha = 0.01;
    }
    return _navView;
}
- (UILabel *)navLabel{
    if (!_navLabel) {
        _navLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-100)/2, StatusBarHeight, 100, 44)];
        _navLabel.text = NSLocalizedString(@"GlobalBuyer_My", nil);
        _navLabel.textColor = [UIColor whiteColor];
        _navLabel.textAlignment = NSTextAlignmentCenter;
        _navLabel.font = [UIFont systemFontOfSize:17];
    }
    return _navLabel;
}
- (void)setHeaderView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:240])];
    _headerView.userInteractionEnabled = YES;
    _headerView.backgroundColor = [UIColor whiteColor];
    UILabel * backLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:150])];
    CAGradientLayer *layerG = [CAGradientLayer new];
    layerG.colors=@[(__bridge id)[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
    layerG.startPoint = CGPointMake(0.5, 0);
    layerG.endPoint = CGPointMake(0.5, 1);
    layerG.frame = backLabel.bounds;
    [backLabel.layer addSublayer:layerG];
    [_headerView addSubview:backLabel];
    
    _headImageView = [Unity imageviewAddsuperview_superView:_headerView _subViewFrame:CGRectMake((kScreenW-100)/2, [Unity countcoordinatesH:105], 100, 100) _imageName:@"我的头像" _backgroundColor:nil];
    _headImageView.layer.cornerRadius = 100/2;
    _headImageView.clipsToBounds = YES;
    UITapGestureRecognizer *singleTap =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerAction)];
    singleTap.numberOfTapsRequired = 1; //点击次数
    singleTap.numberOfTouchesRequired = 1; //点击手指数
    [_headImageView addGestureRecognizer:singleTap];
    _headImageView.userInteractionEnabled = YES;
    
    UIImageView * xjImgView = [Unity imageviewAddsuperview_superView:_headerView _subViewFrame:CGRectMake(_headImageView.right-[Unity countcoordinatesH:25], _headImageView.bottom-[Unity countcoordinatesH:25], [Unity countcoordinatesH:25], [Unity countcoordinatesH:25]) _imageName:@"相机" _backgroundColor:nil];
    
    _loginBtn = [Unity buttonAddsuperview_superView:_headerView _subViewFrame:CGRectMake(_headImageView.left, xjImgView.bottom+10, _headImageView.width, [Unity countcoordinatesH:20]) _tag:self _action:@selector(loginClick) _string:NSLocalizedString(@"GlobalBuyer_My_Login", nil) _imageName:@""];
    [_loginBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
    
    _nameL = [Unity lableViewAddsuperview_superView:_headerView _subViewFrame:CGRectMake(_headImageView.left, _headImageView.bottom+[Unity countcoordinatesH:5], _headImageView.width, [Unity countcoordinatesH:20]) _string:@"" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    _nameL.hidden = YES;

    _EmailL = [Unity lableViewAddsuperview_superView:_headerView _subViewFrame:CGRectMake(0, _nameL.bottom, kScreenW, [Unity countcoordinatesH:10]) _string:@"" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
    _EmailL.hidden = YES;
    
}
- (void)setOrderView{
    _orderView = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.bottom, kScreenW, [Unity countcoordinatesH:120])];
    _orderView.backgroundColor = [UIColor whiteColor];
    UILabel * orderL = [Unity lableViewAddsuperview_superView:_orderView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]) _string:NSLocalizedString(@"GlobalBuyer_MyView_orderView_order", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
    UIImageView * nextImg = [Unity imageviewAddsuperview_superView:_orderView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:12], orderL.top+[Unity countcoordinatesH:5], [Unity countcoordinatesW:7], [Unity countcoordinatesH:10]) _imageName:@"箭头" _backgroundColor:nil];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(kScreenW/4, [Unity countcoordinatesH:70]);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    self.orderCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, orderL.bottom+[Unity countcoordinatesH:10], kScreenW,[Unity countcoordinatesH:70]) collectionViewLayout:layout];
    self.orderCollection.backgroundColor = [UIColor whiteColor];
    self.orderCollection.tag = 10001;
    self.orderCollection.delegate = self;
    self.orderCollection.dataSource = self;
    self.orderCollection.scrollsToTop = NO;
    self.orderCollection.showsVerticalScrollIndicator = NO;
    self.orderCollection.showsHorizontalScrollIndicator = NO;
    [self.orderCollection registerClass:[MyViewCollectionViewCell class] forCellWithReuseIdentifier:kMyViewOrderCellID];
    
    [_orderView addSubview:self.orderCollection];
    
}
- (void)setTaobaoView{
    _taobaoView = [[UIView alloc]initWithFrame:CGRectMake(0, _orderView.bottom+[Unity countcoordinatesH:7], kScreenW, [Unity countcoordinatesH:120])];
    _taobaoView.backgroundColor = [UIColor whiteColor];
    UILabel * orderL = [Unity lableViewAddsuperview_superView:_taobaoView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]) _string:NSLocalizedString(@"GlobalBuyer_MyView_taobaoView_taobao", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
    UIImageView * nextImg = [Unity imageviewAddsuperview_superView:_taobaoView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:12], orderL.top+[Unity countcoordinatesH:5], [Unity countcoordinatesW:7], [Unity countcoordinatesH:10]) _imageName:@"箭头" _backgroundColor:nil];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(kScreenW/4, [Unity countcoordinatesH:70]);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    self.taobaoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, orderL.bottom+[Unity countcoordinatesH:10], kScreenW,[Unity countcoordinatesH:70]) collectionViewLayout:layout];
    self.taobaoCollection.backgroundColor = [UIColor whiteColor];
    self.taobaoCollection.tag = 10002;
    self.taobaoCollection.delegate = self;
    self.taobaoCollection.dataSource = self;
    self.taobaoCollection.scrollsToTop = NO;
    self.taobaoCollection.showsVerticalScrollIndicator = NO;
    self.taobaoCollection.showsHorizontalScrollIndicator = NO;
    [self.taobaoCollection registerClass:[MyViewCollectionViewCell class] forCellWithReuseIdentifier:kMyViewTaobaoCellID];
    
    [_taobaoView addSubview:self.taobaoCollection];
}
- (void)setpartnerView{
    _partnerView = [[UIView alloc]initWithFrame:CGRectMake(0, _taobaoView.bottom+[Unity countcoordinatesH:7], kScreenW, [Unity countcoordinatesH:100])];
    _partnerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * orderL = [Unity lableViewAddsuperview_superView:_partnerView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]) _string:NSLocalizedString(@"GlobalBuyer_MyView_partnerView_partner", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
    UIImageView * nextImg = [Unity imageviewAddsuperview_superView:_partnerView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:12], orderL.top+[Unity countcoordinatesH:5], [Unity countcoordinatesW:7], [Unity countcoordinatesH:10]) _imageName:@"箭头" _backgroundColor:nil];
    UIImageView * partnerImg = [Unity imageviewAddsuperview_superView:_partnerView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], orderL.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:10], [Unity countcoordinatesH:50]) _imageName:@"" _backgroundColor:[UIColor yellowColor]];
    partnerImg.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    //为图片添加手势
    [partnerImg addGestureRecognizer:singleTap];
}
- (void)setServiceView{
    _serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, _taobaoView.bottom+[Unity countcoordinatesH:7], kScreenW, [Unity countcoordinatesH:260])];
    _serviceView.backgroundColor = [UIColor whiteColor];
    UILabel * orderL = [Unity lableViewAddsuperview_superView:_serviceView _subViewFrame:CGRectMake([Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]) _string:NSLocalizedString(@"GlobalBuyer_MyView_serviceView_service", nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
    UIImageView * nextImg = [Unity imageviewAddsuperview_superView:_serviceView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:12], orderL.top+[Unity countcoordinatesH:5], [Unity countcoordinatesW:7], [Unity countcoordinatesH:10]) _imageName:@"箭头" _backgroundColor:nil];

    for (int i=0; i<self.serviceList.count; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:_serviceView _subViewFrame:CGRectMake((i%4)*(kScreenW/4), (orderL.bottom+[Unity countcoordinatesH:10])+(i/4*[Unity countcoordinatesH:70]), kScreenW/4, [Unity countcoordinatesH:70]) _tag:self _action:@selector(btnClick:) _string:@"" _imageName:@""];
        btn.tag = 20000+i;
        UIImageView * imageView = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake((btn.width-[Unity countcoordinatesH:30])/2, [Unity countcoordinatesH:15], [Unity countcoordinatesH:30], [Unity countcoordinatesH:30]) _imageName:self.serviceList[i][@"icon"] _backgroundColor:nil];
        UILabel * nameL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(0, imageView.bottom+[Unity countcoordinatesH:5], btn.width, [Unity countcoordinatesH:20]) _string:self.serviceList[i][@"name"] _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
    }
    
}
- (void)btnClick:(UIButton *)btn{
    if (![self chenkUserLogin]) {
        [self loginClick];
        return;
    }
    switch (btn.tag) {
        case 20000://钱包
        {
            PurseViewController * purseVC = [[PurseViewController alloc]init];
            purseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:purseVC animated:YES];
        }
            break;
        case 20001://优惠券
        {
            CouponViewController *couponVC = [[CouponViewController alloc]init];
            couponVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case 20002://收藏
        {
            CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
            collectionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
        case 20003://足迹
        {
            FootprintViewController * bvc = [[FootprintViewController alloc]init];
            bvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bvc animated:YES];
        }
            break;
        case 20004://邀请好友
        {
            MineOrderViewController * mvc = [MineOrderViewController new];
            mvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 20005://地址
        {
            AddressViewController *addressVC = [AddressViewController new];
            addressVC.istrue = NO;
            addressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
            break;
        case 20006://售后服务
        {
            AwaitingDeliveryViewController *awaitingVC = [[AwaitingDeliveryViewController alloc]init];
            awaitingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:awaitingVC animated:YES];
        }
            break;
        case 20007://帮助与客服
            {
                Help_CustomerViewController * hvc = [[Help_CustomerViewController alloc]init];
                hvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:hvc animated:YES];
            }
            break;
        case 20008://设置
        {
            SetViewController * svc = [[SetViewController alloc]init];
            svc.delegate = self;
            svc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 20009://账号绑定
        {
            BindViewController * svc = [[BindViewController alloc]init];
            svc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UI                                                                                                                                                                                                                                                                                                                                                                                                                                                                      CollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 10001) {
        return self.orderList.count;
    }else if(collectionView.tag == 10002){
        return self.taobaoList.count;
    }
    return 1;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 10001) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:kMyViewOrderCellID forIndexPath:indexPath];
    }else if (collectionView.tag == 10002){
        return [collectionView dequeueReusableCellWithReuseIdentifier:kMyViewTaobaoCellID forIndexPath:indexPath];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMyViewOrderCellID forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 10001) {
        [(MyViewCollectionViewCell *)cell configureCellWithImagePath:self.orderList[indexPath.row][@"icon"] WithBusinessName:self.orderList[indexPath.row][@"name"] WithCornerNum:self.orderList[indexPath.row][@"corner"]];
    }else if(collectionView.tag == 10002){
        [(MyViewCollectionViewCell *)cell configureCellWithImagePath:self.taobaoList[indexPath.row][@"icon"] WithBusinessName:self.taobaoList[indexPath.row][@"name"] WithCornerNum:self.taobaoList[indexPath.row][@"corner"]];
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![self chenkUserLogin]) {
        [self loginClick];
        return;
    }
    if (collectionView.tag == 10001) {
        switch (indexPath.row) {
            case 0:
            {
                NoPayViewController *nopayVC = [[NoPayViewController alloc]init];
                nopayVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:nopayVC animated:YES];
            }
                break;
            case 1:
            {
                ProcurementViewController *procurementVC = [[ProcurementViewController alloc]init];
                procurementVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:procurementVC animated:YES];
            }
                break;
            case 2:
            {
                AuditStatusViewController *auditVC =[[AuditStatusViewController alloc]init];
                auditVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:auditVC animated:YES];
            }
                break;
            case 3:
            {
                AlreadyShippedViewController *alreadySVC = [[AlreadyShippedViewController alloc]init];
                alreadySVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:alreadySVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (collectionView.tag ==10002){
        switch (indexPath.row) {
            case 0:
            {
                TaobaoLogisticsNumberViewController *vc = [[TaobaoLogisticsNumberViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                TaobaoPackViewController *vc = [[TaobaoPackViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                AuditStatusViewController *auditVC =[[AuditStatusViewController alloc]init];
                auditVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:auditVC animated:YES];
            }
                break;
            case 3:
            {
                AlreadyShippedViewController *alreadySVC = [[AlreadyShippedViewController alloc]init];
                alreadySVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:alreadySVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);;
    NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
    self.model = [[UserModel alloc]initWithDictionary:dict error:nil];
    
    NSLog(@"dic = %@",dict);
    if (userToken) {
        _loginBtn.hidden = YES;
        _nameL.hidden = NO;
        _EmailL.hidden = NO;
        if ([self.model.fullname isEqualToString: @""] || !self.model.fullname) {
            _nameL.text = @"未命名";
        }else{
            _nameL.text = self.model.fullname;
            _EmailL.text = self.model.email;
        }
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"]) {
            [self.headImageView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"] placeholderImage:[UIImage imageNamed:@"我的头像"]];
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"DistributorBoss"]isEqualToString:@"true"]) {
            self.serviceView.frame = CGRectMake(0, _partnerView.bottom+[Unity countcoordinatesH:7], kScreenW, [Unity countcoordinatesH:260]);
            /*将ui添加到scrollView数组中*/
            [self.scrollView sd_addSubviews:@[_headerView,_orderView,_taobaoView,_partnerView,_serviceView]];
            // scrollview自动contentsize
            [self.scrollView setupAutoContentSizeWithBottomView:_serviceView bottomMargin:0];
        }
        [self downLoadNumOfGoods];
    }else{
        _loginBtn.hidden = NO;
        _nameL.hidden = YES;
        _EmailL.hidden = YES;
    }
}
- (void)downLoadNumOfGoods
{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:GetAllStateGoodsApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSArray * orderList = @[
                               @{@"name":@"待付定金", @"icon":@"定金",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"payWaitOrder"]]},
                               @{@"name":@"商品采购", @"icon":@"采购",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"buyWaitProduct"]]},
                               @{@"name":@"待付尾款", @"icon":@"订单待付尾款",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"payWaitPackage"]]},
                               @{@"name":@"待确认收货", @"icon":@"订单待确认收货",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"completePackage"]]}];
            _orderList = [NSMutableArray arrayWithArray:orderList];
            NSArray * taobaoList = @[
                                     @{@"name":@"待填快递单号", @"icon":@"待填快递单号",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"updateExpressProducts"]]},
                                     @{@"name":@"淘宝集货仓", @"icon":@"淘宝集货仓",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"transportStoragePackage"]]},
                                     @{@"name":@"待付尾款", @"icon":@"淘宝待付尾款",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"payWaitPackage"]]},
                                     @{@"name":@"待确认收货", @"icon":@"淘宝待确认收货",@"corner":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"completePackage"]]}];
            _taobaoList = [NSMutableArray arrayWithArray:taobaoList];
            [self.orderCollection reloadData];
            [self.taobaoCollection reloadData];
        }
        
        //[self judgeVipMember];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self judgeVipMember];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
//头像点击事件
-(void)headerAction
{
    NSLog(@"1");
    if (![self chenkUserLogin]) {
        return;
    }
    PersonalCenterViewController * pvc = [[PersonalCenterViewController alloc]init];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
}
//登录
- (void)loginClick{
    LoginViewController *loginVC = [LoginViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
//合伙人图片点击事件
- (void)singleTapAction:(UITapGestureRecognizer *)btn{
    
}
-(NSMutableArray *)orderList{
    if(_orderList == nil){
        _orderList = [NSMutableArray new];
        NSArray * arr =  @[
                        @{@"name":@"待付定金", @"icon":@"定金",@"corner":@"0"},
                        @{@"name":@"商品采购", @"icon":@"采购",@"corner":@"0"},
                        @{@"name":@"待付尾款", @"icon":@"订单待付尾款",@"corner":@"0"},
                        @{@"name":@"待确认收货", @"icon":@"订单待确认收货",@"corner":@"0"}];
        _orderList = [NSMutableArray arrayWithArray:arr];
    }
    return _orderList;
}
-(NSMutableArray *)taobaoList{
    if(_taobaoList == nil){
        _taobaoList = [NSMutableArray new];
        NSArray * arr = @[
                       @{@"name":@"待填快递单号", @"icon":@"待填快递单号",@"corner":@"0"},
                       @{@"name":@"淘宝集货仓", @"icon":@"淘宝集货仓",@"corner":@"0"},
                       @{@"name":@"待付尾款", @"icon":@"淘宝待付尾款",@"corner":@"0"},
                       @{@"name":@"待确认收货", @"icon":@"淘宝待确认收货",@"corner":@"0"}];
        _taobaoList = [NSMutableArray arrayWithArray:arr];
    }
    return _taobaoList;
}
-(NSMutableArray *)serviceList{
    if(_serviceList == nil){
        _serviceList = [NSMutableArray new];
        NSArray * arr = @[
                       @{@"name":@"钱包", @"icon":@"我的钱包"},
                       @{@"name":@"优惠券", @"icon":@"我的优惠券"},
                       @{@"name":@"收藏", @"icon":@"我的收藏"},
                       @{@"name":@"足迹", @"icon":@"我的足迹"},
                       @{@"name":@"邀请好友", @"icon":@"我的邀请"},
                       @{@"name":@"地址", @"icon":@"我的地址"},
                       @{@"name":@"售后服务", @"icon":@"我的售后服务"},
                       @{@"name":@"帮助与客服", @"icon":@"我的客服"},
                       @{@"name":@"设置", @"icon":@"我的设置"},
                       @{@"name":@"账号绑定", @"icon":@"绑定"}];
        _serviceList = [NSMutableArray arrayWithArray:arr];
    }
    return _serviceList;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //禁止  scrollView下拉
    CGPoint offset = _scrollView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    _scrollView.contentOffset = offset;
    
    CGFloat maxAlphaOffset = [Unity countcoordinatesH:100];
    CGFloat offset1 = scrollView.contentOffset.y;
    CGFloat alpha = offset1/maxAlphaOffset;
    if (alpha<=0) {
        alpha = 0;
    }else if(alpha >=0.99){
        alpha = 0.99;
    }
    self.navView.alpha = alpha;
}
- (void)loadMyPage{
    self.headImageView.image = [UIImage imageNamed:@"我的头像"];
    [self downLoadNumOfGoods];
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
