//
//  PackPayViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/10.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "OrderViewController.h"
@interface PackPayViewController : RootViewController
@property (nonatomic, strong)NSString *urlString;
@property (nonatomic, strong)OrderViewController *OrderVC;
@end
