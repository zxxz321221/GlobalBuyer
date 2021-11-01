//
//  CountryClassifyCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/3.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "CountryClassifyCell.h"

@implementation CountryClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return self;
}

-(void)addSubviews{
    [self.contentView addSubview:self.wirteV];
    [self.contentView addSubview:self.rightWirteV];
}

- (UIView *)wirteV
{
    if (_wirteV == nil) {
        _wirteV = [[UIView alloc]initWithFrame:CGRectMake( 10, 1, kScreenW/2 - 11, kScreenW/2 - 1 + 30)];
        _wirteV.backgroundColor = [UIColor whiteColor];
        _wirteV.userInteractionEnabled = YES;
        [_wirteV addSubview:self.imgView];
        [_wirteV addSubview:self.webIconIV];
        [_wirteV addSubview:self.goodName];
        [_wirteV addSubview:self.priceLb];
        [_wirteV addSubview:self.oPriceLb];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLeftLink)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_wirteV addGestureRecognizer:tap];
        
    }
    return _wirteV;
}

- (void)clickLeftLink
{
    [self.delegate clickHomeGoodsWithLink:self.href Good_site:self.good_site];
}

- (UIView *)rightWirteV
{
    if (_rightWirteV == nil) {
        _rightWirteV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, 1, kScreenW/2 - 10, kScreenW/2 - 1 + 30)];
        _rightWirteV.backgroundColor = [UIColor whiteColor];
        _rightWirteV.userInteractionEnabled = YES;
        [_rightWirteV addSubview:self.rightImgView];
        [_rightWirteV addSubview:self.rightWebIconIV];
        [_rightWirteV addSubview:self.rightGoodName];
        [_rightWirteV addSubview:self.rightPriceLb];
        [_rightWirteV addSubview:self.oRightPriceLb];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRightLink)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_rightWirteV addGestureRecognizer:tap];
    }
    return _rightWirteV;
}

- (void)clickRightLink
{
    [self.delegate clickHomeGoodsWithLink:self.rightHref Good_site:self.rightgood_site];
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.frame = CGRectMake(30, 15, self.wirteV.frame.size.width - 60 ,self.wirteV.frame.size.width - 60);
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.masksToBounds = YES;
        _imgView.autoresizesSubviews = YES;
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    }
    return _imgView;
}

- (UIImageView *)rightImgView
{
    if (_rightImgView == nil) {
        _rightImgView = [UIImageView new];
        _rightImgView.frame = CGRectMake(30, 15, self.rightWirteV.frame.size.width - 60 ,self.rightWirteV.frame.size.width - 60);
    }
    return _rightImgView;
}

- (UIImageView *)webIconIV
{
    if (_webIconIV == nil) {
        _webIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 20, 20)];
    }
    return _webIconIV;
}

- (UIImageView *)rightWebIconIV
{
    if (_rightWebIconIV == nil) {
        _rightWebIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 20, 20)];
    }
    return _rightWebIconIV;
}

- (UILabel *)goodName
{
    if (_goodName == nil) {
        _goodName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rightWirteV.frame.size.width - 60 + 20, self.rightWirteV.frame.size.width - 20, 20)];
        _goodName.font = [UIFont systemFontOfSize:12];
    }
    return _goodName;
}

- (UILabel *)rightGoodName
{
    if (_rightGoodName == nil) {
        _rightGoodName = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rightWirteV.frame.size.width - 60 + 20, self.rightWirteV.frame.size.width - 20, 20)];
        _rightGoodName.font = [UIFont systemFontOfSize:12];
    }
    return _rightGoodName;
}

- (UILabel *)oPriceLb
{
    if (_oPriceLb == nil) {
        _oPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rightWirteV.frame.size.width - 60 + 20 + 20+5, self.rightWirteV.frame.size.width - 20, 25)];
        _oPriceLb.textColor = [UIColor lightGrayColor];
        _oPriceLb.font = [UIFont systemFontOfSize:13];
    }
    return _oPriceLb;
}

- (UILabel *)oRightPriceLb
{
    if (_oRightPriceLb == nil) {
        _oRightPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rightWirteV.frame.size.width - 60 + 20 + 20+5, self.rightWirteV.frame.size.width - 20, 25)];
        _oRightPriceLb.textColor = [UIColor lightGrayColor];
        _oRightPriceLb.font = [UIFont systemFontOfSize:13];
    }
    return _oRightPriceLb;
}

- (UILabel *)priceLb
{
    if (_priceLb == nil) {
        _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rightWirteV.frame.size.width - 60 + 20 + 20 + 30, self.rightWirteV.frame.size.width - 20, 25)];
        _priceLb.textColor = [UIColor redColor];
    }
    return _priceLb;
}

- (UILabel *)rightPriceLb
{
    if (_rightPriceLb == nil) {
        _rightPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rightWirteV.frame.size.width - 60 + 20 + 20 + 30, self.rightWirteV.frame.size.width - 20, 25)];
        _rightPriceLb.textColor = [UIColor redColor];
    }
    return _rightPriceLb;
}

@end
