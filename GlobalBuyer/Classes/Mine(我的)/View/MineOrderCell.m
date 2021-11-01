//
//  MineOrderCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/19.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "MineOrderCell.h"
#import "MineCollectionViewCell.h"
@interface MineOrderCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSoucer;
@end

@implementation MineOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    [self.contentView addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenW/5, 75);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/5) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([MineCollectionViewCell class]) bundle:[NSBundle mainBundle]];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([MineCollectionViewCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSoucer {
    if (_dataSoucer == nil) {
        _dataSoucer = [NSMutableArray new];
        NSString *str1 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Wait", nil);
        NSString *str2 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_SubmitAdd", nil);
        NSString *str3 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Purchase", nil);
        NSString *str4 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Paytransport", nil);
        NSString *str5 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Overseas", nil);
         [_dataSoucer addObject:@{@"imgName":@"ic_unpaid",@"name":str1}];
         [_dataSoucer addObject:@{@"imgName":@"ic_up_address",@"name":str2}];
         [_dataSoucer addObject:@{@"imgName":@"ic_purchase",@"name":str3}];
         [_dataSoucer addObject:@{@"imgName":@"ic_freight",@"name":str4}];
         [_dataSoucer addObject:@{@"imgName":@"ic_shipments",@"name":str5}];
    }
    return _dataSoucer;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSoucer.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MineCollectionViewCell class]) forIndexPath:indexPath];
    NSDictionary *dict = self.dataSoucer[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dict[@"imgName"]] ;
    cell.nameLa.text = dict[@"name"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate orderClick:indexPath.row];
}

@end
