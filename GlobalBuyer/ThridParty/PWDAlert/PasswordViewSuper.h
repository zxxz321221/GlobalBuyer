//
//  WHPasswordView.h
//  PasswordView
//
//  Created by 西太科技 on 2017/2/6.
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordViewSuper;


@protocol PasswordViewSuperDelegate <NSObject>

- (void)didEnterPWD:(NSString *)pwd withType:(NSString *)type;

@end

@interface PasswordViewSuper : UIView

/** 背景View */
@property (strong, nonatomic) UIView * bg_view;

+ (instancetype)wh_passwordViewWithAlertTitle:(NSString *)alertTitle AlertMessageTitle:(NSString *)messageTitle AlertAmount:(NSString *)alertAmount;

- (void)show;

@property (weak, nonatomic) id<PasswordViewSuperDelegate> delegate;
@property (strong, nonatomic) NSString *setOrEnter;

@end
