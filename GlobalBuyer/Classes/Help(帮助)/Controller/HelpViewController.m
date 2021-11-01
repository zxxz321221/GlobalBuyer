//
//  HelpViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/14.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpSectionModel.h"
#import "HelpDetailViewController.h"
#import "HelpHeaderView.h"
#import "HelpListViewController.h"
#import "ServiceHotlineViewController.h"
#import "ActivityWebViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "PurchaseInformationViewController.h"
#import "ServiceViewController.h"
@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableView *nTableView;
@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSDictionary *dataDict;
@property(nonatomic,strong)NSMutableArray *sectionDataSources;

@property(nonatomic,strong)NSMutableArray *tipsDataSource;
@property(nonatomic,strong)NSMutableArray *qAADataSorce;

@property(nonatomic,strong)UIView *olServiceV;
@property(nonatomic,strong)UIView *phoneServiceV;
@property(nonatomic,strong)UIView *lineV;
@property(nonatomic,strong)UIView *lineHv;

@property(nonatomic,strong)UIView *tipsV;
@property(nonatomic,strong)UIView *questionAndAnswerV;
@property(nonatomic,strong)UIView *tipsLineV;
@property(nonatomic,strong)UIView *tipsLineHv;

@property(nonatomic,strong)UIView *informationV;

@property(nonatomic,strong)UIView *noviceLb;
@property(nonatomic,strong)UIView *serveLb;
@property(nonatomic,strong)UIView *guaranteeLb;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self downloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = Main_Color;
    self.navigationController.navigationBar.backgroundColor = Main_Color;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshGoodsNum" object:nil];
//    ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
//    [albbSDK logout];
}

- (NSMutableArray *)titleArr {
    if (_titleArr == nil) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}

- (NSMutableArray *)tipsDataSource
{
    if (_tipsDataSource == nil) {
        _tipsDataSource = [[NSMutableArray alloc]init];
    }
    return _tipsDataSource;
}

- (NSMutableArray *)qAADataSorce
{
    if (_qAADataSorce == nil) {
        _qAADataSorce = [[NSMutableArray alloc]init];
    }
    return _qAADataSorce;
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Helpcenter", nil);
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
}

- (void)finishedLoading
{
    UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    backSv.contentSize = CGSizeMake(0, 700);
    backSv.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    
    [backSv addSubview:self.olServiceV];
    [backSv addSubview:self.phoneServiceV];
    [backSv addSubview:self.lineV];
    [backSv addSubview:self.lineHv];
    
    [backSv addSubview:self.nTableView];
    [backSv addSubview:self.noviceLb];
    [backSv addSubview:self.serveLb];
    [backSv addSubview:self.guaranteeLb];
    
    [backSv addSubview:self.tipsV];
//    [backSv addSubview:self.informationV];
    
    
    [self.view addSubview:backSv];
//    [self.view addSubview:self.questionAndAnswerV];
//    [self.view addSubview:self.tipsLineV];
//    [self.view addSubview:self.tipsLineHv];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH + 100, kScreenW, kScreenH - kNavigationBarH - kStatusBarH - 100) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [self.tableView registerClass:[HelpHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HelpHeaderView class])];
    }
    return _tableView;
}

- (UITableView *)nTableView
{
    if (_nTableView == nil) {
        _nTableView = [[UITableView alloc]initWithFrame:CGRectMake( 100 , kNavigationBarH + kStatusBarH + 100 + 15, kScreenW - 100, 6 * 50) style:UITableViewStylePlain];
        _nTableView.tableFooterView = [[UIView alloc]init];
        _nTableView.delegate = self;
        _nTableView.dataSource = self;
        _nTableView.bounces = NO;
    }
    return _nTableView;
}

