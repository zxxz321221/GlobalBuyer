//
//  ShopNotiView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/17.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "ShopNotiView.h"
@interface ShopNotiView()

@property (nonatomic,strong) UIView * notiView;
@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UIButton * detailBtn;
@end
@implementation ShopNotiView
+(instancetype)setShopNotiView:(UIView *)view{
    ShopNotiView * notiView = [[ShopNotiView alloc]initWithFrame:view.frame];
    [[UIApplication sharedApplication].keyWindow addSubview:notiView];
    return notiView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.hidden = YES;
        [self addSubview:self.notiView];
        [self.notiView addSubview:self.label];
        [self.notiView addSubview:self.detailBtn];
    }
    return self;
}
- (UIView *)notiView{
    if (!_notiView) {
        _notiView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenW, 64)];
        _notiView.backgroundColor = Main_Color;
    }
    return _notiView;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], 20, [Unity countcoordinatesW:200], 34)];
        _label.text = NSLocalizedString(@"GlobalBuyer_shopNotiView_msg", nil);
        _label.textAlignment=NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
        
    }
    return _label;
}
- (UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:100], 20, [Unity countcoordinatesW:80], 44)];
        [_detailBtn setTitle:NSLocalizedString(@"GlobalBuyer_shopNotiView_btn", nil) forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_detailBtn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
}
- (void)showNoti{
    self.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        self.notiView.frame = CGRectMake(0, 0, kScreenW, 64);
    }];
    [self performSelector:@selector(dimissAlert:) withObject:self afterDelay:3];
}
-(void) dimissAlert:(UIAlertView *)alert{
    [UIView animateWithDuration:1 animations:^{
        self.notiView.frame = CGRectMake(0, -64, kScreenW, 64);
    }];
    [self performSelector:@selector(dimiss:) withObject:self afterDelay:1];
}
-(void) dimiss:(UIAlertView *)alert{
    self.hidden=YES;
}
- (void)detail{
    [self.delegate detailClick];
}
@end
