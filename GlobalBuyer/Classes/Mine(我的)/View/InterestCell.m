//
//  InterestCell.m
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/4/30.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import "InterestCell.h"
@interface InterestCell()
@property (nonatomic , strong)UIImageView * imageView;
@property (nonatomic , strong)UILabel * title;
@end
@implementation InterestCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
    }
    return self;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], 0, self.frame.size.width-[Unity countcoordinatesW:20], self.frame.size.width-[Unity countcoordinatesW:20])];
//        _imageView.backgroundColor = [UIColor whiteColor];
        [_imageView addSubview:self.maskV];
    }
    return _imageView;
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _imageView.width, _imageView.height)];
        _maskV.backgroundColor = [UIColor blackColor];
        _maskV.alpha=0.5;
        _maskV.hidden=YES;
        UIImageView * icon = [Unity imageviewAddsuperview_superView:_maskV _subViewFrame:CGRectMake((_maskV.width-[Unity countcoordinatesW:32])/2, (_maskV.height-[Unity countcoordinatesW:20])/2, [Unity countcoordinatesW:32], [Unity countcoordinatesW:20]) _imageName:@"选择分类" _backgroundColor:nil];
    }
    return _maskV;
}
- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.bottom, self.frame.size.width, [Unity countcoordinatesH:30])];
        _title.text = @"";
        _title.textColor = [Unity getColor:@"#333333"];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font =[UIFont systemFontOfSize:12];
    }
    return _title;
}
- (void)configWithOfIcon:(NSString *)icon WithOfName:(NSString *)name{
    self.imageView.image = [UIImage imageNamed:icon];
    self.title.text = name;
}
@end
