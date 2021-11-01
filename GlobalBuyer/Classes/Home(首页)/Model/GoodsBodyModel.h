//
//  GoodsBodyModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GoodsBodyModel : JSONModel
@property (nonatomic , copy) NSString              <Optional>* oprice;
@property (nonatomic , copy) NSString              <Optional>* sourceImg;
@property (nonatomic , copy) NSString              <Optional>* goodsDesc;
@property (nonatomic , copy) NSString              <Optional>* price;
@property (nonatomic , copy) NSString              <Optional>* image;
@property (nonatomic , copy) NSString              <Optional>* goodsLink;
@property (nonatomic , copy) NSString              <Optional>* goodsDisc;
@property (nonatomic , copy) NSString              <Optional>* discount;
@property (nonatomic , copy) NSString              <Optional>* source;
@property (nonatomic , copy) NSString              <Optional>* nationality;
@end
