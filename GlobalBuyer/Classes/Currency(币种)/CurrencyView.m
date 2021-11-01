//
//  CurrencyView.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/23.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "CurrencyView.h"

@interface CurrencyView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *btnBgView;
@property (nonatomic, strong)NSMutableArray *currencyArr;
@end

@implementation CurrencyView

+ (instancetype)currencyView {
    CurrencyView *currencyView = [[CurrencyView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    currencyView.hidden = YES;
    return currencyView;

}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (NSMutableArray *)currencyArr {
    if (_currencyArr == nil) {
        _currencyArr = [[NSMutableArray alloc]initWithArray:@[@"RMB",@"TWD",@"USD ",@"JPY",@"EUR",@"GBP",@"AUD",@"KRW"]];
    }
    return _currencyArr;
}

#pragma mark 创建视图
- (void)setupUI {
 
    self.bgView = [[UIView alloc]initWithFrame:self.frame];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    self.bgView.hidden = YES;
    [self addSubview:self.bgView];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.frame;
    [self.bgView addSubview:effectView];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    self.btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 270)];
    self.btnBgView.backgroundColor = [UIColor darkTextColor];
    self.btnBgView.alpha = 0.5;
    [self addSubview:self.btnBgView];
    UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.btnBgView addGestureRecognizer:tapGesture1];
    
    for (int i = 0; i< 4 ; i++) {
        for (int j = 0; j < 2; j++) {
            if ( j == 0) {
                 UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4 - 40 , 35 + i * (30+25), 80, 30)];
                [btn setTitle:self.currencyArr[i*2 + j] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.tag =i*2 + j +10;
                btn.layer.borderWidth = 1;
                //btn.layer.cornerRadius = 15;
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                [btn addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
                [self.btnBgView addSubview:btn];
            }else{
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4 * 3 - 40 , 35 + i * (30+25), 80, 30)];
                [btn setTitle:self.currencyArr[i*2 + j] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.tag =i*2 + j +10;
                btn.layer.borderWidth = 1;
                //btn.layer.cornerRadius = 15;
                [btn addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                [self.btnBgView addSubview:btn];
            }
        }
    }
}

#pragma mark 选择币种
- (void)selectCurrency:(UIButton *)btn {
    
    switch (btn.tag) {
        case 10:
            [UserDefault setObject:@"rmb_rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"人民币"  forKey:@"rmb_rate_rmb"];
            break;
        case 11:
            [UserDefault setObject:@"rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"台币"  forKey:@"rate_rmb"];
            break;
            
        case 12:
            [UserDefault setObject:@"usd_rate_rmb"  forKey:@"currency"];
            
            [UserDefault setObject:@"美元"  forKey:@"usd_rate_rmb"];
            break;
            
        case 13:
            [UserDefault setObject:@"jyp_rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"日元"  forKey:@"jyp_rate_rmb"];
            break;
        case 14:
            [UserDefault setObject:@"euro_rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"欧元"  forKey:@"euro_rate_rmb"];
            break;
        case 15:
            [UserDefault setObject:@"gbp_rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"英镑"  forKey:@"gbp_rate_rmb"];
            break;
        case 16:
            [UserDefault setObject:@"aud_rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"澳元"  forKey:@"aud_rate_rmb"];
            break;
        case 17:
            [UserDefault setObject:@"krw_rate_rmb"  forKey:@"currency"];
            [UserDefault setObject:@"韩币"  forKey:@"krw_rate_rmb"];
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.btnBgView.frame;
        frame.origin.y = kScreenH;
        self.btnBgView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden =YES;
            self.bgView.hidden = YES;
            [self.delegate goTo];
        }];
        
    }];
}

#pragma mark 隐藏和显示视图
-( void)Actiondo:(id)sender {
    [self hideCurrencyView];
}

- (void)showCurrencyView {
    self.hidden =NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
     self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.btnBgView.frame;
            frame.origin.y = kScreenH - 270;
            self.btnBgView.frame = frame;
        }];
    }];
}

- (void)hideCurrencyView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.btnBgView.frame;
        frame.origin.y = kScreenH;
        self.btnBgView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden =YES;
            self.bgView.hidden = YES;
        }];
        
    }];
}

@end
