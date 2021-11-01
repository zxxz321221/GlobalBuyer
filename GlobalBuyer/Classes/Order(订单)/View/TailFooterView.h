//
//  TailFooterView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  TailFooterViewDelegate <NSObject>
//订单详情
- (void)detailClick:(NSInteger)section;
//尾款支付
- (void)tailPaymentClick:(NSInteger)section;
//查看验货照片
- (void)ccheckImgClick:(NSInteger)section;
@end
NS_ASSUME_NONNULL_BEGIN

@interface TailFooterView : UITableViewHeaderFooterView
- (void)configWithSection:(NSInteger)section;
@property (nonatomic, strong) id<TailFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
