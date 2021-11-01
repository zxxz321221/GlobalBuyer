//
//  WaterWaveView.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "WaterWaveView.h"
#import "WaveView.h"
#import "UIView+SetRect.h"
#import "DefaultNotificationCenter.h"
#import "NSObject+ViewTag.h"
#import "GCD.h"

typedef enum : NSUInteger {
    
    kWaveOne = 1000,
    kWaveTwo,
    kWaveThree,
    
} EWaterWaveViewControllerViewTag;

@interface WaterWaveView () <DefaultNotificationCenterDelegate>
@property (nonatomic, strong) DefaultNotificationCenter *notificationCenter;
@end

@implementation WaterWaveView

-(instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        
        // Register notification.
        self.notificationCenter = [DefaultNotificationCenter new];
        self.notificationCenter.delegate = self;
        [self.notificationCenter addNotificationName:UIApplicationDidBecomeActiveNotification];
        // WaveThree
        {
            WaveView *waveView = [[WaveView alloc] initWithFrame:CGRectMake(0, self.height/2+20, Width * 2, self.height/2-20)];
            waveView.phase     = 7.5f;
            waveView.waveCrest = 10.f;
            waveView.waveCount = 2;
            waveView.type      = kStrokeWave | kFillWave;
            [self addSubview:waveView];
            [waveView attachTo:self setIdentifier:@(kWaveThree).stringValue];
            
            {
                DrawingStyle *fillStyle = [DrawingStyle new];
                fillStyle.fillColor     = [DrawingColor colorWithUIColor:[[UIColor whiteColor] colorWithAlphaComponent:0.25f]];
                waveView.fillStyle      = fillStyle;
                
                DrawingStyle *strokeStyle = [DrawingStyle new];
                strokeStyle.strokeColor   = [DrawingColor colorWithUIColor:[[UIColor whiteColor] colorWithAlphaComponent:0.15f]];
                strokeStyle.lineWidth     = 0.5f;
                waveView.strokeStyle      = strokeStyle;
            }
        }
        
        // WaveTwo
        {
            WaveView *waveView = [[WaveView alloc] initWithFrame:CGRectMake(0, self.height/2 +20, Width * 2, self.height/2 - 20)];
            waveView.phase     = 5.f;
            waveView.waveCrest = 15.f;
            waveView.waveCount = 2;
            waveView.type      = kStrokeWave | kFillWave;
            [self addSubview:waveView];
            [waveView attachTo:self setIdentifier:@(kWaveTwo).stringValue];
            
            {
                DrawingStyle *fillStyle = [DrawingStyle new];
                fillStyle.fillColor     = [DrawingColor colorWithUIColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
                waveView.fillStyle      = fillStyle;
                
                DrawingStyle *strokeStyle = [DrawingStyle new];
                strokeStyle.strokeColor   = [DrawingColor colorWithUIColor:[[UIColor whiteColor]  colorWithAlphaComponent:0.25f]];
                strokeStyle.lineWidth     = 0.5f;
                waveView.strokeStyle      = strokeStyle;
            }
        }
        
        // WaveOne
        {
            WaveView *waveView = [[WaveView alloc] initWithFrame:CGRectMake(0,self.height/2 + 20, Width * 2, self.height/2 - 20)];
            waveView.phase     = 0.f;
            waveView.waveCrest = 20.f;
            waveView.waveCount = 2;
            waveView.type      = kStrokeWave | kFillWave;
            [self addSubview:waveView];
            [waveView attachTo:self setIdentifier:@(kWaveOne).stringValue];
            
            {
                DrawingStyle *fillStyle = [DrawingStyle new];
                fillStyle.fillColor     = [DrawingColor colorWithUIColor:[UIColor whiteColor]];
                waveView.fillStyle      = fillStyle;
                
                DrawingStyle *strokeStyle = [DrawingStyle new];
                strokeStyle.strokeColor   = [DrawingColor colorWithUIColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
                strokeStyle.lineWidth     = 0.5f;
                waveView.strokeStyle      = strokeStyle;
            }
        }
        
        [self addSubview:self.iconView];
        [self addSubview:self.nameLa];
        //[self addSubview:self.vipView];
        [self readyToBegin];
        
    }
    return self;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init];
        _iconView.backgroundColor = [UIColor whiteColor];
        _iconView.layer.cornerRadius = 40;
        _iconView.clipsToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"icon"];
        _iconView.frame = CGRectMake((kScreenW - 80)/2, 30, 80, 80);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
        tapGesture.numberOfTapsRequired = 1; //点击次数
        tapGesture.numberOfTouchesRequired = 1; //点击手指数
        [ _iconView addGestureRecognizer:tapGesture];
        _iconView.userInteractionEnabled = YES;
        
    }
    return _iconView;

}

