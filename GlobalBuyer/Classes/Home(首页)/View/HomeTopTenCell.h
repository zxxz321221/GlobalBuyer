//
//  HomeTopTenCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HomeTopTenCellDelegate <NSObject>

- (void)clickTopTenWithLink:(NSString *)link type:(NSString *)type;

@end

@interface HomeTopTenCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong)NSMutableArray *topTenDataSource;
@property (nonatomic, strong) id<HomeTopTenCellDelegate>delegate;
@end
