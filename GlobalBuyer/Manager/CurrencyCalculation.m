//
//  CurrencyCalculation.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "CurrencyCalculation.h"

@implementation CurrencyCalculation
+ (NSString *)currencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency{
    
    NSString *currency =  [UserDefault objectForKey:@"currency"];
    
    CGFloat rate = 1.0;
    CGFloat tenRmb = 10.0;
//    if ([currency isEqualToString:currentCommodityCurrency]) {
//        
//    }else{
//        for (int i = 0; i < moneytypeArr.count; i++) {
//            if ([currentCommodityCurrency isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
//                count = count * [moneytypeArr[i][@"rate"] floatValue];
//            }
//        }
//        for (int j = 0 ; j < moneytypeArr.count; j++) {
//            if ([@"USD" isEqualToString:moneytypeArr[j][@"from_currency"]] && [currency isEqualToString:moneytypeArr[j][@"to_currency"]]) {
//                rate = [moneytypeArr[j][@"rate"] floatValue];
//            }
//        }
//    }
    for (int i = 0; i < moneytypeArr.count; i++) {
        if ([currentCommodityCurrency isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
            count = count * [moneytypeArr[i][@"rate"] floatValue];
        }
        if ([@"CNY" isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
            tenRmb = tenRmb * [moneytypeArr[i][@"rate"] floatValue];
        }
    }
    for (int j = 0 ; j < moneytypeArr.count; j++) {
        if ([@"USD" isEqualToString:moneytypeArr[j][@"from_currency"]] && [currency isEqualToString:moneytypeArr[j][@"to_currency"]]) {
            rate = [moneytypeArr[j][@"rate"] floatValue];
        }
    }
    
    if ([currency isEqualToString:@"USD"]) {
        rate = 1.0;
    }
    
    if ([currency  isEqualToString:@"CNY"]) {
        
        return  [NSString stringWithFormat:@"%@:CNY%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil), count*rate + (tenRmb * rate)];
        
    } else if ([currency  isEqualToString:@"TWD"]) {
        
        return [NSString stringWithFormat:@"%@:TWD%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil), count*rate + (tenRmb * rate)];
        
    } else if ([currency  isEqualToString:@"USD"]) {
    
        return  [NSString stringWithFormat:@"%@:USD%0.2f", NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),count*rate + (tenRmb * rate)];
        
    } else if ([currency  isEqualToString:@"JPY"]) {
        
        return  [NSString stringWithFormat:@"%@:JPY%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil), count*rate + (tenRmb * rate)];
        
    } else if ([currency isEqualToString:@"EUR"]) {
        
        return  [NSString stringWithFormat:@"%@:EUR%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil), count*rate + (tenRmb * rate)];
        
    } else if ([currency  isEqualToString:@"GBP"]) {
        
        return  [NSString stringWithFormat:@"%@:GBP%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil), count*rate + (tenRmb * rate)];
        
    } else if ([currency isEqualToString:@"AUD"]) {
        
        return  [NSString stringWithFormat:@"%@:AUD%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),count*rate + (tenRmb * rate)];
        
    } else if ([currency  isEqualToString:@"KRW"]) {
        
        return [NSString stringWithFormat:@"%@:KRW%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),count*rate + (tenRmb * rate)];
        
    } else if ([currency  isEqualToString:@"HKD"]){
        return [NSString stringWithFormat:@"%@:HKD%0.2f",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),count*rate + (tenRmb * rate)];
    }else{
      return @"无法计算";
    }
    
}

//委托清单头部费用转换
+ (NSString *)getcurrencyCalculation:(float)count  currentCommodityCurrency:(NSString *)currentCommodityCurrency numberOfGoods:(float)number

{
    NSString *currency =  currentCommodityCurrency;
    
    if ([currency  isEqualToString:@"CNY"]) {
        
        return  [NSString stringWithFormat:@"CNY%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"TWD"]) {
        
        return [NSString stringWithFormat:@"TWD%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"USD"]) {
        
        return  [NSString stringWithFormat:@"USD%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"JPY"]) {
        
        return  [NSString stringWithFormat:@"JPY%0.2f", count*number];
        
    } else if ([currency isEqualToString:@"EUR"]) {
        
        return  [NSString stringWithFormat:@"EUR%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"GBP"]) {
        
        return  [NSString stringWithFormat:@"GBP%0.2f", count*number];
        
    } else if ([currency isEqualToString:@"AUD"]) {
        
        return  [NSString stringWithFormat:@"AUD%0.2f",count*number];
        
    } else if ([currency  isEqualToString:@"KRW"]) {
        
        return [NSString stringWithFormat:@"KRW%0.2f",count*number];
        
    }else if ([currency  isEqualToString:@"HKD"]){
        
        return [NSString stringWithFormat:@"HKD%0.2f",count*number];
        
    }else{
        return @"无法计算";
    }
}

//计算关税用
+ (NSString *)getcurrencyCalculation:(float)count numberOfGoods:(float)number

{
    NSString *currency =  [UserDefault objectForKey:@"ReceiveCurrency"];
    
    if ([currency  isEqualToString:@"rmb_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"rate_rmb"]) {
        
        return [NSString stringWithFormat:@"%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"usd_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"jyp_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f", count*number];
        
    } else if ([currency isEqualToString:@"euro_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f", count*number];
        
    } else if ([currency  isEqualToString:@"gbp_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f", count*number];
        
    } else if ([currency isEqualToString:@"aud_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f",count*number];
        
    } else if ([currency  isEqualToString:@"krw_rate_rmb"]) {
        
        return [NSString stringWithFormat:@"%0.2f",count*number];
        
    }else{
        return @"无法计算";
    }
}

//委托清单显示用
+ (NSString *)getcurrencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency numberOfGoods:(float)number

{
    NSString *currency =  [UserDefault objectForKey:@"currency"];
    
    CGFloat rate = 1.0;
//    if ([currency isEqualToString:currentCommodityCurrency]) {
//        
//    }else{
//        for (int i = 0; i < moneytypeArr.count; i++) {
//            if ([currentCommodityCurrency isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
//                count = count * [moneytypeArr[i][@"rate"] floatValue];
//            }
//        }
//        for (int j = 0 ; j < moneytypeArr.count; j++) {
//            if ([@"USD" isEqualToString:moneytypeArr[j][@"from_currency"]] && [currency isEqualToString:moneytypeArr[j][@"to_currency"]]) {
//                rate = [moneytypeArr[j][@"rate"] floatValue];
//            }
//        }
//    }
    
    for (int i = 0; i < moneytypeArr.count; i++) {
        if ([currentCommodityCurrency isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
            count = count * [moneytypeArr[i][@"rate"] floatValue];
        }
    }
    for (int j = 0 ; j < moneytypeArr.count; j++) {
        if ([@"USD" isEqualToString:moneytypeArr[j][@"from_currency"]] && [currency isEqualToString:moneytypeArr[j][@"to_currency"]]) {
            rate = [moneytypeArr[j][@"rate"] floatValue];
        }
    }
    
    if ([currency isEqualToString:@"USD"]) {
        rate = 1.0;
    }
    
    if ([currency  isEqualToString:@"CNY"]) {
        
        return  [NSString stringWithFormat:@"CNY%0.2f", count*number*rate];
        
    } else if ([currency  isEqualToString:@"TWD"]) {
        
        return [NSString stringWithFormat:@"TWD%0.2f", count*number*rate];
        
    } else if ([currency  isEqualToString:@"USD"]) {
        
        return  [NSString stringWithFormat:@"USD%0.2f", count*number*rate];
        
    } else if ([currency  isEqualToString:@"JPY"]) {
        
        return  [NSString stringWithFormat:@"JPY%0.2f", count*number*rate];
        
    } else if ([currency isEqualToString:@"EUR"]) {
        
        return  [NSString stringWithFormat:@"EUR%0.2f", count*number*rate];
        
    } else if ([currency  isEqualToString:@"GBP"]) {
        
        return  [NSString stringWithFormat:@"GBP%0.2f", count*number*rate];
        
    } else if ([currency isEqualToString:@"AUD"]) {
        
        return  [NSString stringWithFormat:@"AUD%0.2f",count*number*rate];
        
    } else if ([currency  isEqualToString:@"KRW"]) {
        
        return [NSString stringWithFormat:@"KRW%0.2f",count*number*rate];
        
    } else if ([currency  isEqualToString:@"HKD"]){
        
        return [NSString stringWithFormat:@"HKD%0.2f",count*number*rate];
        
    }
    else{
        return @"无法计算";
    }
}

+ (NSString *)calculationCurrencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency numberOfGoods:(float)number
{
    NSString *currency =  [UserDefault objectForKey:@"currency"];
    
    CGFloat rate = 1.0;
    for (NSDictionary *dict in moneytypeArr) {
        if ([dict[@"name"] isEqualToString:currency ]) {
            rate = [dict[@"rate"] floatValue];
        }
        
        if ([dict[@"name"] isEqualToString:currentCommodityCurrency]) {
            if ([currentCommodityCurrency isEqualToString:@"rate_rmb"]) {
                count = count/[dict[@"rate"] floatValue];
            }else{
                count = count*[dict[@"rate"] floatValue];
            }
        }
    }
    
    if ([currency  isEqualToString:@"rmb_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"RMB￥%0.2f", count*number + (10.0 * rate) ];
        
    } else if ([currency  isEqualToString:@"rate_rmb"]) {
        
        return [NSString stringWithFormat:@"NT$%0.2f", (count*rate)*number + (10.0 * rate)];
        
    } else if ([currency  isEqualToString:@"usd_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"$%0.2f", (count/rate)*number + (10.0 / rate)];
        
    } else if ([currency  isEqualToString:@"jyp_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f日元", (count/rate)*number + (10.0 / rate)];
        
    } else if ([currency isEqualToString:@"euro_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"€%0.2f", (count/rate)*number + (10.0 / rate)];
        
    } else if ([currency  isEqualToString:@"gbp_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"£%0.2f", (count/rate)*number + (10.0 / rate)];
        
    } else if ([currency isEqualToString:@"aud_rate_rmb"]) {
        
        return  [NSString stringWithFormat:@"%0.2f澳元",(count/rate)*number + (10.0 / rate)];
        
    } else if ([currency  isEqualToString:@"krw_rate_rmb"]) {
        
        return [NSString stringWithFormat:@"%0.2f韩币",(count/rate)*number + (10.0 / rate)];
        
    }else{
        return @"无法计算";
    }

}

//委托清单首次付款计算用(合计)
+ (NSString *)calculationCurrencyCalculation:(float)count moneytypeArr:(NSMutableArray *)moneytypeArr currentCommodityCurrency:(NSString *)currentCommodityCurrency numberOfGoods:(float)number freight:(float)freight serviceCharge:(float)serviceCharge exciseTax:(float)exciseTax

{
    NSString *currency =  [UserDefault objectForKey:@"currency"];
    
    CGFloat rate = 1.0;
//    if ([currency isEqualToString:currentCommodityCurrency]) {
//        
//    }else{
//        for (int i = 0; i < moneytypeArr.count; i++) {
//            if ([currentCommodityCurrency isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
//                count = count * [moneytypeArr[i][@"rate"] floatValue];
//
//            }
//            if ([@"CNY" isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
//                tenRmb = tenRmb * [moneytypeArr[i][@"rate"] floatValue];
//                freight = freight * [moneytypeArr[i][@"rate"] floatValue];
//            }
//        }
//        for (int j = 0 ; j < moneytypeArr.count; j++) {
//            if ([@"USD" isEqualToString:moneytypeArr[j][@"from_currency"]] && [currency isEqualToString:moneytypeArr[j][@"to_currency"]]) {
//                rate = [moneytypeArr[j][@"rate"] floatValue];
//            }
//        }
//    }
    
    
    for (int i = 0; i < moneytypeArr.count; i++) {
        if ([currentCommodityCurrency isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
            count = count * [moneytypeArr[i][@"rate"] floatValue];
            exciseTax = exciseTax * [moneytypeArr[i][@"rate"] floatValue];
        }
//        if ([@"CNY" isEqualToString:moneytypeArr[i][@"from_currency"]] && [@"USD" isEqualToString:moneytypeArr[i][@"to_currency"]]) {
//            tenRmb = tenRmb * [moneytypeArr[i][@"rate"] floatValue];
//            freight = freight * [moneytypeArr[i][@"rate"] floatValue];
//        }
    }
    for (int j = 0 ; j < moneytypeArr.count; j++) {
        if ([@"USD" isEqualToString:moneytypeArr[j][@"from_currency"]] && [currency isEqualToString:moneytypeArr[j][@"to_currency"]]) {
            rate = [moneytypeArr[j][@"rate"] floatValue];
        }
    }
    
    if ([currency isEqualToString:@"USD"]) {
        rate = 1.0;
    }
    
    if ([currency  isEqualToString:@"CNY"]) {
        
        return  [NSString stringWithFormat:@"CNY%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];
        //return  [NSString stringWithFormat:@"RMB￥%0.2f", (count*rate)*number + (tenRmb * rate) + (freight * rate)];
        
    } else if ([currency  isEqualToString:@"TWD"]) {
        return [NSString stringWithFormat:@"TWD%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];
        //return [NSString stringWithFormat:@"%0.2f台币", (count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency  isEqualToString:@"USD"]) {
        return [NSString stringWithFormat:@"USD%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];
        //return  [NSString stringWithFormat:@"$%0.2f", (count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency  isEqualToString:@"JPY"]) {
        
        return [NSString stringWithFormat:@"JPY%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];

        //return  [NSString stringWithFormat:@"%0.2f日元", (count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency isEqualToString:@"EUR"]) {
        
        return [NSString stringWithFormat:@"EUR%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];

        //return  [NSString stringWithFormat:@"€%0.2f", (count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency  isEqualToString:@"GBP"]) {
        
        return [NSString stringWithFormat:@"GBP%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];

        
        //return  [NSString stringWithFormat:@"£%0.2f", (count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency isEqualToString:@"AUD"]) {
        
        return [NSString stringWithFormat:@"AUD%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];

        //return  [NSString stringWithFormat:@"%0.2f澳元",(count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency  isEqualToString:@"KRW"]) {
        
        return [NSString stringWithFormat:@"KRW%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];

        //return [NSString stringWithFormat:@"%0.2f韩币",(count*rate)*number + (tenRmb * rate) + (freight *rate)];
        
    } else if ([currency  isEqualToString:@"HKD"]){
        
        return [NSString stringWithFormat:@"HKD%0.2f", (count*rate)*number + freight + serviceCharge + exciseTax*rate];
        
    }else{
        return @"无法计算";
    }
}
//转换币种 amount当前金额  curr 当前币种  dic汇率字典
+ (NSString *)conversionCurrency:(NSString *)amount Curr:(NSString *)curr ReteDic:(NSDictionary *)dic GoodSite:(NSString *)goodsite{
    NSString *currency =  [UserDefault objectForKey:@"currency"];//索要转换成的币种
    if ([goodsite isEqualToString:@"ebay"]) {
        return [NSString stringWithFormat:@"%@%@",curr,amount];
    }
    NSArray * array = dic[@"from"];
    NSArray * arr = dic[@"to"];
    NSString * place;
    for (int i=0; i<arr.count; i++) {
        if ([curr isEqualToString:arr[i][@"from_currency"]]) {
            float usdP = [amount floatValue]*[arr[i][@"rate"]floatValue];//第一步 转成美元
            for (int j= 0; j<array.count; j++) {
                if ([currency isEqualToString:array[j][@"to_currency"]]) {
                    float currP = usdP*[array[j][@"rate"]floatValue];
                    place = [NSString stringWithFormat:@"%@%0.2f",currency,currP];
                }
            }
        }
    }
    return place;
}
@end
