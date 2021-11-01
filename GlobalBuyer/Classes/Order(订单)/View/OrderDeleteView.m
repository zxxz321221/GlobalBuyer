//
//  OrderDeleteView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/13.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "OrderDeleteView.h"
@interface OrderDeleteView()

@property (nonatomic,strong) UIView * backView;
@property (nonatomic , strong) UILabel * titleL;
@property (nonatomic , strong) UIButton * cancel;
@property (nonatomic , strong) UIButton * confim;


@end
@implementation OrderDeleteView
+(instancetype)setOrderDeleteView:(UIView *)view{
    OrderDeleteView * orderDltView = [[OrderDeleteView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [[UIApplication sharedApplication].keyWindow addSubview:orderDltView];
    return orderDltView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.hidden = YES;
        [self addSubview:self.backView];
    }
    return self;
}
-(UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:30], (kScreenH-[Unity countcoordinatesH:100])/2, [Unity countcoordinatesW:260], [Unity countcoordinatesH:100])];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 10;
        
        [_backView addSubview:self.titleL];
        [_backView addSubview:self.cancel];
        [_backView addSubview:self.confim];
        
    }
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], [Unity countcoordinatesH:20], _backView.width-[Unity countcoordinatesW:40], [Unity countcoordinatesH:20])];
        _titleL.text = NSLocalizedString(@"GlobalBuyer_order_deleteOrder?", nil);
        _titleL.textColor = [Unity getColor:@"#b444c8"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UIButton *)cancel{
    if (!_cancel) {
        _cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, _titleL.bottom+[Unity countcoordinatesH:20], _backView.width/2, [Unity countcoordinatesH:30])];
        [_cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancel setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [_cancel setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _cancel;
}
- (UIButton *)confim{
    if (!_confim) {
        _confim = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width/2, _cancel.top, _backView.width/2, [Unity countcoordinatesH:30])];
        [_confim addTarget:self action:@selector(confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_confim setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_confim setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        _confim.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _confim;
}
- (void)showDltView{
    self.hidden = NO;
}
- (void)hiddenDltView{
    self.hidden = YES;
}

- (void)cancelClick{
    [self hiddenDltView];
}
- (void)confimClick{
    [self hiddenDltView];
    [self.delegate confirmTheDeletion];
}


@end
