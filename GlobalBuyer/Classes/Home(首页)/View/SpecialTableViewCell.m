//
//  SpecialTableViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/10.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "SpecialTableViewCell.h"

@implementation SpecialTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
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
        _lightGV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        _lightGV.backgroundColor = Cell_BgColor;
    }
    return _lightGV;
}

- (UIView *)wirteV
{
    if (_wirteV == nil) {
        _wirteV = [[UIView alloc]initWithFrame:CGRectMake( 5, 5, kScreenW - 10, 150 - 10)];
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
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,_model.image]]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    self.nameLa.text = _model.title;
    CGSize strSize = [self.nameLa.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 160, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    CGRect frame = self.nameLa.frame;
    frame.size.height = strSize.height;
    
    self.nameLa.frame = frame;
    
    self.priceLa.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_Nowprice", nil),_model.sub_title2];
    
    NSLog(@"%@",_model.body.oprice);
    
    self.sourceLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_CollectionViewController_Source", nil),model.sub_title3];
    
    if ([self.model.discount isEqualToString:@"goodsDisc"] || _model.sub_title1 != nil) {
        self.discount.hidden = NO;
        self.opriceLa.hidden = NO;
        self.disIv.hidden = NO;
        self.priceLa.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_Discountprice", nil),_model.sub_title2];
        self.discount.text = [NSString stringWithFormat:@"%@%@",model.placeholder2,NSLocalizedString(@"GlobalBuyer_Home_Discount", nil)];
        
        NSString *opstr = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Home_price",nil),_model.sub_title1];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
