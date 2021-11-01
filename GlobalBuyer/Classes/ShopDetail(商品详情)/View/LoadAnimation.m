//
//  LoadAnimation.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/20.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "LoadAnimation.h"

@interface LoadAnimation ()
@property(nonatomic,strong)NSMutableArray *imgArray;
@property (nonatomic,strong)UIImageView * wotadaImg;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIImageView *imgAnimaView;
@property(nonatomic,strong)UILabel *messageLb;
@end

@implementation LoadAnimation
+(instancetype)LoadingViewSetView:(UIView *)view{
    LoadAnimation * loadingView = [[LoadAnimation alloc]initWithFrame:view.frame];
    [view addSubview:loadingView];
    return loadingView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0;
        self.hidden = YES;
        [self addSubview:self.wotadaImg];
        [self addSubview:self.imgAnimaView];
        
        //        self.imgView.image = [UIImage imageNamed:self.imageName];
        [self addSubview:self.imgView];
        [self addSubview:self.messageLb];
    }
    return self;
}

- (UIImageView *)wotadaImg{
    if (_wotadaImg == nil) {
        _wotadaImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*0.15, self.bounds.size.height/2, self.bounds.size.width*0.2, self.bounds.size.height/32)];
        _wotadaImg.image = [UIImage imageNamed:@"wotada"];
    }
    return _wotadaImg;
}
- (UIImageView *)imgAnimaView{
    if (_imgAnimaView == nil) {
        _imgAnimaView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*0.37, self.bounds.size.height*0.515, self.bounds.size.width/5, self.bounds.size.height/75)];
    }
    return _imgAnimaView;
}
-(UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*0.6,self.bounds.size.height/2, self.bounds.size.width/5, self.bounds.size.height/22)];
        _imgView.backgroundColor = [UIColor yellowColor];
    }
    return _imgView;
}

- (UILabel *)messageLb
{
    if (_messageLb == nil) {
        _messageLb = [[UILabel alloc]initWithFrame:CGRectMake(20, self.bounds.size.height*0.57, self.bounds.size.width-40, 60)];
        _messageLb.numberOfLines = 0;
        _messageLb.text = @"wotada全球买手正在跳转海外网站";
        _messageLb.textColor = Main_Color;
        _messageLb.textAlignment = NSTextAlignmentLeft;
        _messageLb.font = [UIFont systemFontOfSize:14];
    }
    return _messageLb;
}
-(NSMutableArray *)imgArray{
    if (_imgArray == nil) {
        _imgArray = [NSMutableArray new];
        for (int i = 0; i < 6; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"2%d",i+1]];
            [_imgArray addObject: img];
        }
    }
    return _imgArray;
}
-(void)startLoadAnimation{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.imgAnimaView.animationImages = self.imgArray;
        self.imgAnimaView.animationDuration = 1;
        self.imgAnimaView.animationRepeatCount = 0;
        [self.imgAnimaView startAnimating];
    }];
}

-(void)stopLoadAnimation{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.imgAnimaView stopAnimating];
    }];
}
@end
