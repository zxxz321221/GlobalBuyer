//
//  CouponCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/4/18.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    self.couponBackIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, kScreenW - 30, kScreenW/3.5)];
    self.couponBackIV.image = [UIImage imageNamed:@"代购费优惠卷背景"];
    [self.contentView addSubview:self.couponBackIV];
    
    self.rightLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/3*2, 40, kScreenW/3 - 30, kScreenW/3.5 - 50)];
    self.rightLb.numberOfLines = 0;
    self.rightLb.font = [UIFont systemFontOfSize:15];
    self.rightLb.textColor = [UIColor whiteColor];
    self.rightLb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rightLb];
    
    self.currencyLb = [[UILabel alloc]initWithFrame:CGRectMake(20*kScaleW, 40*kScaleH, 40*kScaleW, 40*kScaleW)];
    self.currencyLb.font = [UIFont systemFontOfSize:16*kScaleW];
    self.currencyLb.textColor = [UIColor whiteColor];
    [self.couponBackIV addSubview:self.currencyLb];
    
    self.priceLb = [[UILabel alloc]initWithFrame:CGRectMake(60*kScaleW, 7*kScaleW, 80*kScaleW, 80*kScaleH)];
    self.priceLb.font = [UIFont systemFontOfSize:58*kScaleH];
    self.priceLb.textColor = [UIColor whiteColor];
    [self.couponBackIV addSubview:self.priceLb];
    
    self.leftLb = [[UILabel alloc]initWithFrame:CGRectMake(140*kScaleW, 7*kScaleW, 100*kScaleW, 80*kScaleW)];
    self.leftLb.textColor = [UIColor whiteColor];
    self.leftLb.font = [UIFont systemFontOfSize:18*kScaleW];
    self.leftLb.numberOfLines = 0;
    [self.couponBackIV addSubview:self.leftLb];
    
    self.dateLb = [[UILabel alloc]initWithFrame:CGRectMake(20*kScaleW, 85*kScaleW, 180*kScaleW, 18*kScaleW)];
    self.dateLb.backgroundColor = [UIColor whiteColor];
    self.dateLb.textAlignment = NSTextAlignmentCenter;
    self.dateLb.font = [UIFont systemFontOfSize:13*kScaleW];
    self.dateLb.textColor = [UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:245.0/255.0 alpha:1];
    [self.couponBackIV addSubview:self.dateLb];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
