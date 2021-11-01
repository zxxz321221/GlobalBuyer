//
//  MsgCell2.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/13.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MsgCell2.h"
#import "UIView+SDAutoLayout.h"
@implementation MsgCell2
{
    UILabel *_titleLabel;
    UILabel * _timeLabel;
    UILabel * _contentLbale;
    UIView * _view;
    UIImageView * _imageView;
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
    _timeLabel.text = @"一周前";
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
    
    _imageView = [UIImageView new];
    _imageView.backgroundColor = [UIColor redColor];
    [_view addSubview:_imageView];
    
    _contentLbale = [UILabel new];
    _contentLbale.textAlignment = NSTextAlignmentLeft;
    _contentLbale.font = [UIFont systemFontOfSize:13];
    _contentLbale.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
    _contentLbale.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLbale.numberOfLines = 0;
    _contentLbale.preferredMaxLayoutWidth = self.contentView.frame.size.width-111;
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
    .heightIs(140);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_view, 7)
    .topSpaceToView(_view, 10)
    .rightSpaceToView(_view, 7)
    .heightIs(15);
    
    _imageView.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 10)
    .widthIs(60)
    .heightIs(60);
    
    _contentLbale.sd_layout
    .leftSpaceToView(_view, 74)
    .topEqualToView(_imageView)
    .rightSpaceToView(_view, 7)
    .heightIs(60);
    
    line.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
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
- (void)setModel:(MsgModel2 *)model
{
//    _model = model;
//
//    _titleLabel.text = model.title;
//    _timeLabel.text = model.author;
//    //    _imageView.image = [UIImage imageNamed:model.imageArr.firstObject];
//    [_imageView sd_setImageWithURL:model.imageArr.firstObject];
}
/*计算消息时间*/
- (NSString *)compareCurrentTime:(NSString *)str
{
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
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
