//
//  BindIDTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/14.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "BindIDTableViewCell.h"

@implementation BindIDTableViewCell

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
    self.lbname = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenW - 40, 40)];
    self.lbname.font = [UIFont systemFontOfSize:13];
    self.lbname.numberOfLines = 0;
    [self.contentView addSubview:self.lbname];
    self.lbstate = [[UILabel alloc]initWithFrame:CGRectMake( 20 , 50, 200, 20)];
    self.lbstate.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.lbstate];
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
