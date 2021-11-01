//
//  BrandSearchViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/29.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "BrandSearchViewController.h"
#import "NewSearchCollectionViewCell.h"
#import<CommonCrypto/CommonDigest.h>
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"
#import "GlobalShopDetailViewController.h"

@interface BrandSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic,strong)NSMutableArray *moneytypeArr;

@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)BOOL searching;
@property(nonatomic,strong)NSString *originalType;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)NSMutableArray *largeClassDataSource;
@property (nonatomic,strong)NSMutableArray *smallClassDataSource;

@property (nonatomic,strong)NSMutableArray *searchSource;

@property (nonatomic,strong)NSMutableArray *jdDataSource;
@property (nonatomic,strong)NSMutableArray *tbDataSource;
@property (nonatomic,strong)NSMutableArray *amDataSource;
@property (nonatomic,strong)NSMutableArray *tmDataSource;
@property (nonatomic,strong)NSMutableArray *allDataSource;
@property (nonatomic,strong)NSMutableArray *deleteSource;

@property (nonatomic,strong)UIView *sourceBackV;
@property (nonatomic,strong)UIButton *JDBtn;
@property (nonatomic,strong)UIButton *TaobaoBtn;
@property (nonatomic,strong)UIButton *TmallBtn;
@property (nonatomic,strong)UIButton *Amazonbtn;

@property (nonatomic,strong)NSMutableArray *ebDataSource;

@property (nonatomic,strong)NSString *sourceNum;//0.ALL 1.淘宝 2.天猫 3.京东 4.亚马孙

@property (nonatomic,strong)UITextField *searchTf;
@property (nonatomic,strong)UIView *magnifierV;
@property (nonatomic,strong)UIImageView *currentWebIconIV;
@property (nonatomic,strong)UILabel *currentWebLb;
@property (nonatomic,strong)UIView *changeWebIconV;

@property (nonatomic,strong)NSString *currentSearchStr;
@property (nonatomic,strong)NSString *currentENSearchStr;
@property (nonatomic,strong)NSString *currentClassStr;
@property (nonatomic,assign)BOOL searchOrClassification;

@property (nonatomic,strong)NSMutableArray *webArr;
@property (nonatomic,strong)NSString *page;
@end

@implementation BrandSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    [self.searchSource addObject:@"JD"];
    [self.searchSource addObject:@"Taobao"];
    [self.searchSource addObject:@"Tmall"];
    [self.searchSource addObject:@"Amazon"];
    self.searching = NO;
    self.sourceNum = @"0";
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSString *language;
    if([currentLanguage isEqualToString:@"zh-Hant"]){
        self.title = self.keyWordsTw;
    }else if([currentLanguage isEqualToString:@"en"]){
        self.title = self.keyWordsEn;
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        self.title = self.keyWordsJp;
    }else{
        self.title = self.keyWords;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    //    [self downExternalEbayDataPage];
    [self downloadMoneytype];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [self.hud hideAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}

//初始化汇率数据源
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}


-(NSMutableArray *)ebDataSource {
    if (_ebDataSource == nil) {
        _ebDataSource = [NSMutableArray new];
    }
    return _ebDataSource;
}


- (NSMutableArray *)largeClassDataSource
{
    if (_largeClassDataSource == nil) {
        _largeClassDataSource = [[NSMutableArray alloc]init];
    }
    return _largeClassDataSource;
}

- (NSMutableArray *)smallClassDataSource
{
    if (_smallClassDataSource == nil) {
        _smallClassDataSource = [[NSMutableArray alloc]init];
    }
    return _smallClassDataSource;
}

- (NSMutableArray *)jdDataSource
{
    if (_jdDataSource == nil) {
        _jdDataSource = [[NSMutableArray alloc]init];
    }
    return _jdDataSource;
}
- (NSMutableArray *)tbDataSource
{
    if (_tbDataSource == nil) {
        _tbDataSource = [[NSMutableArray alloc]init];
    }
    return _tbDataSource;
}
- (NSMutableArray *)amDataSource
{
    if (_amDataSource == nil) {
        _amDataSource = [[NSMutableArray alloc]init];
    }
    return _amDataSource;
}
- (NSMutableArray *)tmDataSource
{
    if (_tmDataSource == nil) {
        _tmDataSource = [[NSMutableArray alloc]init];
    }
    return _tmDataSource;
}

- (NSMutableArray *)allDataSource
{
    if (_allDataSource == nil) {
        _allDataSource = [[NSMutableArray alloc]init];
    }
    return _allDataSource;
}

- (NSMutableArray *)deleteSource
{
    if (_deleteSource == nil) {
        _deleteSource = [[NSMutableArray alloc]init];
    }
    return _deleteSource;
}

- (NSMutableArray *)searchSource
{
    if (_searchSource == nil) {
        _searchSource = [[NSMutableArray alloc]init];
        
    }
    return _searchSource;
}

- (NSMutableArray *)webArr
{
    if (_webArr == nil) {
        _webArr = [[NSMutableArray alloc]init];
    }
    return _webArr;
}

//下载汇率
- (void)downloadMoneytype {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *param = @{@"api_id":API_ID,@"api_token":TOKEN};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:moneyTypeApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.moneytypeArr removeAllObjects];
        NSDictionary *dict = responseObject[@"data"];
        NSArray *fromArr = dict[@"from"];
        NSArray *toArr = dict[@"to"];
        for (int i = 0 ; i < fromArr.count; i++) {
            [self.moneytypeArr addObject:fromArr[i]];
        }
        for (int j = 0 ; j < toArr.count; j++) {
            [self.moneytypeArr addObject:toArr[j]];
        }
        
        [self downLoadWithSearchKeyWord:self.keyWords AmazonKeyWord:self.keyWordsEn];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self downLoadWithSearchKeyWord:self.keyWords AmazonKeyWord:self.keyWordsEn];
    }];
}

