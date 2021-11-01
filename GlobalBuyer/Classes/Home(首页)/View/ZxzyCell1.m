//
//  ZxzyCell1.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "ZxzyCell1.h"
@interface ZxzyCell1()
{
    NSString * goodsName;
    NSString * goodsLink;
    NSString * goodsParam;
    NSString * goodsPrice;
    NSString * iconUrl;
    NSString * goodsCurrecy;
}
@property (nonatomic , strong) UILabel * block0;//标题前红快
@property (nonatomic , strong) UILabel * goodsInfo;



@property (nonatomic , strong) UIButton * jianBtn;
@property (nonatomic , strong) UIButton * jiaBtn;
@property (nonatomic , strong) UITextField * numText;
@property (nonatomic , strong) UILabel * line0;
@property (nonatomic , strong) UIButton * addBtn;
//@property (nonatomic , strong) UIButton * currencyBtn;
@property (nonatomic , strong) UILabel * currencyBtn;
@end
@implementation ZxzyCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.block0];
        [self.contentView addSubview:self.goodsInfo];
        [self createInfo];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.currencyBtn];
        [self.contentView addSubview:self.jianBtn];
        [self.contentView addSubview:self.numText];
        [self.contentView addSubview:self.jiaBtn];
        [self.contentView addSubview:self.line0];
        [self.contentView addSubview:self.addBtn];
    }
    return self;
}
- (UILabel *)block0{
    if (!_block0) {
        _block0 = [[UILabel alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:15], [Unity countcoordinatesW:3], [Unity countcoordinatesH:10])];
        _block0.backgroundColor = Main_Color;
    }
    return _block0;
}
- (UILabel *)goodsInfo{
    if (!_goodsInfo) {
        _goodsInfo = [[UILabel alloc]initWithFrame:CGRectMake(_block0.right+[Unity countcoordinatesW:10], [Unity countcoordinatesH:10], 200, [Unity countcoordinatesH:20])];
        _goodsInfo.text = NSLocalizedString(@"GlobalBuyer_goodsInfo", nil);
        _goodsInfo.font = [UIFont systemFontOfSize:17];
        _goodsInfo.textColor = [Unity getColor:@"333333"];
    }
    return _goodsInfo;
}
- (void)createInfo{
    NSArray * arr = @[NSLocalizedString(@"GlobalBuyer_zdy_goodsImg", nil),NSLocalizedString(@"GlobalBuyer_zdy_goodsName", nil),NSLocalizedString(@"GlobalBuyer_zdy_goodsLink", nil),NSLocalizedString(@"GlobalBuyer_zdy_goodsParam", nil),NSLocalizedString(@"GlobalBuyer_zdy_goodsPrice", nil),NSLocalizedString(@"GlobalBuyer_zdy_goodsCurrecy", nil),NSLocalizedString(@"GlobalBuyer_zdy_goodsNum", nil)];
    for (int i=0; i<arr.count; i++) {
        UILabel * label = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake([Unity countcoordinatesW:20], _goodsInfo.bottom+i*[Unity countcoordinatesH:25], [Unity countcoordinatesW:80], [Unity countcoordinatesH:25]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"333333"] _textAlignment:NSTextAlignmentLeft];
        label.backgroundColor = [UIColor clearColor];
    }
    NSArray * arr1 = @[NSLocalizedString(@"GlobalBuyer_zdy_inputName", nil),NSLocalizedString(@"GlobalBuyer_zdy_inputLink", nil),NSLocalizedString(@"GlobalBuyer_zdy_inputParam", nil),NSLocalizedString(@"GlobalBuyer_zdy_inputPrice", nil)];
    for (int i=0; i<arr1.count; i++) {
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:110], _goodsInfo.bottom+(i+1)*[Unity countcoordinatesH:25], [Unity countcoordinatesW:200], [Unity countcoordinatesH:25])];
        textField.placeholder = arr1[i];
        textField.textAlignment = NSTextAlignmentRight;
        textField.tag = i+1000;
        textField.font = [UIFont systemFontOfSize:14];
        if (i==3) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [textField addTarget:self action:@selector(textInput:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:textField];
    }
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:95], _goodsInfo.bottom, [Unity countcoordinatesW:25], [Unity countcoordinatesH:25])];
    }
    return _icon;
}
- (UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:110], _goodsInfo.bottom, [Unity countcoordinatesW:195], [Unity countcoordinatesH:25])];
        [_iconBtn setTitle:NSLocalizedString(@"GlobalBuyer_zdy_inputImg", nil) forState:UIControlStateNormal];
        [_iconBtn setTitleColor:[Unity getColor:@"999999"] forState:UIControlStateNormal];
        _iconBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _iconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_iconBtn addTarget:self action:@selector(iconBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconBtn;
}
- (UILabel *)currencyBtn{
    if (!_currencyBtn) {
        _currencyBtn = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:110], _goodsInfo.bottom+[Unity countcoordinatesH:125], [Unity countcoordinatesW:200], [Unity countcoordinatesH:25])];
        _currencyBtn.text = NSLocalizedString(@"GlobalBuyer_zdy_seleteCurrecy", nil);
        _currencyBtn.textColor = [Unity getColor:@"999999"];
        _currencyBtn.font = [UIFont systemFontOfSize:14];
        _currencyBtn.textAlignment = NSTextAlignmentRight;
        _currencyBtn.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        
        [_currencyBtn addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _currencyBtn;
}
- (UIButton *)jianBtn{
    if (!_jianBtn) {
        _jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:90], _goodsInfo.bottom+[Unity countcoordinatesH:150], [Unity countcoordinatesW:25], [Unity countcoordinatesH:25])];
        [_jianBtn setBackgroundImage:[UIImage imageNamed:@"newjian"] forState:UIControlStateNormal];
        [_jianBtn addTarget:self action:@selector(jianClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jianBtn;
}
- (UITextField *)numText{
    if (!_numText) {
        _numText = [[UITextField alloc]initWithFrame:CGRectMake(_jianBtn.right, _jianBtn.top, [Unity countcoordinatesW:30], _jianBtn.height)];
        _numText.text = @"1";
        _numText.textColor = [Unity getColor:@"999999"];
        _numText.font = [UIFont systemFontOfSize:14];
        _numText.textAlignment = NSTextAlignmentCenter;
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        [_numText addTarget:self action:@selector(numText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _numText;
}
- (UIButton *)jiaBtn{
    if (!_jiaBtn) {
        _jiaBtn = [[UIButton alloc]initWithFrame:CGRectMake(_numText.right, _goodsInfo.bottom+[Unity countcoordinatesH:150], [Unity countcoordinatesW:25], [Unity countcoordinatesH:25])];
        [_jiaBtn setBackgroundImage:[UIImage imageNamed:@"newjia"] forState:UIControlStateNormal];
        [_jiaBtn addTarget:self action:@selector(jiaClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiaBtn;
}
- (UILabel *)line0{
    if (!_line0) {
        _line0 = [[UILabel alloc]initWithFrame:CGRectMake(0, _goodsInfo.bottom+[Unity countcoordinatesH:175], SCREEN_WIDTH, 1)];
        _line0.backgroundColor = [Unity getColor:@"f0f0f0"];
    }
    return _line0;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-[Unity countcoordinatesW:140])/2, _line0.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:140], [Unity countcoordinatesH:25])];
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.layer.cornerRadius = _addBtn.height/2;
        _addBtn.layer.borderColor = [Unity getColor:@"aa112d"].CGColor;
        _addBtn.layer.borderWidth = 1;
        [_addBtn setTitle:NSLocalizedString(@"GlobalBuyer_zdy_addGoods", nil) forState:UIControlStateNormal];
        [_addBtn setTitleColor:[Unity getColor:@"aa112d"] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _addBtn;
}
- (void)textInput:(UITextField *)textField{
    if (textField.tag == 1000) {
        goodsName = textField.text;
    }else if (textField.tag == 1001){
        goodsLink = textField.text;
    }else if (textField.tag == 1002){
        goodsParam = textField.text;
    }else{
        goodsPrice = textField.text;
    }
}
- (void)iconBtnClick{
    [self.delegate updateIcon];
}
- (void)numText:(UITextField *)textField{
    if (textField.text.length ==0) {
        self.numText.text = @"1";
    }
}
- (void)jianClick{
    NSInteger num = [self.numText.text intValue]-1;
    if (num<1) {
        self.numText.text = @"1";
    }else{
        self.numText.text = [NSString stringWithFormat:@"%ld",(long)num];
    }
}
- (void)jiaClick{
    //    NSLog(@"%@",self.numText.text);
    NSInteger num = [self.numText.text intValue]+1;
    self.numText.text = [NSString stringWithFormat:@"%ld",(long)num];
}
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    //textfield 失去焦点
    for (int i=0; i<4; i++) {
        UITextField * textField = (UITextField *)[self.contentView viewWithTag:i+1000];
        [textField resignFirstResponder];
    }
    [self.delegate seleteCurrecy];
}
- (void)addClick{
    if (goodsLink == nil) {
        [self.delegate showHud1:NSLocalizedString(@"link_null", nil)];
        return;
    }
    if (goodsName.length ==0) {
        [self.delegate showHud1:NSLocalizedString(@"goodsName_null", nil)];
        return;
    }
    if (goodsParam.length == 0){
        [self.delegate showHud1:NSLocalizedString(@"goodsParam_null", nil)];
        return;
    }
    if (goodsPrice.length == 0){
        [self.delegate showHud1:NSLocalizedString(@"goodsPrice_null", nil)];
        
        return;
    }
    if (iconUrl.length == 0) {
        [self.delegate showHud1:NSLocalizedString(@"noupload_img", nil)];
        return;
    }
    if (goodsCurrecy.length == 0) {
        [self.delegate showHud1:NSLocalizedString(@"nocurrecy_img", nil)];
        return;
    }

    [self.delegate addIconUrl:iconUrl GoodsName:goodsName GoodsLink:goodsLink GoodsParam:goodsParam GoodsPrice:goodsPrice GoodsCurrecy:goodsCurrecy GoodsNum:self.numText.text];
}
- (void)configLink:(NSString *)link WithDic:(NSDictionary *)dic{
    iconUrl = link;
    goodsCurrecy = dic[@"bz"];
    if (dic.count != 0) {
        self.currencyBtn.text = dic[@"title"];
    }
    if (iconUrl.length != 0) {
        [_iconBtn setTitle:NSLocalizedString(@"uploaded_yy", nil) forState:UIControlStateNormal];
        [_iconBtn setTitleColor:[Unity getColor:@"333333"] forState:UIControlStateNormal];
    }
}
@end
