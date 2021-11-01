//
//  MsgCell1.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/13.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MsgCell1.h"
#import "UIView+SDAutoLayout.h"
@implementation MsgCell1
{
    UILabel *_titleLabel;
    UILabel * _timeLabel;
    UILabel * _contentLbale;
    UIView * _view;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.contentView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
    _timeLabel.text = @"昨天";
    [self.contentView addSubview:_timeLabel];
    
    _view = [UIView new];
    [self.contentView addSubview:_view];
    _view.layer.cornerRadius = 7;
    _view.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"超级购物日来袭";
    [_view addSubview:_titleLabel];
    
    _contentLbale = [UILabel new];
    _contentLbale.font = [UIFont systemFontOfSize:13];
    _contentLbale.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
    _contentLbale.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLbale.numberOfLines = 0;
    _contentLbale.preferredMaxLayoutWidth = self.contentView.frame.size.width-30;
    _contentLbale.textAlignment = NSTextAlignmentLeft;
    _contentLbale.text = @"爆款2.5折起，全场折上88折，明星同款爱丽丝系列限量抢，还有品牌新客50元门槛，速戳>>";
    [_view addSubview:_contentLbale];
    
    UILabel * line = [UILabel new];
    line.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [_view addSubview:line];
    
    UILabel * lookLabel = [UILabel new];
    lookLabel.font = [UIFont systemFontOfSize:13];
    lookLabel.textAlignment = NSTextAlignmentLeft;
    lookLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
    lookLabel.text = @"查看详情";
    [_view addSubview:lookLabel];
    
    
    CGFloat margin = 15;
    UIView *contentView = self.contentView;
    
    _timeLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(15);
    
    _view.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_timeLabel, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(120);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_view, 7)
    .topSpaceToView(_view, 10)
    .rightSpaceToView(_view, 7)
    .heightIs(15);
    
    _contentLbale.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 10)
    .rightEqualToView(_titleLabel)
    .heightIs(40);
    
    line.sd_layout
    .leftEqualToView(_contentLbale)
    .rightEqualToView(_contentLbale)
    .topSpaceToView(_contentLbale, 10)
    .heightIs(1);
    
    lookLabel.sd_layout
    .leftEqualToView(line)
    .rightEqualToView(line)
    .topSpaceToView(line, 0)
    .heightIs(34);
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
    [self setupAutoHeightWithBottomViewsArray:@[_timeLabel,_view ] bottomMargin:margin];
}

- (void)setModel:(MsgModel1 *)model
{
//    _model = model;
//
//    _titleLabel.text = model.title;
//    _timeLabel.text = model.author;
//    //    _imageView.image = [UIImage imageNamed:model.imageArr.firstObject];
//    [_imageView sd_setImageWithURL:model.imageArr.firstObject];
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
