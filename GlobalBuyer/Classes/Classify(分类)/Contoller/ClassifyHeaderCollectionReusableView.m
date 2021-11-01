//
//  ClassifyHeaderCollectionReusableView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/19.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "ClassifyHeaderCollectionReusableView.h"

@implementation ClassifyHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    imageView.image = [UIImage imageNamed:@"首页全球好站"];
    [self addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, kScreenW-10-50-5-10, 30)];
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_Home_GlobalClassification", nil);
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = Main_Color;
    [self addSubview:titleLabel];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, kScreenW-10-50-5-10, 20)];
    contentLabel.text = NSLocalizedString(@"GlobalBuyer_home_Preferential_2330", nil);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = Main_Color;
    [self addSubview:contentLabel];
}
@end
