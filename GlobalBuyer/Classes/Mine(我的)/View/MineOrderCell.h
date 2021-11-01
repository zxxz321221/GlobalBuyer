//
//  MineOrderCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/19.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MineOrderCellDelegate <NSObject>

-(void)orderClick:(NSInteger)index;

@end


@interface MineOrderCell : UITableViewCell
@property (nonatomic, strong)id<MineOrderCellDelegate>delegate;
@end
