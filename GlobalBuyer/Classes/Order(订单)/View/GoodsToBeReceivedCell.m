//
//  GoodsToBeReceivedCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/14.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "GoodsToBeReceivedCell.h"
@interface GoodsToBeReceivedCell()
@property (nonatomic , strong) UILabel * deliverGoodsL;
@property (nonatomic , strong) UILabel * deliverGoodsTime;
@property (nonatomic , strong) UILabel * signL;
@property (nonatomic , strong) UILabel * signTime;
@end
@implementation GoodsToBeReceivedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self CellView];
    }
    return self;
}
- (void)CellView{
    [self.contentView addSubview:self.deliverGoodsL];
    [self.contentView addSubview:self.deliverGoodsTime];
    [self.contentView addSubview:self.signL];
    [self.contentView addSubview:self.signTime];
}
- (UILabel *)deliverGoodsL{
    if (!_deliverGoodsL) {
        _deliverGoodsL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:20], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _deliverGoodsL.text = @"已发货";
        _deliverGoodsL.textColor = [Unity getColor:@"#999999"];
        _deliverGoodsL.textAlignment = NSTextAlignmentLeft;
        _deliverGoodsL.font = [UIFont systemFontOfSize:13];
    }
    return _deliverGoodsL;
}
- (UILabel *)deliverGoodsTime{
    if (!_deliverGoodsTime) {
        _deliverGoodsTime = [[UILabel alloc]initWithFrame:CGRectMake(_deliverGoodsL.right, [Unity countcoordinatesH:20], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _deliverGoodsTime.text = @"2019.05.14 14:22:22";
        _deliverGoodsTime.textColor = [Unity getColor:@"#999999"];
        _deliverGoodsTime.textAlignment = NSTextAlignmentRight;
        _deliverGoodsTime.font = [UIFont systemFontOfSize:13];
    }
    return _deliverGoodsTime;
}
- (UILabel *)signL{
    if (!_signL) {
        _signL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:50], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _signL.text = @"已签收";
        _signL.textColor = [Unity getColor:@"#999999"];
        _signL.textAlignment = NSTextAlignmentLeft;
        _signL.font = [UIFont systemFontOfSize:13];
    }
    return _signL;
}
- (UILabel *)signTime{
    if (!_signTime) {
        _signTime = [[UILabel alloc]initWithFrame:CGRectMake(_signL.right, [Unity countcoordinatesH:50], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _signTime.text = @"2019.05.14 14:22:22";
        _signTime.textColor = [Unity getColor:@"#999999"];
        _signTime.textAlignment = NSTextAlignmentRight;
        _signTime.font = [UIFont systemFontOfSize:13];
    }
    return _signTime;
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
