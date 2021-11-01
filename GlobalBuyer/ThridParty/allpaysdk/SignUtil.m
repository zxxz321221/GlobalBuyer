//
//  SignUtil.m
//  Demo
//
//  Created by BensonZhang on 15/11/16.
//  Copyright © 2015年 xunlian. All rights reserved.
//

#import "SignUtil.h"
#import "AllPayRequest.h"

@implementation SignUtil

+(NSString *)getSign:(PayOrder *)payOrder{
    
    NSMutableDictionary * paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:payOrder.version forKey:@"version"];
    [paramDic setObject:payOrder.charSet forKey:@"charSet"];
    [paramDic setObject:payOrder.transType forKey:@"transType"];
    [paramDic setObject:payOrder.orderNum forKey:@"orderNum"];
    [paramDic setObject:payOrder.orderAmount forKey:@"orderAmount"];
    [paramDic setObject:payOrder.orderCurrency forKey:@"orderCurrency"];
    [paramDic setObject:payOrder.frontURL forKey:@"frontURL"];
    [paramDic setObject:payOrder.backURL forKey:@"backURL"];
    [paramDic setObject:payOrder.merReserve forKey:@"merReserve"];
    [paramDic setObject:payOrder.merID forKey:@"merID"];
    [paramDic setObject:payOrder.acqID forKey:@"acqID"];
    [paramDic setObject:payOrder.paymentSchema forKey:@"paymentSchema"];
    [paramDic setObject:payOrder.transTime forKey:@"transTime"];
    [paramDic setObject:payOrder.OrderDesc forKey:@"OrderDesc"];
    [paramDic setObject:payOrder.customerId forKey:@"customerId"];
    [paramDic setObject:payOrder.language forKey:@"language"];
    [paramDic setObject:payOrder.signType forKey:@"signType"];
    
    return [SignUtil getMD5:[SignUtil getSignStr:paramDic  signkey:payOrder.signKey]];
}

+(NSString *)getSignStr:(NSMutableDictionary *)paramDic  signkey:(NSString *)key{
    
    NSArray *keys = [paramDic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
     NSMutableString *signStr=[[NSMutableString alloc]init];
    int i=0;
    for (NSString *categoryId in sortedArray) {
        if(i>0){
            [signStr appendString:[NSString stringWithFormat:@"&%@=%@",categoryId,[paramDic objectForKey:categoryId]]];
        }else{
            [signStr appendString:[NSString stringWithFormat:@"%@=%@",categoryId,[paramDic objectForKey:categoryId]]];
        }
        i++;
    }
    [signStr appendString:key];
       return signStr ;
}

+(NSString *)getMD5:(NSString *)signStr{
    NSLog(@"%@",signStr);
    return [AllPayRequest md5:signStr];
   

}


@end