- (void)firstData
{
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage containsString:@"zh-Hans"]) {
        self.originalType = @"zh";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        self.originalType = @"cht";
    }else{
        self.originalType = @"auto";
    }
    
    //    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    //
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"appid":BaiDuAppid,
                             @"key":BaiDuKey,
                             @"q":self.keyWords,
                             @"salt":@"1521168024389",
                             @"from":self.originalType,
                             @"to":@"en",
                             @"sign":[self md5:[NSString stringWithFormat:@"%@%@%@%@",BaiDuAppid,self.keyWords,@"1521168024389",BaiDuKey]]};
    
    [manager POST:BaiDuTranslateApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        [self downLoadWithSearchKeyWord:self.keyWords AmazonKeyWord:responseObject[@"trans_result"][0][@"dst"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hideAnimated:YES];
    }];
}




////放大镜图标
//- (UIView *)magnifierV
//{
//    if (_magnifierV == nil) {
//        _magnifierV = [[UIView alloc]initWithFrame:CGRectMake(10, 64 + 10, 90, 35)];
//        _magnifierV.backgroundColor = [UIColor whiteColor];
//        _magnifierV.layer.borderWidth = 0.7;
//        _magnifierV.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _magnifierV.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeWebSource)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [_magnifierV addGestureRecognizer:tap];
//
//        self.currentWebIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
//        self.currentWebIconIV.image = [UIImage imageNamed:@"WebIconALL"];
//        [_magnifierV addSubview:self.currentWebIconIV];
//        self.currentWebLb = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 60 , 25)];
//        self.currentWebLb.textAlignment = NSTextAlignmentCenter;
//        self.currentWebLb.font = [UIFont systemFontOfSize:15];
//        self.currentWebLb.text = @"ALL";
//        [_magnifierV addSubview:self.currentWebLb];
//    }
//    return _magnifierV;
//}

//- (void)changeWebSource
//{
//    [self.view addSubview:self.changeWebIconV];
//}

//- (UIView *)changeWebIconV
//{
//    if (_changeWebIconV == nil) {
//        _changeWebIconV = [[UIView alloc]initWithFrame:CGRectMake(10, 64 + 10 + 35, 90, 35*5)];
//        _changeWebIconV.backgroundColor = [UIColor whiteColor];
//        _changeWebIconV.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _changeWebIconV.layer.borderWidth = 0.7;
//
//        NSArray *arr = @[@"WebIconALL",@"淘宝分类",@"天猫分类",@"京东分类",@"亚马逊分类"];
//        NSArray *arrName = @[@"ALL",@"TaoBao",@"Tmall",@"JD",@"Amazon"];
//        for (int i = 0 ; i < arr.count; i++) {
//            UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 35*i, 90, 35)];
//            backV.tag = i;
//            backV.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShopIcon:)];
//            tap.numberOfTapsRequired = 1;
//            tap.numberOfTouchesRequired = 1;
//            [backV addGestureRecognizer:tap];
//
//            UIImageView *webIconIv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5 , 25, 25)];
//            webIconIv.image = [UIImage imageNamed:arr[i]];
//            [backV addSubview:webIconIv];
//            UILabel *webNameLb = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 60, 25)];
//            webNameLb.textAlignment = NSTextAlignmentCenter;
//            webNameLb.text = arrName[i];
//            webNameLb.font = [UIFont systemFontOfSize:14];
//            [backV addSubview:webNameLb];
//            [_changeWebIconV addSubview:backV];
//
//        }
//    }
//    return _changeWebIconV;
//}

