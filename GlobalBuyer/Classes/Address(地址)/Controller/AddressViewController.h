//
//  AddressViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/25.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "AddressModel.h"
@protocol  AddressViewControllerDelegate<NSObject>

- (void)sendAdressModel:(AddressModel *)model;
-(void)changeAddress:(AddressModel *)model;

@end

@interface AddressViewController : RootViewController
@property (nonatomic , assign) BOOL istrue;
@property(nonatomic,assign)BOOL isShopCart;
@property (nonatomic , strong) NSString * taobao;
@property(nonatomic,assign)id<AddressViewControllerDelegate>delegate;
@end
