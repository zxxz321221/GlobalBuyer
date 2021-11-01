//
//  PoisModel.h
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "JSONModel.h"
#import "EnterLocationModel.h"
@interface PoisModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*uid;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*address;
@property(nonatomic,strong)NSString <Optional>*district;
@property(nonatomic,strong)NSString <Optional>*province;
@property(nonatomic,strong)NSString <Optional>*city;
@property(nonatomic,strong)EnterLocationModel <Optional>*location;
@end