- (UIButton *)vipView
{
    if (_vipView == nil) {
        _vipView = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2 - 30, 75, 60, 60)];
        [_vipView setBackgroundImage:[UIImage imageNamed:@"未开通会员"] forState:UIControlStateNormal];
        [_vipView setBackgroundImage:[UIImage imageNamed:@"已开通会员"] forState:UIControlStateSelected];
    }
    return _vipView;
}

-(void)iconClick{
    [self.delegate changeIcon];
}

-(UILabel *)nameLa {
    if (_nameLa == nil) {
        _nameLa = [[UILabel alloc]init];
        _nameLa.textColor = [UIColor whiteColor];
        _nameLa.font = [UIFont systemFontOfSize:14.0f];
        _nameLa.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1; //点击次数
        tapGesture.numberOfTouchesRequired = 1; //点击手指数
        [ _nameLa addGestureRecognizer:tapGesture];
        _nameLa.userInteractionEnabled = YES;
    }
    return _nameLa;
}

-(void)tapGesture:(UITapGestureRecognizer *)tap {
    [self.delegate loginClick];
}

-(void)setName:(NSString *)name{
    self.nameLa.text = name;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
    CGSize strSize = [name boundingRectWithSize:CGSizeMake(kScreenW, 30) options: NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
    [self.nameLa mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(strSize.width, strSize.height));
        make.top.equalTo(self.iconView).with.offset(90);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)readyToBegin {
    
    UIView *waveOne   = [self viewWithIdentifier:@(kWaveOne).stringValue];
    UIView *waveTwo   = [self viewWithIdentifier:@(kWaveTwo).stringValue];
    UIView *waveThree = [self viewWithIdentifier:@(kWaveThree).stringValue];
    
    [waveOne.layer   removeAllAnimations];
    [waveTwo.layer   removeAllAnimations];
    [waveThree.layer removeAllAnimations];
    
    waveOne.x   = 0.f;
    waveTwo.x   = 0.f;
    waveThree.x = 0.f;
    
    [self doAnimation];
}

- (void)doAnimation {
    
    {
        UIView *waveView = [self viewWithIdentifier:@(kWaveOne).stringValue];
        [UIView animateWithDuration:2.f
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             waveView.x = -Width;
                             
                         } completion:nil];
    }
    
    {
        UIView *waveView = [self viewWithIdentifier:@(kWaveTwo).stringValue];
        [UIView animateWithDuration:4.f
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             waveView.x = -Width;
                             
                         } completion:nil];
    }
    
    {
        UIView *waveView = [self viewWithIdentifier:@(kWaveThree).stringValue];
        [UIView animateWithDuration:6.f
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             waveView.x = -Width;
                             
                         } completion:nil];
    }
}

#pragma mark - DefaultNotificationCenterDelegate

- (void)defaultNotificationCenter:(DefaultNotificationCenter *)notification name:(NSString *)name object:(id)object {
    
    if ([name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        
        [self readyToBegin];
    }
}

@end
