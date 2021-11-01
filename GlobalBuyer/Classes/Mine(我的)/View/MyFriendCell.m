//
//  MyFriendCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/22.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MyFriendCell.h"

@implementation MyFriendCell

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
    self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 50, 50)];
    self.userImg.layer.cornerRadius = 25;
    self.userImg.clipsToBounds = YES;
    self.userImg.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.userImg];
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(80, 10,  kScreenW - 100 - 150, 40)];
    [self.contentView addSubview:self.userName];
    
    self.dateLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 150, 10, 140, 40)];
    self.dateLb.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.dateLb];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
