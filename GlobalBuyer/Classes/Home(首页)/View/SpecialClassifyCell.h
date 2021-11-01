//
//  SpecialClassifyCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/7.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"


@interface SpecialClassifyCell : UICollectionViewCell

@property (nonatomic ,strong)GoodsModel *model;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *opriceLa;
@property (nonatomic, strong) UILabel *discount;
@property (nonatomic, strong) UILabel *sourceLb;
@property (nonatomic, strong) UIImageView *disIv;

@property (nonatomic, strong)UIView *lightGV;
@property (nonatomic, strong)UIView *wirteV;

@end
