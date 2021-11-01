//
//  NoPayTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/13.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "NoPayTableViewCell.h"

@implementation NoPayTableViewCell


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
    self.iv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    [self.contentView addSubview:self.iv];
    self.lb = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, kScreenW - 120, 40)];
    self.lb.numberOfLines = 0;
    self.lb.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.lb];
    self.numLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 50, 40, 30, 30)];
    self.numLb.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.numLb];
    self.priceLb = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 100, 20)];
    self.priceLb.font = [UIFont systemFontOfSize:15];
    self.priceLb.textColor = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1];
    [self.contentView addSubview:self.priceLb];
    self.showInspectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 110, 65, 80, 25)];
    [self.showInspectionBtn setTitle:NSLocalizedString(@"GlobalBuyer_Logistics_Inspection", nil) forState:UIControlStateNormal];
    [self.showInspectionBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    self.showInspectionBtn.hidden = YES;
    self.showInspectionBtn.layer.borderWidth = 0.8;
    self.showInspectionBtn.layer.borderColor = Main_Color.CGColor;
    self.showInspectionBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:self.showInspectionBtn];
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
