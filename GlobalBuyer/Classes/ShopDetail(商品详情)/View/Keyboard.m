//
//  Keyboard.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/9.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "Keyboard.h"

@interface Keyboard()
@property (nonatomic , strong) UIView *keyboardView;
@property (nonatomic , strong) NSArray *keyList;

@end
@implementation Keyboard

+(instancetype)setKeyboard:(UIView *)view{
    Keyboard * keyborad = [[Keyboard alloc]initWithFrame:view.frame];
    [view addSubview:keyborad];
    return keyborad;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.keyboardView];
    }
    return self;
}
-(UIView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, [Unity countcoordinatesH:200])];
        _keyboardView.backgroundColor = [UIColor whiteColor];
        
        NSArray * keylist = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"X",@"0",@"."];
        for (int i=0; i<keylist.count; i++) {
            UIButton * btn = [Unity buttonAddsuperview_superView:_keyboardView _subViewFrame:CGRectMake((i%3)*(kScreenW/4), (i/3)*[Unity countcoordinatesH:50], kScreenW/4, [Unity countcoordinatesH:50]) _tag:self _action:@selector(keyBoardClick:) _string:@"" _imageName:@""];
            [btn setTitle:keylist[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:24];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = 666+i;
        }
        NSArray * arr = @[@"key_cancel",@"confim_key"];
        for (int j=0; j<arr.count; j++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4*3, j*[Unity countcoordinatesH:100], kScreenW/4, [Unity countcoordinatesH:100])];
            [_keyboardView addSubview:btn];
            [btn addTarget:self action:@selector(keyBoardClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:arr[j]] forState:UIControlStateNormal];
            btn.adjustsImageWhenHighlighted = NO;
            btn.tag = 678+j;
        }
    }
    return _keyboardView;
}
- (void)keyBoardClick:(UIButton *)btn{
    NSString * keys;
    if (btn.tag < 675) {
        keys = [NSString stringWithFormat:@"%ld",btn.tag-665];
    }else if (btn.tag == 675){
        keys=@"X";
    }else if (btn.tag == 676){
        keys=@"0";
    }
    else if (btn.tag == 677){
        keys=@".";
    }
    else if (btn.tag == 678){
        keys=@"-";
    }
    else if (btn.tag == 679){
        keys=@"enter";
    }
    [self.delegate keyboardKeys:keys];
}
- (void)showKeyboard{
    [UIView animateWithDuration:0.5 animations:^{
        self.keyboardView.frame = CGRectMake(0, kScreenH-[Unity countcoordinatesH:200]-64, kScreenW, [Unity countcoordinatesH:200]);
    }];
}
- (void)hiddenKeyboard{
    [UIView animateWithDuration:0.5 animations:^{
        self.keyboardView.frame = CGRectMake(0, kScreenH-64, kScreenW, [Unity countcoordinatesH:200]);
    }];
}
@end

