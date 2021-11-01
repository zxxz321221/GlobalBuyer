//
//  CurrencyView.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/23.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyViewDelegate <NSObject>

-(void)goTo;

@end


@interface CurrencyView : UIView

@property(nonatomic,strong)id<CurrencyViewDelegate>delegate;

+(instancetype)currencyView;
-(void)showCurrencyView;

@end
