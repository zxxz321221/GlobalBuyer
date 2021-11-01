//
//  InterestViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/23.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "InterestViewController.h"
#import "InterestCell.h"
#import "InterestReusableView.h"
#define ICellIdentifier @"CellIdentifier"
@interface InterestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray * arr;
}
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic , strong) UIButton * confirmBtn;

@end

@implementation InterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = @[@"母婴用品",@"床上用品",@"个人护理",@"护肤美妆",@"3C数码",@"保健食品",@"运动户外",@"服装靴鞋",@"宠物用品",@"箱包差旅",@"家具家饰",@"餐厨用品",@"日用日化",@"时尚配饰",@"小家电",@"车载用品",@"动漫游戏",@"旅行必备",@"内衣裤袜",@"收纳清洁",@"园艺农业",@"休闲零食",@"茶酒冲饮",@"家装工具",@"文具办公",@"手工DIY",@"益智玩具"];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"感兴趣的分类";
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREEN_WIDTH / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)createUI{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.confirmBtn];
}
- (UIButton *)confirmBtn{
    if (_confirmBtn == nil) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], SCREEN_HEIGHT-NavBarHeight-[Unity countcoordinatesH:60], SCREEN_WIDTH-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.cornerRadius = [Unity countcoordinatesH:20];
        _confirmBtn.layer.borderColor = [[Unity getColor:@"#b445c8"] CGColor];
        _confirmBtn.layer.borderWidth = 1.0f;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_confirmBtn setTitleColor:[Unity getColor:@"#b445c8"] forState:UIControlStateNormal];
    }
    return _confirmBtn;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight-[Unity countcoordinatesH:70]) collectionViewLayout:self.flowLayout];
        self.flowLayout.minimumLineSpacing = 10;
        self.flowLayout.minimumInteritemSpacing = 0;
        if (@available(iOS 9.0, *)) {
            self.flowLayout.sectionHeadersPinToVisibleBounds = true;
        } else {
            // Fallback on earlier versions
        }
        //设置header大小
        self.flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, [Unity countcoordinatesH:50]);
        
        self.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3,[Unity countcoordinatesH:120]);
        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = YES;//允许多选
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[InterestCell class] forCellWithReuseIdentifier:ICellIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[InterestReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"InterestReusableView"];
        
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 27;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ICellIdentifier forIndexPath:indexPath];
    [cell configWithOfIcon:arr[indexPath.row] WithOfName:arr[indexPath.row]];
    if (cell.isSelected) {
        
        cell.maskV.hidden=NO;//选中
        
    }else{
        
        cell.maskV.hidden=YES;//未选中
        
    }
    
    return cell;
}

#pragma mark -

//collView学名是集合视图  tableView是表视图

//collView中的foot header 是曽补视图



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    InterestReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"InterestReusableView" forIndexPath:indexPath];
    
    reusableView.backgroundColor = [UIColor whiteColor];
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据idenxPath获取对应的cell
    InterestCell *cell = (InterestCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.maskV.hidden=NO;//选中
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    InterestCell *cell = (InterestCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.maskV.hidden=YES;//未选中
}
//确定
- (void)confirmClick{
    
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
