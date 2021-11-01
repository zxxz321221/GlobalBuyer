//
//  CurrencyCalculation.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyCalculation : NSObject

+ (NSString *)currencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency;

//计算关税用
+ (NSString *)getcurrencyCalculation:(float)count numberOfGoods:(float)number;

+ (NSString *)getcurrencyCalculation:(float)count  currentCommodityCurrency:(NSString *)currentCommodityCurrency numberOfGoods:(float)number;

+ (NSString *)getcurrencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency  numberOfGoods:(float)number;

+ (NSString *)calculationCurrencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency numberOfGoods:(float)number freight:(float)freight serviceCharge:(float)serviceCharge exciseTax:(float)exciseTax;

//转换币种
+ (NSString *)conversionCurrency:(NSString *)amount Curr:(NSString *)curr ReteDic:(NSDictionary *)dic GoodSite:(NSString *)goodsite;
@end
