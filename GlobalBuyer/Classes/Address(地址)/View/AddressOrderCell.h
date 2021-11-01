//
//  addressOrderCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@protocol AddressOrderCellDelegate <NSObject>

-(void)select:(AddressModel *)model;
-(void)delectAddress:(AddressModel *)model;
-(void)editAddress:(AddressModel *)model;

@end

@interface AddressOrderCell : UITableViewCell
@property (nonatomic, strong)AddressModel *model;
@property (nonatomic, strong)id <AddressOrderCellDelegate>delegate;
@end
