//
//  AddAdderssViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "AddressModel.h"
@protocol  EditAdderssViewControllerDelegate <NSObject>

-(void)addAddressModel:(AddressModel*) addressModel;

@end

@interface EditAdderssViewController : RootViewController
@property(nonatomic,strong)id<EditAdderssViewControllerDelegate>delegate;
@property(nonatomic,strong)AddressModel *model;
@end
