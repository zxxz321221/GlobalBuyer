//
//  StorageOrderFooterView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "StorageOrderFooterView.h"
@interface StorageOrderFooterView()
{
    NSInteger index;
}
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UILabel * sumNum;
@property (nonatomic , strong) UIButton * orderDetail;
@property (nonatomic , strong) UIButton * logistics;
@property (nonatomic , strong) UIButton * checkImg;

@end
@implementation StorageOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.backView];
    }
    return self;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], 0, kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:90])];
        _backView.backgroundColor  = [UIColor whiteColor];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
        _backView.layer.masksToBounds = YES;
        _backView.layer.mask = maskLayer;
        
        [_backView addSubview:self.sumNum];
        [_backView addSubview:self.orderDetail];
        [_backView addSubview:self.logistics];
        [_backView addSubview:self.checkImg];
    }
    return _backView;
}
- (UILabel *)sumNum{
    if (!_sumNum) {
        _sumNum = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], _backView.width-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        _sumNum.text = @"合计:¥2888.88";
        _sumNum.textAlignment = NSTextAlignmentRight;
        _sumNum.textColor = [Unity getColor:@"#333333"];
        _sumNum.font = [UIFont systemFontOfSize:14];
    }
    return _sumNum;
}
- (UIButton *)orderDetail{
    if (!_orderDetail) {
        _orderDetail = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:240], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_orderDetail addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetail setTitle:@"订单详情" forState:UIControlStateNormal];
        _orderDetail.layer.borderColor = [[Unity getColor:@"#333333"] CGColor];
        _orderDetail.layer.borderWidth = 1.0f;
        [_orderDetail setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _orderDetail.titleLabel.font = [UIFont systemFontOfSize:14];
        _orderDetail.layer.cornerRadius = [Unity countcoordinatesH:15];
        _orderDetail.layer.masksToBounds = YES;
    }
    return _orderDetail;
}
- (UIButton *)logistics{
    if (!_logistics) {
        _logistics = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:80], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_logistics addTarget:self action:@selector(logisticsClick) forControlEvents:UIControlEventTouchUpInside];
        [_logistics setTitle:@"查看物流" forState:UIControlStateNormal];
        _logistics.backgroundColor = [Unity getColor:@"#b445c8"];
        _logistics.layer.cornerRadius = [Unity countcoordinatesH:15];
        _logistics.layer.masksToBounds=YES;
        _logistics.titleLabel.font = [UIFont systemFontOfSize:13];
        [_logistics setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _logistics;
}
- (UIButton *)checkImg{
    if (!_checkImg) {
        _checkImg = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:160], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_checkImg addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
        [_checkImg setTitle:@"验货照片" forState:UIControlStateNormal];
        _checkImg.layer.borderColor = [[Unity getColor:@"#b445c8"] CGColor];
        _checkImg.layer.borderWidth = 1.0f;
        [_checkImg setTitleColor:[Unity getColor:@"#b445c8"] forState:UIControlStateNormal];
        _checkImg.titleLabel.font = [UIFont systemFontOfSize:14];
        _checkImg.layer.cornerRadius = [Unity countcoordinatesH:15];
        _checkImg.layer.masksToBounds = YES;
    }
    return _checkImg;
}
- (void)configWithSection:(NSInteger)section{
    index = section;
}
//订单详情
- (void)detailClick{
    [self.delegate detailClick:index];
}
//查看物流
- (void)logisticsClick{
    [self.delegate logisticsClick:index];
    
}
//验货照片
- (void)checkClick{
    [self.delegate checkClick:index];
    
}

@end
