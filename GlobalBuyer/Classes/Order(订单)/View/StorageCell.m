//
//  StorageCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/14.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "StorageCell.h"
@interface StorageCell()
@property (nonatomic , strong) UILabel * TopLine;
@property (nonatomic , strong) UILabel * tailLine;

@property (nonatomic , strong) UILabel * purchaseL;//采购中
@property (nonatomic , strong) UILabel * purchaseTime;
@property (nonatomic , strong) UILabel * purchasedL;//已采购
@property (nonatomic , strong) UILabel * purchasedTime;
@property (nonatomic , strong) UILabel * sellerStockL;//卖家备货
@property (nonatomic , strong) UILabel * sellerStockTime;
@property (nonatomic , strong) UILabel * sellerShippingL;//卖家发货
@property (nonatomic , strong) UILabel * sellerShippingTime;
@property (nonatomic , strong) UILabel * transportL;//运输中
@property (nonatomic , strong) UILabel * transportTime;
@property (nonatomic , strong) UILabel * warehouseArrivalL;//到达wotada海外仓库
@property (nonatomic , strong) UILabel * warehouseArrivalTime;
@property (nonatomic , strong) UILabel * inspectionL;//验货中
@property (nonatomic , strong) UILabel * inspectionTime;
@property (nonatomic , strong) UILabel * endOfInspectionL;//验货完毕
@property (nonatomic , strong) UILabel * endOfInspectionTime;
@property (nonatomic , strong) UILabel * freightL;//运费计算中
@property (nonatomic , strong) UILabel * freightTime;
@end
@implementation StorageCell
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
    [self.contentView addSubview:self.purchaseL];
    [self.contentView addSubview:self.purchaseTime];
    [self.contentView addSubview:self.purchasedL];
    [self.contentView addSubview:self.purchasedTime];
    [self.contentView addSubview:self.sellerStockL];
    [self.contentView addSubview:self.sellerStockTime];
    [self.contentView addSubview:self.sellerShippingL];
    [self.contentView addSubview:self.sellerShippingTime];
    [self.contentView addSubview:self.transportL];
    [self.contentView addSubview:self.transportTime];
    [self.contentView addSubview:self.warehouseArrivalL];
    [self.contentView addSubview:self.warehouseArrivalTime];
    [self.contentView addSubview:self.inspectionL];
    [self.contentView addSubview:self.inspectionTime];
    [self.contentView addSubview:self.endOfInspectionL];
    [self.contentView addSubview:self.endOfInspectionTime];
    [self.contentView addSubview:self.freightL];
    [self.contentView addSubview:self.freightTime];
}
- (UILabel *)TopLine{
    if (!_TopLine) {
        _TopLine = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], 0, [Unity countcoordinatesW:2], [Unity countcoordinatesH:150])];
        _TopLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _TopLine;
}
- (UILabel *)tailLine{
    if (!_tailLine) {
        _tailLine = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16], [Unity countcoordinatesH:150], [Unity countcoordinatesW:2], [Unity countcoordinatesH:150])];
        _tailLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _tailLine;
}
- (UILabel *)purchaseL{
    if (!_purchaseL) {
        _purchaseL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:20], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _purchaseL.text = @"采购中";
        _purchaseL.textColor = [Unity getColor:@"#999999"];
        _purchaseL.textAlignment = NSTextAlignmentLeft;
        _purchaseL.font = [UIFont systemFontOfSize:13];
    }
    return _purchaseL;
}
- (UILabel *)purchaseTime{
    if (!_purchaseTime) {
        _purchaseTime = [[UILabel alloc]initWithFrame:CGRectMake(_purchaseL.right, [Unity countcoordinatesH:20], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _purchaseTime.text = @"2019.05.14 14:22:22";
        _purchaseTime.textColor = [Unity getColor:@"#999999"];
        _purchaseTime.textAlignment = NSTextAlignmentRight;
        _purchaseTime.font = [UIFont systemFontOfSize:13];
    }
    return _purchaseTime;
}
- (UILabel *)purchasedL{
    if (!_purchasedL) {
        _purchasedL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:50], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _purchasedL.text = @"已采购";
        _purchasedL.textColor = [Unity getColor:@"#999999"];
        _purchasedL.textAlignment = NSTextAlignmentLeft;
        _purchasedL.font = [UIFont systemFontOfSize:13];
    }
    return _purchasedL;
}
- (UILabel *)purchasedTime{
    if (!_purchasedTime) {
        _purchasedTime = [[UILabel alloc]initWithFrame:CGRectMake(_purchasedL.right, [Unity countcoordinatesH:50], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _purchasedTime.text = @"2019.05.14 14:22:22";
        _purchasedTime.textColor = [Unity getColor:@"#999999"];
        _purchasedTime.textAlignment = NSTextAlignmentRight;
        _purchasedTime.font = [UIFont systemFontOfSize:13];
    }
    return _purchasedTime;
}
- (UILabel *)sellerStockL{
    if (!_sellerStockL) {
        _sellerStockL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:80], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _sellerStockL.text = @"卖家备货";
        _sellerStockL.textColor = [Unity getColor:@"#999999"];
        _sellerStockL.textAlignment = NSTextAlignmentLeft;
        _sellerStockL.font = [UIFont systemFontOfSize:13];
    }
    return _sellerStockL;
}
- (UILabel *)sellerStockTime{
    if (!_sellerStockTime) {
        _sellerStockTime = [[UILabel alloc]initWithFrame:CGRectMake(_sellerStockL.right, [Unity countcoordinatesH:80], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _sellerStockTime.text = @"2019.05.14 14:22:22";
        _sellerStockTime.textColor = [Unity getColor:@"#999999"];
        _sellerStockTime.textAlignment = NSTextAlignmentRight;
        _sellerStockTime.font = [UIFont systemFontOfSize:13];
    }
    return _sellerStockTime;
}
- (UILabel *)sellerShippingL{
    if (!_sellerShippingL) {
        _sellerShippingL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:110], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _sellerShippingL.text = @"卖家发货";
        _sellerShippingL.textColor = [Unity getColor:@"#999999"];
        _sellerShippingL.textAlignment = NSTextAlignmentLeft;
        _sellerShippingL.font = [UIFont systemFontOfSize:13];
    }
    return _sellerShippingL;
}
- (UILabel *)sellerShippingTime{
    if (!_sellerShippingTime) {
        _sellerShippingTime = [[UILabel alloc]initWithFrame:CGRectMake(_sellerShippingL.right, [Unity countcoordinatesH:110], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _sellerShippingTime.text = @"2019.05.14 14:22:22";
        _sellerShippingTime.textColor = [Unity getColor:@"#999999"];
        _sellerShippingTime.textAlignment = NSTextAlignmentRight;
        _sellerShippingTime.font = [UIFont systemFontOfSize:13];
    }
    return _sellerShippingTime;
}
- (UILabel *)transportL{
    if (!_transportL) {
        _transportL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:140], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _transportL.text = @"运输中";
        _transportL.textColor = [Unity getColor:@"#999999"];
        _transportL.textAlignment = NSTextAlignmentLeft;
        _transportL.font = [UIFont systemFontOfSize:13];
    }
    return _transportL;
}
- (UILabel *)transportTime{
    if (!_transportTime) {
        _transportTime = [[UILabel alloc]initWithFrame:CGRectMake(_transportL.right, [Unity countcoordinatesH:140], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _transportTime.text = @"2019.05.14 14:22:22";
        _transportTime.textColor = [Unity getColor:@"#999999"];
        _transportTime.textAlignment = NSTextAlignmentRight;
        _transportTime.font = [UIFont systemFontOfSize:13];
    }
    return _transportTime;
}
- (UILabel *)warehouseArrivalL{
    if (!_warehouseArrivalL) {
        _warehouseArrivalL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:170], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _warehouseArrivalL.text = @"到达wotada海外仓库";
        _warehouseArrivalL.textColor = [Unity getColor:@"#999999"];
        _warehouseArrivalL.textAlignment = NSTextAlignmentLeft;
        _warehouseArrivalL.font = [UIFont systemFontOfSize:13];
    }
    return _warehouseArrivalL;
}
- (UILabel *)warehouseArrivalTime{
    if (!_warehouseArrivalTime) {
        _warehouseArrivalTime = [[UILabel alloc]initWithFrame:CGRectMake(_warehouseArrivalL.right, [Unity countcoordinatesH:170], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _warehouseArrivalTime.text = @"2019.05.14 14:22:22";
        _warehouseArrivalTime.textColor = [Unity getColor:@"#999999"];
        _warehouseArrivalTime.textAlignment = NSTextAlignmentRight;
        _warehouseArrivalTime.font = [UIFont systemFontOfSize:13];
    }
    return _warehouseArrivalTime;
}
- (UILabel *)inspectionL{
    if (!_inspectionL) {
        _inspectionL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:200], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _inspectionL.text = @"验货中";
        _inspectionL.textColor = [Unity getColor:@"#999999"];
        _inspectionL.textAlignment = NSTextAlignmentLeft;
        _inspectionL.font = [UIFont systemFontOfSize:13];
    }
    return _inspectionL;
}
- (UILabel *)inspectionTime{
    if (!_inspectionTime) {
        _inspectionTime = [[UILabel alloc]initWithFrame:CGRectMake(_inspectionL.right, [Unity countcoordinatesH:200], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _inspectionTime.text = @"2019.05.14 14:22:22";
        _inspectionTime.textColor = [Unity getColor:@"#999999"];
        _inspectionTime.textAlignment = NSTextAlignmentRight;
        _inspectionTime.font = [UIFont systemFontOfSize:13];
    }
    return _inspectionTime;
}
- (UILabel *)endOfInspectionL{
    if (!_endOfInspectionL) {
        _endOfInspectionL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:230], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _endOfInspectionL.text = @"验货完毕";
        _endOfInspectionL.textColor = [Unity getColor:@"#999999"];
        _endOfInspectionL.textAlignment = NSTextAlignmentLeft;
        _endOfInspectionL.font = [UIFont systemFontOfSize:13];
    }
    return _endOfInspectionL;
}
- (UILabel *)endOfInspectionTime{
    if (!_endOfInspectionTime) {
        _endOfInspectionTime = [[UILabel alloc]initWithFrame:CGRectMake(_endOfInspectionL.right, [Unity countcoordinatesH:230], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _endOfInspectionTime.text = @"2019.05.14 14:22:22";
        _endOfInspectionTime.textColor = [Unity getColor:@"#999999"];
        _endOfInspectionTime.textAlignment = NSTextAlignmentRight;
        _endOfInspectionTime.font = [UIFont systemFontOfSize:13];
    }
    return _endOfInspectionTime;
}
- (UILabel *)freightL{
    if (!_freightL) {
        _freightL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], [Unity countcoordinatesH:260], [Unity countcoordinatesW:120], [Unity countcoordinatesH:20])];
        _freightL.text = @"允许计算中";
        _freightL.textColor = [Unity getColor:@"#999999"];
        _freightL.textAlignment = NSTextAlignmentLeft;
        _freightL.font = [UIFont systemFontOfSize:13];
    }
    return _freightL;
}
- (UILabel *)freightTime{
    if (!_freightTime) {
        _freightTime = [[UILabel alloc]initWithFrame:CGRectMake(_freightL.right, [Unity countcoordinatesH:260], [Unity countcoordinatesW:130], [Unity countcoordinatesH:20])];
        _freightTime.text = @"2019.05.14 14:22:22";
        _freightTime.textColor = [Unity getColor:@"#999999"];
        _freightTime.textAlignment = NSTextAlignmentRight;
        _freightTime.font = [UIFont systemFontOfSize:13];
    }
    return _freightTime;
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