//- (void)clickShopIcon:(UITapGestureRecognizer *)tap
//{
//    if ([tap view].tag == 0) {
//        self.currentWebIconIV.image = [UIImage imageNamed:@"WebIconALL"];
//        self.currentWebLb.text = @"ALL";
//        self.sourceNum = @"0";
//    }
//    if ([tap view].tag == 1) {
//        self.currentWebIconIV.image = [UIImage imageNamed:@"淘宝分类"];
//        self.currentWebLb.text = @"TaoBao";
//        self.sourceNum = @"1";
//    }
//    if ([tap view].tag == 2) {
//        self.currentWebIconIV.image = [UIImage imageNamed:@"天猫分类"];
//        self.currentWebLb.text = @"Tmall";
//        self.sourceNum = @"2";
//    }
//    if ([tap view].tag == 3) {
//        self.currentWebIconIV.image = [UIImage imageNamed:@"京东分类"];
//        self.currentWebLb.text = @"JD";
//        self.sourceNum = @"3";
//    }
//    if ([tap view].tag == 4) {
//        self.currentWebIconIV.image = [UIImage imageNamed:@"亚马逊分类"];
//        self.currentWebLb.text = @"Amazon";
//        self.sourceNum = @"4";
//    }
//    [self.changeWebIconV removeFromSuperview];
//    self.changeWebIconV = nil;
//    if (self.searching == NO) {
//        return;
//    }else{
//        [self.collectionView reloadData];
//    }
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    // 获得当前iPhone使用的语言
//    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
//    NSLog(@"当前使用的语言：%@",currentLanguage);
//    if ([currentLanguage containsString:@"zh-Hans"]) {
//        self.originalType = @"zh";
//    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        self.originalType = @"cht";
//    }else{
//        self.originalType = @"auto";
//    }
//
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    NSDictionary *params = @{@"appid":BaiDuAppid,
//                             @"key":BaiDuKey,
//                             @"q":textField.text,
//                             @"salt":@"1521168024389",
//                             @"from":self.originalType,
//                             @"to":@"en",
//                             @"sign":[self md5:[NSString stringWithFormat:@"%@%@%@%@",BaiDuAppid,textField.text,@"1521168024389",BaiDuKey]]};
//
//    [manager POST:BaiDuTranslateApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        [self.hud hideAnimated:YES];
//        [self downLoadWithSearchKeyWord:textField.text AmazonKeyWord:responseObject[@"trans_result"][0][@"dst"]];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.hud hideAnimated:YES];
//    }];
//
//
//    return YES;
//}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)downLoadWithSearchKeyWord:(NSString *)keyWord AmazonKeyWord:(NSString *)AmazonKeyWord
{
    
    self.searchOrClassification = YES;
    self.currentSearchStr = keyWord;
    self.currentENSearchStr = AmazonKeyWord;
    
    //    [self.jdDataSource removeAllObjects];
    //    [self.tbDataSource removeAllObjects];
    //    [self.tmDataSource removeAllObjects];
    //    [self.amDataSource removeAllObjects];
    //    [self.allDataSource removeAllObjects];
    
    [self downWebLink];
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    //    parameters[@"api_id"] = API_ID;
    //    parameters[@"api_token"] = TOKEN;
    //    parameters[@"keyword"] = [NSString stringWithFormat:@"%@/%@/%@",self.keyWords,self.keyWordsEn,self.keyWordsJp];
    //    parameters[@"sort_key"] = @"1";
    //    parameters[@"more"] = @"1";
    //
    //    [manager GET:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/bykeyword/webapi/list" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //
    //
    //        [self.hud hideAnimated:YES];
    //
    //        if ([responseObject[@"code"]isEqualToString:@"success"]) {
    //
    //            [self.jdDataSource removeAllObjects];
    //            [self.tbDataSource removeAllObjects];
    //            [self.tmDataSource removeAllObjects];
    //            [self.amDataSource removeAllObjects];
    //            [self.allDataSource removeAllObjects];
    //
    //
    //
    //            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
    //                if ([responseObject[@"data"][i][@"good_site"]isEqualToString:@"ebay"]) {
    ////                    return ;
    //                }else{
    //                    [self.allDataSource addObject:responseObject[@"data"][i]];
    //                }
    //
    //            }
    //            for (int i = 0 ; i < self.allDataSource.count; i++) {
    //                NSString *tmpStr = self.allDataSource[i][@"good_name"];
    //                for (int j = i + 1; j < self.allDataSource.count; j++) {
    //                    if ([tmpStr isEqualToString:self.allDataSource[j][@"good_name"]]) {
    //                        [self.allDataSource removeObjectAtIndex:j];
    //                    }
    //                }
    //            }
    //            for (int i = 0; i < self.allDataSource.count; i++) {
    //                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"taobao"]) {
    //                    [self.tbDataSource addObject:self.allDataSource[i]];
    //                }
    //                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"jingdong"]) {
    //                    [self.jdDataSource addObject:self.allDataSource[i]];
    //                }
    //                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"tmall"]) {
    //                    [self.tmDataSource addObject:self.allDataSource[i]];
    //                }
    //                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"amazon-us"]) {
    //                    [self.amDataSource addObject:self.allDataSource[i]];
    //                }
    //            }
    //
    //        }
    //
    //        [self downWebLink];
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //
    //        [self.hud hideAnimated:YES];
    //        [self downLoadWithSearchKeyWord:keyWord AmazonKeyWord:AmazonKeyWord];
    //
    //    }];
    //
}

- (void)downWebLink
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
        parameters[@"keyword"] = [NSString stringWithFormat:@"%@",self.keyWords];
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
        parameters[@"keyword"] = [NSString stringWithFormat:@"%@",self.keyWordsTw];
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
        parameters[@"keyword"] = [NSString stringWithFormat:@"%@",self.keyWordsEn];
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
        parameters[@"keyword"] = [NSString stringWithFormat:@"%@",self.keyWordsJp];
    }else{
        language = @"zh_CN";
        parameters[@"keyword"] = [NSString stringWithFormat:@"%@",self.keyWords];
    }
    parameters[@"locale"] = [NSString stringWithFormat:@"%@",language];
    
    [manager GET:BrandSearchWeb parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        [self downExternalEbayDataPage];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.webArr removeAllObjects];
            
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.webArr addObject:responseObject[@"data"][i]];
            }
            
            
            self.searching = YES;
            [self.collectionView reloadData];
        }
        //        [self.hud hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self downExternalEbayDataPage];
        //        [self.hud hideAnimated:YES];
        
    }];
    
    
}

- (void)downExternalEbayDataPage{
    
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSDictionary *params = @{@"paginationInput.pageNumber":self.page,
                             @"keywords":self.keyWordsEn
    };
    
    [manager GET:@"https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=-0-PRD-0ea9e4abd-faed9a4b&REST-PAYLOAD&itemFilter(0).name=Currency&itemFilter(0).value=USD&itemFilter(1).name=HideDuplicateItems&itemFilter(1).value=true&outputSelector=SellerInfo&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=100" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"@count"]] isEqualToString:@"0"]) {
        }else{
            NSArray *tmpArr = responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"];
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"ebay";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"title"][0]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"https://www.ebay.com/itm/%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"itemId"][0]];
                tmpDict[@"good_pic"] = [NSString stringWithFormat:@"http://galleryplus.ebayimg.com/ws/web/%@_1_10_1.jpg",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"itemId"][0]];
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"sellingStatus"][0][@"currentPrice"][0][@"__value__"]];
                tmpDict[@"good_currency"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"sellingStatus"][0][@"currentPrice"][0][@"@currencyId"]];
                [self.ebDataSource addObject:tmpDict];
            }
        }
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.ebDataSource.count; i++) {
                [self.allDataSource addObject:self.ebDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.ebDataSource.count; i++) {
                [self.allDataSource insertObject:self.ebDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        [self downExternalJDDataPage];
//        [self.collectionView reloadData];
//        [self.hud hideAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self.hud hideAnimated:YES];
        [self downExternalJDDataPage];
    }];
}


