//
//  FootGoodsModel.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/8.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FootGoodsModel : NSObject
//商品属性
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * name;
//@property(nonatomic,copy)NSString * goodsID;
//@property(nonatomic,copy)NSString * goodsTitle;
//@property(nonatomic,copy)NSString * goodsCount;
//@property(nonatomic,copy)NSString * goodsColor;
//@property(nonatomic,copy)NSString * goodsSize;
//@property(nonatomic,copy)NSString * goodsPrice;
//@property(nonatomic,copy)NSString * goodsImageURL;
//测试image
//@property(nonatomic,copy)NSString * goodsImage;
//选中状态
@property(nonatomic,assign)BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
