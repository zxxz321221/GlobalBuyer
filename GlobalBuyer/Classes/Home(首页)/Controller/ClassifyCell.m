//
//  ClassifyCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ClassifyCell.h"

@interface ClassifyCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UILabel *priceLa;
@property (nonatomic, strong) UILabel *opriceLa;
@property (nonatomic, strong) UILabel *discount;
@property (nonatomic, strong) UILabel *sourceLb;
@property (nonatomic, strong) UIImageView *disIv;

@property (nonatomic, strong)UIView *lightGV;
@property (nonatomic, strong)UIView *wirteV;

@end

@implementation ClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = Cell_BgColor;
    }
    return self;
}

-(void)addSubviews{
    [self.contentView addSubview:self.lightGV];
    [self.contentView addSubview:self.wirteV];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLa];
    [self.contentView addSubview:self.priceLa];
    [self.contentView addSubview:self.opriceLa];
    [self.contentView addSubview:self.sourceLb];
}

- (UIView *)lightGV
{
    if (_lightGV == nil) {
        _lightGV = [[UIView alloc]initWithFrame:self.frame];
        _lightGV.backgroundColor = Cell_BgColor;
    }
    return _lightGV;
}

- (UIView *)wirteV
{
    if (_wirteV == nil) {
        _wirteV = [[UIView alloc]initWithFrame:CGRectMake( 5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
        _wirteV.backgroundColor = [UIColor whiteColor];
    }
    return _wirteV;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.frame = CGRectMake(15, 15, 120 ,120);
        _imgView.layer.borderColor = [UIColor grayColor].CGColor;
        _imgView.layer.borderWidth = 0.5;

        [_imgView addSubview:self.disIv];
        [_imgView addSubview:self.discount];
    }
    return _imgView;
}

- (UIImageView *)disIv
{
    if (_disIv == nil) {
        _disIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        _disIv.image = [UIImage imageNamed:@"折扣贴"];
    }
    return _disIv;
}

- (UILabel *)nameLa {
    if (_nameLa == nil) {
        _nameLa = [UILabel new];
        _nameLa.frame = CGRectMake(self.imgView.frame.origin.x + self.imgView.frame.size.width + 10, 15, [[UIScreen mainScreen] bounds].size.width - 160, 60);
        _nameLa.textColor = [UIColor darkTextColor];
        _nameLa.font = [UIFont systemFontOfSize:13];
        _nameLa.numberOfLines = 0;
    }
    return _nameLa;
}

- (void)setModel:(GoodsModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.body.image]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    self.nameLa.text = _model.value.title;
    CGSize strSize = [self.nameLa.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 160, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    CGRect frame = self.nameLa.frame;
    frame.size.height = strSize.height;
    
    self.nameLa.frame = frame;
    
    self.priceLa.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_Nowprice", nil),_model.body.price];
    
    NSLog(@"%@",_model.body.oprice);
    
    self.sourceLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_CollectionViewController_Source", nil),_model.body.source];
    
    if ([self.model.body.discount isEqualToString:@"goodsDisc"] || _model.body.oprice != nil) {
        self.discount.hidden = NO;
        self.opriceLa.hidden = NO;
        self.disIv.hidden = NO;
        self.priceLa.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_Discountprice", nil),_model.body.price];
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        float oprice = [[model.body.oprice stringByTrimmingCharactersInSet:nonDigits] floatValue];
        float price = [[model.body.price stringByTrimmingCharactersInSet:nonDigits] floatValue];
        self.discount.text = [NSString stringWithFormat:@"%.1f%@",(price/oprice)*10,NSLocalizedString(@"GlobalBuyer_Home_Discount", nil)];
        
        NSString *opstr = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_price",nil),_model.body.oprice];
        NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:opstr];
        [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,opstr.length)];
        self.opriceLa.attributedText = attributeMarket;
    }else{
        self.discount.hidden = YES;
        self.opriceLa.hidden = YES;
        self.disIv.hidden = YES;
    }
}

-(UILabel *)priceLa {
    if (_priceLa == nil) {
        _priceLa = [[UILabel alloc]init];
        _priceLa.frame = CGRectMake(self.imgView.frame.origin.x + self.imgView.frame.size.width + 10, 110, [[UIScreen mainScreen] bounds].size.width - 160, 20);
        _priceLa.font = [UIFont systemFontOfSize:15];
        _priceLa.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    }
    return _priceLa;
}

- (UILabel *)opriceLa
{
    if (_opriceLa == nil) {
        _opriceLa = [[UILabel alloc]init];
        _opriceLa.frame = CGRectMake(self.imgView.frame.origin.x + self.imgView.frame.size.width + 10, 90, [[UIScreen mainScreen] bounds].size.width - 160, 20);
        _opriceLa.font = [UIFont systemFontOfSize:13];
        _opriceLa.textColor = [UIColor lightGrayColor];
    }
    return _opriceLa;
}

- (UILabel *)sourceLb
{
    if (_sourceLb == nil) {
        _sourceLb = [[UILabel alloc]initWithFrame:CGRectMake(self.imgView.frame.origin.x + self.imgView.frame.size.width + 10, 45, [[UIScreen mainScreen] bounds].size.width - 160, 20)];
        _sourceLb.font = [UIFont systemFontOfSize:13];
        _sourceLb.textColor = [UIColor grayColor];
    }
    return _sourceLb;
}

- (UILabel *)discount{
    if (_discount == nil) {
        _discount = [[UILabel alloc]init];
        _discount.frame = CGRectMake(1, 1, 33 ,33);
        _discount.textAlignment = NSTextAlignmentCenter;
        _discount.font = [UIFont systemFontOfSize:11];
        _discount.textColor = [UIColor whiteColor];
    }
    return _discount;
}
@end
