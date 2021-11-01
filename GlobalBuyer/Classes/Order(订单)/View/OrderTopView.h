//
//  OrderTopView.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderTopViewDelegate <NSObject>

-(void)clickAtIndex:(NSInteger) index;

@end

@interface OrderTopView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) id<OrderTopViewDelegate>delegate;
- (void)setOrderTopViewLaState:(NSInteger) index;

@end
