//
//  CustomsCategoryCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/31.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "CustomsCategoryCell.h"

@implementation CustomsCategoryCell

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

- (void)initLayout{
    
    self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    [self.contentView addSubview:self.nameLb];
    
    self.contLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenW - 40, 100)];
    self.contLb.numberOfLines = 0;
    self.contLb.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.contLb];
    
    self.isSelectbtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 50, 15, 20, 20)];
    [self.isSelectbtn setImage:[UIImage imageNamed:@"ic_right"] forState:UIControlStateNormal];
    [self.isSelectbtn setImage:[UIImage imageNamed:@"ic_selection_close"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.isSelectbtn];
    [self.isSelectbtn addTarget:self action:@selector(isSelectRight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)isSelectRight
{
    self.isSelectbtn.selected = !self.isSelectbtn.selected;
    if (self.isSelectbtn.selected == NO) {
        [self.delegate isSelect:@""];
    }else{
        [self.delegate isSelect:self.specialStr];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
