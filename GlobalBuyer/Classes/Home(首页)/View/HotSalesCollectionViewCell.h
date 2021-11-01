//
//  HotSalesCollectionViewCell.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2021/7/16.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotSalesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *webIconIV;
@property (weak, nonatomic) IBOutlet UIImageView *goodIV;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end

NS_ASSUME_NONNULL_END
