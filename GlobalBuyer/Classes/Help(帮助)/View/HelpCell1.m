//
//  HelpCell1.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/22.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "HelpCell1.h"

@implementation HelpCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (void)initLayout{
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:20], [Unity countcoordinatesW:3], [Unity countcoordinatesH:10])];
    label.backgroundColor = [Unity getColor:@"#b445c8"];
        [self.contentView addSubview:label];
        UILabel * titleL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right+[Unity countcoordinatesW:5], [Unity countcoordinatesH:15], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"自助服务" _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, titleL.bottom+[Unity countcoordinatesH:15], kScreenW, [Unity countcoordinatesH:1])];
        line.backgroundColor = [Unity getColor:@"#f0f0f0"];
        [self.contentView addSubview:line];
        NSArray * arr = @[@"购物流程",@"代购指南",@"修改订单",@"发票服务",@"小帮手",@"意见反馈"];
        for (int i=0; i<6; i++) {
            UIButton * btn = [Unity buttonAddsuperview_superView:self.contentView _subViewFrame:CGRectMake((i%4)*(kScreenW/4), line.bottom+(i/4)*[Unity countcoordinatesH:75], kScreenW/4, [Unity countcoordinatesH:75]) _tag:self _action:@selector(btnClick:) _string:@"" _imageName:@""];
            btn.tag = 1000+i;
            UIImageView * img = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake((btn.width-[Unity countcoordinatesW:30])/2, [Unity countcoordinatesH:10], [Unity countcoordinatesW:30], [Unity countcoordinatesW:30]) _imageName:arr[i] _backgroundColor:nil];
            UILabel * nameL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(0, img.bottom+[Unity countcoordinatesH:5], btn.width, [Unity countcoordinatesH:20]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
            nameL.backgroundColor = [UIColor clearColor];
        }
        UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, line.bottom+[Unity countcoordinatesH:150], kScreenW, [Unity countcoordinatesH:10])];
        line1.backgroundColor = [Unity getColor:@"#f0f0f0"];
        [self.contentView addSubview:line1];
    
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, line1.bottom+[Unity countcoordinatesH:20], [Unity countcoordinatesW:3], [Unity countcoordinatesH:10])];
        label1.backgroundColor = [Unity getColor:@"#b445c8"];
        [self.contentView addSubview:label1];
         UILabel * titleL1 = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right+[Unity countcoordinatesW:5], line1.bottom+[Unity countcoordinatesH:15], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:@"帮助中心" _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, titleL1.bottom+[Unity countcoordinatesH:15], kScreenW, [Unity countcoordinatesH:1])];
        line2.backgroundColor = [Unity getColor:@"#f0f0f0"];
        [self.contentView addSubview:line2];
}
- (void)btnClick:(UIButton *)btn{
    [self.delegate headerButtonClick:btn.tag-1000];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
