//
//  GoodsValueModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GoodsValueModel : JSONModel
@property (nonatomic , copy) NSNumber              <Optional>* enabled;
@property (nonatomic , copy) NSNumber              <Optional>* Id;
@property (nonatomic , copy) NSString              <Optional>* keywords;
@property (nonatomic , copy) NSString              <Optional>* title;
@property (nonatomic , copy) NSString              <Optional>* created_at;
@property (nonatomic , copy) NSString              <Optional>* deleted_at;
@property (nonatomic , copy) NSString              <Optional>* Description;
@property (nonatomic , copy) NSString              <Optional>* body;
@property (nonatomic , copy) NSNumber              <Optional>* archive_field_id;
@property (nonatomic , copy) NSString              <Optional>* updated_at;
@end
