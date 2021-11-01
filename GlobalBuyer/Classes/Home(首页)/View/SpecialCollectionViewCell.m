//
//  SpecialCollectionViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/1.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "SpecialCollectionViewCell.h"

@implementation SpecialCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self.contentView addSubview:self.specialV];
    [self.contentView addSubview:self.goodsBackV];
    [self.goodsBackV addSubview: self.goodsSv];
    [self.contentView addSubview:self.specialSecondV];
    [self.contentView addSubview:self.goodsBackSecondV];
    [self.goodsBackSecondV addSubview:self.goodsSecondSv];
    [self.contentView addSubview:self.singleProductV];
}

- (UIImageView *)specialV
{
    if (_specialV == nil) {
        _specialV = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 5, kScreenW - 20, 200)];
        _specialV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstNoticeClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_specialV addGestureRecognizer:tap];
    }
    return _specialV;
}

- (void)firstNoticeClick
{
    [self.delegate clickFirstSpecialNoticeWithBody:self.bodyData];
}

- (UIView *)goodsBackV
{
    if (_goodsBackV == nil) {
        _goodsBackV = [[UIView alloc]initWithFrame:CGRectMake(10, self.specialV.frame.origin.y + self.specialV.frame.size.height + 10, kScreenW - 20, 180)];
    }

    return _goodsBackV;
}

- (UIScrollView *)goodsSv
{
    if (_goodsSv == nil) {
        _goodsSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 20, 180)];
        _goodsSv.contentSize = CGSizeMake(110 * 6, 0);
        [self setData];
    }
    return _goodsSv;
}

- (UIImageView *)specialSecondV
{
    if (_specialSecondV == nil) {
        _specialSecondV = [[UIImageView alloc]initWithFrame:CGRectMake(10 , self.goodsBackV.frame.origin.y + self.goodsBackV.frame.size.height + 10 , kScreenW - 20, 200)];
        _specialSecondV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondNoticeClick)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [_specialSecondV addGestureRecognizer:tap];
    }
    return _specialSecondV;
}

- (void)secondNoticeClick
{
    [self.delegate clickSecondSpecialNoticeWithBody:self.bodySecondData];
}

- (UIView *)goodsBackSecondV
{
    if (_goodsBackSecondV == nil) {
        _goodsBackSecondV = [[UIView alloc]initWithFrame:CGRectMake(10, self.specialSecondV.frame.origin.y + self.specialSecondV.frame.size.height + 10, kScreenW - 20, 180)];
    }
    return _goodsBackSecondV;
}

- (UIScrollView *)goodsSecondSv
{
    if (_goodsSecondSv == nil) {
        _goodsSecondSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 20, 180)];
        _goodsSecondSv.contentSize = CGSizeMake(110 * 6, 0);
    }
    return _goodsSecondSv;
}

- (UIView *)singleProductV
{
    if (_singleProductV == nil) {
        _singleProductV = [[UIView alloc]initWithFrame:CGRectMake(0 ,self.goodsBackSecondV.frame.origin.y + self.goodsBackSecondV.frame.size.height + 10, kScreenW, 80)];
        _singleProductV.backgroundColor = Cell_BgColor;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(40 , 25 , 80, 1)];
        lineV.backgroundColor = [UIColor blackColor];
        [_singleProductV addSubview:lineV];
        UIView *lineSecondV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - 40 - 80, 25, 80, 1)];
        lineSecondV.backgroundColor = [UIColor blackColor];
        [_singleProductV addSubview:lineSecondV];
        UILabel *singleProductLb = [[UILabel alloc]initWithFrame:CGRectMake(lineV.frame.origin.x + lineV.frame.size.width, 5, lineSecondV.frame.origin.x - (lineV.frame.origin.x + lineV.frame.size.width), 40)];
        singleProductLb.text = NSLocalizedString(@"GlobalBuyer_Special_SingleItemRecommendation", nil);
        singleProductLb.textAlignment = NSTextAlignmentCenter;
        singleProductLb.font = [UIFont systemFontOfSize:26];
        [_singleProductV addSubview:singleProductLb];
        UIImageView *singleProductIv = [[UIImageView alloc]initWithFrame:CGRectMake(lineV.frame.origin.x + lineV.frame.size.width + 5, 45, lineSecondV.frame.origin.x - (lineV.frame.origin.x + lineV.frame.size.width) - 10, 25)];
        singleProductIv.image = [UIImage imageNamed:@"单品标题"];
        [_singleProductV addSubview:singleProductIv];
        UILabel *subLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, singleProductIv.frame.size.width - 20, 23)];
        subLb.text = NSLocalizedString(@"GlobalBuyer_Special_Selling", nil);
        subLb.font = [UIFont systemFontOfSize:12];
        subLb.textColor = [UIColor whiteColor];
        subLb.textAlignment = NSTextAlignmentCenter;
        [singleProductIv addSubview:subLb];
    }
    return _singleProductV;
}

