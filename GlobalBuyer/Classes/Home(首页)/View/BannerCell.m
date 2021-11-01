//
//  BannerCell.m
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//
//#define Main_Color [UIColor colorWithRed:0.50 green:0.76 blue:0.25 alpha:1]
#define Cell_BgColor  [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kTabBarH        49.0f
#define kStatusBarH     20.0f
#define kNavigationBarH 44.0f

#import "BannerCell.h"
#import "BannerModel.h"
#import "UIImageView+WebCache.h"
#import "CategoryModel.h"

@implementation BannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = Cell_BgColor;
    }
    return self;
}

-(void)addSubviews {

    [self.contentView addSubview:self.scrollView];
//    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.arcV];
    [self.contentView addSubview:self.noviceV];
    [self.contentView addSubview:self.amazonV];
    
    [self.contentView addSubview:self.firstV];
    
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        [self.contentView addSubview:self.secondV];
    }else if([currentLanguage isEqualToString:@"en"]){
        [self.contentView addSubview:self.secondV];
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        [self.contentView addSubview:self.secondV];
    }else{
        
    }
    
    [self.contentView addSubview:self.thirdV];
    
//    [self.contentView addSubview:self.newyearBackV];
    [self.contentView addSubview:self.webBackV];
    
//    [self.contentView addSubview:self.goodsTitleV];
}

- (UILabel *)noviceV
{
    if (_noviceV == nil) {
        _noviceV = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.scrollView.frame) -10, kScreenW - 60, 30)];
        _noviceV.userInteractionEnabled = YES;
        UILabel *noviceText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _noviceV.frame.size.width - 50, 30)];
        noviceText.textAlignment = NSTextAlignmentRight;
        noviceText.text = NSLocalizedString(@"GlobalBuyer_home_bannerTitle", nil);
        noviceText.textColor = Main_Color;
        [_noviceV addSubview:noviceText];
        UIImageView *markIv = [[UIImageView alloc]initWithFrame:CGRectMake(_noviceV.frame.size.width - 40, 5, 20, 20)];
        markIv.image = [UIImage imageNamed:@"首页叹号"];
        [_noviceV addSubview:markIv];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noviceClick)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [_noviceV addGestureRecognizer:tap];
    }
    return _noviceV;
}

- (void)noviceClick
{
    [self.delegate clickNovice];
}

- (UIView *)arcV
{
    if (_arcV == nil) {
//        _arcV = [[UIView alloc]initWithFrame:CGRectMake(-1200, CGRectGetMaxY(self.scrollView.frame) -15, kScreenW + 2400, 50)];
//
//        _arcV.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
//        _arcV.layer.cornerRadius = (kScreenW + 2400)/2;

        _arcV = [[UIView alloc]initWithFrame:CGRectMake(-150, CGRectGetMaxY(self.scrollView.frame) -15, kScreenW+300, 50)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:_arcV.bounds];
        imageView.image = [UIImage imageNamed:@"ic_home_acr"];
        [_arcV addSubview:imageView];
    }
    return _arcV;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
       
        _pageControl.currentPageIndicatorTintColor = Main_Color;
        _pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 60, kScreenW, 30);
        
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenW, kScreenW/2.5);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        //_scrollView.contentOffset = CGPointMake(kScreenW, 0);
        self.start = YES;
    }
    return _scrollView;
}

- (UIView *)amazonV
{
    if (_amazonV == nil) {
        _amazonV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenW/2.5 + [Unity countcoordinatesW:20] , kScreenW, [Unity countcoordinatesH:85])];
        _amazonV.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
//        NSArray *arr = @[@"首页分类",@"首页淘宝集运",@"首页全球好站",@"首页品牌库"];
        NSArray * arr = @[@"首页淘宝集运",@"淘宝转运",@"海淘咨询",@"找商品"];
