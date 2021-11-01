//
//  OrderTopView.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "OrderTopView.h"

@interface OrderTopView ()

@property (nonatomic, assign) NSInteger oldNum;
@property (nonatomic, strong) NSMutableArray *dataSoucer;
@property (nonatomic, strong) UIView *line;

@end

@implementation OrderTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.oldNum = 10;
        [self addSubviews];
    }
    return self;
}

#pragma mark 初始化数据
-(NSMutableArray *)dataSoucer {
    if (_dataSoucer == nil) {
        _dataSoucer = [NSMutableArray new];
        NSString *str1 = NSLocalizedString(@"GlobalBuyer_Order_all", nil);
        NSString *str2 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Wait", nil);
        NSString *str3 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_SubmitAdd", nil);
        NSString *str4 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Purchase", nil);
        NSString *str5 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Paytransport", nil);
        NSString *str6 = NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Overseas", nil);
        [_dataSoucer addObject:str1];
        [_dataSoucer addObject:str2];
        [_dataSoucer addObject:str3];
        [_dataSoucer addObject:str4];
        [_dataSoucer addObject:str5];
        [_dataSoucer addObject:str6];
    }
    return _dataSoucer;
}

#pragma mark 添加视图
-(void)addSubviews{
    
    for (int i = 0; i < 6; i++) {
        UILabel *la = [[UILabel alloc]init];
        la.textColor =  [UIColor colorWithRed:0.57 green:0.57 blue:0.68 alpha:1];
        la.tag = 10+i;
        la.textAlignment = NSTextAlignmentCenter;
        la.font = [UIFont systemFontOfSize:11];
        la.text = self.dataSoucer[i];
        la.frame = CGRectMake(i*(kScreenW/6), 0, kScreenW/6, 35);
        [self addSubview:la];
        if (i == 0) {
            la.font = [UIFont systemFontOfSize:13];
            la.textColor = Main_Color;
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1; //点击次数
        tapGesture.numberOfTouchesRequired = 1; //点击手指数
        [la addGestureRecognizer:tapGesture];
        la.userInteractionEnabled = YES;
        
    }
    UIView *la = [[UIView alloc]initWithFrame:CGRectMake(0, 34, kScreenW, 1)];
    la.backgroundColor = Cell_BgColor;
    [self addSubview:la];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(5, 32, kScreenW/6 - 10, 2)];
    self.line.backgroundColor = Main_Color;
    [self addSubview:self.line];
    self.userInteractionEnabled = YES;
 
}

#pragma mark 添加手势
-(void)tapGesture:(UITapGestureRecognizer *)tap {
    NSInteger newNum = [tap view].tag;
    if (newNum == self.oldNum) {
        return;
    }
    UILabel *oldLa = [self viewWithTag:self.oldNum];
    oldLa.font = [UIFont systemFontOfSize:11];
    oldLa.textColor =  [UIColor colorWithRed:0.57 green:0.57 blue:0.68 alpha:1];
    
    UILabel *newLa = [self viewWithTag:newNum];
    newLa.font = [UIFont systemFontOfSize:13];
    newLa.textColor =  Main_Color;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.line.frame;
        frame.origin.x =(newNum - 10) * (kScreenW/6) + 5;
        self.line.frame = frame;
    }];
    self.oldNum = newNum;
    
    [self.delegate clickAtIndex:newNum];
    
}

#pragma mark 滑动事件
- (void)setOrderTopViewLaState:(NSInteger)index{

    NSInteger newNum = index + 10;
   
    UILabel *oldLa = [self viewWithTag:self.oldNum];
    oldLa.font = [UIFont systemFontOfSize:11];
    oldLa.textColor =  [UIColor colorWithRed:0.57 green:0.57 blue:0.68 alpha:1];
    
    UILabel *newLa = [self viewWithTag:newNum];
    newLa.font = [UIFont systemFontOfSize:13];
    newLa.textColor =  Main_Color;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.line.frame;
        frame.origin.x =(newNum - 10) * (kScreenW/6) + 5;
        self.line.frame = frame;
    }];
    self.oldNum = newNum;
}
@end
