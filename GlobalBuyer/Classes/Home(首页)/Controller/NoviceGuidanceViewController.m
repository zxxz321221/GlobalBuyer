//
//  NoviceGuidanceViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/4/9.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "NoviceGuidanceViewController.h"
#import "HelpListViewController.h"
#import "HelpDetailViewController.h"

@interface NoviceGuidanceViewController ()

@property(nonatomic,strong)UIScrollView *guidanceSV;
@property(nonatomic,strong)NSDictionary *firstSource;
@property(nonatomic,strong)NSDictionary *secondSource;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation NoviceGuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Help", nil);
    
    [self downFirstData];
}

- (UIScrollView *)guidanceSV
{
    if (_guidanceSV == nil) {
        _guidanceSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64)];
        NSArray *imgNameArr = @[@"guidance-first",@"guidance-second",@"guidance-third"];
        for (int i = 0 ; i < imgNameArr.count; i++) {
            UIImageView *guidanceIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + i*(kScreenW/2.5) , kScreenW - 40, kScreenW/2.5 - 20)];
            guidanceIv.userInteractionEnabled = YES;
            guidanceIv.image = [UIImage imageNamed:imgNameArr[i]];
            guidanceIv.tag = 100+i;
            [_guidanceSV addSubview:guidanceIv];
            UITapGestureRecognizer *guidanceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guidanceClick:)];
            guidanceTap.numberOfTapsRequired = 1;
            guidanceTap.numberOfTouchesRequired = 1;
            [guidanceIv addGestureRecognizer:guidanceTap];
        }
        _guidanceSV.contentSize = CGSizeMake(0, 20 + kScreenW/2.5*3);
    }
    return _guidanceSV;
}

- (void)createUI
{
    [self.view addSubview:self.guidanceSV];
}

- (void)downFirstData
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    self.hud.label.text= NSLocalizedString(@"GlobalBuyer_Loading", nil);
    
    
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
    }
    
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"name":@"shopping-process",
                             @"sign":@"symbol",
                             @"locale":language};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:HelpOneApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.firstSource = responseObject[@"data"];
        }
        [self downSecondData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downSecondData
{
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
    }
    
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"name":@"taobaoFreight",
                             @"sign":@"symbol",
                             @"locale":language};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:HelpOneApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.secondSource = responseObject[@"data"];
        }
        [self createUI];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)guidanceClick:(UITapGestureRecognizer *)tap
{
    if ([tap view].tag == 100) {
        HelpDetailViewController *helpDetailVC = [HelpDetailViewController new];
        helpDetailVC.hidesBottomBarWhenPushed = YES;
        helpDetailVC.bodyStr = self.firstSource[@"body"];
        helpDetailVC.navigationItem.title = self.firstSource[@"title"];
        [self.navigationController pushViewController:helpDetailVC animated:YES];
    }
    
    if ([tap view].tag == 101) {
        return;
        HelpDetailViewController *helpDetailVC = [HelpDetailViewController new];
        helpDetailVC.hidesBottomBarWhenPushed = YES;
        helpDetailVC.bodyStr = self.secondSource[@"body"];
        helpDetailVC.navigationItem.title = self.secondSource[@"title"];
        [self.navigationController pushViewController:helpDetailVC animated:YES];
    }
    
    if ([tap view].tag == 102) {
        HelpListViewController *helpDetailVC = [HelpListViewController new];
        helpDetailVC.hidesBottomBarWhenPushed = YES;
        helpDetailVC.bodyTitleArr = self.qaaSource;
        helpDetailVC.navigationItem.title = NSLocalizedString(@"GlobalBuyer_HelpViewController_QAA", nil);
        [self.navigationController pushViewController:helpDetailVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
