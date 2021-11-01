//
//  tableFootView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  TableFooterViewDelegate <NSObject>
//付款
- (void)paymentClick:(NSInteger)section;
//取消订单
- (void)cancelOrderClick:(NSInteger)section;
//订单详情
- (void)detailClick:(NSInteger)section;
//查看物流
- (void)logisticsClick:(NSInteger)section;
//验货照片
- (void)checkClick:(NSInteger)section;
//尾款支付
- (void)tailPaymentClick:(NSInteger)section;
//查看验货照片
- (void)ccheckImgClick:(NSInteger)section;
//确认收货
- (void)confirmClick:(NSInteger)section;
//配送物流信息
- (void)shippingInfoClick:(NSInteger)section;
//删除订单
- (void)deleteOrderClick:(NSInteger)section;
@end
NS_ASSUME_NONNULL_BEGIN

@interface tableFootView : UITableViewHeaderFooterView
- (void)configWithSection:(NSInteger)section;
@property (nonatomic, strong) id<TableFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
