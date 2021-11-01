//
//  HomeDiscountCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "HomeDiscountCell.h"

@implementation HomeDiscountCell

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

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = Cell_BgColor;
    }
    return self;
}

-(void)addSubviews{
    [self.contentView addSubview:self.backV];
}

- (UIView *)backV{
    if (_backV == nil) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenW - 20, 0)];
        _backV.backgroundColor = [UIColor whiteColor];
        _backV.layer.cornerRadius = 10;
    }
    return _backV;
}

- (void)setDiscountDataSource:(NSMutableArray *)discountDataSource{
    _discountDataSource = discountDataSource;
    if (_discountDataSource == nil) {
        return;
    }
//    if (self.discountDataSource.count > 6) {
//        self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, 8*50);
//
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 350, kScreenW - 20, 50)];
//        [btn setTitle:@"查看更多" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.backV addSubview:btn];
//        [btn addTarget:self action:@selector(clickDiscountMore) forControlEvents:UIControlEventTouchUpInside];
//
//        for (int i = 0; i < 6; i++) {
//            UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 50+50*i, kScreenW - 20, 50)];
//            back.tag = i;
//            back.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDiscuntView:)];
//            tap.numberOfTapsRequired = 1;
//            tap.numberOfTouchesRequired = 1;
//            [back addGestureRecognizer:tap];
//            [self.backV addSubview:back];
//            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 100, 40)];
//            [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebPictureApi,discountDataSource[i][@"pic"]]]];
//            [back addSubview:iv];
//            UILabel *tLb= [[UILabel alloc]initWithFrame:CGRectMake(130, 5, kScreenW - 170, 40)];
//            tLb.numberOfLines = 0;
//            tLb.text = [NSString stringWithFormat:@"%@",self.discountDataSource[i][@"title"]];
//            tLb.font = [UIFont systemFontOfSize:15];
//            [back addSubview:tLb];
//            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(20, 49, kScreenW - 40, 1)];
//            lineV.backgroundColor = Cell_BgColor;
//            [back addSubview:lineV];
//        }
//    }else{
        self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, (self.discountDataSource.count+2)*50);
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50+discountDataSource.count*50, kScreenW - 20, 50)];
        [btn setTitle:NSLocalizedString(@"GlobalBuyer_home_more", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.backV addSubview:btn];
        [btn addTarget:self action:@selector(clickDiscountMore) forControlEvents:UIControlEventTouchUpInside];
        
        for (int i = 0; i < discountDataSource.count; i++) {
            UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 50+50*i, kScreenW - 20, 50)];
            back.tag = i;
            back.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDiscuntView:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [back addGestureRecognizer:tap];
            [self.backV addSubview:back];
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 100, 40)];
            [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebPictureApi,discountDataSource[i][@"pic"]]]];
            [back addSubview:iv];
            UILabel *tLb= [[UILabel alloc]initWithFrame:CGRectMake(130, 5, kScreenW - 170, 40)];
            tLb.numberOfLines = 0;
            tLb.text = [NSString stringWithFormat:@"%@",self.discountDataSource[i][@"title"]];
            tLb.font = [UIFont systemFontOfSize:15];
            [back addSubview:tLb];
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(20, 49, kScreenW - 40, 1)];
            lineV.backgroundColor = Cell_BgColor;
            [back addSubview:lineV];
        }
//    }
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
    title.text = NSLocalizedString(@"GlobalBuyer_home_Preferential_activities", nil);
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = [UIColor colorWithRed:113.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1];
    [self.backV addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(105, 12, kScreenW - 120, 30)];
    subTitle.text = NSLocalizedString(@"GlobalBuyer_home_bargainGoods_content", nil);
    subTitle.font = [UIFont systemFontOfSize:12];
    subTitle.textColor = [UIColor colorWithRed:113.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1];
    [self.backV addSubview:subTitle];
}

- (void)clickDiscuntView:(UITapGestureRecognizer *)tap{
    
    [self.delegate clickDiscountWithLink:[NSString stringWithFormat:@"%@",self.discountDataSource[[tap view].tag][@"url"]] type:[NSString stringWithFormat:@"%@",self.discountDataSource[[tap view].tag][@"if_develop"]]];
}

- (void)clickDiscountMore{
    [self.delegate clickDiscountWithMore];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
