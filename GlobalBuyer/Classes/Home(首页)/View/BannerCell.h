//
//  BannerCell.h
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BannerCellDelegate <NSObject>

-(void)cellImgClickWithLink:(NSString *)urlString withImg:(NSString *)img type:(NSString *)type url:(NSString *)url;
-(void)selectAmazonOrOthers:(NSInteger)index;
-(void)clickGlobalWebMore;
-(void)clickWebWithLink:(NSString *)link;
-(void)clickNovice;
-(void)clickOneImg;
-(void)clickTwoImg;
-(void)clickThreeImg;
-(void)clickNewYearWithId:(NSString *)goodsid tag:(NSInteger)tag;

@end

@interface BannerCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *amazonV;
@property (nonatomic, strong) id<BannerCellDelegate>delegate;
@property (nonatomic, assign) BOOL start;
@property (nonatomic, strong) UIView *arcV;
@property (nonatomic, assign) int currentTimerNum;
@property (nonatomic, strong) UILabel *noviceV;

@property (nonatomic, strong) UIView *firstV;
@property (nonatomic, strong) UIView *secondV;
@property (nonatomic, strong) UIView *thirdV;

@property (nonatomic, strong) NSMutableArray *newyearArr;
@property (nonatomic, strong) UIView *newyearBackV;

@property (nonatomic, strong) UIView *webBackV;
@property (nonatomic, strong) NSMutableArray *webArr;

@end
