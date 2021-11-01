//
//  LogisticsTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/26.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "LogisticsTableViewCell.h"

@implementation LogisticsTableViewCell



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
    self.dateLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20, 20)];
    self.dateLb.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.dateLb];
    
    self.serviceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kScreenW - 20, 20)];
    self.serviceLb.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.serviceLb];
    
    self.detailLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenW - 20, 20)];
    self.detailLb.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.detailLb];
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