- (void)downExternalJDDataPage{
    
    [self.jdDataSource removeAllObjects];
    [self.hud hideAnimated:NO];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml",@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *time = [self getCurrentTimes];
    

    NSString *mdStr = [NSString stringWithFormat:@"cf2109bc3d254ecba1a1a0b823b78bd1360buy_param_json{\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%@,\"pageSize\":100},\"orderField\":0}access_token031e8a1b04c545a6bc033929f200873amxztapp_key398230142d607c53011684710b966978methodjd.kpl.open.xuanpin.searchgoodstimestamp%@v1.0cf2109bc3d254ecba1a1a0b823b78bd1",self.keyWords,self.page,time];
    
    NSLog(@"mdStr============>%@",mdStr);

    
    NSString *url = [NSString stringWithFormat:@"https://api.jd.com/routerjson?access_token=031e8a1b04c545a6bc033929f200873amxzt&app_key=398230142d607c53011684710b966978&method=jd.kpl.open.xuanpin.searchgoods&v=1.0&timestamp=%@&360buy_param_json={\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%@,\"pageSize\":100},\"orderField\":0}&sign=%@",time,self.keyWords,self.page,[self md5:mdStr].uppercaseString];
    
    
    NSLog(@"url============>%@",url);
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:@"" progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        //获得的json先转换成字符串
                NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

                //字符串再生成NSData
                NSData * data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];

                //再解析
                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];


                NSMutableArray * jdArr = [[NSMutableArray alloc]init];
                NSArray *tmpArr = dicData[@"jd_kpl_open_xuanpin_searchgoods_responce"][@"searchgoodsResult"][@"result"][@"queryVo"];
                NSLog(@"tmpArr====>%@",tmpArr);
                NSLog(@"tmpArr.count====>%ld",tmpArr.count);
                
                if (tmpArr==nil ||tmpArr.count == 0) {
                }else{
                 
                    for (int i = 0 ; i < tmpArr.count ; i++) {
                        NSDictionary *dic = tmpArr[i];
                        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                        tmpDict[@"good_site"] = @"jingdong";
                        tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",dic[@"wareName"]];
                        tmpDict[@"good_link"] = [NSString stringWithFormat:@"https://item.m.jd.com/product/%@.html",dic[@"skuId"]];//https://item.m.jd.com/product/662188.html
                        tmpDict[@"good_pic"] = [NSString stringWithFormat:@"https://m.360buyimg.com/mobilecms/%@",dic[@"imageUrl"]];//https://m.360buyimg.com/mobilecms/jfs/t1/88307/5/16848/82493/5e7f0720E47dae41a/e1f4e04ad674b432.jpg
        //                NSLog(@"ebay图片地址%@",);
                        tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",dic[@"price"]];
                        tmpDict[@"good_currency"] = @"CNY";
                        [self.jdDataSource addObject:tmpDict];
                    }
                }
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.jdDataSource.count; i++) {
                [self.allDataSource addObject:self.jdDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.jdDataSource.count; i++) {
                [self.allDataSource insertObject:self.jdDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        [self.collectionView reloadData];
        [self.hud hideAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self.hud hideAnimated:YES];
    }];
}


- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}




- (UIView *)sourceBackV
{
    if (_sourceBackV == nil) {
        _sourceBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 60, kScreenW , 40)];
        
        for (int i = 0; i < 4 ; i++) {
            UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/4*i, 0, kScreenW/4, 40)];
            if (i == 0) {
                [iv addSubview:self.JDBtn];
                UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 10 , 5, 60, 30)];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.text = @"JD";
                lb.font = [UIFont systemFontOfSize:12];
                [iv addSubview:lb];
            }
            
            if (i == 1) {
                [iv addSubview:self.TaobaoBtn];
                UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 10 , 5, 60, 30)];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.text = @"Taobao";
                lb.font = [UIFont systemFontOfSize:12];
                [iv addSubview:lb];
            }
            
            if (i == 2) {
                [iv addSubview:self.TmallBtn];
                UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 10 , 5, 60, 30)];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.text = @"Tmall";
                lb.font = [UIFont systemFontOfSize:12];
                [iv addSubview:lb];
            }
            
            if (i == 3) {
                [iv addSubview:self.Amazonbtn];
                UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 10 , 5, 60, 30)];
                lb.textAlignment = NSTextAlignmentCenter;
                lb.text = @"Amazon";
                lb.font = [UIFont systemFontOfSize:12];
                [iv addSubview:lb];
            }
            
            [_sourceBackV addSubview:iv];
        }
    }
    return _sourceBackV;
}

