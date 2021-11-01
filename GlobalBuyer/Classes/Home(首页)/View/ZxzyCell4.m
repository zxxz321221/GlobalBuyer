//
//  ZxzyCell4.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "ZxzyCell4.h"
@interface ZxzyCell4()
{
    NSDictionary * dicc;
}
@property (nonatomic , strong) UILabel * numTable;
@property (nonatomic , strong) UILabel * numL;
@property (nonatomic , strong) UIButton * icon;
@property (nonatomic , strong) UITextField * goodsName;
@property (nonatomic , strong) UITextField * goodsPrice;
@property (nonatomic , strong) UIButton * currencyBtn;
@property (nonatomic , strong) UILabel * goodsParam;
@property (nonatomic , strong) UITextField * goodsParamL;
@property (nonatomic , strong) UILabel * goodsNum;
@property (nonatomic , strong) UITextField * goodsNUmL;

@property (nonatomic , strong) UIButton * updateBtn;
@property (nonatomic , strong) UIButton * deleteBtn;
@property (nonatomic , strong) UILabel * line;

@end
@implementation ZxzyCell4

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dicc = [NSDictionary new];
        [self.contentView addSubview:self.numTable];
        [self.contentView addSubview:self.numL];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.goodsName];
        [self.contentView addSubview:self.goodsPrice];
        [self.contentView addSubview:self.currencyBtn];
        [self.contentView addSubview:self.goodsParam];
        [self.contentView addSubview:self.goodsParamL];
        [self.contentView addSubview:self.goodsNum];
        [self.contentView addSubview:self.goodsNUmL];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.updateBtn];
        [self.contentView addSubview:self.line];
    }
    return self;
}
- (UILabel *)numTable{
    if (!_numTable) {
        _numTable = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], [Unity countcoordinatesH:5], 100, [Unity countcoordinatesH:25])];
        _numTable.text = NSLocalizedString(@"listNumber_new", nil);
        _numTable.font = [UIFont systemFontOfSize:14];
    }
    return _numTable;
}
- (UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:60], _numTable.top, [Unity countcoordinatesW:50], _numTable.height)];
        _numL.font = [UIFont systemFontOfSize:14];
        _numL.textAlignment = NSTextAlignmentRight;
    }
    return _numL;
}
- (UIButton *)icon{
    if (!_icon) {
        _icon = [[UIButton alloc]initWithFrame:CGRectMake(_numTable.left, _numTable.bottom, [Unity countcoordinatesW:60], [Unity countcoordinatesH:60])];
        _icon.userInteractionEnabled=NO;
        [_icon addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _icon;
}
- (UITextField *)goodsName{
    if (!_goodsName) {
        _goodsName = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:80], _icon.top, SCREEN_WIDTH-[Unity countcoordinatesW:100], [Unity countcoordinatesH:30])];
        _goodsName.textColor = [Unity getColor:@"666666"];
        _goodsName.font = [UIFont systemFontOfSize:14];
        _goodsName.userInteractionEnabled = NO;
    }
    return _goodsName;
}
- (UITextField *)goodsPrice{
    if (!_goodsPrice) {
        _goodsPrice = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:170], _goodsName.bottom, [Unity countcoordinatesW:110], [Unity countcoordinatesH:30])];
        _goodsPrice.font = [UIFont systemFontOfSize:14];
        _goodsPrice.keyboardType = UIKeyboardTypeNumberPad;
        _goodsPrice.userInteractionEnabled = NO;
        _goodsPrice.textColor = [Unity getColor:@"666666"];
        _goodsPrice.textAlignment = NSTextAlignmentRight;
    }
    return _goodsPrice;
}
- (UIButton *)currencyBtn{
    if (!_currencyBtn) {
        _currencyBtn = [[UIButton alloc]initWithFrame:CGRectMake(_goodsPrice.right, _goodsPrice.top, [Unity countcoordinatesW:40], _goodsPrice.height)];
        _currencyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _currencyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_currencyBtn setTitleColor:[Unity getColor:@"666666"] forState:UIControlStateNormal];
        _currencyBtn.userInteractionEnabled = NO;
        [_currencyBtn addTarget:self action:@selector(seleteCurrecy) forControlEvents:UIControlEventTouchUpInside];

    }
    return _currencyBtn;
}
- (UILabel *)goodsParam{
    if (!_goodsParam) {
        _goodsParam = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], _icon.bottom, 100, [Unity countcoordinatesH:25])];
        _goodsParam.text = NSLocalizedString(@"new_param", nil);
        _goodsParam.font = [UIFont systemFontOfSize:14];
    }
    return _goodsParam;
}
- (UITextField *)goodsParamL{
    if (!_goodsParamL) {
        _goodsParamL = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:240], _goodsParam.top, [Unity countcoordinatesW:220], _goodsParam.height)];
        _goodsParamL.font = [UIFont systemFontOfSize:14];
        _goodsParamL.userInteractionEnabled = NO;
        _goodsParamL.textColor = [Unity getColor:@"666666"];
        _goodsParamL.textAlignment = NSTextAlignmentRight;
    }
    return _goodsParamL;
}
- (UILabel *)goodsNum{
    if (!_goodsNum) {
        _goodsNum = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], _goodsParamL.bottom, 100, [Unity countcoordinatesH:25])];
        _goodsNum.text = NSLocalizedString(@"GlobalBuyer_zdy_goodsNum", nil);
        _goodsNum.font = [UIFont systemFontOfSize:14];
    }
    return _goodsNum;
}
- (UITextField *)goodsNUmL{
    if (!_goodsNUmL) {
        _goodsNUmL = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:70], _goodsNum.top, [Unity countcoordinatesW:50], _goodsNum.height)];
        _goodsNUmL.font = [UIFont systemFontOfSize:14];
        _goodsNUmL.userInteractionEnabled = NO;
        _goodsNUmL.textColor = [Unity getColor:@"666666"];
        _goodsNUmL.textAlignment = NSTextAlignmentRight;
        _goodsNUmL.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _goodsNUmL;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:70], _goodsNUmL.bottom+[Unity countcoordinatesH:5], [Unity countcoordinatesW:60], [Unity countcoordinatesH:25])];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:NSLocalizedString(@"new_delete", nil) forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[Unity getColor:@"333333"] forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = _deleteBtn.height/2;
        _deleteBtn.layer.borderWidth =1;
        _deleteBtn.layer.borderColor = [Unity getColor:@"333333"].CGColor;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _deleteBtn;
}
- (UIButton *)updateBtn{
    if (!_updateBtn) {
        _updateBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:140], _goodsNUmL.bottom+[Unity countcoordinatesH:5], [Unity countcoordinatesW:60], [Unity countcoordinatesH:25])];
        [_updateBtn addTarget:self action:@selector(updateClick:) forControlEvents:UIControlEventTouchUpInside];
        [_updateBtn setTitle:NSLocalizedString(@"new_update", nil) forState:UIControlStateNormal];
        [_updateBtn setTitle:NSLocalizedString(@"new_confirm", nil) forState:UIControlStateSelected];
        [_updateBtn setTitleColor:[Unity getColor:@"333333"] forState:UIControlStateNormal];
        [_updateBtn setTitleColor:Main_Color forState:UIControlStateSelected];
        _updateBtn.layer.cornerRadius = _updateBtn.height/2;
        _updateBtn.layer.borderWidth =1;
        _updateBtn.layer.borderColor = [Unity getColor:@"333333"].CGColor;
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _updateBtn;
}
- (UILabel *)line{
    if (!_line) {
        _line = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:180]-1, SCREEN_WIDTH-[Unity countcoordinatesW:20], 1)];
        _line.backgroundColor = [Unity getColor:@"f0f0f0"];
    }
    return _line;
}
- (void)deleteClick{
    [self.delegate goodsDelete:self];
}
-(void)iconClick{
    [self.delegate updateIcon:self];
}
-(void)seleteCurrecy{
    [self.delegate seleteCurrecy:self];
}
- (void)updateClick:(UIButton *)btn{
    if (btn.selected) {//确认
//        [self.delegate updateWithName:self.goodsName.text WithParam:self.goodsParamL.text WithPrice:self.goodsPrice.text WithNum:self.goodsNUmL.text WithCurrety:self.currety WithCell:self];
        [self.delegate updataIcon:dicc[@"picture"] Name:self.goodsName.text Price:self.goodsPrice.text BZ:dicc[@"currency"] Param:self.goodsParamL.text Num:self.goodsNUmL.text Cell:self];
        self.icon.userInteractionEnabled = NO;
        self.goodsName.userInteractionEnabled = NO;
        self.goodsPrice.userInteractionEnabled = NO;
        self.goodsParamL.userInteractionEnabled = NO;
        self.goodsNUmL.userInteractionEnabled = NO;
        self.currencyBtn.userInteractionEnabled = NO;
        self.updateBtn.selected = NO;
        self.updateBtn.layer.borderColor = [Unity getColor:@"333333"].CGColor;
    }else{//修改
        self.currencyBtn.userInteractionEnabled = YES;
        self.icon.userInteractionEnabled = YES;
        self.goodsName.userInteractionEnabled = YES;
        self.goodsPrice.userInteractionEnabled = YES;
        self.goodsParamL.userInteractionEnabled = YES;
        self.goodsNUmL.userInteractionEnabled = YES;
        self.updateBtn.selected = YES;
        self.updateBtn.layer.borderColor = Main_Color.CGColor;
    }
}
- (void)configWithData:(NSDictionary *)dic xvhao:(NSInteger)hao{
    dicc = dic;
    self.numL.text = [NSString stringWithFormat:@"%ld",(long)hao];
    UIImage * image = [UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:dic[@"picture"]]]];
    [self.icon setBackgroundImage:image forState:UIControlStateNormal];
