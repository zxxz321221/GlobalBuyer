//
//  AlreadyPayTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/15.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "AlreadyPayTableViewCell.h"

@implementation AlreadyPayTableViewCell

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
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 60, 60)];
    [self.contentView addSubview:self.iv];
    self.lb = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, kScreenW - 140, 40)];
    self.lb.numberOfLines = 0;
    self.lb.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.lb];
    self.numLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 50, 40, 30, 30)];
    self.numLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.numLb];
    self.priceLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, 100, 20)];
    self.priceLb.font = [UIFont systemFontOfSize:12];
    self.priceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    [self.contentView addSubview:self.priceLb];
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 24, 24)];
    [self.btn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.btn];
    
    
    self.pickLimitV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    self.pickLimitV.backgroundColor = [UIColor lightGrayColor];
    self.pickLimitV.alpha = 0.5;
    [self.contentView addSubview:self.pickLimitV];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
