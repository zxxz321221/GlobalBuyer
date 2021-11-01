//
//  ShopCartManager.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "ShopCartModel.h"
@interface ShopCartManager : FMDatabase
@property (nonatomic, strong)ShopCartModel *model;
+(instancetype)manager;
- (void)creatDB ;
- (void)addGoods:(ShopCartModel *)model andUserToken:(NSString *)userToken;
- (NSMutableArray *)getAllGoods;
@end
