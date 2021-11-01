//
//  SpecialTableViewCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsModel.h"

@interface SpecialTableViewCell : UITableViewCell
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
