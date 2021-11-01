//
//  PurchaseInformationCollectionViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/24.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "PurchaseInformationCollectionViewCell.h"

@implementation PurchaseInformationCollectionViewCell

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
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height - 10)];
    backV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backV];
    
    
    self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10 , 10, backV.frame.size.width - 20, 25)];
    self.titleLb.font = [UIFont systemFontOfSize:18 weight:0.5];
    //self.titleLb.text = @"123123123123123123123123123123123";
    [backV addSubview:self.titleLb];
    
    self.describeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.titleLb.frame.origin.y + self.titleLb.frame.size.height, backV.frame.size.width - 20, 22)];
    self.describeLb.textColor = [UIColor lightGrayColor];
    self.describeLb.font = [UIFont systemFontOfSize:14];
    //self.describeLb.text = @"123123123123123123123123123asdasdasdasdasdasdasdasdasdasdasd";
    [backV addSubview:self.describeLb];
    
    self.informationImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.describeLb.frame.origin.y + self.describeLb.frame.size.height , backV.frame.size.width - 20, 160)];
    //self.informationImageV.backgroundColor = [UIColor orangeColor];
    [backV addSubview:self.informationImageV];
    
    self.fromLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.informationImageV.frame.origin.y + self.informationImageV.frame.size.height + 5, backV.frame.size.width - 20, 20)];
    //self.fromLb.text = @"来自：啊实打实的";
    self.fromLb.textColor = [UIColor lightGrayColor];
    self.fromLb.font = [UIFont systemFontOfSize:12];
    [backV addSubview:self.fromLb];
}

@end
