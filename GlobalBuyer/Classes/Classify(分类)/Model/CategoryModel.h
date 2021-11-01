//
//  CategoryModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CategoryModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*link;
@property(nonatomic,strong)NSString <Optional>*image;
@property(nonatomic,strong)NSString <Optional>*Description;
@property(nonatomic,strong)NSString <Optional>*country;
@property(nonatomic,strong)NSString <Optional>*created_at;
@property(nonatomic,strong)NSString <Optional>*recommend;
@property(nonatomic,strong)NSString <Optional>*introduction;
@property(nonatomic,strong)NSString <Optional>*good_site;

@property(nonatomic,strong)NSString <Optional>*Title;
@property(nonatomic,strong)NSString <Optional>*ASIN;
@property(nonatomic,strong)NSString <Optional>*FormattedPrice;
@property(nonatomic,strong)NSString <Optional>*URL;
@property(nonatomic,strong)NSString <Optional>*DetailPageURL;
@property(nonatomic,strong)NSString <Optional>*guide;

@end
