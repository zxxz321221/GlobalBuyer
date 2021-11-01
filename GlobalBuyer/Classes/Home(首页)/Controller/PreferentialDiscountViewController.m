//
//  PreferentialDiscountViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "PreferentialDiscountViewController.h"
#import "HomeDiscountCollectionViewCell.h"
#import "GlobalShopDetailViewController.h"
#import "ShopDetailViewController.h"
#import "PreferentialCollectionReusableView.h"

static NSString *head = @"PreferentialCollectionReusableView";
@interface PreferentialDiscountViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation PreferentialDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
- (void)createUI
{
    self.title = NSLocalizedString(@"GlobalBuyer_home_Preferential_activities", nil);
    self.view.backgroundColor = Cell_BgColor;
    [self.view addSubview:self.collectionView];
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        if (@available(iOS 11.0, *)) {
            flowLayout.estimatedItemSize = CGSizeMake(0, 0);
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH , kScreenW ,  kScreenH - kNavigationBarH - kStatusBarH  ) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = Cell_BgColor;
        [_collectionView registerClass:[HomeDiscountCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HomeDiscountCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.collectionView registerClass:[PreferentialCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:head];
        
    }
    return _collectionView;
}
#pragma mark ————————— Header的大小 size —————————————

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(kScreenW, 35);
    
}
#pragma mark ————————— 自定义分区头  —————————————

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PreferentialCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:head forIndexPath:indexPath];
        reusableView = header;
    }
    return reusableView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.discountDataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.discountDataSource[0] count];
    }else if (section == 1){
        return [self.discountDataSource[1] count];
    }
    return [self.discountDataSource[0] count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenW , 260);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeDiscountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeDiscountCollectionViewCell class])  forIndexPath:indexPath];
    
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebPictureApi,self.discountDataSource[indexPath.section][indexPath.row][@"pic"]]]];
    cell.titleLb.text = [NSString stringWithFormat:@"%@",self.discountDataSource[indexPath.section][indexPath.row][@"title"]];
    cell.subTitle.text = [NSString stringWithFormat:@"%@",self.discountDataSource[indexPath.section][indexPath.row][@"description"]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSString stringWithFormat:@"%@",self.discountDataSource[indexPath.section][indexPath.row][@"if_develop"]]isEqualToString:@"1"]) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = [NSString stringWithFormat:@"%@",self.discountDataSource[indexPath.section][indexPath.row][@"url"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = [NSString stringWithFormat:@"%@",self.discountDataSource[indexPath.section][indexPath.row][@"url"]];
        [self.navigationController pushViewController:shopDetail animated:YES];
    }
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
