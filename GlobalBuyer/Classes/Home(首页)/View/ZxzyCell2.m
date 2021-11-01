//
//  ZxzyCell2.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "ZxzyCell2.h"
@interface ZxzyCell2()
@property (nonatomic , strong) UILabel * line0;
@property (nonatomic , strong) UILabel * block1;//标题前红快
@property (nonatomic , strong) UILabel * titleL;
@end

@implementation ZxzyCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.line0];
        [self.contentView addSubview:self.block1];
        [self.contentView addSubview:self.titleL];
    }
    return self;
}
- (UILabel *)line0{
    if (!_line0) {
        _line0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Unity countcoordinatesH:10])];
        _line0.backgroundColor = [Unity getColor:@"f0f0f0"];
    }
    return _line0;
}
- (UILabel *)block1{
    if (!_block1) {
        _block1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _line0.bottom+[Unity countcoordinatesH:15], [Unity countcoordinatesW:3], [Unity countcoordinatesH:10])];
        _block1.backgroundColor = Main_Color;
    }
    return _block1;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(_block1.right+[Unity countcoordinatesW:10], _line0.bottom+[Unity countcoordinatesH:10], 200, [Unity countcoordinatesH:20])];
        _titleL.text = NSLocalizedString(@"goods_list_new", nil);
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.textColor = [Unity getColor:@"333333"];
    }
    return _titleL;
}
@end
