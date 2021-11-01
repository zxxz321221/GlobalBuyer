//
//  PayViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/8.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "ShoppingCartViewController.h"

@interface PayViewController : RootViewController
@property (nonatomic, strong)UIViewController *shopCartVC;
@property (nonatomic, strong)NSString *urlString;
@property (nonatomic,copy)NSString *type;
@end
