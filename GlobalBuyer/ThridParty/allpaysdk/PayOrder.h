//
//  PayOrder.h
//  Demo
//
//  Created by BensonZhang on 15/11/16.
//  Copyright © 2015年 xunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayOrder : NSObject
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *charSet;
@property (strong, nonatomic) NSString *transType;
@property (strong, nonatomic) NSString *orderNum;
@property (strong, nonatomic) NSString *orderAmount;
@property (strong, nonatomic) NSString *orderCurrency;
@property (strong, nonatomic) NSString *frontURL;
@property (strong, nonatomic) NSString *backURL;
@property (strong, nonatomic) NSString *merReserve;
@property (strong, nonatomic) NSString *merID;
@property (strong, nonatomic) NSString *acqID;
@property (strong, nonatomic) NSString *paymentSchema;
@property (strong, nonatomic) NSString *transTime;
@property (strong, nonatomic) NSString *signType;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *OrderDesc;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *customerId;
@property (strong, nonatomic) NSString *signKey;
@end
