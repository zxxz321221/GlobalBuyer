//
//  CollectionViewHeaderView.h
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/4/22.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FootHearModel;
@class CollectionViewHeaderView;
NS_ASSUME_NONNULL_BEGIN
@protocol  CollectionViewHeaderViewDelegate<NSObject>

- (void)shoppingCarHeaderViewDelegat:(UIButton *)bt WithHeadView:(CollectionViewHeaderView *)view;

@end
@interface CollectionViewHeaderView : UICollectionReusableView
@property (nonatomic,strong) FootHearModel *model;
@property (nonatomic,strong) UILabel * label;
@property (nonatomic , strong) UIButton * readBtn;
@property(nonatomic,assign)id<CollectionViewHeaderViewDelegate>delegate;
- (void)configWithIsEdit:(BOOL)isEdit Section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
