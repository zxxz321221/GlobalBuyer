//
//  AllOrderCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AllOrderCell.h"

@interface AllOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *detailLa;
@property (weak, nonatomic) IBOutlet UILabel *countLa;
@property (weak, nonatomic) IBOutlet UILabel *priceLa;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLa;
@property (nonatomic, assign)NSInteger state;
@end

@implementation AllOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)stateBtnCilck:(id)sender {
    
    if (self.state == 0) {
        [self.delegate payGoods:self.model];
    }
    if (self.state == 1) {
        [self.delegate addAddress:self.model];
    }
    if (self.state == 4) {
        [self.delegate showSendGoodsInfo:self.model];
    }
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    self.nameLa.text = model.body.name;
    if ([model.body.picture hasPrefix:@"https:"] || [model.body.picture hasPrefix:@"http:"]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.body.picture ] ]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    }else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@",model.body.picture ] ]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    }
    self.countLa.text = [NSString stringWithFormat:@"x%@",model.quantity];
     NSString *moneyTypeName;
    if ([_model.body.moneyType isEqualToString:@"rmb_rate_rmb"]) {
        moneyTypeName = @"￥";
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",moneyTypeName,model.body.price ];
    }
    if ([_model.body.moneyType isEqualToString:@"rate_rmb"]) {
        moneyTypeName = NSLocalizedString(@"GlobalBuyer_Currency_NT", nil);
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",model.body.price,moneyTypeName ];
    }
    if ([_model.body.moneyType isEqualToString:@"usd_rate_rmb"]) {
        moneyTypeName = @" $";
        
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",moneyTypeName,model.body.price ];
        
    }
    if ([_model.body.moneyType isEqualToString:@"jpy_rate_rmb"]) {
        moneyTypeName = @"日元";
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",model.body.price,moneyTypeName ];
    }
    if ([_model.body.moneyType isEqualToString:@"euro_rate_rmb"]) {
        moneyTypeName = @"€";
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",moneyTypeName,model.body.price ];
    }
    if ([_model.body.moneyType isEqualToString:@"gbp_rate_rmb"]) {
        moneyTypeName = @"£";
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",moneyTypeName,model.body.price ];
    }
    
    if ([_model.body.moneyType isEqualToString:@"aud_rate_rmb"]) {
        moneyTypeName = @"澳元";
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",model.body.price,moneyTypeName ];
    }
    if ([_model.body.moneyType isEqualToString:@"krw_rate_rmb"]) {
        moneyTypeName = @"韩币";
        self.priceLa.text = [NSString stringWithFormat:@"%@%@",model.body.price,moneyTypeName ];
    }
    
    self.detailLa.text = model.body.attributes;
    if ([model.shop_source isEqualToString:@"PAY_STATUS_WAIT"]) {
        self.stateLa.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_status_nopay", nil);
        [self.stateBtn setTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_status_nopay_btn", nil) forState:UIControlStateNormal];
        self.state = 0;
    }
    
    if ([model.shop_source isEqualToString:@"PAY_STATUS_COMPLETE"]) {
        self.stateLa.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_status_Add", nil);
         [self.stateBtn setTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_status_Add_btn", nil) forState:UIControlStateNormal];
        self.state = 1;
    }
    
    if ([model.shop_source isEqualToString:@"PAY_PLAG_WAIT"]) {
        self.stateLa.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_status_freighting", nil);
        [self.stateBtn setTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_status_freight_btn", nil) forState:UIControlStateNormal];
        self.state = 2;
        if ([model.interfreight_finish isEqual:@1])
         {
             self.stateLa.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_status_freight", nil);
             self.state = 3;
         }
    }
    if ([model.shop_source isEqualToString:@"PAY_PLAG_WAIT"] && [model.interfreight_finish isEqual:@0]) {
        
        self.stateLa.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_status_Inpurchasing", nil);
        
    }
    if ([model.shop_source isEqualToString:@"PAY_PLAG_COMPLETE"]&& model.express_no) {
        self.state = 4;
         self.stateLa.text = NSLocalizedString(@"GlobalBuyer_Order_Pay_status_done", nil);
        [self.stateBtn setTitle:NSLocalizedString(@"GlobalBuyer_Order_Pay_status_done_btn", nil) forState:UIControlStateNormal];
    }
}

-(void)hideBtn:(BOOL)hidden {
    self.stateBtn.hidden = hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