//    [self.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"picture"]]]];
    self.goodsName.text = dic[@"name"];
    self.goodsPrice.text = dic[@"price"];
    [self.currencyBtn setTitle:[self withCurrecy:dic[@"currency"]] forState:UIControlStateNormal];
    self.goodsParamL.text = dic[@"attributes"];
    self.goodsNUmL.text = dic[@"quantity"];
}
- (NSString *)withCurrecy:(NSString *)str{
    NSArray * arr = @[@{@"title":NSLocalizedString(@"new_CHY", nil),@"bz":@"CNY"},@{@"title":NSLocalizedString(@"new_TWD", nil),@"bz":@"TWD"},@{@"title":NSLocalizedString(@"new_USD", nil),@"bz":@"USD"},@{@"title":NSLocalizedString(@"new_JPY", nil),@"bz":@"JPY"},@{@"title":NSLocalizedString(@"new_EUR", nil),@"bz":@"EUR"},@{@"title":NSLocalizedString(@"new_GBP", nil),@"bz":@"GBP"},@{@"title":NSLocalizedString(@"new_AUD", nil),@"bz":@"AUD"},@{@"title":NSLocalizedString(@"new_KRW", nil),@"bz":@"KRW"},@{@"title":NSLocalizedString(@"new_HKD", nil),@"bz":@"HKD"}];
    for (int i=0; i<arr.count; i++) {
        if ([str isEqualToString:arr[i][@"bz"] ]) {
            return arr[i][@"title"];
        }
    }
    return @"";
}
@end
