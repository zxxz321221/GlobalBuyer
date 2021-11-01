//
//  ReceivingAreaViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/11/15.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "ReceivingAreaViewController.h"
#import "FileArchiver.h"
#import "AppDelegate+RootController.h"

@interface ReceivingAreaViewController ()

@property (nonatomic,strong)NSMutableArray *selectCountryArr;
@property (nonatomic,strong)UIView *backV;
@property (nonatomic,strong)UIImageView *backIv;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UIScrollView *countrySV;
@property (nonatomic,assign) NSInteger countryTag;
@property (nonatomic,strong)UIButton *sureBtn;

@end

@implementation ReceivingAreaViewController

- (NSMutableArray *)selectCountryArr
{
    if (_selectCountryArr == nil) {
        _selectCountryArr = [[NSMutableArray alloc]init];
    }
    return _selectCountryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downLoadCountry];
}

- (void)downLoadCountry
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
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
    
    NSArray *readArr = [FileArchiver readFileArchiver:@"Country"];
    if (readArr != nil) {
        self.selectCountryArr = [NSMutableArray arrayWithArray:readArr];
        [self createUI];
    }
    
    NSDictionary *param = @{@"api_id":API_ID,
                            @"api_token":TOKEN,
                            @"locale":language};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:RegionApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"responseObject%@",responseObject);
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.selectCountryArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.selectCountryArr addObject:dict];
            }
            if (readArr == nil) {
                [self createUI];
            }
            [FileArchiver writeFileArchiver:@"Country" withArray:self.selectCountryArr];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self initData:language];
        [self createUI];

        [hud hideAnimated:YES];
    }];

}

