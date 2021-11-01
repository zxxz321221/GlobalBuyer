//
//  WalletTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/5.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "WalletTableViewCell.h"

@implementation WalletTableViewCell

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
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    self.userName.textColor = [UIColor grayColor];
    self.userName.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.userName];
    
    self.numIdLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 150, 20)];
    self.numIdLb.textColor = [UIColor grayColor];
    self.numIdLb.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.numIdLb];
    
    self.dateLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 200, 20)];
    self.dateLb.textColor = [UIColor grayColor];
    self.dateLb.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dateLb];
    
    self.profitNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 160, 10, 140, 30)];
    self.profitNum.textAlignment = NSTextAlignmentCenter;
    self.profitNum.layer.cornerRadius = 15;
    self.profitNum.clipsToBounds = YES;
    self.profitNum.backgroundColor = Cell_BgColor;
    self.profitNum.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.profitNum];
    
    self.balanceLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 160, 40, 140, 30)];
    self.balanceLb.textAlignment = NSTextAlignmentCenter;
    self.balanceLb.textColor = [UIColor grayColor];
    self.balanceLb.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.balanceLb];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
