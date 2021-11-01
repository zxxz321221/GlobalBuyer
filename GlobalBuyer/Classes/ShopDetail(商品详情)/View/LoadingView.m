//
//  LoadingView.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/23.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)UIImageView *imgView;

@end

@implementation LoadingView

+(instancetype)LoadingViewSetView:(UIView *)view{
    LoadingView * loadingView = [[LoadingView alloc]initWithFrame:view.frame];
    [view addSubview:loadingView];
    return loadingView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0;
        self.hidden = YES;
        [self addSubview:self.imgView];
        NSString *str1 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_1", nil);
        NSString *str2 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_2", nil);
        NSString *str3 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_3", nil);
        NSString *str4 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_4", nil);
        NSString *str5 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_5", nil);
        NSString *str6 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_6", nil);
        NSString *str7 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_7", nil);
        NSString *str8 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_8", nil);
        NSString *str9 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_9", nil);
        NSString *str10 = NSLocalizedString(@"GlobalBuyer_LoadingView_message_10", nil);
        
        NSArray *strArr = @[str2,str4,str5,str6,str7,str8,str9,str10];
        NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoadingViewNum"];
        int num = [numStr intValue];
        self.messageLb.text = strArr[num];
        num++;
        if (num >= strArr.count) {
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"LoadingViewNum"];
        }else{
            NSString *tmpStr = [NSString stringWithFormat:@"%d",num];
            [[NSUserDefaults standardUserDefaults]setObject:tmpStr forKey:@"LoadingViewNum"];
        }

        [self addSubview:self.messageLb];
    }
    return self;
}

-(UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 75, self.bounds.size.height/2 - 100, 150, 150)];
    }
    return _imgView;
}

- (UILabel *)messageLb
{
    if (_messageLb == nil) {
        _messageLb = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 150, self.bounds.size.height/2 + 30, 300, 90)];
        _messageLb.numberOfLines = 0;
        _messageLb.textAlignment = NSTextAlignmentCenter;
        _messageLb.font = [UIFont systemFontOfSize:14];
    }
    return _messageLb;
}

-(NSMutableArray *)imgArray{
    if (_imgArray == nil) {
        _imgArray = [NSMutableArray new];
        for (int i = 0; i < 26; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i+1]];
            [_imgArray addObject: img];
        }
    }
    return _imgArray;
}

-(void)startLoading{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
     self.alpha = 1;
    } completion:^(BOOL finished) {
        self.imgView.animationImages = self.imgArray;
        self.imgView.animationDuration = 30*0.15;
        self.imgView.animationRepeatCount = 0;
        [self.imgView startAnimating];
    }];
}

-(void)stopLoading{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.imgView stopAnimating];
    }];
}
@end
