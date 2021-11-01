//
//  HomeHeaderView.m
//  GlobalBuyer
//
//  Created by 赵阳 on 2017/5/3.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderView ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *imgArr;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
    }
    return self;
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 5, kScreenW, kScreenW/2.5);
        _scrollView.contentSize = CGSizeMake(kScreenW, 0);
        
        for (int i = 0; i < self.imgArr.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(0, i * kScreenW, kScreenW, kScreenW/2.5);
            imgView.image = [UIImage imageNamed:self.imgArr[i]];
            [_scrollView addSubview:imgView];
        }
        
    }
    return _scrollView;
}
- (NSMutableArray *)imgArr {
    if (_imgArr == nil) {
        _imgArr = [[NSMutableArray alloc]init];
        [_imgArr addObject:@"首页banner1.jpg"];
        [_imgArr addObject:@""];
    }
    return _imgArr;
}
@end
