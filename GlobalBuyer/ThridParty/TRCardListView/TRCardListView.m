//
//  TRCardListView.m
//  卡片堆叠效果实现
//
//  Created by cry on 2017/6/8.
//  Copyright © 2017年 egova. All rights reserved.
//

#import "TRCardListView.h"

#define TR_HEIGTH [UIScreen mainScreen].bounds.size.height
#define TR_WIDTH [UIScreen mainScreen].bounds.size.width

#ifndef __OPTIMIZE__
#    define TRLog(...) NSLog(__VA_ARGS__)
#else
#    define TRLog(...)
#endif

@interface TRCard : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) CGFloat positionY;

@end

@implementation TRCard

- (instancetype)initWithPositionY:(CGFloat)positionY{
    
    if (self = [super init]) {
        _positionY = positionY;
        _view = nil;
    }
    return self;
}

@end

@interface TRCardListView()

@property (nonatomic, strong) UIView *contentView;
//用来存储card位置
@property (nonatomic, strong) NSMutableArray<TRCard *> * cards;
@property (nonatomic, strong) NSMutableArray<UIView *> * unUsedCards;
@property (nonatomic, assign) NSInteger countOfCard;
@property (nonatomic) Class cardClass;

@end

@implementation TRCardListView

- (void)registerForReuseWithClass:(Class)cardClass{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    _cardClass = cardClass;
    [self updateLayout];
}

- (UIView *)dequeueReusableCardAtIndex:(NSInteger)index{
    
    UIView *view = nil;
    if (_unUsedCards.count > 0) {
        view = _unUsedCards.firstObject;
    }else{
        UIView *card = [[_cardClass alloc] initWithFrame:CGRectMake(0, 0, TR_WIDTH, TR_HEIGTH)];
        view = card;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [card addGestureRecognizer:tap];
        
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        [card addGestureRecognizer:swipe];
    }
    return view;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (_trDelegate && [_trDelegate respondsToSelector:@selector(tr_cardListView:didSelectCardAtIndex:)]) {
        for (int i = 0; i < self.countOfCard; i++) {
            if (_cards[i].view) {
                if (view == _cards[i].view) {
                    [_trDelegate tr_cardListView:self didSelectCardAtIndex:i];
                    break;
                }
            }
        }
    }
}

//- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipe{
//    NSLog(@"swipe");
//    UIView *view = swipe.view;
//}

- (void)reloadData{
    
    [self initCards];
    [self updateLayout];
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupContentView];
    [self setupDefaultValue];
    self.contentView.frame = self.bounds;
}

- (instancetype)init{
    
    if (self = [super init]) {
        [self setupDefaultValue];
        [self setupContentView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    self.contentView.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
        [self setupDefaultValue];
        self.delegate = self;
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= 220) {
        [scrollView setContentOffset:CGPointMake(0, 220)];
    }
}

- (void)setupContentView{
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
}

- (void)setupDefaultValue{
    
    _top = 64.0;
    _distance = 64.0;
}

- (void)initCards{
    
    _cards = [NSMutableArray array];
    _unUsedCards = [NSMutableArray array];
    NSInteger count = self.countOfCard;
    for (NSInteger i = 0; i < count; i++) {
        TRCard *card = [[TRCard alloc] initWithPositionY:0];
        [_cards insertObject:card atIndex:0];
    }
}

- (void)setTrDelegate:(id<TRCardListViewDelegate>)trDelegate{
    _trDelegate = trDelegate;
    if (self.countOfCard) {
        [self initCards];
        [self updateLayout];
    }
}

- (void)setTrDataSource:(id<TRCardListViewDataSource>)trDataSource{
    _trDataSource = trDataSource;
    if (self.countOfCard) {
        [self initCards];
        [self updateLayout];
    }
}

- (NSInteger)countOfCard{
    
    if (_trDataSource && [_trDataSource respondsToSelector:@selector(tr_numberOfCardsInCardListView:)]) {
        return [_trDataSource tr_numberOfCardsInCardListView:self];
    }
    return 0;
}

- (void)setTop:(CGFloat)top{
    
    _top = top;
    [self updateLayout];
}

- (void)setDistance:(CGFloat)distance{
    
    _distance = distance;
    [self updateLayout];
}

- (void)setContentOffset:(CGPoint)contentOffset{
    
    [self updateLayoutOfCardWithContentOffset:contentOffset];
    [super setContentOffset:contentOffset];
}


- (void)updateLayout{
    
    self.contentSize = CGSizeMake(TR_WIDTH, TR_HEIGTH + self.distance * self.countOfCard - 1.5);
    self.contentOffset = CGPointMake(0, 0);
}

- (void)updateLayoutOfCardWithContentOffset:(CGPoint)contentOffset{
    
    self.contentView.frame = CGRectMake(0, contentOffset.y, TR_WIDTH, TR_HEIGTH);
    [_cards enumerateObjectsUsingBlock:^(TRCard * card, NSUInteger idx, BOOL *stop) {
        
        NSInteger value = self.distance;
        /*************设置位置***************/
        NSInteger begin_y = value * (self.countOfCard - idx - 1);
        CGFloat distance_y = self.contentSize.height - contentOffset.y - TR_HEIGTH - begin_y;
        CGFloat positionY = self.top + pow(distance_y, 2) / pow(2, 6);
        if (distance_y >= -50) {
            CGFloat alpha = distance_y >= 0?1:(distance_y + 50)/ 50;
            card.view.alpha = alpha;
        }else{
            card.view.alpha = 0;
        }
        card.positionY = positionY;
        if (positionY <= TR_HEIGTH) {
            if (card.view == nil) {
                [self setViewInCard:card atIndex:idx];
                [self addCardWithCard:card atIndex:idx];;
            }
            [self updateOriginWithView:card.view newOriginY:positionY];
            /*************设置大小***************/
            CGFloat scale = 0.50;
            scale = (positionY * 0.75 + 70) / 1000 + scale >= 0.95?0.95:(positionY * 0.75 + 50) / 1000 + scale;
            card.view.layer.transform = CATransform3DMakeScale(scale, scale, 1);
        }else{
            if (card.view != nil) {
                [_unUsedCards addObject:card.view];
                [card.view removeFromSuperview];
                card.view = nil;
            }
        }
    }];
}

- (void)setViewInCard:(TRCard *)card atIndex:(NSInteger)index{
    
    if (self.trDataSource && [self.trDataSource respondsToSelector:@selector(tr_cardListView:cardAtIndex:)]) {
        
        UIView * view = [self.trDataSource tr_cardListView:self cardAtIndex:index];
        card.view = view;
        if ([_unUsedCards containsObject:view]) {
            [_unUsedCards removeObject:view];
        }
    }else{
        TRLog(@"未实现 Method: \"tr_carListView:cardAtIndex:\"");
    }
}

- (void)addCardWithCard:(TRCard *)card atIndex:(NSInteger)index{
    
    if (index == 0) {
        [self.contentView insertSubview:card.view atIndex:0];
    }else if (index == self.countOfCard - 1){
        [self.contentView addSubview:card.view];
    }else if (self.cards[index + 1].view){
        [self.contentView insertSubview:card.view atIndex:0];
    }else if (self.cards[index - 1].view){
        [self.contentView addSubview:card.view];
    }
}

- (void)updateOriginWithView:(UIView *)view newOriginY:(CGFloat)originY{
    
    CGSize size = view.frame.size;
    view.frame = CGRectMake(view.frame.origin.x, originY, size.width, size.height);
}

@end
