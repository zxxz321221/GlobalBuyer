//
//  CollectionViewHeaderView.m
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/4/22.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import "CollectionViewHeaderView.h"
#import "FootHearModel.h"
@implementation CollectionViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [Unity getColor:@"#f0f0f0"];

        self.readBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, [Unity countcoordinatesH:12], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16])];
        [self.readBtn addTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.readBtn setImage:[UIImage imageNamed:@"未选中1"] forState:UIControlStateNormal];
        [self.readBtn setImage:[UIImage imageNamed:@"已选中"] forState:UIControlStateSelected];
        self.readBtn.hidden=YES;
        [self addSubview:self.readBtn];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20])];
        self.label.font = [UIFont systemFontOfSize:15.0];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.textColor = [Unity getColor:@"#666666"];
//        self.label.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [self addSubview:self.label];

    }
    return self;
}
- (void)setModel:(FootHearModel *)model{
    self.readBtn.selected = model.isSelect;
    self.label.text = model.days;
}
- (void)configWithIsEdit:(BOOL)isEdit Section:(NSInteger)section{
    self.readBtn.tag = section+1000;
    if (isEdit) {
        self.readBtn.hidden=NO;
        self.label.frame = CGRectMake(5+[Unity countcoordinatesW:16]+[Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]);
        return;
    }
    self.readBtn.hidden = YES;
    self.label.frame = CGRectMake([Unity countcoordinatesW:5], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:20]);
}
- (void)readClick:(UIButton *)bt
{
    if([self.delegate respondsToSelector:@selector(shoppingCarHeaderViewDelegat:WithHeadView:)])
    {
        [self.delegate shoppingCarHeaderViewDelegat:bt WithHeadView:self];
    }
}
@end
