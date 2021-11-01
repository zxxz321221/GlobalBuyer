//
//  FinalPaymentTableViewCell.m
//  GlobalBuyer
//
//  Created by 赵祥 on 2021/9/7.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import "FinalPaymentTableViewCell.h"

@implementation FinalPaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    
    return self;
}

-(void)createUI{
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kWidth(15));
        make.centerY.equalTo(self.contentView);
        make.width.mas_offset(SCREEN_WIDTH/3);
    }];
    
    self.priceLab = [[UILabel alloc]init];
    self.priceLab.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    self.priceLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kWidth(-10));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.explainLab = [[UILabel alloc]init];
    self.explainLab.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    self.explainLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.explainLab];
    [self.explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kWidth(100));
        make.centerY.equalTo(self.contentView);
    }];
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
