//
//  AroundAnimation.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/21.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "AroundAnimation.h"

@interface AroundAnimation ()

@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView * imgView;

@end
@implementation AroundAnimation

+(instancetype)AroundAnimationViewSetView:(UIView *)view{
    AroundAnimation * aroundAnimation = [[AroundAnimation alloc]initWithFrame:view.frame];
    [view addSubview:aroundAnimation];
    return aroundAnimation;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        UIColor *color = [UIColor blackColor];
        self.backgroundColor = [color colorWithAlphaComponent:0.3];
//        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0;
        self.hidden = YES;
        [self addSubview:self.backView];
        
    }
    return self;
}

-(UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake((self.bounds.size.width-80)/2, (self.bounds.size.height-80)/2, 80, 80)];
        _backView.backgroundColor = [UIColor whiteColor];
//        _backView.alpha = 0.8;
        _backView.layer.cornerRadius = 8;
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [_backView addSubview:_imgView];
    }
    return _backView;
}

- (NSMutableArray *)imgArray{
    if (_imgArray == nil) {
        _imgArray = [NSMutableArray new];
        for (int i = 0; i < 19; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"x%d",i+1]];
            [_imgArray addObject: img];
        }
    }
    return _imgArray;
}

-(void)startAround{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.backView.hidden=NO;
    } completion:^(BOOL finished) {
        self.imgView.animationImages = self.imgArray;
        self.imgView.animationDuration = 1;
        self.imgView.animationRepeatCount = 0;
        [self.imgView startAnimating];
    }];
}

-(void)stopAround{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.backView.hidden=YES;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.imgView stopAnimating];
    }];
}

@end

    
