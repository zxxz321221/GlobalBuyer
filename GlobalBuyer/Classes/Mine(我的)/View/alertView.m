//
//  alertView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/3.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "alertView.h"

@interface alertView()

@property (nonatomic,strong) UIView * backView;

@end

@implementation alertView

+(instancetype)setAlertView:(UIView *)view{
    alertView * altView = [[alertView alloc]initWithFrame:view.frame];
    [[UIApplication sharedApplication].keyWindow addSubview:altView];
    return altView;
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
        _backView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:40], (kScreenH-[Unity countcoordinatesH:280])/2, [Unity countcoordinatesW:240], [Unity countcoordinatesH:280])];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 10;
        
        [_backView addSubview:self.imageView];
        [_backView addSubview:self.titleL];
        [_backView addSubview:self.contentL];
        [_backView addSubview:self.placeL];
        
        _btn = [Unity buttonAddsuperview_superView:_backView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _placeL.bottom+[Unity countcoordinatesH:30], _backView.width-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]) _tag:self _action:@selector(btnClick) _string:@"" _imageName:@""];
        _btn.layer.cornerRadius = [Unity countcoordinatesW:20];
        [_btn setTitleColor:[Unity getColor:@"#b444c8"] forState:UIControlStateNormal];
        [_btn.layer setBorderColor:[Unity getColor:@"#b444c8"].CGColor];
        [_btn.layer setBorderWidth:1.0];
    }
    return _backView;
}
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [Unity imageviewAddsuperview_superView:_backView _subViewFrame:CGRectMake((_backView.width-[Unity countcoordinatesH:50])/2, [Unity countcoordinatesH:40], [Unity countcoordinatesH:50], [Unity countcoordinatesH:50]) _imageName:@"" _backgroundColor:nil];
    }
    return _imageView;
}
- (UILabel *)titleL{
    if (_titleL == nil) {
        _titleL = [Unity lableViewAddsuperview_superView:_backView _subViewFrame:CGRectMake(0, _imageView.bottom+[Unity countcoordinatesH:20], _backView.width, [Unity countcoordinatesH:20]) _string:@"" _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    }
    return _titleL;
}
- (UILabel *)contentL{
    if (_contentL == nil) {
        _contentL = [Unity lableViewAddsuperview_superView:_backView _subViewFrame:CGRectMake(0, _titleL.bottom, _titleL.width, [Unity countcoordinatesH:20]) _string:@"" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
    }
    return _contentL;
}
- (UILabel *)placeL{
    if (_placeL == nil) {
        _placeL = [Unity lableViewAddsuperview_superView:_backView _subViewFrame:CGRectMake(0, _contentL.bottom, _contentL.width, [Unity countcoordinatesH:40]) _string:@"" _lableFont:[UIFont systemFontOfSize:30] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    }
    return _placeL;
}

- (void)btnClick{
    [self.delegate alertBtnClick];
}

- (void)showAlertView{
    self.hidden = NO;
}
- (void)hiddenAlertView{
    self.hidden = YES;
}
@end
