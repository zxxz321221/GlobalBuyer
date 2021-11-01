//
//  StorageOrderFooterView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  StorageFooterViewDelegate <NSObject>
//订单详情
- (void)detailClick:(NSInteger)section;
//查看物流
- (void)logisticsClick:(NSInteger)section;
//验货照片
- (void)checkClick:(NSInteger)section;
@end
NS_ASSUME_NONNULL_BEGIN

@interface StorageOrderFooterView : UITableViewHeaderFooterView
- (void)configWithSection:(NSInteger)section;
@property (nonatomic, strong) id<StorageFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
