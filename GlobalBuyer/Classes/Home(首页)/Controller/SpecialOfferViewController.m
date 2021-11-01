//
//  SpecialOfferViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/23.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "SpecialOfferViewController.h"
#import "ShopDetailViewController.h"
#import "GlobalShopDetailViewController.h"
#import "HomeSpecialOfferCollectionViewCell.h"

@interface SpecialOfferViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation SpecialOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI
{
    self.title = NSLocalizedString(@"GlobalBuyer_home_bargainGoods", nil);
    self.view.backgroundColor = Cell_BgColor;
    [self.view addSubview:self.collectionView];
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH , kScreenW ,  kScreenH - kNavigationBarH - kStatusBarH  ) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = Cell_BgColor;
        [_collectionView registerClass:[HomeSpecialOfferCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HomeSpecialOfferCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.specialOfferDataSource.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenW/2 - 10 , 260);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeSpecialOfferCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeSpecialOfferCollectionViewCell class])  forIndexPath:indexPath];
    
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.specialOfferDataSource[indexPath.row][@"pic"]]]];
    
    NSString *bfh = @"%";
    cell.lbo.text = [NSString stringWithFormat:@"%@%@OFF",self.specialOfferDataSource[indexPath.row][@"off"],bfh];
    
    NSString *opstr = [NSString stringWithFormat:@"%@%@",self.specialOfferDataSource[indexPath.row][@"currency_sign"],self.specialOfferDataSource[indexPath.row][@"cost"]];
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:opstr];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,opstr.length)];
    cell.lbt.attributedText = attributeMarket;
    
    cell.lbth.text = [NSString stringWithFormat:@"%@%@",self.specialOfferDataSource[indexPath.row][@"currency_sign"],self.specialOfferDataSource[indexPath.row][@"pirce"]];
    
    cell.lbf.text = [NSString stringWithFormat:@"%@",self.specialOfferDataSource[indexPath.row][@"name"]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSString stringWithFormat:@"%@",self.specialOfferDataSource[indexPath.row][@"if_develop"]]isEqualToString:@"1"]) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc]init];
        vc.link = [NSString stringWithFormat:@"%@",self.specialOfferDataSource[indexPath.row][@"url"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        shopDetail.hidesBottomBarWhenPushed = YES;
        shopDetail.link = [NSString stringWithFormat:@"%@",self.specialOfferDataSource[indexPath.row][@"url"]];
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
