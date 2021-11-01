//
//  GoodSpecificationModel.m
//  GlobalBuyer
//
//  Created by 澜与轩 on 2020/10/15.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "GoodSpecificationModel.h"

@implementation GoodSpecificationModel
+ (instancetype)shareGoodSpecificationModel{
   static dispatch_once_t onceToken;
    static GoodSpecificationModel *appearance;
    dispatch_once(&onceToken, ^{
        appearance = [GoodSpecificationModel new];
    });
    return  appearance;
}
@end
