//
//  NewSearchCollectionViewCell.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "NewSearchCollectionViewCell.h"

@implementation NewSearchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    _iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, self.contentView.frame.size.width - 16, self.contentView.frame.size.height - 16 - 50)];
    [self.contentView addSubview:_iv];
    
    _nameasd = [[UILabel alloc]initWithFrame:CGRectMake(8, self.contentView.frame.size.height - 50, self.contentView.frame.size.width - 16, 20)];
    _nameasd.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameasd];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake(8, self.contentView.frame.size.height - 30, 100, 20)];
    [self.contentView addSubview:_price];
    
    _source = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 30, self.contentView.frame.size.height - 30, 20, 20)];
    [self.contentView addSubview:_source];
}

@end
