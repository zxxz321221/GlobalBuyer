//
//  HelpCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/22.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "HelpCell.h"
@interface HelpCell()
@property (nonatomic , strong) UIButton * classBtn;
@property (nonatomic , strong) UIImageView * lineImg;
@property (nonatomic , strong) UIView * line;
@property (nonatomic , strong) UIImageView * btnIcon;
@property (nonatomic , strong) UILabel * btnName;
@property (nonatomic , strong) UIView * line1;
@property (nonatomic , strong) UIView * line2;
@end
@implementation HelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (void)initLayout{
    [self.contentView addSubview:self.classBtn];
    [self.contentView addSubview:self.lineImg];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    
}
- (UIButton *)classBtn{
    if (!_classBtn) {
        _classBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [Unity countcoordinatesW:80], [Unity countcoordinatesH:91])];
        
        [_classBtn addSubview:self.btnIcon];
        [_classBtn addSubview:self.btnName];
    }
    return _classBtn;
}
- (UIImageView *)lineImg{
    if (!_lineImg) {
        _lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(_classBtn.right, 0, [Unity countcoordinatesW:6], [Unity countcoordinatesH:91])];
        _lineImg.image = [UIImage imageNamed:@"helpcell_line"];
    }
    return _lineImg;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:91], kScreenW, [Unity countcoordinatesH:5])];
        _line.backgroundColor = [Unity getColor:@"#f0f0f0"];
    }
    return _line;
}
- (UIImageView *)btnIcon{
    if (!_btnIcon) {
        _btnIcon = [[UIImageView alloc]initWithFrame:CGRectMake((_classBtn.width-[Unity countcoordinatesH:25])/2, [Unity countcoordinatesH:22.5], [Unity countcoordinatesH:25], [Unity countcoordinatesH:25])];
//        _btnIcon.image = [UIImage imageNamed:@""];
    }
    return _btnIcon;
}
- (UILabel *)btnName{
    if (!_btnName) {
        _btnName = [[UILabel alloc]initWithFrame:CGRectMake(0, _btnIcon.bottom, _classBtn.width, [Unity countcoordinatesH:20])];
//        _btnName.text = @"";
        _btnName.textColor = [Unity getColor:@"#333333"];
        _btnName.textAlignment = NSTextAlignmentCenter;
        _btnName.font = [UIFont systemFontOfSize:14];
    }
    return _btnName;
}
- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc]initWithFrame:CGRectMake(_lineImg.right+[Unity countcoordinatesW:20], [Unity countcoordinatesH:45], kScreenW-[Unity countcoordinatesW:126], 1)];
        _line1.backgroundColor = [Unity getColor:@"#e0e0e0"];
        
    }
    return _line1;
}
- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:86])/2+[Unity countcoordinatesW:86], [Unity countcoordinatesH:10], 1, [Unity countcoordinatesH:71])];
        _line2.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _line2;
}
- (void)configWithData:(NSDictionary *)dic{
    self.btnIcon.image = [UIImage imageNamed:[dic objectForKey:@"name"]];
    self.btnName.text = [dic objectForKey:@"name"];
    for (int i=0; i<4; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(_lineImg.right+((i%2)*((kScreenW-[Unity countcoordinatesW:86])/2))+(i%2)*1, (i/2)*[Unity countcoordinatesH:45]+(i/2)*1, (kScreenW-[Unity countcoordinatesW:86])/2, [Unity countcoordinatesH:45]) _tag:self _action:@selector(btnClick:) _string:@"" _imageName:@""];
        btn.tag = 1000+i;
        [btn setTitle:[dic objectForKey:@"list"][i] forState:UIControlStateNormal];
        [btn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
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
