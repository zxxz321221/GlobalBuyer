//
//  ShopCartHeaderView.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/3.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ShopCartHeaderView.h"

@interface ShopCartHeaderView ()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *imgView2;
@property (nonatomic, strong)UIView *view;
@property (nonatomic, strong)UILabel *fLa;
@property (nonatomic, strong)UILabel *sLa;
@property (nonatomic, strong)UILabel *tLa;
@property (nonatomic, strong)UILabel *foLa;
@property (nonatomic, strong)UILabel *fiLa;
@end

@implementation ShopCartHeaderView

- (instancetype)init{
    if ([super init]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.bgView];
//    [self.bgView addSubview:self.view];
    [self addSubview:self.imgView2];
    [self.bgView addSubview:self.fLa];
    [self.bgView addSubview:self.sLa];
    [self.bgView addSubview:self.tLa];
    [self addSubview:self.foLa];
    [self addSubview:self.fiLa];
}

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 ,kScreenW  , CGRectGetMaxY(self.bgView.frame))];
        NSString *str1 = NSLocalizedString(@"GlobalBuyer_Shopcart_SubmitPurchasing", nil);
        NSString *str2 = NSLocalizedString(@"GlobalBuyer_Shopcart_Pay", nil);
        NSString *str3 = NSLocalizedString(@"GlobalBuyer_Shopcart_Purchasing", nil);
        NSString *str4 = NSLocalizedString(@"GlobalBuyer_Shopcart_SubmitTransport", nil);
        NSString *str5 = NSLocalizedString(@"GlobalBuyer_Shopcart_ConfirmReceipt", nil);
        NSArray *laTxt = @[str1,str2,str3,str4,str5];
        for (int i = 0; i < 5; i++) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            view.backgroundColor =  Main_Color;
            view.clipsToBounds = YES;
            view.center = CGPointMake(CGRectGetWidth(_view.frame)/6 * (i + 1),CGRectGetHeight(_view.frame)/2);
            view.layer.cornerRadius = 5;
            [_view addSubview:view];
            
            if (i < 4) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(view.frame),CGRectGetHeight(_view.frame)/2 - 1 , kScreenW/6, 2)];
                line.backgroundColor = Main_Color;
                [_view addSubview:line];
            }
            
            UILabel *la = [[UILabel alloc]init];
            la.textAlignment = NSTextAlignmentCenter;
            la.frame = CGRectMake(CGRectGetWidth(_view.frame)/6 * i + CGRectGetWidth(_view.frame)/12, CGRectGetMaxY(view.frame) + 5, CGRectGetWidth(_view.frame)/6, 20);
            la.font = [UIFont systemFontOfSize:8];
            la.text = laTxt[i];
            [_view addSubview:la];
            
        }
    }
    return _view;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
        _bgView.frame = CGRectMake(0, 0, kScreenW , 0);
        _bgView.backgroundColor = Cell_BgColor;
        
    }
    return _bgView;
}

- (UIImageView *)imgView2 {
    if (_imgView2 == nil) {
        _imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bgView.frame) + 10, 30 , 30)];
        _imgView2.image = [UIImage imageNamed:@"ic_medal"];
    }
    return _imgView2;
}

- (UILabel *)fLa {
    if (_fLa == nil) {
        _fLa = [UILabel new];
        _fLa.frame = CGRectMake(30, CGRectGetMaxY(self.bgView.frame) + 10, 2000, 30);
        _fLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Shoppingguide", nil);
        _fLa.textColor = [UIColor orangeColor];
        _fLa.font = [UIFont systemFontOfSize:15];
    }
    return _fLa;
}

-(UILabel *)sLa {
    if (_sLa == nil) {
        _sLa = [[UILabel alloc]init];
        _sLa.font = [UIFont systemFontOfSize:10];
        _sLa.textColor = [UIColor orangeColor];
        _sLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Shoppingguide_1", nil);
        _sLa.numberOfLines = 0;
        _sLa.frame = CGRectMake(10, CGRectGetMaxY(self.fLa.frame) + 5 , kScreenW -20, [self textH:_sLa.text]);
        
    }
    return _sLa;
}

- (UILabel *)tLa {
    if (_tLa == nil) {
        _tLa = [[UILabel alloc]init];
        _tLa.textColor = [UIColor orangeColor];
        _tLa.numberOfLines = 0;
        _tLa.font = [UIFont systemFontOfSize:10];
        _tLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Shoppingguide_2", nil);
        _tLa.frame = CGRectMake(10, CGRectGetMaxY(self.sLa.frame) + 5 , kScreenW -20, [self textH:_tLa.text]);
    }
    return _tLa;
}
    
-(UILabel *)foLa {
    if (_foLa == nil) {
        _foLa = [[UILabel alloc]init];
        _foLa.font = [UIFont systemFontOfSize:10];
        _foLa.textColor = [UIColor orangeColor];
        _foLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Shoppingguide_3", nil);
        _foLa.frame = CGRectMake(10, CGRectGetMaxY(self.tLa.frame)+5 , kScreenW -20, [self textH:_sLa.text]);
        _foLa.numberOfLines = 0;
    }
    return _foLa;
}
    
-(UILabel *)fiLa {
    if (_fiLa == nil) {
        _fiLa= [[UILabel alloc]init];
        _fiLa.font = [UIFont systemFontOfSize:10];
        _fiLa.textColor = [UIColor orangeColor];
        _fiLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Shoppingguide_4", nil);
        _fiLa.frame = CGRectMake(10, CGRectGetMaxY(self.foLa.frame)+5 , kScreenW -20, [self textH:self.fiLa.text]);
        _fiLa.numberOfLines = 0;
    }
    return _fiLa;
}

-(CGFloat )textH:(NSString *)string{
    CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenW - 20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    return size.height;
}

-(CGFloat) getH{

    return CGRectGetMaxY(self.fiLa.frame)+10;

}
@end
