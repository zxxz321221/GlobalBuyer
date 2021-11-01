//
//  CountryBannerCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/2.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CountryBannerCellDelegate <NSObject>

-(void)cellImgClickWithLink:(NSString *)urlString;
-(void)cellImgClickWebMore;

@end

@interface CountryBannerCell : UICollectionViewCell<UIScrollViewDelegate,UITextFieldDelegate>

- (void)setWebLinkWithData:(NSMutableArray *)data;

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *webTitleV;
@property (nonatomic, strong) UIView *webLinkV;
@property (nonatomic, strong) UIView *recommendV;
@property (nonatomic, strong) id<CountryBannerCellDelegate>delegate;
@property (nonatomic, assign) BOOL start;
@property (nonatomic, strong) NSMutableArray *webData;

@property (nonatomic, assign) BOOL isMore;

@property (nonatomic, assign) int currentTimerNum;

@end
