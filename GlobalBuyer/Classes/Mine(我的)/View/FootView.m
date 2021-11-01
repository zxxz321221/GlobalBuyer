//
//  FootView.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/7.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "FootView.h"
@interface FootView()

@property (nonatomic,strong) UIView * backView;
@property (nonatomic, strong) UIButton * collectionBtn;
@property (nonatomic , strong) UIButton * deleteBtn;
@property (nonatomic , strong) UILabel * collectionL;
@property (nonatomic , strong) UILabel * deleteL;
@property (nonatomic , strong) UIButton * cancelBtn;
@end
@implementation FootView

+(instancetype)setFootView:(UIView *)view{
    FootView * footView = [[FootView alloc]initWithFrame:view.frame];
    [[UIApplication sharedApplication].keyWindow addSubview:footView];
    return footView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.hidden = YES;
        [self addSubview:self.backView];
    }
    return self;
}
-(UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-[Unity countcoordinatesH:150]-NavBarHeight, kScreenW, [Unity countcoordinatesH:150])];
        _backView.backgroundColor = [Unity getColor:@"#e0e0e0"];
        
        [_backView addSubview:self.collectionBtn];
        [_backView addSubview:self.deleteBtn];
        [_backView addSubview:self.collectionL];
        [_backView addSubview:self.deleteL];
        [_backView addSubview:self.cancelBtn];
    }
    return _backView;
}
- (UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:80], [Unity countcoordinatesH:20], [Unity countcoordinatesW:45], [Unity countcoordinatesH:45])];
        _collectionBtn.backgroundColor = [UIColor whiteColor];
        _collectionBtn.layer.cornerRadius = 10;
        _collectionBtn.layer.masksToBounds=YES;
        UIImageView * imageView = [Unity imageviewAddsuperview_superView:_collectionBtn _subViewFrame:CGRectMake([Unity countcoordinatesW:7.5], [Unity countcoordinatesH:7.5], [Unity countcoordinatesW:30], [Unity countcoordinatesH:30]) _imageName:@"足迹收藏" _backgroundColor:nil];
        imageView.userInteractionEnabled = NO;
        [_collectionBtn addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:125], [Unity countcoordinatesH:20], [Unity countcoordinatesW:45], [Unity countcoordinatesH:45])];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.layer.cornerRadius = 10;
        _deleteBtn.layer.masksToBounds=YES;
        UIImageView * imageView = [Unity imageviewAddsuperview_superView:_deleteBtn _subViewFrame:CGRectMake([Unity countcoordinatesW:7.5], [Unity countcoordinatesH:7.5], [Unity countcoordinatesW:30], [Unity countcoordinatesH:30]) _imageName:@"单删" _backgroundColor:nil];
        imageView.userInteractionEnabled = NO;
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UILabel *)collectionL{
    if (!_collectionL) {
        _collectionL = [[UILabel alloc]initWithFrame:CGRectMake(_collectionBtn.left, _collectionBtn.bottom+[Unity countcoordinatesH:10], _collectionBtn.width, [Unity countcoordinatesH:20])];
        _collectionL.text = @"收藏";
        _collectionL.textColor = [Unity getColor:@"#333333"];
        _collectionL.font = [UIFont systemFontOfSize:14];
        _collectionL.textAlignment = NSTextAlignmentCenter;
    }
    return _collectionL;
}
- (UILabel *)deleteL{
    if (!_deleteL) {
        _deleteL = [[UILabel alloc]initWithFrame:CGRectMake(_deleteBtn.left, _deleteBtn.bottom+[Unity countcoordinatesH:10], _deleteBtn.width, [Unity countcoordinatesH:20])];
        _deleteL.text = @"删除";
        _deleteL.textColor = [Unity getColor:@"#333333"];
        _deleteL.font = [UIFont systemFontOfSize:14];
        _deleteL.textAlignment = NSTextAlignmentCenter;
    }
    return _deleteL;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:110], kScreenW, [Unity countcoordinatesH:40])];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[Unity getColor:@"#33333"] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (void)cancelClick{
    [self hiddenFootView];
}
- (void)collectionClick{
    [self.delegate footCollection];
}
- (void)deleteClick{
    [self.delegate footDelete];
}
- (void)showFootView{
    self.hidden = NO;
}
- (void)hiddenFootView{
    self.hidden = YES;
}

@end
