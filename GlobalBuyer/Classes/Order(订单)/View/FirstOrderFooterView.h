//
//  FirstOrderFooterView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  FirstFooterViewDelegate <NSObject>
//付款
- (void)paymentClick:(NSInteger)section;
//取消订单
- (void)cancelOrderClick:(NSInteger)section;
//订单详情
- (void)detailClick:(NSInteger)section;
@end
NS_ASSUME_NONNULL_BEGIN

@interface FirstOrderFooterView : UITableViewHeaderFooterView
- (void)configWithSection:(NSInteger)section;
@property (nonatomic, strong) id<FirstFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