- (UIButton *)JDBtn
{
    if (_JDBtn == nil) {
        _JDBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 40 , 5, 30, 30)];
        [_JDBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_JDBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        _JDBtn.selected = YES;
        [_JDBtn addTarget:self action:@selector(JDSourceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _JDBtn;
}

- (void)JDSourceClick
{
    
    if (self.JDBtn.selected == YES) {
        self.JDBtn.selected = NO;
        [self.searchSource removeObject:@"JD"];
        if (self.searching == NO) {
            return;
        }
        if (self.JDBtn.selected == NO) {
            for (int i = 0; i < self.allDataSource.count; i++) {
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"jingdong"]) {
                    [self.deleteSource addObject:self.allDataSource[i]];
                }
            }
            for (int i = 0; i < self.deleteSource.count; i++) {
                [self.allDataSource removeObject:self.deleteSource[i]];
            }
            [self.deleteSource removeAllObjects];
        }
        [self.collectionView reloadData];
    }else{
        self.JDBtn.selected = YES;
        [self.searchSource addObject:@"JD"];
        if (self.searching == NO) {
            return;
        }
        if (self.searchOrClassification == YES) {
            [self downLoadWithSearchKeyWord:self.currentSearchStr AmazonKeyWord:self.currentENSearchStr];
        }
        if (self.searchOrClassification == NO) {
            [self downLoadWithKeyWord:self.currentClassStr];
        }
        //        [self.collectionView reloadData];
    }
}

- (UIButton *)TaobaoBtn
{
    if (_TaobaoBtn == nil) {
        _TaobaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 40 , 5, 30, 30)];
        [_TaobaoBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_TaobaoBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        _TaobaoBtn.selected = YES;
        [_TaobaoBtn addTarget:self action:@selector(TaobaoSourceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TaobaoBtn;
}

- (void)TaobaoSourceClick
{
    if (self.TaobaoBtn.selected == YES) {
        self.TaobaoBtn.selected = NO;
        [self.searchSource removeObject:@"Taobao"];
        if (self.searching == NO) {
            return;
        }
        if (self.TaobaoBtn.selected == NO) {
            for (int i = 0; i < self.allDataSource.count; i++) {
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"taobao"]) {
                    [self.deleteSource addObject:self.allDataSource[i]];
                }
            }
            for (int i = 0; i < self.deleteSource.count; i++) {
                [self.allDataSource removeObject:self.deleteSource[i]];
            }
            [self.deleteSource removeAllObjects];
        }
        [self.collectionView reloadData];
    }else{
        self.TaobaoBtn.selected = YES;
        [self.searchSource addObject:@"Taobao"];
        if (self.searching == NO) {
            return;
        }
        if (self.searchOrClassification == YES) {
            [self downLoadWithSearchKeyWord:self.currentSearchStr AmazonKeyWord:self.currentENSearchStr];
        }
        if (self.searchOrClassification == NO) {
            [self downLoadWithKeyWord:self.currentClassStr];
        }
        //        [self.collectionView reloadData];
    }
}

- (UIButton *)TmallBtn
{
    if (_TmallBtn == nil) {
        _TmallBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 40 , 5, 30, 30)];
        [_TmallBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_TmallBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        _TmallBtn.selected = YES;
        [_TmallBtn addTarget:self action:@selector(TmallSourceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TmallBtn;
}

- (void)TmallSourceClick
{
    if (self.TmallBtn.selected == YES) {
        self.TmallBtn.selected = NO;
        [self.searchSource removeObject:@"Tmall"];
        if (self.searching == NO) {
            return;
        }
        if (self.TmallBtn.selected == NO) {
            for (int i = 0; i < self.allDataSource.count; i++) {
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"tmall"]) {
                    [self.deleteSource addObject:self.allDataSource[i]];
                }
            }
            for (int i = 0; i < self.deleteSource.count; i++) {
                [self.allDataSource removeObject:self.deleteSource[i]];
            }
            [self.deleteSource removeAllObjects];
        }
        [self.collectionView reloadData];
    }else{
        self.TmallBtn.selected = YES;
        [self.searchSource addObject:@"Tmall"];
        if (self.searching == NO) {
            return;
        }
        if (self.searchOrClassification == YES) {
            [self downLoadWithSearchKeyWord:self.currentSearchStr AmazonKeyWord:self.currentENSearchStr];
        }
        if (self.searchOrClassification == NO) {
            [self downLoadWithKeyWord:self.currentClassStr];
        }
        //        [self.collectionView reloadData];
    }
}


- (UIButton *)Amazonbtn
{
    if (_Amazonbtn == nil) {
        _Amazonbtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4/2 - 40 , 5, 30, 30)];
        [_Amazonbtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_Amazonbtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        _Amazonbtn.selected = YES;
        [_Amazonbtn addTarget:self action:@selector(AmazonSourceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Amazonbtn;
}

- (void)AmazonSourceClick
{
    if (self.Amazonbtn.selected == YES) {
        self.Amazonbtn.selected = NO;
        [self.searchSource removeObject:@"Amazon"];
        if (self.searching == NO) {
            return;
        }
        if (self.Amazonbtn.selected == NO) {
            for (int i = 0; i < self.allDataSource.count; i++) {
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"amazon-us"]) {
                    [self.deleteSource addObject:self.allDataSource[i]];
                }
            }
            for (int i = 0; i < self.deleteSource.count; i++) {
                [self.allDataSource removeObject:self.deleteSource[i]];
            }
            [self.deleteSource removeAllObjects];
        }
        [self.collectionView reloadData];
    }else{
        self.Amazonbtn.selected = YES;
        [self.searchSource addObject:@"Amazon"];
        if (self.searching == NO) {
            return;
        }
        if (self.searchOrClassification == YES) {
            [self downLoadWithSearchKeyWord:self.currentSearchStr AmazonKeyWord:self.currentENSearchStr];
        }
        if (self.searchOrClassification == NO) {
            [self downLoadWithKeyWord:self.currentClassStr];
        }
        //        [self.collectionView reloadData];
    }
}

