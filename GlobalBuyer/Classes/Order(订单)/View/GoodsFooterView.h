//
//  GoodsFooterView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  GoodsFooterViewDelegate <NSObject>
//订单详情
- (void)detailClick:(NSInteger)section;
//确认收货
- (void)confirmClick:(NSInteger)section;
//配送物流信息
- (void)shippingInfoClick:(NSInteger)section;
@end
NS_ASSUME_NONNULL_BEGIN

@interface GoodsFooterView : UITableViewHeaderFooterView
- (void)configWithSection:(NSInteger)section;
@property (nonatomic, strong) id<GoodsFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
