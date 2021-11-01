//
//  GoodSpecificationModel.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2020/10/15.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodSpecificationModel : NSObject
+ (instancetype)shareGoodSpecificationModel;
@property(nonatomic,strong)NSString* pictureUrl;
@property(nonatomic,strong)NSString* titleOfGoods;
@property(nonatomic,strong)NSString* numberOfGoods;
@property(nonatomic,strong)NSString* priceOfGoods;
@property(nonatomic,strong)NSString* nameOfGoods;
@property(nonatomic,strong)NSString* attributesOfGoods;
@property(nonatomic,strong)NSString* moneyTypeOfGoods;
@property(nonatomic,strong)NSString* tureNumberOfGoods;
@property(nonatomic,strong)NSDictionary* dic;
//
@end

NS_ASSUME_NONNULL_END
