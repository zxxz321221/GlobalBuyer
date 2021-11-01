//
//  ShowUserInfoTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/5/21.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "ShowUserInfoTableViewCell.h"

@implementation ShowUserInfoTableViewCell

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
    self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 40)];
    [self.contentView addSubview:self.nameLb];
    
    self.inputTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - 200, 15, 190, 30)];
    self.inputTF.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.inputTF];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
