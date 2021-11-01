//
//  SizeTableViewCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/8.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "SizeTableViewCell.h"

@implementation SizeTableViewCell
{
    UILabel * nameL;//名称
    UILabel * defaultl;//默认
    UILabel * sexL;//性别
    UILabel * heightL;//身高
    UILabel * weightL;//体重
    UILabel * shoulderL;//肩宽
    UILabel * chestL;//胸围
    UILabel * waistlineL;//腰围
    UILabel * girthL;//臂围
    UILabel * footSizeL;//脚长
    UILabel * bottomsL;//脚围
    UIButton * edit;
    NSInteger sum;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self loadView];
    }
    return self;
}
- (void)loadView{
    nameL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], 100, [Unity countcoordinatesH:30]) _string:@"" _lableFont:[UIFont systemFontOfSize:20] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    defaultl = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(nameL.right, nameL.top+[Unity countcoordinatesH:3], 50, [Unity countcoordinatesH:24]) _string:@"默认" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:[UIColor redColor] _textAlignment:NSTextAlignmentCenter];
    defaultl.layer.borderColor = [[UIColor redColor]CGColor];
    defaultl.layer.borderWidth = 1.0f;
    defaultl.layer.masksToBounds = YES;
    
    edit = [Unity buttonAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:40], defaultl.top, [Unity countcoordinatesW:30], [Unity countcoordinatesH:30]) _tag:self _action:@selector(editAction:) _string:@"编辑" _imageName:@""];
    edit.backgroundColor = [UIColor redColor];
    
    UILabel * sexLabel = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(nameL.left, nameL.bottom+[Unity countcoordinatesH:10], 100, [Unity countcoordinatesH:30]) _string:@"性别" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    sexL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(sexLabel.right, sexLabel.top, 50, sexLabel.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentCenter];
    NSArray * arr = @[@"身高(cm)",@"体重(kg)",@"肩宽(cm)",@"胸围(cm)",@"腰围(cm)",@"臂围(cm)",@"脚长(cm)",@"脚围(cm)"];
    for (int i=0; i<arr.count; i++) {
        UILabel * label = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake((i%2)*(kScreenW/2)+[Unity countcoordinatesW:10], sexLabel.bottom+([Unity countcoordinatesH:25]*(i/2)), [Unity countcoordinatesW:80], [Unity countcoordinatesH:25]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        if (i==0) {
            heightL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==1){
            weightL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==2){
            shoulderL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==3){
            chestL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==4){
            waistlineL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==5){
            girthL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==6){
            footSizeL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }else if (i==7){
            bottomsL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(label.right, label.top, [Unity countcoordinatesW:60], label.height) _string:@"--" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        }
    }
}
- (void)editAction:(UIButton *)sender{
    if (self.editBlock) {
        self.editBlock(sum);
    }
}
- (void)configName:(NSString *)name Sex:(NSString *)sex Height:(NSString *)height Weight:(NSString *)weight Shoulder:(NSString *)shoulder Chest:(NSString *)chest Waistline:(NSString *)waistline Girth:(NSString *)girth FootSize:(NSString *)footSize Bottoms:(NSString *)bottoms Index:(NSInteger)index{
    sum = index;
    nameL.text = name;
    if (![sex isEqualToString:@""]) {
        sexL.text = sex;
    }
    if (![height isEqualToString:@""]) {
        heightL.text = height;
    }
    if (![weight isEqualToString:@""]) {
        weightL.text = weight;
    }
    if (![shoulder isEqualToString:@""]) {
        shoulderL.text = shoulder;
    }
    if (![chest isEqualToString:@""]) {
        chestL.text = chest;
    }
    if (![waistline isEqualToString:@""]) {
        waistlineL.text = waistline;
    }
    if (![girth isEqualToString:@""]) {
        girthL.text = girth;
    }
    if (![footSize isEqualToString:@""]) {
        footSizeL.text = footSize;
    }
    if (![bottoms isEqualToString:@""]) {
        bottomsL.text = bottoms;
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
