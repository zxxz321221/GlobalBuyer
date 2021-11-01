//
//  AllOrderCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol AllOrderCellDelegate <NSObject>

- (void)payGoods:(OrderModel *)model;
-  (void)addAddress:(OrderModel *)model;
- (void)showSendGoodsInfo:(OrderModel *)model;

@end

@interface AllOrderCell : UITableViewCell

@property(nonatomic, strong)OrderModel *model;
@property (nonatomic, strong)id <AllOrderCellDelegate>delegate;
-(void)hideBtn:(BOOL) hidden;

@end
