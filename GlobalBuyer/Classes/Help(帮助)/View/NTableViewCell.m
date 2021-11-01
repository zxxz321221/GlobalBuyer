//
//  NTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/28.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "NTableViewCell.h"

@implementation NTableViewCell

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
    self.logoLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, [[UIScreen mainScreen] bounds].size.width - 80 - 40, 30)];
    self.logoLb.font = [UIFont systemFontOfSize:12];
    self.logoLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    self.logoLb.numberOfLines = 0;
    [self.contentView addSubview:self.logoLb];
    
    self.sourceLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 120, 10)];
    self.sourceLb.font = [UIFont systemFontOfSize:10];
    self.sourceLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self.contentView addSubview:self.sourceLb];
    
    self.remakeLb = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 200, 10)];
    self.remakeLb.font = [UIFont systemFontOfSize:10];
    self.remakeLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self.contentView addSubview:self.remakeLb];
    
    self.logoIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
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
