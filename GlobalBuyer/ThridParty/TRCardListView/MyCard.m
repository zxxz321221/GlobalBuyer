//
//  MyCard.m
//  TRCardListView
//
//  Created by cry on 2017/6/13.
//  Copyright © 2017年 eGova. All rights reserved.
//

#import "MyCard.h"

@implementation MyCard

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        /**************添加子视图到view上****************/
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, 50)];
        //_label.backgroundColor = [UIColor lightGrayColor];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = 1;
        [self addSubview:_label];
        
        _webIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, frame.size.width, 50)];
        [_webIconIV setContentMode:UIViewContentModeScaleAspectFit];
        _webIconIV.clipsToBounds = YES;
        [self addSubview:_webIconIV];
        
    }
    return self;
}

@end
