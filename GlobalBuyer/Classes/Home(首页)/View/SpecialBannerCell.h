//
//  SpecialBannerCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/7.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialBannerCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *webTitleV;
@property (nonatomic, strong) UIView *webLinkV;
@property (nonatomic, strong) UIView *recommendV;
@property (nonatomic, assign) BOOL start;
@property (nonatomic, strong) NSMutableArray *webData;

@property (nonatomic, strong) NSString *noticeURL;

@end
