//
//  AddressModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <UIKit/UIKit.h>
@interface AddressModel : JSONModel
@property (nonatomic, strong)NSNumber <Optional>*Id;
@property (nonatomic, strong) NSString <Optional>*fullname;
@property (nonatomic, strong) NSString <Optional>*mobile_phone;
@property (nonatomic, strong) NSString <Optional>*address;
@property (nonatomic, strong) NSNumber <Optional>*Default;
@property (nonatomic, strong) NSNumber <Optional>*isSelect;
@property (nonatomic, strong) NSString <Optional>*idCardNum;
@property (nonatomic, strong) NSString <Optional>*idcard_front;
@property (nonatomic, strong) NSString <Optional>*idcard_back;
@property (nonatomic, strong) NSString <Optional>*zipcode;
-(CGFloat)cellH;
@end
