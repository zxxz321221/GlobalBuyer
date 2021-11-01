//
//  HomeGoodsTitleCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "HomeGoodsTitleCell.h"

@implementation HomeGoodsTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return self;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    if ([super initWithFrame:frame]) {
//        [self addSubviews];
//        self.backgroundColor = Cell_BgColor;
//    }
//    return self;
//}

-(void)addSubviews{
    [self.contentView addSubview:self.goodsTitleV];
}

- (UIView *)goodsTitleV
{
    if (_goodsTitleV == nil) {
        _goodsTitleV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20, 90)];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_goodsTitleV.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _goodsTitleV.bounds;
        maskLayer.path = path.CGPath;
        _goodsTitleV.layer.mask = maskLayer;
        _goodsTitleV.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _goodsTitleV.frame.size.width, 30)];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = [UIFont systemFontOfSize:20];
        titleLb.textColor = [UIColor redColor];
        titleLb.text = NSLocalizedString(@"GlobalBuyer_home_HotCommodity", nil);
        [_goodsTitleV addSubview:titleLb];
        
        UILabel *subTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, _goodsTitleV.frame.size.width, 30)];
        subTitleLb.textAlignment = NSTextAlignmentCenter;
        subTitleLb.font = [UIFont systemFontOfSize:12];
        subTitleLb.textColor = [UIColor redColor];
        subTitleLb.text = NSLocalizedString(@"GlobalBuyer_home_HotCommodity_content", nil);
        [_goodsTitleV addSubview:subTitleLb];
    }
    return _goodsTitleV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
