//
//  ZxzyCell3.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "ZxzyCell3.h"
@interface ZxzyCell3()
@property (nonatomic , strong) UILabel * titleL;
@property (nonatomic , strong) UILabel * numl;
@end
@implementation ZxzyCell3
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.numl];
    }
    return self;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], 0, 100, [Unity countcoordinatesH:25])];
        _titleL.text = NSLocalizedString(@"listNumber_new", nil);
        _titleL.textColor = [Unity getColor:@"333333"];
        _titleL.font = [UIFont systemFontOfSize:14];
    }
    return _titleL;
}
- (UILabel *)numl{
    if (!_numl) {
        _numl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:50], 0, [Unity countcoordinatesW:40], [Unity countcoordinatesH:25])];
        _numl.text = @"1";
        _numl.textColor = [Unity getColor:@"666666"];
        _numl.font = [UIFont systemFontOfSize:14];
        _numl.textAlignment = NSTextAlignmentRight;
    }
    return _numl;
}
@end
