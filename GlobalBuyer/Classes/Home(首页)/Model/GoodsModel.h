//
//  GoodsModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodsValueModel.h"
#import "GoodsBodyModel.h"
@interface GoodsModel : JSONModel
@property (nonatomic, strong) GoodsValueModel <Optional>*value;
@property (nonatomic, strong) GoodsBodyModel <Optional>*body;

@property (nonatomic, strong) NSString <Optional>*title;
@property (nonatomic, strong) NSString <Optional>*href;
@property (nonatomic, strong) NSString <Optional>*sub_title3;
@property (nonatomic, strong) NSString <Optional>*sub_title2;
@property (nonatomic, strong) NSString <Optional>*sub_title1;
@property (nonatomic, strong) NSString <Optional>*placeholder2;
@property (nonatomic, strong) NSString <Optional>*image;
@property (nonatomic, strong) NSString <Optional>*discount;
@property (nonatomic, strong) NSString <Optional>*placeholder1;

@end
