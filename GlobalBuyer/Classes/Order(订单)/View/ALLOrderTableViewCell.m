//
//  ALLOrderTableViewCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/10.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "ALLOrderTableViewCell.h"
@interface ALLOrderTableViewCell()
@property (nonatomic , strong) UIView * backView;
@property (nonatomic , strong) UIImageView * icon;
@property (nonatomic , strong) UILabel * titleL;
@property (nonatomic , strong) UILabel * number;
@end
@implementation ALLOrderTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [self CellView];
    }
    return self;
}
- (void)CellView{
    [self.contentView addSubview:self.backView];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], 0, kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:90])];
        _backView.backgroundColor = [UIColor whiteColor];
        
        [_backView addSubview:self.icon];
        [_backView addSubview:self.titleL];
        [_backView addSubview:self.number];
    }
    return _backView;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:70], [Unity countcoordinatesH:70])];
        _icon.backgroundColor = [UIColor redColor];
    }
    return _icon;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(_icon.right+[Unity countcoordinatesW:5], _icon.top, _backView.width-[Unity countcoordinatesW:125], [Unity countcoordinatesH:40])];
        _titleL.text = @"【03SDW1924】中国古董品明时代古铜制镀金欧美小人精致美彫...";
        _titleL.numberOfLines = 0;
        _titleL.textColor = [Unity getColor:@"#333333"];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UILabel *)number{
    if (!_number) {
        _number = [[UILabel alloc]initWithFrame:CGRectMake(_titleL.right+[Unity countcoordinatesW:10], _titleL.top+[Unity countcoordinatesH:5], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        _number.text = @"x1";
        _number.textColor = [Unity getColor:@"#666666"];
        _number.font = [UIFont systemFontOfSize:12];
        _number.textAlignment = NSTextAlignmentRight;
    }
    return _number;
}



- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
