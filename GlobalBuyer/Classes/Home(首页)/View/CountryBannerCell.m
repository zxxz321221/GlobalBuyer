//
//  CountryBannerCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/2.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#define Main_Color [UIColor colorWithRed:0.50 green:0.76 blue:0.25 alpha:1]
#define Cell_BgColor  [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kTabBarH        49.0f
#define kStatusBarH     20.0f
#define kNavigationBarH 44.0f

#import "CountryBannerCell.h"

#import "BannerModel.h"
#import "UIImageView+WebCache.h"

@implementation CountryBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = Cell_BgColor;
    }
    return self;
}

-(void)addSubviews {
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.webTitleV];
    [self.contentView addSubview:self.webLinkV];
    [self.contentView addSubview:self.recommendV];
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
        
        _pageControl.currentPageIndicatorTintColor = Main_Color;
        _pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 30, kScreenW, 30);
        
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 10, kScreenW, kScreenW/2.5);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        self.start = YES;
    }
    return _scrollView;
}

- (UIView *)webTitleV
{
    if (_webTitleV == nil) {
        _webTitleV = [[UIView alloc]initWithFrame:CGRectMake(5, self.scrollView.frame.origin.y + self.scrollView.frame.size.height, kScreenW - 10, 50)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(50, 24, 80, 1)];
        lineV.backgroundColor = [UIColor blackColor];
        [_webTitleV addSubview:lineV];
        UIView *lineRightV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50 - 80, 24, 80, 1)];
        lineRightV .backgroundColor = [UIColor blackColor];
        [_webTitleV addSubview:lineRightV];
        UILabel *webTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(lineV.frame.origin.x + lineV.frame.size.width, 10, lineRightV.frame.origin.x - (lineV.frame.origin.x + lineV.frame.size.width), 30)];
        webTitleLb.text = NSLocalizedString(@"GlobalBuyer_Special_Web", nil);
        webTitleLb.textAlignment = NSTextAlignmentCenter;
        webTitleLb.font = [UIFont systemFontOfSize:21];
        [_webTitleV addSubview:webTitleLb];
    }
    return _webTitleV;
}

- (UIView *)webLinkV
{
    if (_webLinkV == nil) {
        _webLinkV = [[UIView alloc]initWithFrame:CGRectMake(5, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 50 , kScreenW - 10 , 100)];
    }
    return _webLinkV;
}

- (UIView *)recommendV
{
    if (_recommendV == nil) {
        _recommendV = [[UIView alloc]initWithFrame:CGRectMake( 5 , self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 50 + 100, kScreenW - 10, 80)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(50, 34, 80, 1)];
        lineV.backgroundColor = [UIColor blackColor];
        [_recommendV addSubview:lineV];
        UIView *lineRightV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50 - 80, 34, 80, 1)];
        lineRightV .backgroundColor = [UIColor blackColor];
        [_recommendV addSubview:lineRightV];
        UILabel *webTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(lineV.frame.origin.x + lineV.frame.size.width, 20, lineRightV.frame.origin.x - (lineV.frame.origin.x + lineV.frame.size.width), 30)];
        webTitleLb.text = NSLocalizedString(@"GlobalBuyer_Special_SingleItemRecommendation", nil);
        webTitleLb.textAlignment = NSTextAlignmentCenter;
        webTitleLb.font = [UIFont systemFontOfSize:21];
        [_recommendV addSubview:webTitleLb];
        UIImageView *sellingIv = [[UIImageView alloc]initWithFrame:CGRectMake(webTitleLb.frame.origin.x, webTitleLb.frame.origin.y + 30 + 1, webTitleLb.frame.size.width, 25)];
        sellingIv.image = [UIImage imageNamed:@"单品标题"];
        [_recommendV addSubview:sellingIv];
        UILabel *bodyLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, sellingIv.frame.size.width - 20, 24)];
        bodyLb.font = [UIFont systemFontOfSize:11];
        bodyLb.text = NSLocalizedString(@"GlobalBuyer_Special_Selling", nil);
        bodyLb.textAlignment = NSTextAlignmentCenter;
        bodyLb.textColor = [UIColor whiteColor];
        [sellingIv addSubview:bodyLb];
    }
    return _recommendV;
}

-(void)setImgArr:(NSMutableArray *)imgArr{
    
    __block int timerNum = 0;
    _imgArr = imgArr;
    if (_imgArr == nil) {
        return;
    }
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    self.scrollView.contentSize = CGSizeMake(kScreenW*_imgArr.count, 0);
    for (int i = 0; i < _imgArr.count; i++) {
        BannerModel * model = _imgArr[i];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenW + 5, 0, kScreenW - 10, kScreenW/2.5)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,model.image]]];
        img.tag = 10 + i;
        [self.scrollView addSubview:img];
        
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1; //点击次数
        tapGesture.numberOfTouchesRequired = 1; //点击手指数
        
        [img addGestureRecognizer:tapGesture];
    }
    
    if (_imgArr.count > 1 && self.start == YES) {
        self.start = NO;
        self.currentTimerNum = timerNum;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(RollTheBanner) userInfo:nil repeats:YES];
//        [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            if (timerNum == _imgArr.count) {
//                timerNum = 0;
//                [UIView animateWithDuration:1 animations:^{
//                    self.scrollView.contentOffset = CGPointMake(0, 0);
//                }];
//            }
//            [UIView animateWithDuration:1 animations:^{
//                self.scrollView.contentOffset = CGPointMake(kScreenW * timerNum, 0);
//                self.pageControl.currentPage = timerNum;
//            }];
//            timerNum++;
//        }];
    }
    self.pageControl.numberOfPages = _imgArr.count;
    
}

