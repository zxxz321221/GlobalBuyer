//
//  ShopNotiView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/17.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  notiViewDelegate <NSObject>

- (void)detailClick;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ShopNotiView : UIView
+(instancetype)setShopNotiView:(UIView *)view;
@property (nonatomic, strong) id<notiViewDelegate>delegate;
- (void)showNoti;
@end

NS_ASSUME_NONNULL_END
