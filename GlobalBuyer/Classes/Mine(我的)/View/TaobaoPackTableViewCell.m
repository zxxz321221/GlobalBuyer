//
//  TaobaoPackTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/17.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "TaobaoPackTableViewCell.h"

@implementation TaobaoPackTableViewCell

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
    self.goodIV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 80, 80)];
    [self.contentView addSubview:self.goodIV];
    
    self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 200, 20)];
    self.titleLb.font = [UIFont systemFontOfSize:11];
    self.titleLb.numberOfLines = 0;
    [self.contentView addSubview:self.titleLb];
    
    self.subTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(130, 40, 200, 20)];
    self.subTitleLb.font = [UIFont systemFontOfSize:9];
    self.subTitleLb.textColor = [UIColor lightGrayColor];
    self.subTitleLb.numberOfLines = 0;
    [self.contentView addSubview:self.subTitleLb];
    
    self.qtyLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 60, 70, 50, 20)];
    self.qtyLb.font = [UIFont systemFontOfSize:13];
    self.qtyLb.textAlignment = NSTextAlignmentRight;
    self.qtyLb.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.qtyLb];
    
    self.priceLb = [[UILabel alloc]initWithFrame:CGRectMake(130, 80, 200, 10)];
    self.priceLb.font = [UIFont systemFontOfSize:15];
    self.priceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    [self.contentView addSubview:self.priceLb];
    
    self.selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 24, 24)];
    [self.selectBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
    
    self.coverV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    self.coverV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.coverV.hidden = YES;
    self.coverV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.coverV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