- (UIView *)olServiceV
{
    if (_olServiceV == nil) {
        _olServiceV = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH, kScreenW/2, 100)];
        _olServiceV.backgroundColor = [UIColor whiteColor];
        UIImageView *olIV = [[UIImageView alloc]initWithFrame:CGRectMake(_olServiceV.frame.size.width/2 - 15, 20, 30, 30)];
        olIV.image = [UIImage imageNamed:@"在线客服"];
        [_olServiceV addSubview:olIV];
        UILabel *olLB = [[UILabel alloc]initWithFrame:CGRectMake(_olServiceV.frame.size.width/2 - 40, 60, 80, 20)];
        olLB.textAlignment = NSTextAlignmentCenter;
        olLB.font = [UIFont systemFontOfSize:14];
        olLB.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_OnlineService", nil);
        olLB.textColor = [UIColor grayColor];
        [_olServiceV addSubview:olLB];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Service)];
        [_olServiceV addGestureRecognizer:tap];
    }
    return _olServiceV;
}

- (void)Service
{
    ServiceViewController * svc = [[ServiceViewController alloc]init];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
//    ActivityWebViewController *webService = [[ActivityWebViewController alloc]init];
//    // 获得当前iPhone使用的语言
//    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
//    NSLog(@"当前使用的语言：%@",currentLanguage);
//    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else if([currentLanguage isEqualToString:@"en"]){
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }else{
//        webService.href = @"http://buy.dayanghang.net/user_data/special/20190124/qqmsCustomerService.html";
//    }
//    webService.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webService animated:YES];
    
//        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
//        [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (UIView *)phoneServiceV
{
    if (_phoneServiceV == nil) {
        _phoneServiceV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, kNavigationBarH + kStatusBarH, kScreenW/2, 100)];
        _phoneServiceV.backgroundColor = [UIColor whiteColor];
        UIImageView *olIV = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneServiceV.frame.size.width/2 - 15, 20, 30, 30)];
        olIV.image = [UIImage imageNamed:@"客服热线"];
        [_phoneServiceV addSubview:olIV];
        UILabel *olLB = [[UILabel alloc]initWithFrame:CGRectMake(_phoneServiceV.frame.size.width/2 - 40, 60, 80, 20)];
        olLB.textAlignment = NSTextAlignmentCenter;
        olLB.font = [UIFont systemFontOfSize:14];
        olLB.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_CustomerServiceHotline", nil);
        olLB.textColor = [UIColor grayColor];
        [_phoneServiceV addSubview:olLB];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneCall)];
        [_phoneServiceV addGestureRecognizer:tap];
    }
    return _phoneServiceV;
}

- (void)phoneCall
{
    ServiceHotlineViewController *serviceHotlineVC = [[ServiceHotlineViewController alloc]init];
    serviceHotlineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:serviceHotlineVC animated:YES];
}

- (UIView *)lineV
{
    if (_lineV == nil) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, kNavigationBarH + kStatusBarH + 12, 1, 76)];
        _lineV.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return _lineV;
}

- (UIView *)lineHv
{
    if (_lineHv == nil) {
        _lineHv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH + 99, [[UIScreen mainScreen] bounds].size.width, 1)];
        _lineHv.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
    }
    return _lineHv;
}

- (UIView *)tipsV
{
    if (_tipsV == nil) {
        _tipsV = [[UIView alloc]initWithFrame:CGRectMake(0, self.nTableView.frame.origin.y + self.nTableView.frame.size.height + 20, kScreenW, 50)];
        _tipsV.backgroundColor = [UIColor whiteColor];
        UIImageView *tipsIV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 40, 40)];
        tipsIV.image = [UIImage imageNamed:@"小貼士lv"];
        [_tipsV addSubview:tipsIV];
        UIView *tipsLineV = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 2, 50)];
        tipsLineV.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
        [_tipsV addSubview:tipsLineV];
        UIView *tipsLineUpV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        tipsLineUpV.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
        [_tipsV addSubview:tipsLineUpV];
        UIView *tipsLineDownV = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenW, 1)];
        tipsLineDownV.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
        [_tipsV addSubview:tipsLineDownV];
        UILabel *tipsLB = [[UILabel alloc]initWithFrame:CGRectMake(117, 5 , 200, 40)];
        tipsLB.textAlignment = NSTextAlignmentLeft;
        tipsLB.font = [UIFont systemFontOfSize:16];
        tipsLB.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_Tips", nil);
        [_tipsV addSubview:tipsLB];
        UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 35, 10, 30, 30)];
        arrowV.image = [UIImage imageNamed:@"tipsarrow"];
        [_tipsV addSubview:arrowV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipsClick)];
        [_tipsV addGestureRecognizer:tap];
    }
    return _tipsV;
}

