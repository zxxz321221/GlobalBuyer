//
//  CountryCell.m
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//
#define Main_Color [UIColor colorWithRed:0.50 green:0.76 blue:0.25 alpha:1]
#define Cell_BgColor  [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kTabBarH        49.0f
#define kStatusBarH     20.0f
#define kNavigationBarH 44.0f

#import "CountryCell.h"

@interface CountryCell()

@property (nonatomic, strong)UIScrollView *noticeSv;
@property (nonatomic, assign)int noticePage;
@property (nonatomic, assign)BOOL isRoll;
@property (nonatomic, strong)UIImageView *activityIv;

@end

@implementation CountryCell

- (NSMutableArray *)noticeArr
{
    if (_noticeArr == nil) {
        _noticeArr = [[NSMutableArray alloc]init];
    }
    return _noticeArr;
}

-(instancetype )initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = Cell_BgColor;
        NSArray *imageName;
        NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
        // 取得 iPhone 支持的所有语言设置
        NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
        NSLog (@"%@", languages);
        
        // 获得当前iPhone使用的语言
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            imageName = @[@"china简.jpg",@"usa简.jpg",@"japan简.jpg",@"europe简.jpg"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            imageName = @[@"china繁.jpg",@"usa繁.jpg",@"japan繁.jpg",@"europe繁.jpg"];
        }else if([currentLanguage isEqualToString:@"en"]){
            imageName = @[@"china英.jpg",@"usa英.jpg",@"japan英.jpg",@"europe英.jpg"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            imageName = @[@"china日.jpg",@"usa日.jpg",@"japan日.jpg",@"europe日.jpg"];
        }else{
            imageName = @[@"china简.jpg",@"usa简.jpg",@"japan简.jpg",@"europe简.jpg"];
        }
        
        for (int i = 0; i < 4; i ++) {
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(10*(i%2+1) + (((kScreenW - 30)/2) * (i%2)) , 70 + (110 * (i/2)), (kScreenW - 30)/2, 100);
            imgView.image = [UIImage imageNamed:imageName[i]];
            [self.contentView addSubview:imgView];
            
            imgView.tag = 100+i;
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            tapGesture.numberOfTapsRequired = 1; //点击次数
            tapGesture.numberOfTouchesRequired = 1; //点击手指数
            [imgView addGestureRecognizer:tapGesture];
        }
        
        self.activityIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 70, kScreenW - 20, 210)];
        self.activityIv.backgroundColor = [UIColor whiteColor];
        self.activityIv.hidden = YES;
        self.activityIv.tag = 888;
        [self.contentView addSubview:self.activityIv];
        UITapGestureRecognizer *tapActivityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapActivityGesture.numberOfTapsRequired = 1; //点击次数
        tapActivityGesture.numberOfTouchesRequired = 1; //点击手指数
        [self.activityIv addGestureRecognizer:tapActivityGesture];
        
        UIImageView *noticeIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5 , [[UIScreen mainScreen] bounds].size.width, 60)];
        noticeIv.image = [UIImage imageNamed:@"新闻公告"];
        noticeIv.tag = 666;
        noticeIv.userInteractionEnabled = YES;
        [self.contentView addSubview:noticeIv];
        
        self.isRoll = NO;
        
        self.noticePage = 0;
        self.noticeSv = [[UIScrollView alloc]initWithFrame:CGRectMake(70, 10, [[UIScreen mainScreen] bounds].size.width - 80, 40)];
        self.noticeSv.userInteractionEnabled = NO;
        self.noticeSv.showsVerticalScrollIndicator = NO;
        self.noticeSv.showsHorizontalScrollIndicator = NO;
//        self.noticeSv.contentSize = CGSizeMake( [[UIScreen mainScreen] bounds].size.width - 80, 30*3);
        [noticeIv addSubview:self.noticeSv];

        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1; //点击次数
        tapGesture.numberOfTouchesRequired = 1; //点击手指数
        [noticeIv addGestureRecognizer:tapGesture];
    }
    return self;

}

- (void)setNoticeMessage
{
    for (UIView *subviews in self.noticeSv.subviews) {
        if ([subviews isKindOfClass:[UILabel class]]) {
            [subviews removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.noticeArr.count; i++) {
        UILabel *noticeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, i * 20, kScreenW - 80, 20)];
        noticeLb.font = [UIFont systemFontOfSize:15];
        noticeLb.text = [NSString stringWithFormat:@"%@",self.noticeArr[i][@"news_title"]];
        [self.noticeSv addSubview:noticeLb];
    }

    if (self.isRoll == NO) {
        [self RollNotice];
    }
}

- (void)RollNotice
{
    if (self.noticeArr.count > 2) {
        self.isRoll = YES;
        
        
        [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(TimerRollNotice) userInfo:nil repeats:YES];
//        [NSTimer scheduledTimerWithTimeInterval:7 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//        }];

    }
}

- (void)TimerRollNotice
{
    self.noticePage++;
    [UIView animateWithDuration:5 animations:^{
        self.noticeSv.contentOffset = CGPointMake(0, 20 * self.noticePage);
    } completion:^(BOOL finished) {
        if (self.noticePage >= self.noticeArr.count - 2){
            [UIView animateWithDuration:1 animations:^{
                self.noticeSv.contentOffset = CGPointMake(0, 0);
            }];
            self.noticePage = 0;
        }
    }];
}

-(void)tapGesture:(UITapGestureRecognizer *)tap {
    [self.delegate cellImgClick:[tap view].tag];
}

- (void)setActivityImg
{
    self.activityIv.hidden = NO;
    self.activityIv.userInteractionEnabled = YES;
    [self.activityIv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.activityArr[0][@"images"][0][@"file_name"]]]];
}

- (void)deleteActivityImg
{
    self.activityIv.hidden = YES;
    self.activityIv.userInteractionEnabled = NO;
}

@end
