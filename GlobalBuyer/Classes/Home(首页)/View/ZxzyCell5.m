//
//  ZxzyCell5.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "ZxzyCell5.h"
@interface ZxzyCell5()
@property (nonatomic , strong) UILabel * titleL;
@property (nonatomic , strong) UILabel * numl;
@end
@implementation ZxzyCell5

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
        _titleL.text = NSLocalizedString(@"new_sum", nil);
        _titleL.textColor = [Unity getColor:@"333333"];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.hidden = YES;
    }
    return _titleL;
}
- (UILabel *)numl{
    if (!_numl) {
        _numl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:50], 0, [Unity countcoordinatesW:40], [Unity countcoordinatesH:25])];
        _numl.textColor = [Unity getColor:@"666666"];
        _numl.font = [UIFont systemFontOfSize:14];
        _numl.textAlignment = NSTextAlignmentRight;
        _numl.hidden = YES;
    }
    return _numl;
}
- (void)configWithIsAdd:(BOOL)isAdd WithNum:(NSInteger )num{
    if (isAdd) {
        //        self.line.hidden = NO;
        self.titleL.hidden= NO;
        self.numl.hidden = NO;
        self.numl.text = [NSString stringWithFormat:@"%ld件",(long)num];
    }else{
        //        self.line.hidden = YES;
        self.titleL.hidden= YES;
        self.numl.hidden = YES;
    }

}

@end
