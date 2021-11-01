//
//  ShoppingCartCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "GoodsBodyModel.h"
@interface ShoppingCartCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *detailLa;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLa;

@property (nonatomic,assign)NSInteger currentMinTime;
@property (nonatomic,assign)NSInteger currentSecTime;

@property (nonatomic,assign)BOOL isCountDown;

@end


@implementation ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectClick:(id)sender {
    if (self.forthcomingCollectionLb.hidden == NO) {
        return;
    }
    self.selectBtn.selected = !self.selectBtn.selected;
    _model.body.iSelect = @(self.selectBtn.selected);
    [self.delegate isSelectGoods:self.model];
}

- (void)setModel:(OrderModel *)model {
    
    self.forthcomingCollectionLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Notice", nil);
    
    _model = model;
    self.nameLa.text = model.body.name;
    if ([model.body.picture hasPrefix:@"https:"] || [model.body.picture hasPrefix:@"http:"]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.body.picture ] ]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    }else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@",model.body.picture ] ]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    }
    self.countLa.text = [NSString stringWithFormat:@"x%@",model.quantity];
    
    if (self.isCountDown == NO) {
        [self computingTime];
    }
    
    
    NSString *moneyTypeName;
    if ([_model.body.currency isEqualToString:@"CNY"]) {
        moneyTypeName = @"CNY";
        self.price.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
    }
    if ([_model.body.currency isEqualToString:@"TWD"]) {
        moneyTypeName = NSLocalizedString(@"TWD", nil);
        self.price.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
    }
    if ([_model.body.currency isEqualToString:@"USD"]) {
        moneyTypeName = @"USD";
        self.price.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
    }
    if ([_model.body.currency isEqualToString:@"JPY"]) {
        moneyTypeName = @"JPY";
        self.price.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
    }
    if ([_model.body.currency isEqualToString:@"EUR"]) {
        moneyTypeName = @"EUR";
        self.price.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
    }
    if ([_model.body.currency isEqualToString:@"GBP"]) {
        moneyTypeName = @"GBP";
        self.price.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
    }
    if ([_model.body.currency isEqualToString:@"AUD"]) {
        moneyTypeName = @"AUD";
        self.price.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
    }
    if ([_model.body.currency isEqualToString:@"KRW"]) {
        moneyTypeName = @"KRW";
        self.price.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
    }

    self.detailLa.text = model.body.attributes;
    BOOL select =[model.body.iSelect boolValue];
    if (select) {
        self.selectBtn.selected = YES;
    }else {
        self.selectBtn.selected = NO;
    }
}

//计算购物物品过期时间
- (void)computingTime
{
    
    self.isCountDown = YES;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString * dateString2 = self.model.created_at;
    
    NSDate *date1 = [NSDate date];
    NSDate *date2 = [df dateFromString:dateString2];
    
    
    NSTimeInterval time = [date1 timeIntervalSinceDate:date2];
    NSInteger timeInteger = time;
    
    
    if (time < 86400) {
        self.forthcomingCollectionLb.hidden = YES;
        
        
        NSInteger surplusTime = 86400 - timeInteger;
        __block NSInteger minTime = surplusTime/60;
        __block NSInteger secTime = surplusTime%60;
        if (minTime < 10) {
            if (minTime > 0) {
                if (secTime < 10) {
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:0%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                    }
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                    }
                }
            }else{
                if (secTime < 10) {

                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:0%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                    }
                }else{
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                    if (secTime == 0) {
                        self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                    }
                }
            }
        }else{
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"%@：%.ld:0%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%@：%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"%@：%.ld:%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
            }
        }
        
        
        self.currentMinTime = minTime;
        self.currentSecTime = secTime;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCountDown) userInfo:nil repeats:YES];
        
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//
//        }];
    }else{

        [self.timeLb removeFromSuperview];
        self.userInteractionEnabled = YES;
        
        
        self.forthcomingCollectionLb.hidden = NO;
//        UIView *overdueBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
//        overdueBackV.userInteractionEnabled = YES;
//        UILabel *overdueLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
//        overdueLb.alpha = 0.7;
//        overdueLb.backgroundColor = [UIColor grayColor];
//        overdueLb.textColor = [UIColor whiteColor];
//        overdueLb.font = [UIFont systemFontOfSize:16];
//        overdueLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Notice", nil);
//        overdueLb.textAlignment = NSTextAlignmentCenter;
//        [overdueBackV addSubview:overdueLb];
//        [self addSubview:overdueBackV];
    }
}


- (void)TimerCountDown
{
    
    NSInteger minTime = self.currentMinTime;
    NSInteger secTime = self.currentSecTime;
    
    secTime--;
    if (secTime < 0) {
        secTime = 59;
        minTime--;
    }
    if (minTime < 10) {
        if (minTime > 0) {
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:0%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                }
            }
        }else{
            if (secTime < 10) {
                self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:0%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                }
            }else{
                self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
                if (secTime == 0) {
                    self.timeLb.text = [NSString stringWithFormat:@"%@：0%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
                }
            }
        }
    }else{
        if (secTime < 10) {
            self.timeLb.text = [NSString stringWithFormat:@"%@：%.ld:0%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
            if (secTime == 0) {
                self.timeLb.text = [NSString stringWithFormat:@"%@：%.ld:00",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime];
            }
        }else{
            self.timeLb.text = [NSString stringWithFormat:@"%@：%.ld:%.ld",NSLocalizedString(@"GlobalBuyer_Shopcart_Remainingtime", nil),(long)minTime,(long)secTime];
        }
    }
    if (minTime == 0 && secTime == 0) {
        [self.timeLb removeFromSuperview];
        self.userInteractionEnabled = NO;
        
        
        self.forthcomingCollectionLb.hidden = NO;
        //                UIView *overdueBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
        //                overdueBackV.userInteractionEnabled = YES;
        //                UILabel *overdueLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
        //                overdueLb.alpha = 0.7;
        //                overdueLb.backgroundColor = [UIColor grayColor];
        //                overdueLb.textColor = [UIColor whiteColor];
        //                overdueLb.font = [UIFont systemFontOfSize:16];
        //                overdueLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Notice", nil);
        //                overdueLb.textAlignment = NSTextAlignmentCenter;
        //                [overdueBackV addSubview:overdueLb];
        //                [self addSubview:overdueBackV];
        //                [timer invalidate];
    }
    
    self.currentMinTime = minTime;
    self.currentSecTime = secTime;
}


- (void)releaseTimer
{
    [self.timer invalidate];
    self.timeLb = nil;
}

-(void)setHideBtn:(BOOL)hideBtn{
    _hideBtn = hideBtn;
    self.selectBtn.hidden = _hideBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
