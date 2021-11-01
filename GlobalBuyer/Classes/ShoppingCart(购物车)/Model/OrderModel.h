//
//  OrderModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/8.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ShopCartModel.h"
@interface OrderModel : JSONModel
@property (nonatomic , copy) NSNumber              <Optional>*userid;
@property (nonatomic , copy) NSString              <Optional>* order_merge_id;
@property (nonatomic , copy) NSString              <Optional>* weight;
@property (nonatomic , copy) NSString              <Optional>* express_origin_no;
@property (nonatomic , copy) NSString              <Optional>* confirm_picture;
@property (nonatomic , copy) NSNumber              <Optional>*storage;
@property (nonatomic , copy) NSString              <Optional>* updated_at;
@property (nonatomic , copy) NSString              <Optional>* confirm;
@property (nonatomic , copy) NSString              <Optional>* pay_type;
@property (nonatomic , copy) NSNumber              <Optional>* package_id;
@property (nonatomic , copy) NSString              <Optional>* quantity;
@property (nonatomic , copy) ShopCartModel         <Optional>* body;
@property (nonatomic , copy) NSNumber              <Optional> *Id;
@property (nonatomic , copy) NSNumber              <Optional>*user_address_id;
@property (nonatomic , copy) NSString              <Optional> * buy;
@property (nonatomic , copy) NSString              <Optional>* freight;
@property (nonatomic , copy) NSString              <Optional>* product_status;
@property (nonatomic , copy) NSString              <Optional>* interfreight;
@property (nonatomic , copy) NSString              <Optional>* from;
@property (nonatomic , copy) NSNumber              <Optional>*interfreight_finish;
@property (nonatomic , copy) NSString              <Optional>* created_at;
@property (nonatomic , copy) NSNumber              <Optional>* express_no;
@property (nonatomic , copy) NSString              <Optional>* express_name;
@property (nonatomic , copy) NSString              <Optional>* remark;
@property (nonatomic , copy) NSNumber              <Optional>*channel_id;
@property (nonatomic , copy) NSString              <Optional>* uniqid;
@property (nonatomic , copy) NSString              <Optional>*shop_source;
@property (nonatomic , copy) NSString              <Optional>*tax;
@property (nonatomic , copy) NSString              <Optional>*price;
@property (nonatomic , copy) NSString              <Optional>*buy_type;
@property (nonatomic , copy) NSString              <Optional>*product_num;
@end
