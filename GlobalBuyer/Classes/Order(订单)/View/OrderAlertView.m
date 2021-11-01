//
//  OrderAlertView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "OrderAlertView.h"
@interface OrderAlertView()<UITextFieldDelegate>
{
    NSArray * arr;
    NSInteger btnIndex;
}
@property (nonatomic,strong) UIView * backView;
@property (nonatomic , strong) UILabel * titleL;
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic , strong) UITextField * textField;
@property (nonatomic , strong) UIButton * cancel;
@property (nonatomic , strong) UIButton * confim;


@end
@implementation OrderAlertView

+(instancetype)setOrderAlertView:(UIView *)view{
    OrderAlertView * orderAltView = [[OrderAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [[UIApplication sharedApplication].keyWindow addSubview:orderAltView];
    return orderAltView;
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
        _backView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:30], (kScreenH-[Unity countcoordinatesH:240])/2, [Unity countcoordinatesW:260], [Unity countcoordinatesH:240])];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 10;
        
        [_backView addSubview:self.titleL];
        arr = @[NSLocalizedString(@"GlobalBuyer_order_reason1", nil),NSLocalizedString(@"GlobalBuyer_order_reason2", nil),NSLocalizedString(@"GlobalBuyer_order_reason3", nil),NSLocalizedString(@"GlobalBuyer_order_reason4", nil)];
        for (int i=0; i<4; i++) {
            UILabel * label = [Unity lableViewAddsuperview_superView:_backView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], self.titleL.bottom+(i+1)*[Unity countcoordinatesH:15]+i*[Unity countcoordinatesH:20], [Unity widthOfString:arr[i] OfFontSize:13 OfHeight:[Unity countcoordinatesH:20]], [Unity countcoordinatesH:20]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
            if (i == 3) {
                _textField = [Unity textFieldAddSuperview_superView:_backView _subViewFrame:CGRectMake(label.right+5, label.top, _backView.width-[Unity countcoordinatesW:36]-label.width-10, [Unity countcoordinatesH:20]) _placeT:NSLocalizedString(@"GlobalBuyer_order_textField_placeholder", nil) _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:nil];
                _textField.font = [UIFont systemFontOfSize:13];
                UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(_textField.left, _textField.bottom, _textField.width, 1)];
                line.backgroundColor = [Unity getColor:@"#e0e0e0"];
                [_backView addSubview:line];
                
            }
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width-[Unity countcoordinatesW:26], label.top+[Unity countcoordinatesH:2], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16])];
            btn.tag = 1000+i;
            [btn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"order_xuanzhong"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:btn];
            if (i ==0) {
                btnIndex = 0;
                btn.selected =YES;
                _selectedBtn =btn;
                
            }
        }
        [_backView addSubview:self.cancel];
        [_backView addSubview:self.confim];
        
    }
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], _backView.width-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        _titleL.text = NSLocalizedString(@"GlobalBuyer_order_title", nil);
        _titleL.textColor = [Unity getColor:@"#b444c8"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UIButton *)cancel{
    if (!_cancel) {
        _cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:200], _backView.width/2, [Unity countcoordinatesH:30])];
        [_cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancel setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [_cancel setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _cancel;
}
- (UIButton *)confim{
    if (!_confim) {
        _confim = [[UIButton alloc]initWithFrame:CGRectMake(_backView.width/2, [Unity countcoordinatesH:200], _backView.width/2, [Unity countcoordinatesH:30])];
         [_confim addTarget:self action:@selector(confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_confim setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_confim setTitleColor:[Unity getColor:@"#666666"] forState:UIControlStateNormal];
        _confim.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _confim;
}
- (void)showAlertView{
    self.hidden = NO;
}
- (void)hiddenAlertView{
    self.hidden = YES;
}
- (void)btnClick:(UIButton *)btn{
    btnIndex = btn.tag-1000;
    if (btn!=self.selectedBtn) {
        self.selectedBtn.selected =NO;
        btn.selected =YES;
        self.selectedBtn = btn;
    }else{
        self.selectedBtn.selected =YES;
    }
}
// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.backView.frame = CGRectMake([Unity countcoordinatesW:30], (kScreenH-[Unity countcoordinatesH:240])/2-[Unity countcoordinatesH:80], [Unity countcoordinatesW:260], [Unity countcoordinatesH:240]);
    return YES;
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.backView.frame = CGRectMake([Unity countcoordinatesW:30], (kScreenH-[Unity countcoordinatesH:240])/2, [Unity countcoordinatesW:260], [Unity countcoordinatesH:240]);
}
- (void)cancelClick{
    [self hiddenAlertView];
}
- (void)confimClick{
    [self hiddenAlertView];
    if (btnIndex != 3) {
        [self.delegate confim:arr[btnIndex]];
    }else{
        [self.delegate confim:self.textField.text];
    }
}
@end
