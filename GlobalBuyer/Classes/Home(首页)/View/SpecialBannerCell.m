//
//  SpecialBannerCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/7.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "SpecialBannerCell.h"

#import "BannerModel.h"

@implementation SpecialBannerCell

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
    [self.contentView addSubview:self.recommendV];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 5, kScreenW, kScreenW/2.5 + 30);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        self.start = YES;
    }
    return _scrollView;
}


- (UIView *)recommendV
{
    if (_recommendV == nil) {
        _recommendV = [[UIView alloc]initWithFrame:CGRectMake( 5 , kScreenW/2.5 + 20, kScreenW - 10, 80)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(50, 34, 80, 1)];
        lineV.backgroundColor = [UIColor blackColor];
        [_recommendV addSubview:lineV];
        UIView *lineRightV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 50 - 80, 34, 80, 1)];
        lineRightV .backgroundColor = [UIColor blackColor];
        [_recommendV addSubview:lineRightV];
        UILabel *webTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(lineV.frame.origin.x + lineV.frame.size.width, 20, lineRightV.frame.origin.x - (lineV.frame.origin.x + lineV.frame.size.width), 30)];
        webTitleLb.text = NSLocalizedString(@"GlobalBuyer_Special_HotRecommendation", nil);
        webTitleLb.textAlignment = NSTextAlignmentCenter;
        webTitleLb.font = [UIFont systemFontOfSize:21];
        [_recommendV addSubview:webTitleLb];
        UIImageView *sellingIv = [[UIImageView alloc]initWithFrame:CGRectMake(webTitleLb.frame.origin.x, webTitleLb.frame.origin.y + 30 + 1, webTitleLb.frame.size.width, 25)];
        sellingIv.image = [UIImage imageNamed:@"单品标题"];
        [_recommendV addSubview:sellingIv];
        UILabel *bodyLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, sellingIv.frame.size.width - 20, 24)];
        bodyLb.font = [UIFont systemFontOfSize:11];
        bodyLb.text = NSLocalizedString(@"GlobalBuyer_Special_Discount", nil);
        bodyLb.textAlignment = NSTextAlignmentCenter;
        bodyLb.textColor = [UIColor whiteColor];
        [sellingIv addSubview:bodyLb];
    }
    return _recommendV;
}

-(void)setImgArr:(NSMutableArray *)imgArr{
    
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
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenW + 5, 0, kScreenW - 10, kScreenW/2.5 + 30)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,model.image]]];
        img.tag = 10 + i;
        [self.scrollView addSubview:img];
    }
    
    
}



@end
