//
//  UserModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel
@property (nonatomic , copy) NSString  <Optional>* fullname;
@property (nonatomic , copy) NSString  <Optional>* email;
@property (nonatomic , copy) NSString  <Optional>* mobile_phone;
@property (nonatomic , copy) NSString  <Optional>* updated_at;
@property (nonatomic , copy) NSString  <Optional>* created_at;
@property (nonatomic , copy) NSString  <Optional>* secret_key;
@property (nonatomic , copy) NSString  <Optional>* third_party;
@property (nonatomic , copy) NSNumber  <Optional>* sex;
@property (nonatomic , copy) NSString  <Optional>* identity;
@property (nonatomic , copy) NSString  <Optional>* currency;
@property (nonatomic , copy) NSString  <Optional>* avatar;
@property (nonatomic , copy) NSString  <Optional>* email_name;
@property (nonatomic , copy) NSString  <Optional>* birth;
@end
