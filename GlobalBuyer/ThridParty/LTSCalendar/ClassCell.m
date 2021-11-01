//
//  ClassCell.m
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/4/22.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import "ClassCell.h"
#import "FootGoodsModel.h"
@interface ClassCell()
{
    NSInteger sec;
    NSInteger index;
}
@property (nonatomic , strong)UIView * backV;
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * name;
@property (nonatomic , strong) UIButton * edit;
@end
@implementation ClassCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [Unity getColor:@"#f0f0f0"];
        [self.contentView addSubview:self.backV];
    }
    return self;
}
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake((kScreenW/3-[Unity countcoordinatesW:100])/2, 5, [Unity countcoordinatesW:100],[Unity countcoordinatesH:200]-10)];
        _backV.backgroundColor = [UIColor whiteColor];
        _backV.layer.cornerRadius = 10;
        
        [_backV addSubview:self.imgView];
        [_backV addSubview:self.name];
        [_backV addSubview:self.read];
        [_backV addSubview:self.icon];
        [_backV addSubview:self.edit];
        
    }
    return _backV;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _backV.width, [Unity countcoordinatesH:120])];
        _imgView.backgroundColor = [UIColor redColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(5, _imgView.bottom, _backV.width-10, [Unity countcoordinatesH:40])];
        _name.text = @"非经典款沙拉酱付款大连市静安看了非经典款啦记录";
        _name.textAlignment = NSTextAlignmentLeft;
        _name.textColor = [Unity getColor:@"#333333"];
        _name.font = [UIFont systemFontOfSize:14];
        _name.numberOfLines = 0;
    }
    return _name;
}
- (UIButton *)read{
    if (!_read) {
        _read = [[UIButton alloc]initWithFrame:CGRectMake(5, _name.bottom+[Unity countcoordinatesH:4], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16])];
        [_read addTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_read setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_read setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [_read setImage:[UIImage imageNamed:@"已选中"] forState:UIControlStateSelected];
        _read.hidden = YES;
    }
    return _read;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, _name.bottom+[Unity countcoordinatesH:2], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
//        _icon = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:16]+10, _name.bottom+[Unity countcoordinatesH:2], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        _icon.backgroundColor = [UIColor redColor];
        _icon.layer.cornerRadius = [Unity countcoordinatesH:10];
        _icon.layer.masksToBounds = YES;
    }
    return _icon;
}
- (UIButton *)edit{
    if (!_edit) {
        _edit = [[UIButton alloc]initWithFrame:CGRectMake(_backV.width-5-[Unity countcoordinatesW:20], _name.bottom+[Unity countcoordinatesH:2], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        [_edit addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [_edit setBackgroundImage:[UIImage imageNamed:@"更多操作"] forState:UIControlStateNormal];
    }
    return _edit;
}
- (void)configWithSection:(NSInteger)section IndexPath:(NSInteger)indexPath IsEdit:(BOOL)isEdit{
    if (isEdit) {
        self.read.hidden = NO;
        self.icon.frame = CGRectMake([Unity countcoordinatesW:16]+10, [Unity countcoordinatesH:162], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
    }else{
        self.read.hidden = YES;
        self.icon.frame = CGRectMake(5, [Unity countcoordinatesH:162], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
    }
    sec = section;
    index = indexPath;
}
- (void)readClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(shoppingCellDelegate:WithSelectButton:)])
    {
        [self.delegate shoppingCellDelegate:self WithSelectButton:sender];
    }
}
- (void)editClick{
    [self.delegate withOfDelete:sec IndexPath:index];
}
/**
 *  模型赋值
 */
- (void)setModel:(FootGoodsModel *)model{
    self.read.selected = model.isSelect;
    
}

@end
