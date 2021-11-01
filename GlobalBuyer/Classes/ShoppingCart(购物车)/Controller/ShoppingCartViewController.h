//
//  ShoppingCartViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"


@interface ShoppingCartViewController : RootViewController
@property (nonatomic, strong)NSMutableArray *dataSoucer;
@property (nonatomic, strong)NSString *shopSource; //商城类型
@end
