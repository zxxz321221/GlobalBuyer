//
//  ChoosePayViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/8.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "ShoppingCartViewController.h"

@protocol  ChoosePayViewControllerDelegate <NSObject>

- (void)Refresh;
- (void)pushNoPayViewC;

@end

@interface ChoosePayViewController : RootViewController
@property (nonatomic, strong)NSString *idsStr;
@property (nonatomic, strong)UIViewController *shopCartVC;
@property (nonatomic, assign)BOOL isCreating;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *packageId;
@property (nonatomic, strong) id<ChoosePayViewControllerDelegate>delegate;

@property (nonatomic, strong)NSString *orderType;
@property (nonatomic, strong)NSString *orderAddress;
@property (nonatomic, strong)NSString *isInspection;

@property (nonatomic, strong)NSString *couponsCode;
@property (nonatomic,strong)NSString *orderStatus;

@property (nonatomic,strong)NSString *invoiceYesOrNo;
@property (nonatomic,strong)NSMutableDictionary *invoiceDict;

@property (nonatomic,copy)NSString *type;

@end