- (void)tipsClick
{
    HelpListViewController *helpDetailVC = [HelpListViewController new];
    helpDetailVC.hidesBottomBarWhenPushed = YES;
    helpDetailVC.bodyTitleArr = self.tipsDataSource;
    helpDetailVC.navigationItem.title = NSLocalizedString(@"GlobalBuyer_HelpViewController_Tips", nil);
    [self.navigationController pushViewController:helpDetailVC animated:YES];
}

- (UIView *)informationV
{
    if (_informationV == nil) {
        _informationV = [[UIView alloc]initWithFrame:CGRectMake(0, self.nTableView.frame.origin.y + self.nTableView.frame.size.height + 20 + 50, kScreenW, 50)];
        _informationV.backgroundColor = [UIColor whiteColor];
        UIImageView *tipsIV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 40, 40)];
        tipsIV.image = [UIImage imageNamed:@"海淘资讯"];
        [_informationV addSubview:tipsIV];
        UIView *tipsLineV = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 2, 50)];
        tipsLineV.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
        [_informationV addSubview:tipsLineV];
        UIView *tipsLineUpV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        tipsLineUpV.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
        [_informationV addSubview:tipsLineUpV];
        UIView *tipsLineDownV = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenW, 1)];
        tipsLineDownV.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
        [_informationV addSubview:tipsLineDownV];
        UILabel *tipsLB = [[UILabel alloc]initWithFrame:CGRectMake(117, 5 , 200, 40)];
        tipsLB.textAlignment = NSTextAlignmentLeft;
        tipsLB.font = [UIFont systemFontOfSize:16];
        tipsLB.text = NSLocalizedString(@"GlobalBuyer_Amazon_OverseasShoppingInformation", nil);
        [_informationV addSubview:tipsLB];
        UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 35, 10, 30, 30)];
        arrowV.image = [UIImage imageNamed:@"tipsarrow"];
        [_informationV addSubview:arrowV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(informationClick)];
        [_informationV addGestureRecognizer:tap];
    }
    return _informationV;
}

- (void)informationClick{
    NSLog(@"HaitaoZixun");
    PurchaseInformationViewController *vc = [[PurchaseInformationViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)questionAndAnswerV
{
    if (_questionAndAnswerV == nil) {
        _questionAndAnswerV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, kNavigationBarH + kStatusBarH + 100 + 1, kScreenW/2, 100)];
        _questionAndAnswerV.backgroundColor = [UIColor whiteColor];
        UIImageView *questionAndAnswerIV = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneServiceV.frame.size.width/2 - 15, 20, 30, 30)];
        questionAndAnswerIV.image = [UIImage imageNamed:@"常见问题"];
        [_questionAndAnswerV addSubview:questionAndAnswerIV];
        UILabel *questionAndAnswerLB = [[UILabel alloc]initWithFrame:CGRectMake(_questionAndAnswerV.frame.size.width/2 - 40, 60, 80, 20)];
        questionAndAnswerLB.textAlignment = NSTextAlignmentCenter;
        questionAndAnswerLB.font = [UIFont systemFontOfSize:14];
        questionAndAnswerLB.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_QAA", nil);
        questionAndAnswerLB.textColor = [UIColor grayColor];
        [_questionAndAnswerV addSubview:questionAndAnswerLB];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionAndAnswerClick)];
        [_questionAndAnswerV addGestureRecognizer:tap];
    }
    return _questionAndAnswerV;
}

