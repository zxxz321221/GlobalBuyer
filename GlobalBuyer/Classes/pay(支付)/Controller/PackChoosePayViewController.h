//
//  PackChoosePayViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "OrderViewController.h"
#import "PackPayViewController.h"
@interface PackChoosePayViewController : RootViewController
@property (nonatomic, strong)NSString *idsStr;
@property (nonatomic, strong)OrderViewController *OrderVC;
@end
