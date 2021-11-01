//
//  SeleteCurrecy.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/31.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "SeleteCurrecy.h"
@interface SeleteCurrecy()
{
    NSInteger index;
    NSArray * arr;
}
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UILabel * titleL;
@property (nonatomic , strong) UILabel * line0;


@end
@implementation SeleteCurrecy

+(instancetype)setSeleteCurrecy:(UIView *)view{
    SeleteCurrecy * seleteCurrecy = [[SeleteCurrecy alloc]initWithFrame:view.frame];
    [view addSubview:seleteCurrecy];
    return seleteCurrecy;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.backView];
        self.hidden = YES;
    }
    return self;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], (SCREEN_HEIGHT-[Unity countcoordinatesH:350])/2-NavBarHeight/2, SCREEN_WIDTH-[Unity countcoordinatesW:40], [Unity countcoordinatesH:350])];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        
        [_backView addSubview:self.titleL];
        [_backView addSubview:self.line0];
        
        arr = @[@{@"title":NSLocalizedString(@"new_CHY", nil),@"bz":@"CNY"},@{@"title":NSLocalizedString(@"new_TWD", nil),@"bz":@"TWD"},@{@"title":NSLocalizedString(@"new_USD", nil),@"bz":@"USD"},@{@"title":NSLocalizedString(@"new_JPY", nil),@"bz":@"JPY"},@{@"title":NSLocalizedString(@"new_EUR", nil),@"bz":@"EUR"},@{@"title":NSLocalizedString(@"new_GBP", nil),@"bz":@"GBP"},@{@"title":NSLocalizedString(@"new_AUD", nil),@"bz":@"AUD"},@{@"title":NSLocalizedString(@"new_KRW", nil),@"bz":@"KRW"},@{@"title":NSLocalizedString(@"new_HKD", nil),@"bz":@"HKD"}];
        for (int i=0; i<9; i++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake((i%2+1)*[Unity countcoordinatesW:10]+(i%2)*((_backView.width-[Unity countcoordinatesW:30])/2), _line0.bottom+(i/2+1)*[Unity countcoordinatesH:10]+(i/2)*[Unity countcoordinatesH:40], (_backView.width-[Unity countcoordinatesW:30])/2, [Unity countcoordinatesH:40])];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:arr[i][@"title"] forState:UIControlStateNormal];
            [btn setTitleColor:[Unity getColor:@"333333"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"an2"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"an1"] forState:UIControlStateSelected];
            [_backView addSubview:btn];
        }
        
        UIButton * confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _backView.height-[Unity countcoordinatesH:40], _backView.width, [Unity countcoordinatesH:40])];
        [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.backgroundColor = [UIColor blackColor];
        [confirmBtn setTitle:NSLocalizedString(@"new_confirm", nil) forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_backView addSubview:confirmBtn];
    }
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _backView.width, [Unity countcoordinatesH:40])];
        _titleL.text = NSLocalizedString(@"new_seleteSHDQ", nil);
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UILabel *)line0{
    if (!_line0) {
        _line0 = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _titleL.bottom, _backView.width-[Unity countcoordinatesW:20], 1)];
        _line0.backgroundColor = [Unity getColor:@"f0f0f0"];
    }
    return _line0;
}
- (void)showSeleteCurrecy{
    self.hidden = NO;
}
- (void)hiddenSeleteCurrecy{
    self.hidden = YES;
}
- (void)btnClick:(UIButton *)btn{
    
    if (index == btn.tag-1000) {
        return;
    }else{
        for (int i=0; i<9; i++) {
            UIButton * btn1 = (UIButton *)[self.backView viewWithTag:i+1000];
            if (btn.tag-1000 == i) {
                btn1.selected = YES;
            }else{
                btn1.selected = NO;
            }
        }
    }
    index = btn.tag-1000;
}
- (void)confirmClick{
    if (index) {
        [self hiddenSeleteCurrecy];
        [self.delegate seleteCurrecyDic:arr[index]];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenSeleteCurrecy];
}
@end