- (void)questionAndAnswerClick
{
    HelpListViewController *helpDetailVC = [HelpListViewController new];
    helpDetailVC.hidesBottomBarWhenPushed = YES;
    helpDetailVC.bodyTitleArr = self.qAADataSorce;
    helpDetailVC.navigationItem.title = NSLocalizedString(@"GlobalBuyer_HelpViewController_QAA", nil);
    [self.navigationController pushViewController:helpDetailVC animated:YES];
}

- (UIView *)tipsLineV
{
    if (_tipsLineV == nil) {
        _tipsLineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2, kNavigationBarH + kStatusBarH + 12 + 100 + 1, 1, 76)];
        _tipsLineV.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:235.0/255.0 alpha:1];
    }
    return _tipsLineV;
}

- (UIView *)tipsLineHv
{
    if (_tipsLineHv == nil) {
        _tipsLineHv = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH + 99 + 100 + 1, [[UIScreen mainScreen] bounds].size.width, 1)];
        _tipsLineHv.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1];
    }
    return _tipsLineHv;
}

- (UIView *)noviceLb
{
    if (_noviceLb == nil) {
        _noviceLb = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH + 100 + 15, 100, 100)];
        _noviceLb.backgroundColor = [UIColor whiteColor];
        _noviceLb.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
        _noviceLb.layer.borderWidth = 1;
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 40, 40)];
        iv.image = [UIImage imageNamed:@"新手专区"];
        [_noviceLb addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake( 20, 70, 60 , 20)];
        lb.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_Newbiezone", nil);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:14];
        [_noviceLb addSubview:lb];
    }
    return _noviceLb;
}

- (UIView *)serveLb
{
    if (_serveLb == nil) {
        _serveLb = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH + 100 + 15 + _noviceLb.frame.size.height, 100, 100)];
        _serveLb.backgroundColor = [UIColor whiteColor];
        _serveLb.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
        _serveLb.layer.borderWidth = 1;
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 40, 40)];
        iv.image = [UIImage imageNamed:@"服务方式"];
        [_serveLb addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake( 20, 70, 60 , 20)];
        lb.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_servicemode", nil);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:14];
        [_serveLb addSubview:lb];
    }
    return _serveLb;
}

- (UIView *)guaranteeLb
{
    if (_guaranteeLb == nil) {
        _guaranteeLb = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + kStatusBarH + 100 + 15 + _serveLb.frame.size.height + _noviceLb.frame.size.height , 100, 100)];
        _guaranteeLb.backgroundColor = [UIColor whiteColor];
        _guaranteeLb.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
        _guaranteeLb.layer.borderWidth = 1;
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 40, 40)];
        iv.image = [UIImage imageNamed:@"权益保障"];
        [_guaranteeLb addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake( 20, 70, 60 , 20)];
        lb.text = NSLocalizedString(@"GlobalBuyer_HelpViewController_Rightsprotection", nil);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:14];
        [_guaranteeLb addSubview:lb];
    }
    return _guaranteeLb;
}

