//
//  TRCardListView.h
//  卡片堆叠效果实现
//
//  Created by cry on 2017/6/8.
//  Copyright © 2017年 egova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRCardListView;

@protocol TRCardListViewDataSource <NSObject>

- (NSInteger)tr_numberOfCardsInCardListView:(TRCardListView *)cardListView;
- (UIView *)tr_cardListView:(TRCardListView *)cardListView cardAtIndex:(NSInteger)index;

@end

@protocol TRCardListViewDelegate <NSObject>

- (void)tr_cardListView:(TRCardListView *)cardListView didSelectCardAtIndex:(NSInteger)index;

@end

@interface TRCardListView : UIScrollView <UIScrollViewDelegate>
/// 距离窗口顶部的距离 默认64
@property (nonatomic,assign) CGFloat top;
/// 视图与视图之间的距离 默认64
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic, weak) id<TRCardListViewDataSource> trDataSource;
@property (nonatomic, weak) id<TRCardListViewDelegate> trDelegate;
/**
 同UITableView，用于注册要复用的卡片类名，需要继承与UIView。
 布局代码重写在 initWithFrame: 方法里。

 @param cardClass 自定义卡片类名
 */
- (void)registerForReuseWithClass:(Class)cardClass;

/**
 在 “tr_carListView: cardAtIndex:” 协议里使用，内部做了复用处理。

 @param index 卡片的位置序号
 @return 返回卡片实例对象，需要根据序号重新更新卡片上的信息，否则因复用会导致信息错乱（同UITableView，你懂得😉）
 */
- (UIView *)dequeueReusableCardAtIndex:(NSInteger)index;

- (void)reloadData;

@end
