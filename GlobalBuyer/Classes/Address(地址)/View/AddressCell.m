//
//  AddressCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *phoneLa;
@property (weak, nonatomic) IBOutlet UILabel *addressLa;
@property (weak, nonatomic) IBOutlet UILabel *defultBtn;

@end

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)editClick:(id)sender {
    [self.delegate editAddress:self.model];
}

- (IBAction)delectClick:(id)sender {
    [self.delegate delectAddress:self.model];
}

- (IBAction)changeClick:(id)sender {
    [self.delegate changeAddress];
}

-(void)setModel:(AddressModel *)model{
    _model = model;
    
    self.nameLa.text = _model.fullname;
    self.phoneLa.text = _model.mobile_phone;
    self.addressLa.text = _model.address;
    if ([_model.Default isEqual:@0]) {
        self.defultBtn.hidden = YES;
    }else{
        self.defultBtn.hidden = NO;
    }
    
    CGRect frame = self.addressLa.frame;
    CGSize strSize = [self.addressLa.text boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width - 16, 100) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    frame.size.height = strSize.height;
    
    self.addressLa.frame = frame;
    
}

-(void)setHideBtn:(BOOL)hideBtn{
         _hideBtn = hideBtn;
        self.editBtn.hidden = _hideBtn;
        self.delectBtn.hidden = _hideBtn;
        self.changeBtn.hidden = !_hideBtn;
}
@end
