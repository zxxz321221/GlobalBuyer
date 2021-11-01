//
//  TailToBePaidCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/14.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "TailToBePaidCell.h"
@interface TailToBePaidCell()
@property (nonatomic , strong) UILabel * TopLine;
@property (nonatomic , strong) UILabel * tailLine;
@property (nonatomic , strong) UILabel * tailPaymentL;
@property (nonatomic , strong) UILabel * tailPaymentTime;
@end
@implementation TailToBePaidCell
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
    [self.contentView addSubview:self.TopLine];
    [self.contentView addSubview:self.tailLine];
    [self.contentView addSubview:self.tailPaymentL];
    [self.contentView addSubview:self.tailPaymentTime];
}
- (UILabel *)TopLine{
    if (!_TopLine) {
        _TopLine = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], 0, [Unity countcoordinatesW:2], [Unity countcoordinatesH:30])];
        _TopLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _TopLine;
}
- (UILabel *)tailLine{
    if (!_tailLine) {
        _tailLine = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], [Unity countcoordinatesH:30], [Unity countcoordinatesW:2], [Unity countcoordinatesH:30])];
        _tailLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _tailLine;
}

- (UILabel *)tailPaymentL{
    if (!_tailPaymentL) {
        _tailPaymentL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:20], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _tailPaymentL.text = @"尾款已支付";
        _tailPaymentL.textColor = [Unity getColor:@"#999999"];
        _tailPaymentL.textAlignment = NSTextAlignmentLeft;
        _tailPaymentL.font = [UIFont systemFontOfSize:13];
    }
    return _tailPaymentL;
}
- (UILabel *)tailPaymentTime{
    if (!_tailPaymentTime) {
        _tailPaymentTime = [[UILabel alloc]initWithFrame:CGRectMake(_tailPaymentL.right, [Unity countcoordinatesH:20], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _tailPaymentTime.text = @"2019.05.14 14:22:22";
        _tailPaymentTime.textColor = [Unity getColor:@"#999999"];
        _tailPaymentTime.textAlignment = NSTextAlignmentRight;
        _tailPaymentTime.font = [UIFont systemFontOfSize:13];
    }
    return _tailPaymentTime;
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