//        NSString *str1 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_Classification", nil);
//        NSString *str2 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_TaobaoCollection", nil);
//        NSString *str3 = NSLocalizedString(@"GlobalBuyer_Home_GlobalClassification", nil);
//        NSString *str4 = NSLocalizedString(@"GlobalBuyer_Amazon_Brand", nil);
        NSString *str1 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_TaobaoCollection", nil);
        NSString *str2 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_TB_Transport", nil);
        NSString *str3 = NSLocalizedString(@"GlobalBuyer_Amazon_OverseasShoppingInformation", nil);
        NSString *str4 = NSLocalizedString(@"GlobalBuyer_Home_HeaderView_LookingGoods", nil);
        NSArray *strArr = @[str1,str2,str3,str4];
        
        for (int i = 0; i < arr.count; i++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/4*i + (kScreenW/4-[Unity countcoordinatesW:50])/2, [Unity countcoordinatesH:10],[Unity countcoordinatesW:50], [Unity countcoordinatesH:50])];
            iv.image = [UIImage imageNamed:arr[i]];
            iv.tag = i + 200;
            iv.userInteractionEnabled = YES;
            [_amazonV addSubview:iv];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAmazonOrOther:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [iv addGestureRecognizer:tap];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/4*i + (kScreenW/4 - [Unity countcoordinatesW:80])/2, [Unity countcoordinatesH:60], [Unity countcoordinatesW:80], [Unity countcoordinatesH:25])];
            lb.text = strArr[i];
            lb.textColor = [Unity getColor:@"#333333"];
            lb.font = [UIFont systemFontOfSize:16];
            lb.textAlignment = NSTextAlignmentCenter;
            [_amazonV addSubview:lb];
        }
    }
    return _amazonV;
}

- (UIView *)firstV
{
    if (_firstV == nil) {
        _firstV = [[UIView alloc]initWithFrame:CGRectMake(10, kScreenW/2.5 + [Unity countcoordinatesH:90] + 10, kScreenW - 20, 130)];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:_firstV.bounds];
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            iv.image = [UIImage imageNamed:@"首页展示图一简1"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            iv.image = [UIImage imageNamed:@"首页展示图一繁1"];
        }else if([currentLanguage isEqualToString:@"en"]){
            iv.image = [UIImage imageNamed:@"首页展示图一英"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            iv.image = [UIImage imageNamed:@"首页展示图一日"];
        }else{
            iv.image = [UIImage imageNamed:@"首页展示图一简1"];
        }
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOneImg)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tap];
        [_secondV addSubview:iv];
        [_firstV addSubview:iv];
    }
    return _firstV;
}

- (void)clickOneImg
{
    [self.delegate clickOneImg];
}

- (UIView *)secondV
{
    if (_secondV == nil) {
        _secondV = [[UIView alloc]initWithFrame:CGRectMake(10, kScreenW/2.5 + [Unity countcoordinatesH:90] + 10 + 130, kScreenW - 20, 130)];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:_secondV.bounds];
        iv.layer.cornerRadius = 10;
        iv.clipsToBounds = YES;
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            iv.image = [UIImage imageNamed:@"首页展示图二繁"];
        }else if([currentLanguage isEqualToString:@"en"]){
            iv.image = [UIImage imageNamed:@"首页展示图二英"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            iv.image = [UIImage imageNamed:@"首页展示图二日"];
        }else{
        }
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTwoImg)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tap];
        [_secondV addSubview:iv];
    }
    return _secondV;
}

- (void)clickTwoImg
{
    [self.delegate clickTwoImg];
}

- (UIView *)thirdV
{
    if (_thirdV == nil) {
        _thirdV = [[UIView alloc]initWithFrame:CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130, kScreenW - 20, 150)];
        UIImageView *iv = [[UIImageView alloc]initWithFrame:_thirdV.bounds];
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            _thirdV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130, kScreenW - 20, 150);
            iv.image = [UIImage imageNamed:@"首页展示图三简"];
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            iv.image = [UIImage imageNamed:@"首页展示图三繁"];
        }else if([currentLanguage isEqualToString:@"en"]){
            iv.image = [UIImage imageNamed:@"首页展示图三英"];
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            iv.image = [UIImage imageNamed:@"首页展示图三日"];
        }else{
            _thirdV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130, kScreenW - 20, 150);
            iv.image = [UIImage imageNamed:@"首页展示图三简"];
        }
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickThreeImg)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tap];
        
        [_thirdV addSubview:iv];
    }
    return _thirdV;
}

