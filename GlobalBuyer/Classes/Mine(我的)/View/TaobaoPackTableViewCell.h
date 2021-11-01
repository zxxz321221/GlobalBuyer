//
//  TaobaoPackTableViewCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/17.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaobaoPackTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *goodIV;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *subTitleLb;
@property (nonatomic,strong)UILabel *qtyLb;
@property (nonatomic,strong)UILabel *priceLb;
@property (nonatomic,strong)UIButton *selectBtn;

@property (nonatomic,strong)UIView *coverV;

@end