- (void)initData:(NSString *)language{
  
    if (self.selectCountryArr == nil||self.selectCountryArr.count == 0) {

        if ([language isEqualToString:@"zh_CN"]||[language isEqualToString:@"zh_TW"]) {
            self.selectCountryArr = [[NSMutableArray alloc]initWithArray:
            @[@{
                  @"country_short" : @"CN",
                  @"created_at" : @"2017-09-04 11:35:25",
                  @"currency" : @"CNY",
                  @"id" : @"1",
                  @"locale" : @"zh_CN",
                  @"name" : @"中国",
                  @"parent_id" : @"1",
                  @"sign" : @"CHINA",
                  @"updated_at" : @"2018-05-04 10:36:26"
            },
              @{
                  @"country_short" : @"US",
                  @"created_at" : @"2017-09-04 11:38:23",
                  @"currency" : @"USD",
                  @"id" : @"4",
                  @"locale" : @"zh_CN",
                  @"name" : @"美国",
                  @"parent_id" : @"4",
                  @"sign" : @"USA",
                  @"updated_at" : @"2018-05-04 10:36:28",
              },
              @{
                  @"country_short" : @"TW",
                  @"created_at" : @"2017-09-04 11:39:31",
                  @"currency" : @"TWD",
                  @"id" : @"5",
                  @"locale" : @"zh_CN",
                  @"name" : @"台湾",
                  @"parent_id" : @"2",
                  @"sign" : @"TAIWAN",
                  @"updated_at" : @"2020-01-22 09:40:04",
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:40:00",
                  @"currency" : @"JPY",
                  @"id" : @"6",
                  @"locale" : @"zh_CN",
                  @"name" : @"日本",
                  @"parent_id" : @"2",
                  @"sign" : @"JAPAN",
                  @"updated_at" : @"2017-09-08 10:46:26"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:41:24",
                  @"currency" : @"GBP",
                  @"id" : @"7",
                  @"locale" : @"zh_CN",
                  @"name" : @"英国",
                  @"parent_id" : @"3",
                  @"sign" : @"UK",
                  @"updated_at" : @"2017-09-08 10:46:26"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:44:34",
                  @"currency" : @"EUR",
                  @"id" : @"3",
                  @"locale" : @"zh_CN",
                  @"name" : @"德国",
                  @"parent_id" : @"3",
                  @"sign" : @"GERMANY",
                  @"updated_at" : @"2017-09-08 10:46:52"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:45:25",
                  @"currency" : @"EUR",
                  @"id" : @"9",
                  @"locale" : @"zh_CN",
                  @"name" : @"法国",
                  @"parent_id" : @"21",
                  @"sign" : @"FRANCE",
                  @"updated_at" : @"2017-09-08 10:47:37"
              },
              @{
                  
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:45:25",
                  @"currency" : @"KRW",
                  @"id" : @"28",
                  @"locale" : @"en",
                  @"name" : @"韩国",
                  @"parent_id" : @"2",
                  @"sign" : @"KOREA",
                  @"updated_at" : @"2017-09-20 10:59:50"
              },
              @{
                  @"country_short" : @"AUS",
                  @"created_at" : @"2017-11-08 16:03:00",
                  @"currency" : @"AUD",
                  @"id" : @"31",
                  @"locale" : @"zh_CN",
                  @"name" : @"澳大利亚",
                  @"parent_id" : @"31",
                  @"sign" : @"AUS",
                  @"updated_at" : @"2017-11-16 09:12:49"
                  
              }, @{
                   @"country_short" : @"HK",
                   @"created_at" : @"2017-11-08 16:03:00",
                   @"currency" : @"HKD",
                   @"id" : @"49",
                   @"locale" : @"zh_CN",
                   @"name" : @"香港",
                   @"parent_id" : @"2",
                   @"sign" : @"HK",
                   @"updated_at" : @"2017-11-16 09:12:49"
              }
            ]];
        }else{
            self.selectCountryArr = [[NSMutableArray alloc]initWithArray:
            @[@{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:35:25",
                  @"currency" : @"CNY",
                  @"id" : @"19",
                  @"locale" : @"en",
                  @"name" : @"China",
                  @"parent_id" : @"19",
                  @"sign" : @"CHINA",
                  @"updated_at" : @"2017-11-01 15:41:56"
            },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:38:23",
                  @"currency" : @"USD",
                  @"id" : @"22",
                  @"locale" : @"en",
                  @"name" : @"America",
                  @"parent_id" : @"22",
                  @"sign" : @"USA",
                  @"updated_at" : @"2017-11-01 15:42:10",
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:39:31",
                  @"currency" : @"TWD",
                  @"id" : @"23",
                  @"locale" : @"en",
                  @"name" : @"Taiwan",
                  @"parent_id" : @"20",
                  @"sign" : @"TAIWAN",
                  @"updated_at" : @"2017-09-08 10:45:55",
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:40:00",
                  @"currency" : @"JPY",
                  @"id" : @"24",
                  @"locale" : @"en",
                  @"name" : @"Japan",
                  @"parent_id" : @"20",
                  @"sign" : @"JAPAN",
                  @"updated_at" : @"2017-09-08 10:46:26"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:41:24",
                  @"currency" : @"GBP",
                  @"id" : @"25",
                  @"locale" : @"en",
                  @"name" : @"England",
                  @"parent_id" : @"21",
                  @"sign" : @"UK",
                  @"updated_at" : @"2017-09-08 10:46:26"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:44:34",
                  @"currency" : @"EUR",
                  @"id" : @"26",
                  @"locale" : @"en",
                  @"name" : @"Germany",
                  @"parent_id" : @"21",
                  @"sign" : @"GERMANY",
                  @"updated_at" : @"2017-09-08 10:46:52"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:45:25",
                  @"currency" : @"EUR",
                  @"id" : @"27",
                  @"locale" : @"en",
                  @"name" : @"France",
                  @"parent_id" : @"21",
                  @"sign" : @"FRANCE",
                  @"updated_at" : @"2017-09-08 10:47:37"
              },
              @{
                  
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-09-04 11:45:25",
                  @"currency" : @"KRW",
                  @"id" : @"30",
                  @"locale" : @"en",
                  @"name" : @"KOREA",
                  @"parent_id" : @"20",
                  @"sign" : @"KOREA",
                  @"updated_at" : @"2017-09-20 10:59:50"
              },
              @{
                  @"country_short" : @"<null>",
                  @"created_at" : @"2017-11-08 16:03:00",
                  @"currency" : @"USD",
                  @"id" : @"33",
                  @"locale" : @"en",
                  @"name" : @"Australia",
                  @"parent_id" : @"33",
                  @"sign" : @"AUS",
                  @"updated_at" : @"2017-11-16 09:12:49"
                  
              }
            ]];
        }
        
        [FileArchiver writeFileArchiver:@"Country" withArray:self.selectCountryArr];
    }
}

- (void)createUI{
    [self.view addSubview:self.backV];
}

- (UIView *)backV
{
    if (_backV == nil) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [_backV addSubview:self.backIv];
        [_backV addSubview:self.titleLb];
        [_backV addSubview:self.countrySV];
        [_backV addSubview:self.sureBtn];
    }
    return _backV;
}

- (UIImageView *)backIv
{
    if (_backIv == nil) {
        _backIv = [[UIImageView alloc]initWithFrame:self.backV.bounds];
        _backIv.image = [UIImage imageNamed:@"CountryBack"];
    }
    return _backIv;
}