//- (void)downloadData {
//    
//    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
//    // 取得 iPhone 支持的所有语言设置
//    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
//    NSLog (@"%@", languages);
//    // 获得当前iPhone使用的语言
//    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
//    NSLog(@"当前使用的语言：%@",currentLanguage);
//    NSString *language;
//    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//        language = @"zh_CN";
//    }else if([currentLanguage isEqualToString:@"zh-Hant-US"] || [currentLanguage isEqualToString:@"zh-Hant-TW"]){
//        language = @"zh_TW";
//    }else if([currentLanguage isEqualToString:@"en"]){
//        language = @"en";
//    }else if([currentLanguage isEqualToString:@"Japanese"]){
//        language = @"ja";
//    }else{
//        language = @"zh_CN";
//    }
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    params[@"api_id"] = API_ID;
//    params[@"api_token"] = TOKEN;
//    params[@"locale"] = language;
//    
//    [manager POST:HelpListApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        self.dataDict = responseObject[@"data"];
//        if (self.dataDict.count == 0) {
//            return ;
//        }
//        self.titleArr = (NSMutableArray *)[self.dataDict allKeys];
//        for (int i = 0; i < self.titleArr.count; i++) {
//             HelpSectionModel *sectionModel = [HelpSectionModel new];
//             sectionModel.isExpanded = NO;
//             sectionModel.sectionTitle = self.titleArr[i];
//             NSMutableArray *itemArray = [[NSMutableArray alloc] init];
//             for (int j = 0; j < [self.dataDict[self.titleArr[i]] count]; j++) {
//                NSDictionary *dict =self.dataDict[self.titleArr[i]][j];
//                HelpCellModel *model =  [[HelpCellModel alloc]init];
//                model.title = dict[@"title"];
//                model.body = dict[@"body"];
//                [itemArray addObject:model];
//            }
//            sectionModel.cellModels = itemArray;
//            [self.sectionDataSources addObject:sectionModel];
//        }
//        [self.nTableView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//}

- (void)downloadData {
    
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"locale"] = language;
    params[@"sign"] = @"help";
    
    [manager POST:HelpListApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tmpArr = responseObject[@"data"];
        if (tmpArr.count == 0) {
            return ;
        }
        for (int i = 0; i < tmpArr.count; i++) {
            [self.titleArr addObject:tmpArr[i][@"category_name"]];
            [self.sectionDataSources addObject:tmpArr[i][@"get_help_content"]];
        }
        
        [self downTips];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downTips
{
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"locale"] = language;
    params[@"sign"] = @"info";
    
    [manager POST:HelpListApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSArray *arr = responseObject[@"data"][0][@"get_help_content"];
            for (int i = 0 ; i < arr.count; i++) {
                [self.tipsDataSource addObject:arr[i]];
            }
        }
        
        [self downQAA];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downQAA
{
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"locale"] = language;
    params[@"sign"] = @"Q&A";

    [manager POST:HelpListApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSArray *arr = responseObject[@"data"][0][@"get_help_content"];
            for (int i = 0 ; i < arr.count; i++) {
                [self.qAADataSorce addObject:arr[i]];
            }
        }
        [self.hud hideAnimated:YES];
        [self finishedLoading];
        [self.nTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSMutableArray *)sectionDataSources{
    if (_sectionDataSources == nil) {
        _sectionDataSources = [NSMutableArray new];
    }
    return _sectionDataSources;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    HelpSectionModel *sectionModel = self.sectionDataSources[section];
//    return sectionModel.isExpanded ? sectionModel.cellModels.count : 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.sectionDataSources.count;
//}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"HelpCell";
//    UITableViewCell *cell = TableViewCellDequeueInit(cellId);
//    TableViewCellDequeue(cell, UITableViewCell, cellId);
//    HelpSectionModel *sectionModel = self.sectionDataSources[indexPath.section];
//    HelpCellModel *cellModel = sectionModel.cellModels[indexPath.row];
//    cell.textLabel.text = cellModel.title;
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"HelpCell";
    UITableViewCell *cell = TableViewCellDequeueInit(cellId);
    TableViewCellDequeue(cell, UITableViewCell, cellId);
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:221.0/255.0 blue:225.0/255.0 alpha:1].CGColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HelpHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HelpHeaderView class])];
//    HelpSectionModel *sectionModel = self.sectionDataSources[section];
//    view.model = sectionModel;
//    view.expandCallback = ^(BOOL isExpanded) {
//        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
//                 withRowAnimation:UITableViewRowAnimationFade];
//    };
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 44;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpListViewController *helpDetailVC = [HelpListViewController new];
    helpDetailVC.hidesBottomBarWhenPushed = YES;
    helpDetailVC.bodyTitleArr = self.sectionDataSources[indexPath.row];
    helpDetailVC.navigationItem.title = self.titleArr[indexPath.row];
    [self.navigationController pushViewController:helpDetailVC animated:YES];
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
