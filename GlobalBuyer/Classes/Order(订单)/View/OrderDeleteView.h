//
//  OrderDeleteView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/13.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  orderDltViewDelegate <NSObject>

//- (void)cancelOrderAlert;
- (void)confirmTheDeletion;

@end
NS_ASSUME_NONNULL_BEGIN

@interface OrderDeleteView : UIView
@property (nonatomic, strong) id<orderDltViewDelegate>delegate;

+ (instancetype)setOrderDeleteView:(UIView *)view;

- (void)showDltView;

- (void)hiddenDltView;
@end

NS_ASSUME_NONNULL_END
