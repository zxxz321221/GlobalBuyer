//
//  ShopCartManager.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ShopCartManager.h"


@implementation ShopCartManager
{
    FMDatabase *_db;
}

static  ShopCartManager *shopCartManager = nil;
+ (instancetype)manager {
    @synchronized (self) {
        if (shopCartManager == nil) {
            shopCartManager = [[ShopCartManager alloc]init];
        }
        return shopCartManager;
    }
}

- (instancetype)init {
    if ([super init]) {
        [self creatDB];
    }
    return self;
}

#pragma mark 创建数据库
- (void)creatDB {
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"shopCart.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    
    [self creatTabel];
}
#pragma mark 创建表

- (void)creatTabel {
    [_db open];
    NSString *sql = @"CREATE TABLE 'shopCart' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'usertoken' VARCHAR(255),'area' VARCHAR(255),'attributes' VARCHAR(255),'channel' VARCHAR(255),'cid' integer,'freight' integer, 'link' VARCHAR(255),'price' integer,'quantity' integer,'moneyType' VARCHAR(255),'rcid' integer,'shopSource' VARCHAR(255),'source' VARCHAR(255) ,'body' VARCHAR(255),'goodsId'  VARCHAR(255))";
    [_db executeUpdate:sql];
    [_db close];
}

- (void)addGoods:(ShopCartModel *)model andUserToken:(NSString *)userToken{
     [_db open];
     [_db executeUpdate:@"INSERT INTO shopCart(usertoken,area,attributes,channel,cid,freight,link,price,quantity,moneyType,rcid,shopSource,source,body,goodsId)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",userToken,model.area,model.attributes,model.channel,model.cid,model.freight,model.link,model.price,model.quantity,model.moneyType,model.rcid,model.shopSource,model.source,model.body,model.goodsId];
    [_db close];
}
- (NSMutableArray *)getAllGoods {
    [_db open];
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    NSMutableArray  *goodsArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM shopCart where usertoken = '%@'",userToken]];
    while ([res next]) {
        ShopCartModel *model = [[ShopCartModel alloc]init];
        
        model.area = [res stringForColumn:@"area"];
        
        model.attributes = [res stringForColumn:@"attributes"];
        
        model.channel = [res stringForColumn:@"channel"];
        
        model.cid = @([res intForColumn:@"cid"]);
        
        model.freight = @([res intForColumn:@"freight"]);
        
        model.link = [res stringForColumn:@"link"];
        
        model.price = @([res intForColumn:@"price"]);
        
        model.quantity = @([res intForColumn:@"quantity"]);
        
        model.moneyType = [res stringForColumn:@"moneyType"];
        
        model.rcid = @([res intForColumn:@"rcid"]);
        
        model.shopSource = [res stringForColumn:@"hopSource"];
        
        model.source = [res stringForColumn:@"source"];
        
        model.body = [res stringForColumn:@"body"];
        
        model.goodsId = @([res intForColumn:@"goodsId"]);
        
        [goodsArray addObject:model];
        
    }

    return goodsArray;

}
@end
