//
//  FirstOrderFooterView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "FirstOrderFooterView.h"
@interface FirstOrderFooterView()
{
    NSInteger index;
}
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UILabel * sumNum;
@property (nonatomic , strong) UIButton * payment;
@property (nonatomic , strong) UIButton * cancelOrder;
@property (nonatomic , strong) UIButton * orderDetail;

@property (nonatomic , strong) NSTimer * timer;

@end
@implementation FirstOrderFooterView

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
    }
    return _orderDetail;
}
- (void)configWithSection:(NSInteger)section{
    index = section;

    [self countdownWithCurrentDate:@"2019-05-11 12:00:00"];
    
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
