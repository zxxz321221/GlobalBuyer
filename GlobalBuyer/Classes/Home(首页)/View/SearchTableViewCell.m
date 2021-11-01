//
//  SearchTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/26.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

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
    self.logoLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 200, 15)];
    self.logoLb.font = [UIFont systemFontOfSize:12];
    self.logoLb.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.logoLb];
    
    self.urlLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 200, 10)];
    self.urlLb.font = [UIFont systemFontOfSize:8];
    self.urlLb.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.urlLb];
    
    self.keyWordLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, [[UIScreen mainScreen] bounds].size.width - 120 - 30, 28)];
    self.keyWordLb.numberOfLines = 0;
    self.keyWordLb.font = [UIFont systemFontOfSize:9];
    self.keyWordLb.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.keyWordLb];
    
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
