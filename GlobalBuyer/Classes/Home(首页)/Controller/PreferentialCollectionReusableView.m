//
//  PreferentialCollectionReusableView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/25.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "PreferentialCollectionReusableView.h"

@implementation PreferentialCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenW-20, 1)];
    label.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [self addSubview:label];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-100)/2, 5, 100, 30)];
    title.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor lightGrayColor];
    title.text = NSLocalizedString(@"GlobalBuyer_Home_activity_sectionTitle", nil);
    [self addSubview:title];
}
@end