- (void)clickThreeImg
{
    [self.delegate clickThreeImg];
}

- (void)selectAmazonOrOther:(UITapGestureRecognizer *)tap
{
    NSLog(@"selectAmazonOrOther");
    [self.delegate selectAmazonOrOthers:[tap view].tag];
}

-(void)setImgArr:(NSMutableArray *)imgArr{
    
    __block int timerNum = 0;
    _imgArr = imgArr;
    if (_imgArr == nil) {
        return;
    }
    
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    self.scrollView.contentSize = CGSizeMake(kScreenW*_imgArr.count, 0);
    for (int i = 0; i < _imgArr.count; i++) {
        BannerModel * model = _imgArr[i];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, kScreenW/2.5)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,model.image]]];
        img.tag = 10 + i;
        [self.scrollView addSubview:img];
        
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1; //点击次数
        tapGesture.numberOfTouchesRequired = 1; //点击手指数
        
        [img addGestureRecognizer:tapGesture];
    }

    if (_imgArr.count > 1 && self.start == YES) {
        self.start = NO;
        self.currentTimerNum = timerNum;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(RollTheBanner) userInfo:nil repeats:YES];
    }
    self.pageControl.numberOfPages = _imgArr.count;
  
}

- (void)RollTheBanner
{
    if (self.currentTimerNum == _imgArr.count) {
        self.currentTimerNum = 0;
        [UIView animateWithDuration:1 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = CGPointMake(kScreenW * self.currentTimerNum, 0);
        self.pageControl.currentPage = self.currentTimerNum;
    }];
    self.currentTimerNum++;
}

- (UIView *)newyearBackV{
    if (_newyearBackV == nil) {
        _newyearBackV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110, kScreenW, 0)];
    }
    return _newyearBackV;
}

-(void)setNewyearArr:(NSMutableArray *)newyearArr{
    _newyearArr = newyearArr;
    if (_newyearArr == nil) {
        return;
    }
    
    self.newyearBackV.frame = CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110, kScreenW, 100*newyearArr.count);
    
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        self.webBackV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 100 + 100*newyearArr.count + 10, kScreenW - 20, 250);
        self.newyearBackV.frame = CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 100, kScreenW, 100*newyearArr.count);
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        self.webBackV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110 + 100*newyearArr.count + 10, kScreenW - 20, 250);
        self.newyearBackV.frame = CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110, kScreenW, 100*newyearArr.count);
    }else if([currentLanguage isEqualToString:@"en"]){
        self.webBackV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110 + 100*newyearArr.count + 10, kScreenW - 20, 250);
        self.newyearBackV.frame = CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110, kScreenW, 100*newyearArr.count);
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        self.webBackV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110 + 100*newyearArr.count + 10, kScreenW - 20, 250);
        self.newyearBackV.frame = CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110, kScreenW, 100*newyearArr.count);
    }else{
        self.webBackV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 100 + 100*newyearArr.count + 10, kScreenW - 20, 250);
        self.newyearBackV.frame = CGRectMake(0, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 100, kScreenW, 100*newyearArr.count);
    }
    
    
    for (int i = 0 ; i < newyearArr.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0+100*i, kScreenW, 100)];
        iv.tag = i;
        iv.userInteractionEnabled = YES;
        [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,newyearArr[i][@"pic"]]]];
        [self.newyearBackV addSubview:iv];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNewYear:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tap];
    }

}

- (void)clickNewYear:(UITapGestureRecognizer *)tap{
    [self.delegate clickNewYearWithId:[NSString stringWithFormat:@"%@",self.newyearArr[[tap view].tag][@"id"]] tag:[tap view].tag];
}

