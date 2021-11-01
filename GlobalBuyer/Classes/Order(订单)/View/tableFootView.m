//
//  tableFootView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "tableFootView.h"
@interface tableFootView()
{
    NSInteger index;
}
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UILabel * sumNum;
@property (nonatomic , strong) UIButton * payment;
@property (nonatomic , strong) UIButton * cancelOrder;
@property (nonatomic , strong) UIButton * orderDetail;
@property (nonatomic , strong) UIButton * logistics;
@property (nonatomic , strong) UIButton * checkImg;
@property (nonatomic , strong) UIButton * tailPayment;
@property (nonatomic , strong) UIButton * ccheckImg;
@property (nonatomic , strong) UIButton * confirm;
@property (nonatomic , strong) UIButton * shippingInfo;
@property (nonatomic , strong) UIButton * deleteOrder;

@property (nonatomic , strong) NSTimer * timer;
@end
@implementation tableFootView
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
        [_backView addSubview:self.payment];
        [_backView addSubview:self.cancelOrder];
        [_backView addSubview:self.orderDetail];
        [_backView addSubview:self.logistics];
        [_backView addSubview:self.checkImg];
        [_backView addSubview:self.tailPayment];
        [_backView addSubview:self.ccheckImg];
        [_backView addSubview:self.confirm];
        [_backView addSubview:self.shippingInfo];
        [_backView addSubview:self.deleteOrder];
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
- (UIButton *)payment{
    if (!_payment) {
        _payment = [[UIButton  alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:120], [Unity countcoordinatesH:50], [Unity countcoordinatesW:110], [Unity countcoordinatesH:30])];
        [_payment addTarget:self action:@selector(paymentClick) forControlEvents:UIControlEventTouchUpInside];
        [_payment setTitle:@"付款:23:59:59" forState:UIControlStateNormal];
        _payment.backgroundColor = [Unity getColor:@"#b445c8"];
        _payment.layer.cornerRadius = [Unity countcoordinatesH:15];
        _payment.layer.masksToBounds=YES;
        _payment.titleLabel.font = [UIFont systemFontOfSize:13];
        [_payment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payment.hidden= YES;
    }
    return _payment;
}
- (UIButton *)cancelOrder{
    if (!_cancelOrder) {
        _cancelOrder = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:200], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_cancelOrder addTarget:self action:@selector(cancelOrderClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancelOrder.layer.borderColor = [[Unity getColor:@"#333333"] CGColor];
        _cancelOrder.layer.borderWidth = 1.0f;
        [_cancelOrder setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _cancelOrder.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelOrder.layer.cornerRadius = [Unity countcoordinatesH:15];
        _cancelOrder.layer.masksToBounds = YES;
        _cancelOrder.hidden=YES;
    }
    return _cancelOrder;
}
- (UIButton *)orderDetail{
    if (!_orderDetail) {
        _orderDetail = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:280], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_orderDetail addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetail setTitle:@"订单详情" forState:UIControlStateNormal];
        _orderDetail.layer.borderColor = [[Unity getColor:@"#333333"] CGColor];
        _orderDetail.layer.borderWidth = 1.0f;
        [_orderDetail setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _orderDetail.titleLabel.font = [UIFont systemFontOfSize:14];
        _orderDetail.layer.cornerRadius = [Unity countcoordinatesH:15];
        _orderDetail.layer.masksToBounds = YES;
        _orderDetail.hidden=YES;
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
        _logistics.hidden= YES;
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
        _checkImg.hidden=YES;
    }
    return _checkImg;
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
        _tailPayment.hidden= YES;
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
        _ccheckImg.hidden=YES;
    }
    return _ccheckImg;
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
        _confirm.hidden= YES;
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
        _shippingInfo.hidden=YES;
    }
    return _shippingInfo;
}
- (UIButton *)deleteOrder{
    if (!_deleteOrder) {
        _deleteOrder = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:160], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30])];
        [_deleteOrder addTarget:self action:@selector(deleteOrderClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteOrder setTitle:@"删除订单" forState:UIControlStateNormal];
        _deleteOrder.layer.borderColor = [[Unity getColor:@"#333333"] CGColor];
        _deleteOrder.layer.borderWidth = 1.0f;
        [_deleteOrder setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _deleteOrder.titleLabel.font = [UIFont systemFontOfSize:14];
        _deleteOrder.layer.cornerRadius = [Unity countcoordinatesH:15];
        _deleteOrder.layer.masksToBounds = YES;
        _deleteOrder.hidden=YES;
    }
    return _deleteOrder;
}
- (void)configWithSection:(NSInteger)section{
    index = section;
        if (section == 0) {
            _payment.hidden = NO;
            _cancelOrder.hidden = NO;
            _orderDetail.frame = CGRectMake(_backView.width-[Unity countcoordinatesW:280], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30]);
            _orderDetail.hidden = NO;
            _logistics.hidden=YES;
            _checkImg.hidden=YES;
            _tailPayment.hidden = YES;
            _ccheckImg.hidden=YES;
            _confirm.hidden = YES;
            _shippingInfo.hidden = YES;
            _deleteOrder.hidden=YES;
            [self countdownWithCurrentDate:@"2019-05-11 12:00:00"];
        }else if (section == 1){
            _logistics.hidden= NO;
            _checkImg.hidden=NO;
            _orderDetail.frame = CGRectMake(_backView.width-[Unity countcoordinatesW:240], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30]);
            _orderDetail.hidden = NO;
            _payment.hidden=YES;
            _cancelOrder.hidden = YES;
            _tailPayment.hidden = YES;
            _ccheckImg.hidden=YES;
            _confirm.hidden = YES;
            _shippingInfo.hidden = YES;
            _deleteOrder.hidden=YES;
        }else if (section == 2){
            _tailPayment.hidden = NO;
            _ccheckImg.hidden=NO;
            _orderDetail.frame = CGRectMake(_backView.width-[Unity countcoordinatesW:250], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30]);
            _orderDetail.hidden = NO;
            _payment.hidden=YES;
            _cancelOrder.hidden=YES;
            _logistics.hidden=YES;
            _checkImg.hidden=YES;
            _confirm.hidden = YES;
            _shippingInfo.hidden = YES;
            _deleteOrder.hidden=YES;
        }else if (section == 3){
            _confirm.hidden = NO;
            _shippingInfo.hidden = NO;
            _orderDetail.frame = CGRectMake(_backView.width-[Unity countcoordinatesW:270], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30]);
            _orderDetail.hidden = NO;
            _payment.hidden=YES;
            _cancelOrder.hidden=YES;
            _logistics.hidden=YES;
            _checkImg.hidden=YES;
            _tailPayment.hidden = YES;
            _ccheckImg.hidden=YES;
            _deleteOrder.hidden=YES;
        }else{
            _orderDetail.frame = CGRectMake(_backView.width-[Unity countcoordinatesW:80], [Unity countcoordinatesH:50], [Unity countcoordinatesW:70], [Unity countcoordinatesH:30]);
            _orderDetail.hidden = NO;
            _payment.hidden=YES;
            _cancelOrder.hidden=YES;
            _deleteOrder.hidden=NO;
            _logistics.hidden=YES;
            _checkImg.hidden=YES;
            _tailPayment.hidden = YES;
            _ccheckImg.hidden=YES;
            _confirm.hidden = YES;
            _shippingInfo.hidden = YES;
        }
}
//付款
- (void)paymentClick{
    [self.delegate paymentClick:index];
}
//取消订单
- (void)cancelOrderClick{
    [self.delegate cancelOrderClick:index];
    
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
//尾款支付
- (void)tailPaymentClick{
    
[self.delegate tailPaymentClick:index];
    
}
//查看验货照片
- (void)ccheckImgClick{
    [self.delegate ccheckImgClick:index];
    
}
//确认收货
- (void)confirmClick{
    [self.delegate confirmClick:index];
    
}
//配送物流信息
- (void)shippingInfoClick{
    [self.delegate shippingInfoClick:index];
    
}
//删除订单
- (void)deleteOrderClick{
    [self.delegate deleteOrderClick:index];
}
- (void)countdownWithCurrentDate:(NSString *)currentDate{
    // 当前时间的时间戳
    NSString *nowStr = [self getCurrentTimeyyyymmdd];
    // 计算时间差值
    NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowStr deadlineStr:currentDate];
    [self daojishi:secondsCountDown];
}
- (void)daojishi:(NSInteger)ss{
    __weak __typeof(self) weakSelf = self;
    
    if (_timer == nil) {
        __block NSInteger timeout = ss; // 倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //倒计时结束
                    });
                } else { // 倒计时重新计算 时/分/秒
                    NSInteger days = (int)(timeout/(3600*24));
                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                    NSString *strTime = [NSString stringWithFormat:@"付款:%02ld:%02ld:%02ld", hours, minute, second];
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.payment setTitle:strTime forState:UIControlStateNormal];
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                }
            });
            dispatch_resume(_timer);
        }
    }
}
/**
 *  获取当天的字符串
 *
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}
/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}
@end
