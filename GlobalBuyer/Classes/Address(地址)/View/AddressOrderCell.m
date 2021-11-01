//
//  addressOrderCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AddressOrderCell.h"

@interface AddressOrderCell ()
@property(nonatomic, strong)UILabel *nameLa;
@property(nonatomic, strong)UILabel *addressLa;
@property(nonatomic, strong)UILabel *phoneLa;
@property(nonatomic, strong)UILabel *deAdLa;
@property(nonatomic, strong)UIButton *selectBtn;
@property(nonatomic, strong)UIButton *delectBtn;
@property(nonatomic, strong)UIButton *editBtn;
@end


@implementation AddressOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    [self addSubview:self.nameLa];
    [self addSubview:self.addressLa];
    [self addSubview:self.phoneLa];
    [self addSubview:self.selectBtn];
    [self addSubview:self.deAdLa];
    [self addSubview:self.delectBtn];
    [self addSubview:self.editBtn];
}

-(UIButton *)selectBtn {
    if (_selectBtn == nil) {
        _selectBtn = [[UIButton alloc]init];
        _selectBtn.frame = CGRectMake(8,CGRectGetMaxY(self.addressLa.frame) , 20, 20);
        [_selectBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

-(void)selectClick{
    [self.delegate select:self.model];
}

-(UILabel *)nameLa {
    if (_nameLa == nil) {
        _nameLa = [[UILabel alloc]init];
        _nameLa.frame = CGRectMake( 8, 8, 100, 20);
        _nameLa.font = [UIFont systemFontOfSize:12];
        _nameLa.textColor = [UIColor scrollViewTexturedBackgroundColor];
    }
    return _nameLa;
}

-(UILabel *)phoneLa {
    if (_phoneLa == nil) {
        _phoneLa = [UILabel new];
        _phoneLa.textColor = [UIColor scrollViewTexturedBackgroundColor];
        _phoneLa.font = [UIFont systemFontOfSize:12];
        _phoneLa.frame = CGRectMake(kScreenW - 108, 8, 100, 20);
        _phoneLa.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLa;
}

-(UILabel *)addressLa{
    if (_addressLa == nil) {
        _addressLa = [[UILabel alloc]init];
        _addressLa.frame = CGRectMake( 8, CGRectGetMaxY(self.nameLa.frame) + 15, kScreenW - 16, 1000);
        _addressLa.textColor = [UIColor scrollViewTexturedBackgroundColor];
        _addressLa.font = [UIFont systemFontOfSize:11];
    }
    return _addressLa;
}

-(void)setModel:(AddressModel *)model{
    _model = model;
    self.nameLa.text = _model.fullname;
    self.phoneLa.text = _model.mobile_phone;
    self.addressLa.text = _model.address;
    
    if ([model.Default boolValue]) {
        self.deAdLa.text = NSLocalizedString(@"GlobalBuyer_Address_DefaultAdds", nil);
    }else{
        self.deAdLa.text = @"";
    }
    if ([_model.isSelect boolValue]) {
        self.selectBtn.selected = YES;
        
    }else{
        self.selectBtn.selected = NO;
      
    }
    CGRect frame = self.addressLa.frame;
    CGSize size = [_model.address boundingRectWithSize:CGSizeMake(kScreenW -  16, 1000) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    frame.size.height = size.height;
    self.addressLa.frame = frame;
    
    CGRect selectBtnFrame = self.selectBtn.frame;
    selectBtnFrame.origin.y = CGRectGetMaxY(self.addressLa.frame) + 8;
    self.selectBtn.frame = selectBtnFrame;
    
    CGRect deAdLaFrame = self.deAdLa.frame;
    deAdLaFrame.origin.y = CGRectGetMaxY(self.addressLa.frame) + 8;
    self.deAdLa.frame = deAdLaFrame;
    
    CGRect editBtnFrame = self.editBtn.frame;
    editBtnFrame.origin.y = CGRectGetMaxY(self.addressLa.frame) + 8;
    self.editBtn.frame = editBtnFrame;
    
    CGRect delectBtnFrame = self.delectBtn.frame;
    delectBtnFrame.origin.y = CGRectGetMaxY(self.addressLa.frame) + 8;
    self.delectBtn.frame = delectBtnFrame;
    
}

-(UILabel *)deAdLa{
    if (_deAdLa == nil) {
        _deAdLa = [UILabel new];
        _deAdLa.frame = CGRectMake(36, 0,100, 20);
        _deAdLa.textColor = [UIColor scrollViewTexturedBackgroundColor] ;
        _deAdLa.font = [UIFont systemFontOfSize:11];
    }
    return _deAdLa;
}

-(UIButton *)editBtn{
    if (_editBtn == nil) {
        _editBtn = [[UIButton alloc]init];
        _editBtn.frame = CGRectMake(kScreenW - 38,CGRectGetMaxY(self.addressLa.frame) + 8 , 30, 20);
        [_editBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_Edit", nil) forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editBtn setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
    }
    return _editBtn;
}

-(void)editClick{
    [self.delegate editAddress:self.model];
}

-(UIButton *)delectBtn {
    if (_delectBtn == nil) {
        _delectBtn = [[UIButton alloc]init];
        _delectBtn.frame = CGRectMake(kScreenW - 38 - 38,CGRectGetMaxY(self.addressLa.frame) + 8 , 30, 20);
        [_delectBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_dele", nil) forState:UIControlStateNormal];
        [_delectBtn addTarget:self action:@selector(delectClick) forControlEvents:UIControlEventTouchUpInside];
        [_delectBtn setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateNormal];
        _delectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _delectBtn;
}

-(void)delectClick{
  [self.delegate delectAddress:self.model];
}
@end
