//
//  ShoppingCartDetailViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/12.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "ShopCartHeaderView.h"

@interface ShoppingCartDetailViewController : RootViewController
@property (nonatomic, strong)NSMutableArray *dataSoucer;
@property (nonatomic, strong)UIViewController *vc;
@property (nonatomic, strong)NSMutableArray *moneytypeArr;
@property (nonatomic, strong)NSString *serviceCharge;
@property (nonatomic, assign)BOOL isAutoPush;
@end
