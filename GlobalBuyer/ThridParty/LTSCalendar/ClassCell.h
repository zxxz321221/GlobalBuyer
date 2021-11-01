//
//  ClassCell.h
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/4/22.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FootGoodsModel;
@class ClassCell;
@protocol  FootCellDelegate <NSObject>
/**
 *  cell关于选中的代理方法
 *
 *  @param cell     cell
 *  @param selectBt cell左边选中按钮
 */
- (void)shoppingCellDelegate:(ClassCell *)cell WithSelectButton:(UIButton *)selectBt;

- (void)withOfDelete:(NSInteger)section IndexPath:(NSInteger)indexPath;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ClassCell : UICollectionViewCell
@property (nonatomic,strong) FootGoodsModel * model;
@property (nonatomic, strong) id<FootCellDelegate>delegate;
@property (nonatomic,strong) UIButton * read;
@property (nonatomic,strong) UIImageView * icon;
- (void)configWithSection:(NSInteger)section IndexPath:(NSInteger)indexPath IsEdit:(BOOL)isEdit;
@end

NS_ASSUME_NONNULL_END
