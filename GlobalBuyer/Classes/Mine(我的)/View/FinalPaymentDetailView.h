//
//  FinalPaymentDetailView.h
//  GlobalBuyer
//
//  Created by 赵祥 on 2021/9/7.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinalPaymentDetailView : UIView

@property (nonatomic , strong)NSDictionary *dataDic;

@property (nonatomic,strong)NSMutableArray *moneytypeArr;

@property (nonatomic,strong)UIButton *paymentBtn;
@end

NS_ASSUME_NONNULL_END
