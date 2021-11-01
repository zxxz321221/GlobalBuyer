//
//  NewAddressManagementViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/7.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface NewAddressManagementViewController : UIViewController

@property(nonatomic,strong)AddressModel *model;
@property (nonatomic,strong)NSString *zipcode;
@property (nonatomic,strong)NSString *editType;
@property (nonatomic,strong)NSString *idCardFIVURL;
@property (nonatomic,strong)NSString *idCardBIVURL;

@end
