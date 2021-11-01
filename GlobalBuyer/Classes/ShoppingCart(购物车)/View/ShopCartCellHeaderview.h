//
//  ShopCartCellHeaderview.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"
@interface ShopCartCellHeaderview : UIView
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *shopNameLa;
@property (nonatomic, strong)ShopCartModel *model;
@end
