//
//  FirstTreatCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/14.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "FirstTreatCell.h"
@interface FirstTreatCell()
@property (nonatomic , strong) UILabel * TopLine;
@property (nonatomic , strong) UILabel * tailLine;
@property (nonatomic , strong) UILabel * entrustL;//订单生成委托成立
@property (nonatomic , strong) UILabel * entrustTime;//订单生成委托成立 右侧
@property (nonatomic , strong) UILabel * examineL;//订单审核通过
@property (nonatomic , strong) UILabel * examineTime;//订单审核通过 右侧
@property (nonatomic , strong) UILabel * generateL;//订单生成
@property (nonatomic , strong) UILabel * generateTime;//订单生成 右侧
@property (nonatomic , strong) UILabel * paymentL;//支付成功
@property (nonatomic , strong) UILabel * paymentTime;//支付成功 右侧
@end
@implementation FirstTreatCell
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
    [self.contentView addSubview:self.entrustL];
    [self.contentView addSubview:self.entrustTime];
    [self.contentView addSubview:self.examineL];
    [self.contentView addSubview:self.examineTime];
    [self.contentView addSubview:self.generateL];
    [self.contentView addSubview:self.generateTime];
    [self.contentView addSubview:self.paymentL];
    [self.contentView addSubview:self.paymentTime];
}
- (UILabel *)TopLine{
    if (!_TopLine) {
        _TopLine = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], 0, [Unity countcoordinatesW:2], [Unity countcoordinatesH:75])];
        _TopLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _TopLine;
}
- (UILabel *)tailLine{
    if (!_tailLine) {
        _tailLine = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], [Unity countcoordinatesH:75], [Unity countcoordinatesW:2], [Unity countcoordinatesH:75])];
        _tailLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _tailLine;
}
- (UILabel *)entrustL{
    if (!_entrustL) {
        _entrustL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:20], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _entrustL.text = @"订单生成委托成立";
        _entrustL.textColor = [Unity getColor:@"#999999"];
        _entrustL.textAlignment = NSTextAlignmentLeft;
        _entrustL.font = [UIFont systemFontOfSize:13];
    }
    return _entrustL;
}
- (UILabel *)entrustTime{
    if (!_entrustTime) {
        _entrustTime = [[UILabel alloc]initWithFrame:CGRectMake(_entrustL.right, [Unity countcoordinatesH:20], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _entrustTime.text = @"2019.05.14 14:22:22";
        _entrustTime.textColor = [Unity getColor:@"#999999"];
        _entrustTime.textAlignment = NSTextAlignmentRight;
        _entrustTime.font = [UIFont systemFontOfSize:13];
    }
    return _entrustTime;
}
- (UILabel *)examineL{
    if (!_examineL) {
        _examineL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:50], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _examineL.text = @"订单审核通过";
        _examineL.textColor = [Unity getColor:@"#999999"];
        _examineL.textAlignment = NSTextAlignmentLeft;
        _examineL.font = [UIFont systemFontOfSize:13];
    }
    return _examineL;
}
- (UILabel *)examineTime{
    if (!_examineTime) {
        _examineTime = [[UILabel alloc]initWithFrame:CGRectMake(_examineL.right, [Unity countcoordinatesH:50], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _examineTime.text = @"2019.05.14 14:22:22";
        _examineTime.textColor = [Unity getColor:@"#999999"];
        _examineTime.textAlignment = NSTextAlignmentRight;
        _examineTime.font = [UIFont systemFontOfSize:13];
    }
    return _examineTime;
}
- (UILabel *)generateL{
    if (!_generateL) {
        _generateL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:80], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _generateL.text = @"订单生成";
        _generateL.textColor = [Unity getColor:@"#999999"];
        _generateL.textAlignment = NSTextAlignmentLeft;
        _generateL.font = [UIFont systemFontOfSize:13];
    }
    return _generateL;
}
- (UILabel *)generateTime{
    if (!_generateTime) {
        _generateTime = [[UILabel alloc]initWithFrame:CGRectMake(_generateL.right, [Unity countcoordinatesH:80], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _generateTime.text = @"2019.05.14 14:22:22";
        _generateTime.textColor = [Unity getColor:@"#999999"];
        _generateTime.textAlignment = NSTextAlignmentRight;
        _generateTime.font = [UIFont systemFontOfSize:13];
    }
    return _generateTime;
}
- (UILabel *)paymentL{
    if (!_paymentL) {
        _paymentL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:110], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _paymentL.text = @"支付成功";
        _paymentL.textColor = [Unity getColor:@"#999999"];
        _paymentL.textAlignment = NSTextAlignmentLeft;
        _paymentL.font = [UIFont systemFontOfSize:13];
    }
    return _paymentL;
}
- (UILabel *)paymentTime{
    if (!_paymentTime) {
        _paymentTime = [[UILabel alloc]initWithFrame:CGRectMake(_paymentL.right, [Unity countcoordinatesH:110], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _paymentTime.text = @"2019.05.14 14:22:22";
        _paymentTime.textColor = [Unity getColor:@"#999999"];
        _paymentTime.textAlignment = NSTextAlignmentRight;
        _paymentTime.font = [UIFont systemFontOfSize:13];
    }
    return _paymentTime;
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