- (void)downLoadLargeClass
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"language"] = language;
    
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/topclassinfo" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self.largeClassDataSource removeAllObjects];
            
            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
                [self.largeClassDataSource addObject:responseObject[@"data"][i]];
            }
            
            [self.tableV reloadData];
            if (self.largeClassDataSource.count != 0) {
                [self downLoadsmallClassWithLargeClass:self.largeClassDataSource[0][@"class_name"]];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.hud hideAnimated:YES];
        
    }];
}

- (void)downLoadsmallClassWithLargeClass:(NSString *)largeClass
{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"parent_class_name"] = largeClass;
    parameters[@"language"] = language;
    
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/childclassinfo" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self.smallClassDataSource removeAllObjects];
            
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.smallClassDataSource addObject:responseObject[@"data"][i]];
            }
            
            [self.collectionView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.hud hideAnimated:YES];
        
    }];
}

- (void)downLoadWithKeyWord:(NSString *)keyWord
{
    self.currentClassStr = keyWord;
    self.searchOrClassification = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"keyword"] = keyWord;
    parameters[@"sort_key"] = @"1";
    parameters[@"more"] = @"1";
    
    [manager GET:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/bykeyword/webapi/list" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self.jdDataSource removeAllObjects];
            [self.tbDataSource removeAllObjects];
            [self.tmDataSource removeAllObjects];
            [self.amDataSource removeAllObjects];
            [self.allDataSource removeAllObjects];
            
            
            
            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
                if ([responseObject[@"data"][i][@"good_site"]isEqualToString:@"ebay"]) {
                    //                    return ;
                }else{
                    [self.allDataSource addObject:responseObject[@"data"][i]];
                }
                
            }
            for (int i = 0 ; i < self.allDataSource.count; i++) {
                NSString *tmpStr = self.allDataSource[i][@"good_name"];
                for (int j = i + 1; j < self.allDataSource.count; j++) {
                    if ([tmpStr isEqualToString:self.allDataSource[j][@"good_name"]]) {
                        [self.allDataSource removeObjectAtIndex:j];
                    }
                }
            }
            for (int i = 0; i < self.allDataSource.count; i++) {
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"taobao"]) {
                    [self.tbDataSource addObject:self.allDataSource[i]];
                }
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"jingdong"]) {
                    [self.jdDataSource addObject:self.allDataSource[i]];
                }
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"tmall"]) {
                    [self.tmDataSource addObject:self.allDataSource[i]];
                }
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"amazon-us"]) {
                    [self.amDataSource addObject:self.allDataSource[i]];
                }
            }
            
            
            
            self.searching = YES;
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.hud hideAnimated:YES];
        [self downLoadWithKeyWord:keyWord];
        
    }];
}


- (UICollectionView *)collectionView {
    if (_collectionView== nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[NewSearchCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    
    
    for (int i = 0; i < self.webArr.count; i++) {
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (i%3 * ((header.frame.size.width - 20)/3) + 5), 10 + 60*(i/3) ,(header.frame.size.width - 20)/3 - 10, 50)];
        img.layer.borderColor = [UIColor lightGrayColor].CGColor;
        img.layer.borderWidth = 0.5;
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.webArr[i][@"image"]]]];
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(webImgClick:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [img addGestureRecognizer:tap];
        
        [header addSubview:img];
    }
    
    return header;
}

- (void)webImgClick:(UITapGestureRecognizer *)tap
{
    NSString *linkStr = [NSString stringWithFormat:@"%@",self.webArr[[tap view].tag-1000][@"search_link"]];
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = linkStr;
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.searching == NO) {
        return self.smallClassDataSource.count;
    }else{
        
        if ([self.sourceNum isEqualToString:@"0"]) {
            return self.allDataSource.count;
        }else if ([self.sourceNum isEqualToString:@"1"]){
            return self.tbDataSource.count;
        }else if ([self.sourceNum isEqualToString:@"2"]){
            return self.tmDataSource.count;
        }else if ([self.sourceNum isEqualToString:@"3"]){
            return self.jdDataSource.count;
        }else if ([self.sourceNum isEqualToString:@"4"]){
            return self.amDataSource.count;
        }
        
        return self.allDataSource.count;
    }
    
}

// item 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((SCREEN_WIDTH - 6) / 2, SCREEN_WIDTH/2.0+20);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.webArr.count%3 == 0) {
        return  CGSizeMake(kScreenW, 60*(self.webArr.count/3));
    }else{
        return CGSizeMake(kScreenW,60 + 70*(self.webArr.count/3));
    }
    
}


// 边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    
    return 0;
}

