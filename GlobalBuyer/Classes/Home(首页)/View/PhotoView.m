//
//  PhotoView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "PhotoView.h"
@interface PhotoView()
@property (nonatomic , strong) UIView * backView;
@end

@implementation PhotoView

+(instancetype)setPhotoView:(UIView *)view{
    PhotoView * photoView = [[PhotoView alloc]initWithFrame:view.frame];
    [view addSubview:photoView];
    return photoView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [self addSubview:self.backView];
        self.hidden = YES;
    }
    return self;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [Unity countcoordinatesH:120])];
        _backView.backgroundColor = [UIColor whiteColor];

        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Unity countcoordinatesH:40])];
        label.text = NSLocalizedString(@"new_updateImg", nil);
        label.textColor = [Unity getColor:@"333333"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [_backView addSubview:label];
        NSArray * arr = @[NSLocalizedString(@"new_paizhao", nil),NSLocalizedString(@"new_xiangce", nil),NSLocalizedString(@"new_lianjie", nil)];
        for ( int i=0; i<3; i++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/3), [Unity countcoordinatesH:40], SCREEN_WIDTH/3, [Unity countcoordinatesH:60])];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((btn.width-[Unity countcoordinatesW:40])/2, 0, [Unity countcoordinatesW:40], [Unity countcoordinatesH:40])];
            imageView.image = [UIImage imageNamed:arr[i]];
            [btn addSubview:imageView];
            
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom, btn.width, [Unity countcoordinatesH:20])];
            title.text = arr[i];
            title.textColor = [Unity getColor:@"666666"];
            title.font = [UIFont systemFontOfSize:14];
            title.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:title];
            [_backView addSubview:btn];
        }
    }
    
    return _backView;
}

- (void)showPhotoView{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT-[Unity countcoordinatesH:120], SCREEN_WIDTH, [Unity countcoordinatesH:120]);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenCashWay];
}
- (void)hiddenCashWay{
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [Unity countcoordinatesH:290]);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    }];
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
}
- (void)delayMethod{
    self.hidden = YES;
}

- (void)btnClick:(UIButton *)btn{
    [self.delegate seleteBtn:btn.tag];
}
@end
