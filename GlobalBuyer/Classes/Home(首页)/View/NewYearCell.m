//
//  NewYearCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/26.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "NewYearCell.h"

@implementation NewYearCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    self.titleIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
    self.titleIv.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleIv.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.titleIv];
    
    self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 180, 60)];
    self.titleLb.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.titleLb];
    
    self.gotoLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 100, 10, 80, 60)];
    self.gotoLb.userInteractionEnabled = YES;
    self.gotoLb.textAlignment = NSTextAlignmentRight;
    self.gotoLb.font = [UIFont systemFontOfSize:11];
    self.gotoLb.text = @"立即前往>>";
    [self.contentView addSubview:self.gotoLb];
    UITapGestureRecognizer *tapT = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoClick)];
    tapT.numberOfTouchesRequired = 1;
    tapT.numberOfTapsRequired = 1;
    [self.gotoLb addGestureRecognizer:tapT];
    
    self.goodsIvOne = [[UIImageView alloc]initWithFrame:CGRectMake(20 , 80, (kScreenW - 50)/3, (kScreenW - 50)/3)];
    self.goodsIvOne.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.goodsIvOne.layer.borderWidth = 0.3;
    self.goodsIvOne.userInteractionEnabled = YES;
    [self.contentView addSubview:self.goodsIvOne];
    UITapGestureRecognizer *tapO = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsOneLinkClick)];
    tapO.numberOfTapsRequired = 1;
    tapO.numberOfTouchesRequired = 1;
    [self.goodsIvOne addGestureRecognizer:tapO];
    self.goodsTitleOne = [[UILabel alloc]initWithFrame:CGRectMake(20, 80 + ((kScreenW - 50)/3), (kScreenW - 50)/3, 50)];
    self.goodsTitleOne.numberOfLines = 0;
    self.goodsTitleOne.font = [UIFont systemFontOfSize:12];
    self.goodsTitleOne.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodsTitleOne];
    self.goodsPriceOne = [[UILabel alloc]initWithFrame:CGRectMake(20, 130 + ((kScreenW - 50)/3), (kScreenW - 50)/3, 30)];
    self.goodsPriceOne.textColor = [UIColor redColor];
    self.goodsPriceOne.font = [UIFont systemFontOfSize:13];
    self.goodsPriceOne.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodsPriceOne];
    
    self.goodsIvTwo = [[UIImageView alloc]initWithFrame:CGRectMake(20 + (kScreenW - 40)/3 , 80, (kScreenW - 50)/3, (kScreenW - 50)/3)];
    self.goodsIvTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.goodsIvTwo.layer.borderWidth = 0.3;
    self.goodsIvTwo.userInteractionEnabled = YES;
    [self.contentView addSubview:self.goodsIvTwo];
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsTwoLinkClick)];
    tapTwo.numberOfTapsRequired = 1;
    tapTwo.numberOfTouchesRequired = 1;
    [self.goodsIvTwo addGestureRecognizer:tapTwo];
    self.goodsTitleTwo = [[UILabel alloc]initWithFrame:CGRectMake(20 + (kScreenW - 40)/3, 80 + ((kScreenW - 50)/3), (kScreenW - 50)/3, 50)];
    self.goodsTitleTwo.numberOfLines = 0;
    self.goodsTitleTwo.font = [UIFont systemFontOfSize:12];
    self.goodsTitleTwo.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodsTitleTwo];
    self.goodsPriceTwo = [[UILabel alloc]initWithFrame:CGRectMake(20 + (kScreenW - 40)/3, 130 + ((kScreenW - 50)/3), (kScreenW - 50)/3, 30)];
    self.goodsPriceTwo.textColor = [UIColor redColor];
    self.goodsPriceTwo.font = [UIFont systemFontOfSize:13];
    self.goodsPriceTwo.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodsPriceTwo];
    
    self.goodsIvThree = [[UIImageView alloc]initWithFrame:CGRectMake(20 + (kScreenW - 40)/3*2 , 80, (kScreenW - 50)/3, (kScreenW - 50)/3)];
    self.goodsIvThree.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.goodsIvThree.layer.borderWidth = 0.3;
    self.goodsIvThree.userInteractionEnabled = YES;
    [self.contentView addSubview:self.goodsIvThree];
    UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsThreeLinkClick)];
    tapThree.numberOfTapsRequired = 1;
    tapThree.numberOfTouchesRequired = 1;
    [self.goodsIvThree addGestureRecognizer:tapThree];
    self.goodsTitleThree = [[UILabel alloc]initWithFrame:CGRectMake(20 + (kScreenW - 40)/3*2, 80 + ((kScreenW - 50)/3), (kScreenW - 50)/3, 50)];
    self.goodsTitleThree.numberOfLines = 0;
    self.goodsTitleThree.font = [UIFont systemFontOfSize:12];
    self.goodsTitleThree.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodsTitleThree];
    self.goodsPriceThree = [[UILabel alloc]initWithFrame:CGRectMake(20 + (kScreenW - 40)/3*2, 130 + ((kScreenW - 50)/3), (kScreenW - 50)/3, 30)];
    self.goodsPriceThree.textColor = [UIColor redColor];
    self.goodsPriceThree.font = [UIFont systemFontOfSize:13];
    self.goodsPriceThree.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.goodsPriceThree];
}

- (void)gotoClick{
    [self.delegate clickNewYearWithLink:self.titleLink];
}

- (void)goodsOneLinkClick{
    [self.delegate clickNewYearWithLink:self.goodsOneLink];
}

- (void)goodsTwoLinkClick{
    [self.delegate clickNewYearWithLink:self.goodsTwoLink];
}

- (void)goodsThreeLinkClick{
    [self.delegate clickNewYearWithLink:self.goodsThreeLink];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
