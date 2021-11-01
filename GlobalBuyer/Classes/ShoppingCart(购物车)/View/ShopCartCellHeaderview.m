//
//  ShopCartCellHeaderview.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ShopCartCellHeaderview.h"
#import "GoodsBodyModel.h"
@implementation ShopCartCellHeaderview

-(instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews{
    [self addSubview:self.imgView];
    [self addSubview:self.shopNameLa];
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = CGRectMake( 8, 5, 20, 20);
    }
    return _imgView;
}

- (UILabel *)shopNameLa {
    if (_shopNameLa == nil) {
        _shopNameLa = [[UILabel alloc]init];
        _shopNameLa.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + 8, 5, kScreenW -CGRectGetMaxX(self.imgView.frame) - 16 , 20);
        _shopNameLa.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.68 alpha:1];
        _shopNameLa.font = [UIFont systemFontOfSize:12];
    }
    return _shopNameLa;
}

-(void)setModel:(ShopCartModel *)model{
    _model = model;
    self.shopNameLa.text = @"";
    NSData *data =   [model.body dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Get:%@",dict);
    GoodsBodyModel *body = [[GoodsBodyModel alloc]initWithDictionary:dict error:nil];
    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://buy.dayanghang.net/%@",body.sourceImg]]];
}

@end
