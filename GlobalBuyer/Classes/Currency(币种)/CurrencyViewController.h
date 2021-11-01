//
//  CurrencyViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/23.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"

@protocol  CurrencyViewControllerDelegate <NSObject>

-(void)gotoHomeVC;

@end

@interface CurrencyViewController : RootViewController
@property(nonatomic,strong)id<CurrencyViewControllerDelegate>delegate;
@end