- (void)setData{
    
    for (int i = 0 ; i < self.bodyData.count; i++) {
        if (i == 5 || i == self.bodyData.count - 1) {
            UIView *moreV = [[UIView alloc]initWithFrame:CGRectMake(i * 110, 0, 109, 180)];
            moreV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstNoticeClick)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [moreV addGestureRecognizer:tap];
            [self.goodsSv addSubview:moreV];
            
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 109, 180)];
            lb.text = [NSString stringWithFormat:@"%@>>",NSLocalizedString(@"GlobalBuyer_Special_More", nil)];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:16];
            [moreV addSubview:lb];
            return;
        }else{
            UIView *goodOfShow = [[UIView alloc]initWithFrame:CGRectMake(i * 110, 0, 109, 180)];
            goodOfShow.userInteractionEnabled = YES;
            goodOfShow.tag = 100 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstDetailClick:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [goodOfShow addGestureRecognizer:tap];
            [self.goodsSv addSubview:goodOfShow];
            UIImageView *goodIm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 109, 110)];
            [goodIm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.bodyData[i][@"image"]]]];
            [goodOfShow addSubview:goodIm];
            UILabel *goodNameLb = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 115, 109, 30)];
            goodNameLb.font = [UIFont systemFontOfSize:12];
            goodNameLb.textAlignment = NSTextAlignmentCenter;
            goodNameLb.numberOfLines = 0;
            goodNameLb.text = self.bodyData[i][@"title"];
            goodNameLb.textColor = [UIColor grayColor];
            [goodOfShow addSubview:goodNameLb];
            UILabel *goodPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(0 , 150, 109, 20)];
            goodPriceLb.font = [UIFont systemFontOfSize:12];
            goodPriceLb.numberOfLines = 0;
            goodPriceLb.textAlignment = NSTextAlignmentCenter;
            goodPriceLb.text = self.bodyData[i][@"sub_title2"];
            goodPriceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
            [goodOfShow addSubview:goodPriceLb];
            
            UIImageView *discountIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            discountIv.image = [UIImage imageNamed:@"折扣贴"];
            [goodIm addSubview:discountIv];
            UILabel *discountLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            discountLb.textColor = [UIColor whiteColor];
            discountLb.font = [UIFont systemFontOfSize:10];
            discountLb.text = [NSString stringWithFormat:@"%@%@",self.bodyData[i][@"placeholder2"],NSLocalizedString(@"GlobalBuyer_Home_Discount", nil)];
            discountLb.textAlignment = NSTextAlignmentCenter;
            [discountIv addSubview:discountLb];
            
        }
    }
}

- (void)firstDetailClick:(UITapGestureRecognizer *)tap
{
    [self.delegate clickFirstDetailWithURL:self.bodyData[[tap view].tag - 100][@"href"] nationalityStr:self.bodyData[[tap view].tag - 100][@"placeholder1"]];
}

- (void)setSecondData
{
    for (int i = 0; i < self.bodySecondData.count; i++) {
        if (i == 5 || i == self.bodySecondData.count - 1) {
            UIView *moreV = [[UIView alloc]initWithFrame:CGRectMake(i * 110, 0, 109, 180)];
            moreV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondNoticeClick)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [moreV addGestureRecognizer:tap];
            [self.goodsSecondSv addSubview:moreV];
            
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 109, 180)];
            lb.text = [NSString stringWithFormat:@"%@>>",NSLocalizedString(@"GlobalBuyer_Special_More", nil)];;
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:16];
            [moreV addSubview:lb];
            return;
        }else{
            UIView *goodOfShowSecond = [[UIView alloc]initWithFrame:CGRectMake(i * 110, 0, 109, 180)];
            goodOfShowSecond.userInteractionEnabled = YES;
            goodOfShowSecond.tag = i + 200;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondDetailClick:)];
            tap.numberOfTouchesRequired = 1;
            tap.numberOfTapsRequired = 1;
            [goodOfShowSecond addGestureRecognizer:tap];
            [self.goodsSecondSv addSubview:goodOfShowSecond];
            UIImageView *goodImSecond = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 109, 110)];
            [goodImSecond sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.bodySecondData[i][@"image"]]]];
            [goodOfShowSecond addSubview:goodImSecond];
            UILabel *goodNameLbSecond = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 115, 109, 30)];
            goodNameLbSecond.text = self.bodySecondData[i][@"title"];
            goodNameLbSecond.font = [UIFont systemFontOfSize:12];
            goodNameLbSecond.textAlignment = NSTextAlignmentCenter;
            goodNameLbSecond.numberOfLines = 0;
            goodNameLbSecond.textColor = [UIColor grayColor];
            [goodOfShowSecond addSubview:goodNameLbSecond];
            UILabel *goodPriceLbSecond = [[UILabel alloc]initWithFrame:CGRectMake(0 , 150, 109, 20)];
            goodPriceLbSecond.text = self.bodySecondData[i][@"sub_title2"];
            goodPriceLbSecond.font = [UIFont systemFontOfSize:12];
            goodPriceLbSecond.numberOfLines = 0;
            goodPriceLbSecond.textAlignment = NSTextAlignmentCenter;
            goodPriceLbSecond.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
            [goodOfShowSecond addSubview:goodPriceLbSecond];
            
            
            UIImageView *discountIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            discountIv.image = [UIImage imageNamed:@"折扣贴"];
            [goodImSecond addSubview:discountIv];
            UILabel *discountLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            discountLb.textColor = [UIColor whiteColor];
            discountLb.font = [UIFont systemFontOfSize:10];
            discountLb.text = [NSString stringWithFormat:@"%@%@",self.bodySecondData[i][@"placeholder2"],NSLocalizedString(@"GlobalBuyer_Home_Discount", nil)];
            discountLb.textAlignment = NSTextAlignmentCenter;
            [discountIv addSubview:discountLb];
        }
    }
}

- (void)secondDetailClick:(UITapGestureRecognizer *)tap
{
    [self.delegate clickSecondDetailWithURL:self.bodySecondData[[tap view].tag - 200][@"href"] nationalityStr:self.bodySecondData[[tap view].tag - 200][@"placeholder1"]];
}

@end