// 水平
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class]) forIndexPath:indexPath];
    
    
    
    
    if (cell == nil) {
        cell = [[NewSearchCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenW/2, kScreenW/2+50)];
    }
    
    //    if (self.searching == NO) {
    //
    //        [cell.iv sd_setImageWithURL:[NSURL URLWithString:self.smallClassDataSource[indexPath.row][@"pic"]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //        cell.price.text = self.smallClassDataSource[indexPath.row][@"name"];
    //        cell.price.font = [UIFont systemFontOfSize:10];
    //        cell.price.textColor = [UIColor blackColor];
    //        cell.source.image = nil;
    //        cell.nameasd.text = @"";
    //
    //    }else{
    if ([self.sourceNum isEqualToString:@"0"]) {
        cell.price.font = [UIFont systemFontOfSize:12];
        cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.allDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
        cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.allDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.allDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];

        //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
        if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"amazon-us"]) {
            cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"tmall"]){
            cell.source.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"taobao"]){
            cell.source.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"jingdong"]){
            cell.source.image = [UIImage imageNamed:@"京东分类"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"6pm"]){
            cell.source.image = [UIImage imageNamed:@"6pm"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"rakuten"]){
            cell.source.image = [UIImage imageNamed:@"乐天"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"macys"]){
            cell.source.image = [UIImage imageNamed:@"梅西百货"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"Nissen"]){
            cell.source.image = [UIImage imageNamed:@"日线"];
        }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"ebay"]){
            cell.source.image = [UIImage imageNamed:@"Ebay"];
        }

        cell.nameasd.text = self.allDataSource[indexPath.row][@"good_name"];
        cell.goodsLink = self.allDataSource[indexPath.row][@"good_link"];
    }else if ([self.sourceNum isEqualToString:@"1"]){
        cell.price.font = [UIFont systemFontOfSize:12];
        cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tbDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
        cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tbDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tbDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
        //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
        if ([self.tbDataSource[indexPath.row][@"good_site"]isEqualToString:@"amazon-us"]) {
            cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.tbDataSource[indexPath.row][@"good_site"]isEqualToString:@"tmall"]){
            cell.source.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.tbDataSource[indexPath.row][@"good_site"]isEqualToString:@"taobao"]){
            cell.source.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.tbDataSource[indexPath.row][@"good_site"]isEqualToString:@"jingdong"]){
            cell.source.image = [UIImage imageNamed:@"京东分类"];
        }
        
        cell.nameasd.text = self.tbDataSource[indexPath.row][@"good_name"];
        cell.goodsLink = self.tbDataSource[indexPath.row][@"good_link"];
        
    }else if ([self.sourceNum isEqualToString:@"2"]){
        cell.price.font = [UIFont systemFontOfSize:12];
        cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tmDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
        cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tmDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tmDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
        //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
        if ([self.tmDataSource[indexPath.row][@"good_site"]isEqualToString:@"amazon-us"]) {
            cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.tmDataSource[indexPath.row][@"good_site"]isEqualToString:@"tmall"]){
            cell.source.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.tmDataSource[indexPath.row][@"good_site"]isEqualToString:@"taobao"]){
            cell.source.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.tmDataSource[indexPath.row][@"good_site"]isEqualToString:@"jingdong"]){
            cell.source.image = [UIImage imageNamed:@"京东分类"];
        }
        
        cell.nameasd.text = self.tmDataSource[indexPath.row][@"good_name"];
        cell.goodsLink = self.tmDataSource[indexPath.row][@"good_link"];
        
    }else if ([self.sourceNum isEqualToString:@"3"]){
        cell.price.font = [UIFont systemFontOfSize:12];
        cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.jdDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
        cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.jdDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.jdDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
        //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
        if ([self.jdDataSource[indexPath.row][@"good_site"]isEqualToString:@"amazon-us"]) {
            cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.jdDataSource[indexPath.row][@"good_site"]isEqualToString:@"tmall"]){
            cell.source.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.jdDataSource[indexPath.row][@"good_site"]isEqualToString:@"taobao"]){
            cell.source.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.jdDataSource[indexPath.row][@"good_site"]isEqualToString:@"jingdong"]){
            cell.source.image = [UIImage imageNamed:@"京东分类"];
        }
        
        cell.nameasd.text = self.jdDataSource[indexPath.row][@"good_name"];
        cell.goodsLink = self.jdDataSource[indexPath.row][@"good_link"];
        
    }else if ([self.sourceNum isEqualToString:@"4"]){
        cell.price.font = [UIFont systemFontOfSize:12];
        cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.amDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
        cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.amDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.amDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
        //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
        if ([self.amDataSource[indexPath.row][@"good_site"]isEqualToString:@"amazon-us"]) {
            cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
        }else if ([self.amDataSource[indexPath.row][@"good_site"]isEqualToString:@"tmall"]){
            cell.source.image = [UIImage imageNamed:@"天猫分类"];
        }else if ([self.amDataSource[indexPath.row][@"good_site"]isEqualToString:@"taobao"]){
            cell.source.image = [UIImage imageNamed:@"淘宝分类"];
        }else if ([self.amDataSource[indexPath.row][@"good_site"]isEqualToString:@"jingdong"]){
            cell.source.image = [UIImage imageNamed:@"京东分类"];
        }
        
        cell.nameasd.text = self.amDataSource[indexPath.row][@"good_name"];
        cell.goodsLink = self.amDataSource[indexPath.row][@"good_link"];
    }
    
    
    //        if (indexPath.row%self.searchSource.count == 0) {
    //
    //            if (indexPath.row/self.searchSource.count >= self.jdDataSource.count &&
    //                self.sourceNum - self.tbDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.jdDataSource.count) {
    //                [self.searchSource removeObject:@"JD"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tbDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.tbDataSource.count) {
    //                [self.searchSource removeObject:@"Taobao"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tmDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.amDataSource.count > self.tmDataSource.count) {
    //                [self.searchSource removeObject:@"Tmall"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.amDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.tmDataSource.count > self.amDataSource.count) {
    //                [self.searchSource removeObject:@"Amazon"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"JD"] && indexPath.row/self.searchSource.count < self.jdDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.jdDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.jdDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"京东分类"];
    //                cell.nameasd.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Taobao"]&& indexPath.row/self.searchSource.count < self.tbDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tbDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tbDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"淘宝分类"];
    //                cell.nameasd.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Tmall"]&& indexPath.row/self.searchSource.count < self.tmDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tmDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tmDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"天猫分类"];
    //                cell.nameasd.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Amazon"]&& indexPath.row/self.searchSource.count < self.amDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.amDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.amDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
    //                cell.nameasd.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.amDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //        }
    //
    //        if (indexPath.row%self.searchSource.count == 1) {
    //
    //            if (indexPath.row/self.searchSource.count >= self.jdDataSource.count &&
    //                self.sourceNum - self.tbDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.jdDataSource.count) {
    //                [self.searchSource removeObject:@"JD"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tbDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.tbDataSource.count) {
    //                [self.searchSource removeObject:@"Taobao"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tmDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.amDataSource.count > self.tmDataSource.count) {
    //                [self.searchSource removeObject:@"Tmall"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.amDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.tmDataSource.count > self.amDataSource.count) {
    //                [self.searchSource removeObject:@"Amazon"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"JD"] && indexPath.row/self.searchSource.count < self.jdDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.jdDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.jdDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"京东分类"];
    //                cell.nameasd.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Taobao"]&& indexPath.row/self.searchSource.count < self.tbDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tbDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tbDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"淘宝分类"];
    //                cell.nameasd.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Tmall"]&& indexPath.row/self.searchSource.count < self.tmDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tmDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tmDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"天猫分类"];
    //                cell.nameasd.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Amazon"]&& indexPath.row/self.searchSource.count < self.amDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.amDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.amDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
    //                cell.nameasd.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.amDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //        }
    //
    //        if (indexPath.row%self.searchSource.count == 2) {
    //
    //            if (indexPath.row/self.searchSource.count >= self.jdDataSource.count &&
    //                self.sourceNum - self.tbDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.jdDataSource.count) {
    //                [self.searchSource removeObject:@"JD"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tbDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.tbDataSource.count) {
    //                [self.searchSource removeObject:@"Taobao"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tmDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.amDataSource.count > self.tmDataSource.count) {
    //                [self.searchSource removeObject:@"Tmall"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.amDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.tmDataSource.count > self.amDataSource.count) {
    //                [self.searchSource removeObject:@"Amazon"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"JD"] && indexPath.row/self.searchSource.count < self.jdDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.jdDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.jdDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"京东分类"];
    //                cell.nameasd.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Taobao"]&& indexPath.row/self.searchSource.count < self.tbDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tbDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tbDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"淘宝分类"];
    //                cell.nameasd.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Tmall"]&& indexPath.row/self.searchSource.count < self.tmDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tmDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tmDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"天猫分类"];
    //                cell.nameasd.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Amazon"]&& indexPath.row/self.searchSource.count < self.amDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.amDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.amDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
    //                cell.nameasd.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.amDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //        }
    //
    //
    //        if (indexPath.row%self.searchSource.count == 3) {
    //
    //            if (indexPath.row/self.searchSource.count >= self.jdDataSource.count &&
    //                self.sourceNum - self.tbDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.jdDataSource.count) {
    //                [self.searchSource removeObject:@"JD"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tbDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tmDataSource.count - self.amDataSource.count > self.tbDataSource.count) {
    //                [self.searchSource removeObject:@"Taobao"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.tmDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.amDataSource.count > self.tmDataSource.count) {
    //                [self.searchSource removeObject:@"Tmall"];
    //            }
    //
    //            if (indexPath.row/self.searchSource.count >= self.amDataSource.count &&
    //                self.sourceNum - self.jdDataSource.count - self.tbDataSource.count - self.tmDataSource.count > self.amDataSource.count) {
    //                [self.searchSource removeObject:@"Amazon"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"JD"] && indexPath.row/self.searchSource.count < self.jdDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.jdDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.jdDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"京东分类"];
    //                cell.nameasd.text = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.jdDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Taobao"]&& indexPath.row/self.searchSource.count < self.tbDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tbDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tbDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"淘宝分类"];
    //                cell.nameasd.text = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tbDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Tmall"]&& indexPath.row/self.searchSource.count < self.tmDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tmDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tmDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"天猫分类"];
    //                cell.nameasd.text = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.tmDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //
    //            if ([self.searchSource[indexPath.row%self.searchSource.count]isEqualToString:@"Amazon"]&& indexPath.row/self.searchSource.count < self.amDataSource.count) {
    //                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.amDataSource[indexPath.row/self.searchSource.count][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    //                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.amDataSource[indexPath.row/self.searchSource.count][@"good_currency"] numberOfGoods:1.0];
    //                //cell.price.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_price"];
    //                cell.source.image = [UIImage imageNamed:@"亚马逊分类"];
    //                cell.nameasd.text = self.amDataSource[indexPath.row/self.searchSource.count][@"good_name"];
    //                cell.goodsLink = self.amDataSource[indexPath.row/self.searchSource.count][@"good_link"];
    //            }
    //        }
    //    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searching == NO) {
        [self downLoadWithKeyWord:self.smallClassDataSource[indexPath.row][@"class_name"]];
    }else{
        //        NewSearchCollectionViewCell * cell = (NewSearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //        if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"ebay"]) {
        //            GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
        //            shopDetail.hidesBottomBarWhenPushed = YES;
        //            shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];
        //            shopDetail.isShowText = YES;
        //            [self.navigationController pushViewController:shopDetail animated:YES];
        //        }else{
        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
        shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
        shopDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
        //        }
    }
}


//- (UITableView *)tableV
//{
//    if (_tableV == nil) {
//        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 70 + 64 , 100, kScreenH - 100)];
//        _tableV.delegate = self;
//        _tableV.dataSource = self;
//        [_tableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    }
//    return _tableV;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.largeClassDataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.textLabel.text = self.largeClassDataSource[indexPath.row][@"name"];
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.searching = NO;
//    [self.searchTf resignFirstResponder];
//    [self downLoadsmallClassWithLargeClass:self.largeClassDataSource[indexPath.row][@"class_name"]];
//}

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
