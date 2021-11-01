//
//  HomeDiscountCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HomeDiscountCellDelegate <NSObject>

- (void)clickDiscountWithLink:(NSString *)link type:(NSString *)type;
- (void)clickDiscountWithMore;

@end

@interface HomeDiscountCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *discountDataSource;
@property (nonatomic,strong) UIView *backV;
@property (nonatomic, strong) id<HomeDiscountCellDelegate>delegate;
@end
