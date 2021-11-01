//
//  ClassifyDetaiCell.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ClassifyDetaiCell.h"



@implementation ClassifyDetaiCell
{
    UIImageView *_imgView;
    UILabel *_nameLa;
    UIView *_bgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    _bgView = [[UIView alloc]init];
    _bgView.frame = CGRectMake(8, 8, self.contentView.frame.size.width - 16, self.contentView.frame.size.height - 16);
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _imgView = [[UIImageView alloc]init];
    _imgView.frame = CGRectMake(16, 16, self.contentView.bounds.size.width - 32, (self.contentView.bounds.size.width - 32)/2);
    [self.contentView addSubview:_imgView];
    
    _nameLa = [[UILabel alloc]init];
    _nameLa.frame = CGRectMake(16, CGRectGetMaxY(_imgView.frame), self.contentView.bounds.size.width - 32, self.contentView.frame.size.height - CGRectGetMaxY(_imgView.frame) - 8);
    _nameLa.textAlignment = NSTextAlignmentCenter;
    _nameLa.font = [UIFont systemFontOfSize:12];
    _nameLa.textColor = [UIColor scrollViewTexturedBackgroundColor];
    _nameLa.numberOfLines = 0;
    [self.contentView addSubview:_nameLa];
    
    
    self.Iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 40, 40)];
    [self.contentView addSubview:self.Iv];
    


}

-(void)setModel:(CategoryModel *)model{
    _model = model;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PictureApi,_model.image];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"goods.png"]];
    
    if([_model.Description isEqual:[NSNull null]]){
        
        _nameLa.text = @"";
        
    }else{
        _nameLa.text = [NSString stringWithFormat:@"%@",_model.Description];
    }
    
    
}
@end
