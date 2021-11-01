//
//  ShoppingCartCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol  ShoppingCartCellDelegate<NSObject>

- (void) isSelectGoods:(OrderModel *)model;
- (void) goToGoodsDetail:(OrderModel *)model;

@end

@interface ShoppingCartCell : UITableViewCell
@property (nonatomic, strong)OrderModel *model;
@property (nonatomic, strong)id <ShoppingCartCellDelegate>delegate;
@property (nonatomic, assign)BOOL hideBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *overdueBackV;
- (void)releaseTimer;
@property (weak, nonatomic) IBOutlet UILabel *forthcomingCollectionLb;

@end
