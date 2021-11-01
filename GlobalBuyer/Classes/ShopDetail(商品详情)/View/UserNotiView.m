//
//  UserNotiView.m
//  测试程序
//
//  Created by why on 2019/3/18.
//  Copyright © 2019年 neusoft. All rights reserved.
//

#import "UserNotiView.h"
typedef void(^userNotiViewBloclk)(NSDictionary *info);
static  NSString *const userActionViewHexColor = @"#4B0E69";
static CGFloat const userActionViewHeight = 64.f;

@implementation UserNotiView{
    userNotiViewBloclk actionBlock;
    NSString *actionStr;
    NSString *messageStr;
}

-(instancetype)initWithTitle:(NSString *)titleStr message:(NSString *)message action:(void (^)(NSDictionary *))block{
    self = [super init];
    if (self) {
        actionBlock = block;
        actionStr = titleStr;
        messageStr = message;
        [self createUI];
    }
    return  self;
}

-(void)createUI{
    self.frame = CGRectMake(0, -userActionViewHeight, kScreenW, userActionViewHeight);
    self.backgroundColor = [UIColor py_colorWithHexString:userActionViewHexColor];
    [self addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, userActionViewHeight-40, (kScreenW-20*3)*3/4, 35)];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextColor:[UIColor whiteColor]];
    messageLabel.font = [UIFont systemFontOfSize:12];
    messageLabel.numberOfLines = 2;
    messageLabel.text = messageStr;
    [self addSubview:messageLabel];
    
    UILabel *actionLabel =  [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-60)*3/4+40, userActionViewHeight-40, (kScreenW-60)*1/4, 35)];
    [actionLabel setBackgroundColor:[UIColor clearColor]];
    [actionLabel setTextColor:[UIColor whiteColor]];
    actionLabel.textAlignment = NSTextAlignmentRight;
    actionLabel.font = [UIFont systemFontOfSize:13];
    actionLabel.text = actionStr;
    [self addSubview:actionLabel];
    
    [self show];
}

-(void)userAction{
    if (actionBlock) {
        actionBlock(nil);
    }
}

-(void)show{
    __weak typeof(self) weakself = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        weakself.frame = CGRectMake(0, 0, kScreenW, userActionViewHeight);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself close];
        });
    }];
}


-(void)close{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.frame = CGRectMake(0, -userActionViewHeight, kScreenW, userActionViewHeight);
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
