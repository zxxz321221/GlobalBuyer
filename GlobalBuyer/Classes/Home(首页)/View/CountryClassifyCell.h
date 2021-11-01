//
//  CountryClassifyCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/3.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@protocol  CountryClassifyCellDelegate <NSObject>

-(void)clickHomeGoodsWithLink:(NSString *)urlString Good_site:(NSString *)good_site;

@end
@interface CountryClassifyCell : UITableViewCell


@property (nonatomic ,strong)GoodsModel *model;

@property (nonatomic, strong) id<CountryClassifyCellDelegate>delegate;

@property (nonatomic,strong)NSString * good_site;
@property (nonatomic,strong)NSString * rightgood_site;

@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSString *rightHref;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UIImageView *webIconIV;
@property (nonatomic, strong) UIImageView *rightWebIconIV;

@property (nonatomic, strong) UIView *wirteV;
@property (nonatomic, strong) UIView *rightWirteV;

@property (nonatomic, strong) UILabel *goodName;
@property (nonatomic, strong) UILabel *rightGoodName;

@property (nonatomic, strong) UILabel *oPriceLb;
@property (nonatomic, strong) UILabel *oRightPriceLb;

@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *rightPriceLb;

@property (nonatomic, strong)NSDictionary *goodsArr;

@end
