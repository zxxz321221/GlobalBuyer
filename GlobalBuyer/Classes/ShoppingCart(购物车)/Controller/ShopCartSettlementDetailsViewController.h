//
//  ShopCartSettlementDetailsViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/12/24.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartSettlementDetailsViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *addressDataSource;
@property (nonatomic,strong)NSArray *payArr;
@property (nonatomic,strong)NSString *idsStr;
@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,strong)NSMutableArray *couponsArr;
@property (nonatomic, strong)UIViewController *vc;
@property (nonatomic,assign)float count;
@property (nonatomic,strong)NSString *currency;
@property (nonatomic,strong)NSString *serviceCharge;
@property (nonatomic,assign)float ooCount;

@end
