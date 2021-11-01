//
//  CooperationProfitCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/22.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "CooperationProfitCell.h"

@implementation CooperationProfitCell

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
    self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
    self.userImg.clipsToBounds = YES;
    self.userImg.layer.cornerRadius = 20;
    [self.contentView addSubview:self.userImg];
    
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 100, 40)];
    self.userName.textColor = [UIColor grayColor];
    self.userName.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.userName];
    
    self.profitNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 150, 10, 140, 40)];
    self.profitNum.textAlignment = NSTextAlignmentCenter;
    self.profitNum.layer.cornerRadius = 20;
    self.profitNum.clipsToBounds = YES;
    self.profitNum.backgroundColor = Cell_BgColor;
    self.profitNum.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.profitNum];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
