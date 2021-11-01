//
//  UserInfoCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell


-(void)layoutSubviews{

    [super layoutSubviews];
   
    [self.titileLa mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(8);
        make.top.mas_equalTo(self.contentView).mas_offset(2);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-2);
        make.width.mas_equalTo(100);
    }];
    
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titileLa);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-1);
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        make.height.mas_equalTo(1);
        
    }];
    
    [self.nextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-8);
        make.top.mas_equalTo(self.contentView).mas_offset(11);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    if (self.nextView.hidden) {
        [self.detailLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.left.mas_equalTo(self.titileLa).mas_offset(8);
            make.top.mas_equalTo(self.nextView);
            make.height.mas_equalTo(self.nextView);
        }];
    }else{
        [self.detailLa mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.nextView.mas_left).mas_offset(-8);
            make.left.mas_equalTo(self.titileLa).mas_offset(8);
            make.top.mas_equalTo(self.nextView);
            make.height.mas_equalTo(self.nextView);
        }];
    }
}

@end
