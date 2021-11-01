//
//  HomeSpecialOfferCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/23.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HomeSpecialOfferCellDelegate <NSObject>

- (void)clickSpecialOfferWithLink:(NSString *)link type:(NSString *)type;
- (void)clickSpecialOfferWithMore;

@end

@interface HomeSpecialOfferCell : UITableViewCell
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) NSMutableArray *specialOfferDataSource;
@property (nonatomic, strong) id<HomeSpecialOfferCellDelegate>delegate;
@end
