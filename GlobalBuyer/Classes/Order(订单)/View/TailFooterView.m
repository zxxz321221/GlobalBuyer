//
//  TailFooterView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "TailFooterView.h"
@interface TailFooterView()
{
    NSInteger index;
}
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UILabel * sumNum;
@property (nonatomic , strong) UIButton * orderDetail;
@property (nonatomic , strong) UIButton * tailPayment;
@property (nonatomic , strong) UIButton * ccheckImg;

@end
@implementation TailFooterView

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
        [_backView addSubview:self.tailPayment];
        [_backView addSubview:self.ccheckImg];
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
        _orderDetail = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:250], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
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
- (UIButton *)tailPayment{
    if (!_tailPayment) {
        _tailPayment = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:60], [Unity countcoordinatesH:50], [Unity countcoordinatesW:50], [Unity countcoordinatesH:30])];
        [_tailPayment addTarget:self action:@selector(tailPaymentClick) forControlEvents:UIControlEventTouchUpInside];
        [_tailPayment setTitle:@"付款" forState:UIControlStateNormal];
        _tailPayment.backgroundColor = [Unity getColor:@"#b445c8"];
        _tailPayment.layer.cornerRadius = [Unity countcoordinatesH:15];
        _tailPayment.layer.masksToBounds=YES;
        _tailPayment.titleLabel.font = [UIFont systemFontOfSize:13];
        [_tailPayment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _tailPayment;
}
- (UIButton *)ccheckImg{
    if (!_ccheckImg) {
        _ccheckImg = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:170], [Unity countcoordinatesH:50], [Unity countcoordinatesW:100], [Unity countcoordinatesH:30])];
        [_ccheckImg addTarget:self action:@selector(ccheckImgClick) forControlEvents:UIControlEventTouchUpInside];
        [_ccheckImg setTitle:@"查看验货照片" forState:UIControlStateNormal];
        _ccheckImg.layer.borderColor = [[Unity getColor:@"#b445c8"] CGColor];
        _ccheckImg.layer.borderWidth = 1.0f;
        [_ccheckImg setTitleColor:[Unity getColor:@"#b445c8"] forState:UIControlStateNormal];
        _ccheckImg.titleLabel.font = [UIFont systemFontOfSize:14];
        _ccheckImg.layer.cornerRadius = [Unity countcoordinatesH:15];
        _ccheckImg.layer.masksToBounds = YES;
    }
    return _ccheckImg;
}
- (void)configWithSection:(NSInteger)section{
    index = section;
}
//订单详情
- (void)detailClick{
    [self.delegate detailClick:index];
}
//尾款支付
- (void)tailPaymentClick{
    
    [self.delegate tailPaymentClick:index];
    
}
//查看验货照片
- (void)ccheckImgClick{
    [self.delegate ccheckImgClick:index];
}


@end
