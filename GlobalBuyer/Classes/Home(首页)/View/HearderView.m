//
//  HearderView.m
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/6.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//
#define Main_Color [UIColor colorWithRed:0.50 green:0.76 blue:0.25 alpha:1]
#define Cell_BgColor  [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kTabBarH        49.0f
#define kStatusBarH     20.0f
#define kNavigationBarH 44.0f
#import "HearderView.h"


@interface HearderView ()
{
    int ind;
}
@end

@implementation HearderView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{

    NSString *str1 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_Comprehensive", nil);
    NSString *str2 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_Popularity", nil);
    NSString *str3 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_Originalprice", nil);
    NSString *str4 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_Discountprice", nil);
    NSArray *titleArr = @[str4,str1,str2,str3];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4 * i + (kScreenW/8 - 30) , 5, 60, 20)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:150.0/255.0 green:85.0/255.0 blue:185.0/255.0 alpha:1] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:btn];
        btn.tag = i +100;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.enabled = NO;
            ind = 100;
        }
    }

}

-(void)btnClick:(UIButton *)btn{
    UIButton *oldBtn = [self viewWithTag:ind];
    oldBtn.enabled = ! oldBtn.enabled;
    ind = btn.tag;
    btn.enabled = !btn.enabled;
    [self.delegate downLoadSelcetData:ind];
}

-(void)resastBtn{

    UIButton *oldBtn = [self viewWithTag:ind];
    oldBtn.enabled = ! oldBtn.enabled;
    
    UIButton *newBtn = [self viewWithTag:100];
    newBtn.enabled = ! newBtn.enabled;
    
    ind = 100;
}
@end
