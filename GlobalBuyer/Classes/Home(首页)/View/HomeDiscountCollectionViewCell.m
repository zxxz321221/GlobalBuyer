//
//  HomeDiscountCollectionViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "HomeDiscountCollectionViewCell.h"

@implementation HomeDiscountCollectionViewCell

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
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 5)];
    backV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backV];
    
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, backV.frame.size.width - 40, 180)];
    [backV addSubview:self.iv];
    
    self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, backV.frame.size.width - 40, 20)];
    self.titleLb.font = [UIFont systemFontOfSize:16];
    [backV addSubview:self.titleLb];
    
    self.subTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, backV.frame.size.width - 40, 30)];
    self.subTitle.textColor = [UIColor lightGrayColor];
    self.subTitle.numberOfLines = 0;
    self.subTitle.font = [UIFont systemFontOfSize:12];
    [backV addSubview:self.subTitle];
}

@end