- (UIView *)webBackV
{
    if (_webBackV == nil) {
        _webBackV = [[UIView alloc]initWithFrame:CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 130 + 110, kScreenW - 20, 250)];
        _webBackV.backgroundColor = [UIColor whiteColor];
        _webBackV.layer.cornerRadius = 10;
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            _webBackV.frame = CGRectMake(10, kScreenW/2.5 +  [Unity countcoordinatesH:90] + 10 + 130 + 100, kScreenW - 20, 250);
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        }else if([currentLanguage isEqualToString:@"en"]){
        }else if([currentLanguage isEqualToString:@"Japanese"]){
        }else{
            _webBackV.frame = CGRectMake(10, kScreenW/2.5 + 100 + 10 + 130 + 100, kScreenW - 20, 250);
        }
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
        titleLb.textColor = Main_Color;
        titleLb.font = [UIFont systemFontOfSize:18];
        titleLb.text = NSLocalizedString(@"GlobalBuyer_Home_GlobalClassification", nil);
        [_webBackV addSubview:titleLb];
        
        UILabel *subTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(105, 12, 240, 20)];
        subTitleLb.textColor = Main_Color;
        subTitleLb.font = [UIFont systemFontOfSize:12];
        subTitleLb.text = NSLocalizedString(@"GlobalBuyer_home_Preferential_2330", nil);
        [_webBackV addSubview:subTitleLb];
        
        UILabel *bottomLb = [[UILabel alloc]initWithFrame:CGRectMake(_webBackV.frame.size.width/2 - 100, 205, 200, 50)];
        bottomLb.textAlignment = NSTextAlignmentCenter;
        bottomLb.textColor = Main_Color;
        bottomLb.text = NSLocalizedString(@"GlobalBuyer_home_more", nil);
        [_webBackV addSubview:bottomLb];
        bottomLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMore)];
        tapG.numberOfTapsRequired = 1;
        tapG.numberOfTouchesRequired = 1;
        [bottomLb addGestureRecognizer:tapG];
    }
    return _webBackV;
}

- (void)clickMore
{
    [self.delegate clickGlobalWebMore];
}

- (void)setWebArr:(NSMutableArray *)webArr
{
    _webArr = webArr;
    if (_webArr == nil) {
        return;
    }
    
    for (int i = 0; i < _webArr.count; i++) {
        if (i == 9) {
            break;
        }
        CategoryModel * model = _webArr[i];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (i%3 * ((self.webBackV.frame.size.width - 20)/3) + 5), 40 + 60*(i/3) ,(self.webBackV.frame.size.width - 20)/3 - 10, 50)];
        img.layer.borderColor = [UIColor lightGrayColor].CGColor;
        img.layer.borderWidth = 0.5;
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,model.image]]];
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(webImgClick:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [img addGestureRecognizer:tap];
//        img.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//        tapGesture.numberOfTapsRequired = 1; //点击次数
//        tapGesture.numberOfTouchesRequired = 1; //点击手指数
//        [img addGestureRecognizer:tapGesture];
        [self.webBackV addSubview:img];
    }
    
}

-(void)tapGesture:(UITapGestureRecognizer *)tap {
    BannerModel * model = self.imgArr[ [tap view].tag - 10];
    [self.delegate cellImgClickWithLink:model.href withImg:model.image type:model.type url:model.list_url];
}

- (void)webImgClick:(UITapGestureRecognizer *)tap
{
    CategoryModel * model = _webArr[[tap view].tag-1000];
    NSString *linkStr = [NSString stringWithFormat:@"%@",model.link];
    [self.delegate clickWebWithLink:linkStr];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pages = scrollView.contentOffset.x/kScreenW ;
    //NSLog(@"%f",scrollView.contentOffset.x);
    self.pageControl.currentPage = pages;
    //NSLog(@"%ld",self.pageControl.currentPage);
}
@end
