//
//  HomeTopTenCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/22.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "HomeTopTenCell.h"

@implementation HomeTopTenCell

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

- (void)setTopTenDataSource:(NSMutableArray *)topTenDataSource{
    _topTenDataSource = topTenDataSource;
    if (_topTenDataSource == nil) {
        return;
    }
    if (self.topTenDataSource.count > 10) {
        self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, 11*60 - 10);
        
        for (int i = 0; i < 10; i++) {
            UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 50+60*i, kScreenW - 20, 50)];
            back.tag = i;
            back.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTopTenView:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [back addGestureRecognizer:tap];
            [self.backV addSubview:back];
            
            UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, back.frame.size.width - 40, 20)];
            titleLb.textColor = [UIColor lightGrayColor];
            titleLb.font = [UIFont systemFontOfSize:16];
            titleLb.text = [NSString stringWithFormat:@"%@",self.topTenDataSource[i][@"brand"]];
            [back addSubview:titleLb];
            
            UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, back.frame.size.width - 40, 30)];
            subTitle.font = [UIFont systemFontOfSize:12];
            subTitle.numberOfLines = 0;
            subTitle.text = [NSString stringWithFormat:@"%@",self.topTenDataSource[i][@"description"]];
            [back addSubview:subTitle];
        }
    }else{
        self.backV.frame = CGRectMake(self.backV.frame.origin.x, self.backV.frame.origin.y, self.backV.frame.size.width, (self.topTenDataSource.count+1)*60 - 10);
        
        for (int i = 0; i < self.topTenDataSource.count; i++) {
            UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 50+60*i, kScreenW - 20, 50)];
            back.tag = i;
            back.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTopTenView:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [back addGestureRecognizer:tap];
            [self.backV addSubview:back];
            
            UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, back.frame.size.width - 40, 20)];
            titleLb.textColor = [UIColor lightGrayColor];
            titleLb.font = [UIFont systemFontOfSize:16];
            titleLb.text = [NSString stringWithFormat:@"%@",self.topTenDataSource[i][@"brand"]];
            [back addSubview:titleLb];
            
            UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, back.frame.size.width - 40, 30)];
            subTitle.font = [UIFont systemFontOfSize:12];
            subTitle.numberOfLines = 0;
            subTitle.text = [NSString stringWithFormat:@"%@",self.topTenDataSource[i][@"description"]];
            [back addSubview:subTitle];
        }
    }
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 110, 30)];
    title.text = [NSString stringWithFormat:@"TOP%lu热卖品牌",(unsigned long)self.topTenDataSource.count];
    if (self.topTenDataSource.count > 10) {
        title.text = [NSString stringWithFormat:@"TOP10热卖品牌"];
    }
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
    [self.backV addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 12, kScreenW - 140, 30)];
    subTitle.text = @"全球知名官网促销回馈！买的越多赚的越多！";
    subTitle.font = [UIFont systemFontOfSize:12];
    subTitle.textColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1];
    [self.backV addSubview:subTitle];
}

- (void)clickTopTenView:(UITapGestureRecognizer *)tap{
    
    [self.delegate clickTopTenWithLink:[NSString stringWithFormat:@"%@",self.topTenDataSource[[tap view].tag][@"url"]] type:[NSString stringWithFormat:@"%@",self.topTenDataSource[[tap view].tag][@"if_develop"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
