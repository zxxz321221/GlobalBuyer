//
//  GoodsFooterView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "GoodsFooterView.h"
@interface GoodsFooterView()
{
    NSInteger index;
}
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UILabel * sumNum;
@property (nonatomic , strong) UIButton * orderDetail;
@property (nonatomic , strong) UIButton * confirm;
@property (nonatomic , strong) UIButton * shippingInfo;

@end
@implementation GoodsFooterView

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
        [_backView addSubview:self.confirm];
        [_backView addSubview:self.shippingInfo];
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
        _orderDetail = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:270], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
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
- (UIButton *)confirm{
    if (!_confirm) {
        _confirm = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:80], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_confirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirm setTitle:@"确认收货" forState:UIControlStateNormal];
        _confirm.backgroundColor = [Unity getColor:@"#b445c8"];
        _confirm.layer.cornerRadius = [Unity countcoordinatesH:15];
        _confirm.layer.masksToBounds=YES;
        _confirm.titleLabel.font = [UIFont systemFontOfSize:13];
        [_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _confirm;
}
- (UIButton *)shippingInfo{
    if (!_shippingInfo) {
        _shippingInfo = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:190], [Unity countcoordinatesH:50], [Unity countcoordinatesW:100], [Unity countcoordinatesH:30])];
        [_shippingInfo addTarget:self action:@selector(shippingInfoClick) forControlEvents:UIControlEventTouchUpInside];
        [_shippingInfo setTitle:@"配送物流信息" forState:UIControlStateNormal];
        _shippingInfo.layer.borderColor = [[Unity getColor:@"#b445c8"] CGColor];
        _shippingInfo.layer.borderWidth = 1.0f;
        [_shippingInfo setTitleColor:[Unity getColor:@"#b445c8"] forState:UIControlStateNormal];
        _shippingInfo.titleLabel.font = [UIFont systemFontOfSize:14];
        _shippingInfo.layer.cornerRadius = [Unity countcoordinatesH:15];
        _shippingInfo.layer.masksToBounds = YES;
    }
    return _shippingInfo;
}
- (void)configWithSection:(NSInteger)section{
    index = section;
}
//订单详情
- (void)detailClick{
    [self.delegate detailClick:index];
}
//确认收货
- (void)confirmClick{
    [self.delegate confirmClick:index];
    
}
//配送物流信息
- (void)shippingInfoClick{
    [self.delegate shippingInfoClick:index];
    
}

@end
