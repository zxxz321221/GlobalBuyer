//
//  FixedPriceShowViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/30.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixedPriceShowViewController : UIViewController

@property (nonatomic,strong)NSString *pictureUrl;
@property (nonatomic,strong)NSString *nameOfGoods;
@property (nonatomic,strong)NSString *attributesOfGoods;
@property (nonatomic,strong)NSString *numberOfGoods;
@property (nonatomic,strong)NSString *priceOfGoods;
@property (nonatomic,strong)NSString *moneyTypeOfGoods;
@property (nonatomic,strong)NSMutableArray *moneytypeArr;

@end
