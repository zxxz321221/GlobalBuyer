//
//  ShopCartModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ShopCartModel : JSONModel

@property (nonatomic, strong)NSString <Optional>*area;
@property (nonatomic, strong)NSString <Optional>*attributes;
@property (nonatomic, strong)NSString <Optional>*channel;
@property (nonatomic, strong)NSNumber <Optional>*cid;
@property (nonatomic, strong)NSNumber <Optional>*freight;
@property (nonatomic, strong)NSString <Optional>*link;
@property (nonatomic, strong)NSString <Optional>*moneyType;
@property (nonatomic, strong)NSString <Optional>*name;
@property (nonatomic, strong)NSString <Optional>*picture;
@property (nonatomic, strong)NSNumber <Optional>*price;
@property (nonatomic, strong)NSNumber <Optional>*quantity;
@property (nonatomic, strong)NSNumber <Optional>*rcid;
@property (nonatomic, strong)NSString <Optional>*shopSource;
@property (nonatomic, strong)NSString <Optional>*source;
@property (nonatomic, strong)NSString <Optional>*body;
@property (nonatomic, strong)NSNumber <Optional>*goodsId;
@property (nonatomic, strong)NSNumber <Optional>*iSelect;
@property (nonatomic, strong)NSString <Optional>*rate;
@property (nonatomic, strong)NSString <Optional>*currency;
@property (nonatomic, strong)NSString <Optional>*totalPrice;
@end
