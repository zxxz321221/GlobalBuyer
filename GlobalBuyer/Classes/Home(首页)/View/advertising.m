//
//  advertising.m
//  TakeThings-iOS
//
//  Created by 桂在明 on 2020/1/17.
//  Copyright © 2020 GUIZM. All rights reserved.
//

#import "advertising.h"

@interface advertising()

@property (nonatomic , strong) UIButton * exitBtn;

@end
@implementation advertising
+(instancetype)setadvertising:(UIView *)view{
    advertising * pView = [[advertising alloc]initWithFrame:view.frame];
    [[UIApplication sharedApplication].keyWindow addSubview:pView];
    return pView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.hidden = YES;
        [self addSubview:self.imageView];
        [self addSubview:self.exitBtn];
    }
    return self;
}
- (FLAnimatedImageView *)imageView{
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-[Unity countcoordinatesW:240])/2, (SCREEN_HEIGHT-[Unity countcoordinatesH:240])/2, [Unity countcoordinatesW:240], [Unity countcoordinatesH:240])];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-[Unity countcoordinatesW:40])/2, _imageView.bottom+[Unity countcoordinatesH:30], [Unity countcoordinatesW:40], [Unity countcoordinatesH:40])];
        [_exitBtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
        [_exitBtn setImage:[UIImage imageNamed:@"home_exit"] forState:UIControlStateNormal];
        
    }
    return _exitBtn;
}
- (void)exitClick{
    self.hidden = YES;
}
- (void)showAdvertising{
    self.hidden = NO;
}
@end
