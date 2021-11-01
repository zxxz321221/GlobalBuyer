//
//  OrderAlertView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  orderAlertViewDelegate <NSObject>

//- (void)cancelOrderAlert;
- (void)confim:(NSString *)reason;

@end
NS_ASSUME_NONNULL_BEGIN

@interface OrderAlertView : UIView
@property (nonatomic, strong) id<orderAlertViewDelegate>delegate;

+ (instancetype)setOrderAlertView:(UIView *)view;

- (void)showAlertView;

- (void)hiddenAlertView;
@end

NS_ASSUME_NONNULL_END