- (UILabel *)titleLb
{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenW - 20, 40)];
        _titleLb.font = [UIFont systemFontOfSize:18];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.text = NSLocalizedString(@"GlobalBuyer_Selectcurrency", nil);
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UIScrollView *)countrySV
{
    if (_countrySV == nil) {
        _countrySV = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 110, kScreenW - 100, kScreenH - 300)];
        _countrySV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _countrySV.layer.cornerRadius = 20;
        _countrySV.contentSize = CGSizeMake(0, 20+42*self.selectCountryArr.count);
        int tmpI = 0;
        for (int i = 0; i < self.selectCountryArr.count; i++) {
            UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(20, 20 + i*42, 200, 40)];
            iv.tag = 1000+i;
            iv.userInteractionEnabled = YES;
            [_countrySV addSubview:iv];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
            [btn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
            btn.tag = 2000+i;
            btn.userInteractionEnabled = NO;
            [iv addSubview:btn];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 100, 30)];
            lb.textColor = [UIColor blackColor];
            lb.text = [NSString stringWithFormat:@"%@",self.selectCountryArr[i][@"name"]];
            lb.tag = 3000+i;
            [iv addSubview:lb];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"currencySign"]isEqualToString:self.selectCountryArr[i][@"sign"]]) {
                btn.selected = YES;
                self.countryTag = 1000;
                lb.textColor = [UIColor colorWithRed:162.0/255.0 green:83.0/255.0 blue:232.0/255.0 alpha:1];
                tmpI++;
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCurrency:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [iv addGestureRecognizer:tap];
        }
        
        if (tmpI == 0) {
            // 获得当前iPhone使用的语言
            NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
            NSLog(@"当前使用的语言：%@",currentLanguage);
            NSString *language;
            if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
                language = @"CHINA";
            }else if([currentLanguage isEqualToString:@"zh-Hant"]){
                language = @"TAIWAN";
            }else if([currentLanguage isEqualToString:@"en"]){
                language = @"USA";
            }else if([currentLanguage isEqualToString:@"Japanese"]){
                language = @"JAPAN";
            }else{
                language = @"CHINA";
            }
            for (int i = 0; i < self.selectCountryArr.count; i++) {
                if ([language isEqualToString:self.selectCountryArr[i][@"sign"]]) {
                    UIView *iv = [_countrySV viewWithTag:1000+i];
                    UIButton *btn = [iv viewWithTag:2000+i];
                    UILabel *lb = [iv viewWithTag:3000+i];
                    btn.selected = YES;
                    self.countryTag = 1000+i;
                    lb.textColor = [UIColor colorWithRed:162.0/255.0 green:83.0/255.0 blue:232.0/255.0 alpha:1];
                }
            }
        }
    }
    return _countrySV;
}

- (void)selectCurrency:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < self.selectCountryArr.count; i++) {
        UIView *iv = (UIView *)[self.countrySV viewWithTag:i + 1000];
        if (iv.tag == [tap view].tag) {
            UIButton *btn = (UIButton *)[iv viewWithTag:i+2000];
            btn.selected = YES;
            UILabel *lb = (UILabel *)[iv viewWithTag:i+3000];
            lb.textColor = [UIColor colorWithRed:162.0/255.0 green:83.0/255.0 blue:232.0/255.0 alpha:1];
            self.countryTag = [tap view].tag;
        }else{
            UIButton *btn = (UIButton *)[iv viewWithTag:i+2000];
            UILabel *lb = (UILabel *)[iv viewWithTag:i+3000];
            lb.textColor = [UIColor blackColor];
            btn.selected = NO;
        }
    }
}

- (UIButton *)sureBtn
{
    if (_sureBtn == nil) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, kScreenH - 150, kScreenW - 100, 50)];
        _sureBtn.backgroundColor = [UIColor colorWithRed:175.0/255.0 green:115.0/255.0 blue:237.0/255.0 alpha:1];
        _sureBtn.layer.cornerRadius = 25;
        [_sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)sureClick
{
    if (self.selectCountryArr.count == 0) {
        [UserDefault setObject:@"CNY" forKey:@"currency"];
        [UserDefault setObject:@"CHINA" forKey:@"currencySign"];
        [UserDefault setObject:@"中国" forKey:@"currencyName"];
    }else{
        [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"currency"] forKey:@"currency"];
        [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"sign"] forKey:@"currencySign"];
        [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"name"] forKey:@"currencyName"];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"isOne" forKey:@"isOne"];
    [user synchronize];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate gotoHomeVC];
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
