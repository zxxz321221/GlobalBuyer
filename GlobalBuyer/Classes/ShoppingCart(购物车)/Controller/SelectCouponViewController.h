//
//  SelectCouponViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/4/20.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SelectCouponViewDelegate<NSObject>

- (void)isSelectCoupon:(NSString *)couponCode;
- (void)cancelSelectCoupon;

@end

@interface SelectCouponViewController : UIViewController

@property (nonatomic, strong)NSString *idsStr;
@property (nonatomic, strong)UIViewController *shopCartVC;
@property (nonatomic, strong)NSString *orderType;
@property (nonatomic, strong)NSString *orderAddress;
@property (nonatomic, strong)NSString *isInspection;
@property (nonatomic, strong)id <SelectCouponViewDelegate>delegate;
@end
