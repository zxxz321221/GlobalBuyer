//
//  alertView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/3.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  alertViewDelegate <NSObject>

- (void)alertBtnClick;

@end

@interface alertView : UIView

@property (nonatomic, strong) id<alertViewDelegate>delegate;
@property (nonatomic,strong) UILabel * titleL;
@property (nonatomic,strong) UILabel * contentL;
@property (nonatomic,strong) UILabel * placeL;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIButton * btn;

+ (instancetype)setAlertView:(UIView *)view;

- (void)showAlertView;

- (void)hiddenAlertView;
@end
