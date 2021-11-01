//
//  LZBLoadingView.m
//  LZBLoadingAnimation
//
//  Created by zibin on 16/10/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LZBLoadingView.h"
#import "LZBLoadingAnimation.h"
#define LZBLoadingView_Width 64
#define LZBLoadingView_Height 64

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

static  LZBLoadingView *_instance;
@interface LZBLoadingView()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation LZBLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
   if(self = [super initWithFrame:frame])
   {
       [self addSubview:self.containerView];
       
   }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.containerView.bounds = CGRectMake(0, 0, LZBLoadingView_Width, LZBLoadingView_Height);
    self.containerView.center = CGPointMake(SCREEN_WIDTH*0.5,SCREEN_HEIGHT*0.5);
}


#pragma mark -API
+ (void)showLoadingViewFourRoundInView:(UIView *)superView
{
    [self instanceViewWithSuperView:superView];
    
    //增加动画
    CGFloat replicatorLayerWidth = 40;
    CALayer *fourRound = [LZBLoadingAnimation loadingReplicatorLayer_SquareWithWidth:replicatorLayerWidth];
    [_instance.containerView.layer addSublayer:fourRound];
    fourRound.bounds = CGRectMake(0, 0, replicatorLayerWidth, replicatorLayerWidth);
    fourRound.position = CGPointMake(LZBLoadingView_Width * 0.5, LZBLoadingView_Height * 0.5);

}

+ (void)showLoadingFourRoundView
{
    [self showLoadingViewFourRoundInView:nil];
}

//加载常用圆形动画
+ (void)showLoadingViewDefautRoundDotInView:(UIView *)superView
{
    [self instanceViewWithSuperView:superView];

    CGFloat replicatorLayerWidth = 40;
    CALayer *fourRound = [LZBLoadingAnimation loadingReplicatorLayer_RoundDot];
    [_instance.containerView.layer addSublayer:fourRound];
    fourRound.bounds = CGRectMake(0, 0, replicatorLayerWidth, replicatorLayerWidth);
    fourRound.position = CGPointMake(LZBLoadingView_Width * 0.2, LZBLoadingView_Height * 0.2);
}

+ (void)showLoadingDefautRoundDotView
{
    [self showLoadingViewDefautRoundDotInView:nil];
}



// 加载常用圆形线动画
+ (void)showLoadingViewDefautRoundLineInView:(UIView *)superView
{
   [self instanceViewWithSuperView:superView];
    CGFloat replicatorLayerWidth = 40;
    CALayer *fourRound = [LZBLoadingAnimation loadingReplicatorLayer_RoundLineRadius:replicatorLayerWidth];
    [_instance.containerView.layer addSublayer:fourRound];
    fourRound.bounds = CGRectMake(0, 0, replicatorLayerWidth, replicatorLayerWidth);
    fourRound.position = CGPointMake(LZBLoadingView_Width * 0.2, LZBLoadingView_Height * 0.2);
}

+ (void)showLoadingDefautRoundLineView
{
    [self showLoadingViewDefautRoundLineInView:nil];
}






+ (void)dismissLoadingView
{
    [UIView animateWithDuration:0.25 animations:^{
        _instance.containerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_instance.containerView.layer removeAllAnimations];
        [_instance.containerView removeFromSuperview];
        [_instance removeFromSuperview];
    }];
 
}

#pragma mark -内部
+ (LZBLoadingView *)instanceViewWithSuperView:(UIView *)superView
{
    if(superView == nil)
        superView = [UIApplication sharedApplication].keyWindow;
    
    if([superView.subviews containsObject:_instance])
        [_instance removeFromSuperview];
    
    _instance = [[LZBLoadingView alloc]init];
    [superView addSubview:_instance];
    _instance.frame = [UIScreen mainScreen].bounds;
    return _instance;
}





#pragma mark - 懒加载
- (UIView *)containerView
{
    if(_containerView == nil)
    {
        _containerView = [UIView new];
        _containerView.userInteractionEnabled = YES;
        _containerView.layer.cornerRadius = 10.0;
        _containerView.layer.masksToBounds= YES;
    }
    return _containerView;
}


- (void)removeAllSubLayer
{
    while (self.layer.sublayers.count)
    {
        CALayer* child = self.layer.sublayers.lastObject;
        [child removeFromSuperlayer];
    }
}

@end
