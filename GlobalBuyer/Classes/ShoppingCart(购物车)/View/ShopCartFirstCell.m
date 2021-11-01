//
//  ShopCartFirstCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/10.
//  Copyright © 2017年 薛铭. All rights reserved.
//

#import "ShopCartFirstCell.h"

@implementation ShopCartFirstCell

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
    self.logoLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 180, 20)];
    self.logoLb.font = [UIFont systemFontOfSize:16];
    self.logoLb.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.logoLb];
    
    self.logoIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 100, 50)];
    [self.contentView addSubview:self.logoIv];
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
