//
//  HomeSpecialOfferCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/23.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "HomeSpecialOfferCell.h"

@implementation HomeSpecialOfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return self;
}

- (void)addSubviews{
    [self.contentView addSubview:self.backV];
}

- (UIView *)backV{
    if (_backV == nil) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20, 0)];
        _backV.backgroundColor = [UIColor whiteColor];
        _backV.layer.cornerRadius = 10;
    }
    return _backV;
}

-(void)setSpecialOfferDataSource:(NSMutableArray *)specialOfferDataSource{
    _specialOfferDataSource = specialOfferDataSource;
    if (_specialOfferDataSource == nil) {
        return;
    }
    if (self.specialOfferDataSource.count > 6) {
//        self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, 360*3 + 50 + 50);
        self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, 360*3 + 50);
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 1130, kScreenW - 20, 50)];
//        [btn setTitle:@"查看更多" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.backV addSubview:btn];
//        [btn addTarget:self action:@selector(clickSpecialOfferMore) forControlEvents:UIControlEventTouchUpInside];

        for (int i = 0; i < 6 ; i++) {
            UIView *goodsV = [[UIView alloc]initWithFrame:CGRectMake(self.backV.frame.size.width/2 * (i%2), 50 + i/2 * 260, self.backV.frame.size.width/2 - 1, 260)];
            goodsV.tag = i;
            goodsV.userInteractionEnabled = YES;
            [self.backV addSubview:goodsV];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSpecialOfferGoods:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [goodsV addGestureRecognizer:tap];
            
            UIView *layerV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, goodsV.frame.size.width - 20, goodsV.frame.size.height - 20)];
            layerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
            layerV.layer.cornerRadius = 10;
            layerV.layer.borderWidth = 0.7;
            [goodsV addSubview:layerV];
            
            UIImageView *goodsIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, goodsV.frame.size.width - 40, goodsV.frame.size.width - 40 + 10)];
            [goodsIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",specialOfferDataSource[i][@"pic"]]]];
            [goodsV addSubview:goodsIv];
            
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
            lb.layer.cornerRadius = 10;
            lb.textColor = [UIColor whiteColor];
            lb.backgroundColor = [UIColor redColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.layer.masksToBounds = YES;
            NSString *bfh = @"%";
            lb.text = [NSString stringWithFormat:@"%@%@OFF",specialOfferDataSource[i][@"off"],bfh];
            [goodsIv addSubview:lb];
            
            UILabel *subPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 30, 120, 20)];
            subPrice.textColor = [UIColor lightGrayColor];
            subPrice.font = [UIFont systemFontOfSize:12];
            NSString *opstr = [NSString stringWithFormat:@"%@%@",specialOfferDataSource[i][@"currency_sign"],specialOfferDataSource[i][@"cost"]];
            NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:opstr];
            [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,opstr.length)];
            subPrice.attributedText = attributeMarket;
            [goodsV addSubview:subPrice];
            
            UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(goodsV.frame.size.width - 140, goodsV.frame.size.height - 32, 120, 20)];
            price.textAlignment = NSTextAlignmentRight;
            price.textColor = [UIColor redColor];
            price.font = [UIFont systemFontOfSize:12];
            price.text = [NSString stringWithFormat:@"%@%@",specialOfferDataSource[i][@"currency_sign"],specialOfferDataSource[i][@"pirce"]];
            [goodsV addSubview:price];
            
            UILabel *tilb = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 70, goodsV.frame.size.width - 40, 40)];
            tilb.textColor = [UIColor lightGrayColor];
            tilb.font = [UIFont systemFontOfSize:13];
            tilb.text = [NSString stringWithFormat:@"%@",specialOfferDataSource[i][@"name"]];
            tilb.numberOfLines = 0;
            [goodsV addSubview:tilb];
        }
    }else{
        if (self.specialOfferDataSource.count%2 == 0) {
            self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, (self.specialOfferDataSource.count/2)*260 + 50);
//            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, (self.specialOfferDataSource.count/2)*260 + 50, kScreenW - 20, 50)];
//            [btn setTitle:@"查看更多" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [self.backV addSubview:btn];
//            [btn addTarget:self action:@selector(clickSpecialOfferMore) forControlEvents:UIControlEventTouchUpInside];
            
            for (int i = 0; i < self.specialOfferDataSource.count ; i++) {
                UIView *goodsV = [[UIView alloc]initWithFrame:CGRectMake(self.backV.frame.size.width/2 * (i%2), 50 + i/2 * 260, self.backV.frame.size.width/2 - 1, 260)];
                goodsV.tag = i;
                goodsV.userInteractionEnabled = YES;
                [self.backV addSubview:goodsV];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSpecialOfferGoods:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [goodsV addGestureRecognizer:tap];
                
                UIView *layerV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, goodsV.frame.size.width - 20, goodsV.frame.size.height - 20)];
                layerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
                layerV.layer.cornerRadius = 10;
                layerV.layer.borderWidth = 0.7;
                [goodsV addSubview:layerV];
                
                UIImageView *goodsIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, goodsV.frame.size.width - 40, goodsV.frame.size.width - 40 + 10)];
                [goodsIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",specialOfferDataSource[i][@"pic"]]]];
                [goodsV addSubview:goodsIv];
                
                UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
                lb.layer.cornerRadius = 10;
                lb.textColor = [UIColor whiteColor];
                lb.backgroundColor = [UIColor redColor];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.layer.masksToBounds = YES;
                NSString *bfh = @"%";
                lb.text = [NSString stringWithFormat:@"%@%@OFF",specialOfferDataSource[i][@"off"],bfh];
                [goodsIv addSubview:lb];
                
                UILabel *subPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 30, 120, 20)];
                subPrice.textColor = [UIColor lightGrayColor];
                subPrice.font = [UIFont systemFontOfSize:12];
                NSString *opstr = [NSString stringWithFormat:@"%@%@",specialOfferDataSource[i][@"currency_sign"],specialOfferDataSource[i][@"cost"]];
                NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:opstr];
                [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,opstr.length)];
                subPrice.attributedText = attributeMarket;
                [goodsV addSubview:subPrice];
                
                UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(goodsV.frame.size.width - 140, goodsV.frame.size.height - 32, 120, 20)];
                price.textAlignment = NSTextAlignmentRight;
                price.textColor = [UIColor redColor];
                price.font = [UIFont systemFontOfSize:12];
                price.text = [NSString stringWithFormat:@"%@%@",specialOfferDataSource[i][@"currency_sign"],specialOfferDataSource[i][@"pirce"]];
                [goodsV addSubview:price];
                
                UILabel *tilb = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 70, goodsV.frame.size.width - 40, 40)];
                tilb.textColor = [UIColor lightGrayColor];
                tilb.font = [UIFont systemFontOfSize:13];
                tilb.text = [NSString stringWithFormat:@"%@",specialOfferDataSource[i][@"name"]];
                tilb.numberOfLines = 0;
                [goodsV addSubview:tilb];
                NSLog(@"%f",kScreenW);
                if (kScreenW <= 375) {
                    price.font = [UIFont systemFontOfSize:10];
                    subPrice.font = [UIFont systemFontOfSize:10];
                }
            }
        }else{
            self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, ((self.specialOfferDataSource.count/2)+1)*260 + 50);
