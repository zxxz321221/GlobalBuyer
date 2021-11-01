//
//  SignUtil.h
//  Demo
//
//  Created by BensonZhang on 15/11/16.
//  Copyright © 2015年 xunlian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayOrder.h"

@interface SignUtil : NSObject

+(NSString *)getSign:(PayOrder *)PayOrder;

@end