- (void)RollTheBanner
{
    if (self.currentTimerNum == _imgArr.count) {
        self.currentTimerNum = 0;
        [UIView animateWithDuration:1 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = CGPointMake(kScreenW * self.currentTimerNum, 0);
        self.pageControl.currentPage = self.currentTimerNum;
    }];
    self.currentTimerNum++;
}

- (void)setWebLinkWithData:(NSMutableArray *)data
{
//    NSArray *arr = @[@"temporary_2.jpg",@"temporary_1.jpg",@"temporary_3.jpg",@"temporary_4.jpg",@"temporary_5.jpg",@"temporary_6.jpg",@"temporary_7.jpg"];
    self.webData = data;
    for (int i = 0; i <= data.count; i++) {
//        if (i == data.count || i == 7) {
//            for (int j = 0; j <= (7 - data.count); j ++) {
//                if ((i+j) == 7) {
//                    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake( 1 + (((kScreenW - 6)/4) * ((i + j) % 4)), 1 + (51 * ((i+j)/4)), (kScreenW/4) - 5, 49)];
//                    iv.tag = 888;
//                    iv.userInteractionEnabled = YES;
//                    iv.backgroundColor = [UIColor whiteColor];
//                    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, iv.frame.size.height)];
//                    lb.text = [NSString stringWithFormat:@"%@>>",NSLocalizedString(@"GlobalBuyer_Special_More", nil)];
//                    lb.textAlignment = NSTextAlignmentCenter;
//                    [iv addSubview:lb];
//                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWebMore)];
//                    tap.numberOfTapsRequired = 1;
//                    tap.numberOfTouchesRequired = 1;
//                    [iv addGestureRecognizer:tap];
//                    [self.webLinkV addSubview:iv];
//                    return;
//                }
//                UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake( 1 + (((kScreenW - 6)/4) * ((i + j) % 4)), 1 + (51 * ((i + j)/4)), (kScreenW/4) - 5, 49)];
//                iv.backgroundColor = [UIColor whiteColor];
//                iv.image = [UIImage imageNamed:arr[j]];
//                [self.webLinkV addSubview:iv];
//            }
//
//
//        }
        if (i == 7 && self.isMore == NO) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake( 1 + (((kScreenW - 6)/4) * (i % 4)), 1 + (51 * (i/4)), (kScreenW/4) - 5, 49)];
            iv.tag = 888;
            iv.userInteractionEnabled = YES;
            iv.backgroundColor = [UIColor whiteColor];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv.frame.size.width, iv.frame.size.height)];
            lb.text = [NSString stringWithFormat:@"%@>>",NSLocalizedString(@"GlobalBuyer_Special_More", nil)];
            lb.textAlignment = NSTextAlignmentCenter;
            [iv addSubview:lb];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWebMore:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [iv addGestureRecognizer:tap];
            [self.webLinkV addSubview:iv];
            return;
        }
        
        if (i < data.count) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake( 1 + (((kScreenW - 6)/4) * (i % 4)), 1 + (51 * (i/4)), (kScreenW/4) - 5, 49)];
            iv.tag = i + 300;
            iv.backgroundColor = [UIColor whiteColor];
            iv.userInteractionEnabled = YES;
            UIImageView *webIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, iv.frame.size.width - 20, iv.frame.size.height - 20)];
            [webIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,data[i][@"image"]]]];
            [iv addSubview:webIv];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWebLink:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [iv addGestureRecognizer:tap];
            [self.webLinkV addSubview:iv];
        }

    }
    
}

- (void)clickWebLink:(UITapGestureRecognizer *)tap
{
    [self.delegate cellImgClickWithLink:self.webData[[tap view].tag - 300][@"link"]];
}

- (void)clickWebMore:(UITapGestureRecognizer *)tap
{
    [[tap view]removeFromSuperview];
    self.isMore = YES;

    [self.webLinkV removeFromSuperview];
    self.webLinkV = nil;
    [self.contentView addSubview:self.webLinkV];
    if (self.webData.count%4 == 0) {
        self.webLinkV.frame = CGRectMake(5, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 50 , kScreenW - 10 , self.webData.count/4 * 50);
        self.recommendV.frame = CGRectMake( 5 , self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 50 + self.webData.count/4 * 50, kScreenW - 10, 80);
    }else{
        self.webLinkV.frame = CGRectMake(5, self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 50 , kScreenW - 10 , (self.webData.count/4 + 1) * 50);
            self.recommendV.frame = CGRectMake( 5 , self.scrollView.frame.origin.y + self.scrollView.frame.size.height + 50 + (self.webData.count/4 + 1) * 50, kScreenW - 10, 80);
    }

    for (int i = 0; i < self.webData.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake( 1 + (((kScreenW - 6)/4) * (i % 4)), 1 + (51 * (i/4)), (kScreenW/4) - 5, 49)];
        iv.tag = i + 300;
        iv.backgroundColor = [UIColor whiteColor];
        iv.userInteractionEnabled = YES;
        UIImageView *webIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, iv.frame.size.width - 20, iv.frame.size.height - 20)];
        [webIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.webData[i][@"image"]]]];
        [iv addSubview:webIv];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickWebLink:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tap];
        [self.webLinkV addSubview:iv];
    }
    [self.delegate cellImgClickWebMore];
}

-(void)tapGesture:(UITapGestureRecognizer *)tap {
    BannerModel * model = self.imgArr[ [tap view].tag - 10];
    [self.delegate cellImgClickWithLink:model.href];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pages = scrollView.contentOffset.x/kScreenW ;
    //NSLog(@"%f",scrollView.contentOffset.x);
    self.pageControl.currentPage = pages;
    //NSLog(@"%ld",self.pageControl.currentPage);
}

@end