//            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, ((self.specialOfferDataSource.count/2)+1)*260 + 50, kScreenW - 20, 50)];
//            [btn setTitle:@"查看更多" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [self.backV addSubview:btn];
//            [btn addTarget:self action:@selector(clickSpecialOfferMore) forControlEvents:UIControlEventTouchUpInside];
            
            for (int i = 0; i < self.specialOfferDataSource.count ; i++) {
                UIView *goodsV = [[UIView alloc]initWithFrame:CGRectMake(self.backV.frame.size.width/2 * (i%2), 50 + i/2 * 260, self.backV.frame.size.width/2 - 1, 260)];
                goodsV.tag = i;
                goodsV.userInteractionEnabled = YES;
                [self.backV addSubview:goodsV];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSpecialOfferGoods:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [goodsV addGestureRecognizer:tap];
                
                UIView *layerV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, goodsV.frame.size.width - 20, goodsV.frame.size.height - 20)];
                layerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
                layerV.layer.cornerRadius = 10;
                layerV.layer.borderWidth = 0.7;
                [goodsV addSubview:layerV];
                
                UIImageView *goodsIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, goodsV.frame.size.width - 40, goodsV.frame.size.width - 40 + 10)];
                [goodsIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",specialOfferDataSource[i][@"pic"]]]];
                [goodsV addSubview:goodsIv];
                
                UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
                lb.layer.cornerRadius = 10;
                lb.textColor = [UIColor whiteColor];
                lb.backgroundColor = [UIColor redColor];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.layer.masksToBounds = YES;
                NSString *bfh = @"%";
                lb.text = [NSString stringWithFormat:@"%@%@OFF",specialOfferDataSource[i][@"off"],bfh];
                [goodsIv addSubview:lb];
                
                UILabel *subPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 30, 120, 20)];
                subPrice.textColor = [UIColor lightGrayColor];
                subPrice.font = [UIFont systemFontOfSize:12];
                NSString *opstr = [NSString stringWithFormat:@"%@%@",specialOfferDataSource[i][@"currency_sign"],specialOfferDataSource[i][@"cost"]];
                NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:opstr];
                [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,opstr.length)];
                subPrice.attributedText = attributeMarket;
                [goodsV addSubview:subPrice];
                
                UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(goodsV.frame.size.width - 140, goodsV.frame.size.height - 32, 120, 20)];
                price.textAlignment = NSTextAlignmentRight;
                price.textColor = [UIColor redColor];
                price.font = [UIFont systemFontOfSize:12];
                price.text = [NSString stringWithFormat:@"%@%@",specialOfferDataSource[i][@"currency_sign"],specialOfferDataSource[i][@"pirce"]];
                [goodsV addSubview:price];
                
                UILabel *tilb = [[UILabel alloc]initWithFrame:CGRectMake(20, goodsV.frame.size.height - 70, goodsV.frame.size.width - 40, 40)];
                tilb.textColor = [UIColor lightGrayColor];
                tilb.font = [UIFont systemFontOfSize:13];
                tilb.text = [NSString stringWithFormat:@"%@",specialOfferDataSource[i][@"name"]];
                tilb.numberOfLines = 0;
                [goodsV addSubview:tilb];

            }
        }

    }
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
    title.text = NSLocalizedString(@"GlobalBuyer_home_bargainGoods", nil);
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = [UIColor colorWithRed:86.0/255.0 green:29.0/255.0 blue:114.0/255.0 alpha:1];
    [self.backV addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(105, 12, kScreenW - 120, 30)];
    subTitle.text = NSLocalizedString(@"GlobalBuyer_home_bargainGoods_content", nil);
    subTitle.font = [UIFont systemFontOfSize:12];
    subTitle.textColor = [UIColor colorWithRed:86.0/255.0 green:29.0/255.0 blue:114.0/255.0 alpha:0.5];
    [self.backV addSubview:subTitle];
}

- (void)clickSpecialOfferMore{
    [self.delegate clickSpecialOfferWithMore];
}

- (void)clickSpecialOfferGoods:(UITapGestureRecognizer *)tap{
    [self.delegate clickSpecialOfferWithLink:[NSString stringWithFormat:@"%@",self.specialOfferDataSource[[tap view].tag][@"url"]] type:[NSString stringWithFormat:@"%@",self.specialOfferDataSource[[tap view].tag][@"if_develop"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
