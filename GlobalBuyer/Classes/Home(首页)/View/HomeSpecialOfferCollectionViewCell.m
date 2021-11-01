//
//  HomeSpecialOfferCollectionViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/23.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "HomeSpecialOfferCollectionViewCell.h"

@implementation HomeSpecialOfferCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    UIView *goodsV = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    goodsV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:goodsV];
    
    UIView *layerV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, goodsV.frame.size.width - 20, goodsV.frame.size.height - 20)];
    layerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    layerV.layer.cornerRadius = 10;
    layerV.layer.borderWidth = 0.7;
    [goodsV addSubview:layerV];
    
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, goodsV.frame.size.width - 40, goodsV.frame.size.width - 40 + 10)];
    [goodsV addSubview:self.iv];
    
    self.lbo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    self.lbo.layer.cornerRadius = 10;
    self.lbo.textColor = [UIColor whiteColor];
    self.lbo.backgroundColor = [UIColor redColor];
    self.lbo.textAlignment = NSTextAlignmentCenter;
    self.lbo.layer.masksToBounds = YES;
    [self.iv addSubview:self.lbo];
    
    self.lbt = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 30, 120, 20)];
    self.lbt.textColor = [UIColor lightGrayColor];
    self.lbt.font = [UIFont systemFontOfSize:12];
    [goodsV addSubview:self.lbt];
    
    self.lbth = [[UILabel alloc]initWithFrame:CGRectMake(goodsV.frame.size.width - 140, goodsV.frame.size.height - 32, 120, 20)];
    self.lbth.textAlignment = NSTextAlignmentRight;
    self.lbth.textColor = [UIColor redColor];
    self.lbth.font = [UIFont systemFontOfSize:12];
    [goodsV addSubview:self.lbth];
    
    self.lbf = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 70, goodsV.frame.size.width - 40, 40)];
    self.lbf.textColor = [UIColor lightGrayColor];
    self.lbf.font = [UIFont systemFontOfSize:13];
    self.lbf.numberOfLines = 0;
    [goodsV addSubview:self.lbf];
}

@end
