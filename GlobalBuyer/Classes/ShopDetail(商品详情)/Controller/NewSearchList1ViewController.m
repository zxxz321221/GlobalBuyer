//
//  NewSearchList1ViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/31.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "NewSearchList1ViewController.h"
#import "NewSearchCollectionViewCell.h"
#import "XMLDictionary.h"
#import<CommonCrypto/CommonDigest.h>
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"
@interface NewSearchList1ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *moneytypeArr;
@property (nonatomic,strong)UIView *animationBackV;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic , strong) UITextField * searchTf;
@property (nonatomic,strong)NSString *page;
@property (nonatomic,strong)NSMutableArray *allDataSource;
@end

@implementation NewSearchList1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = @"1";
    [self createUI];
    [self downloadMoneytype];
}
//下载汇率
- (void)downloadMoneytype {
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
        
        [self downExternalTaobaoData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)downExternalTaobaoData{//76e85e1eb449630feeb6da85a21496fc
    [self.allDataSource removeAllObjects];
    self.animationBackV.hidden = NO;
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    // 可接受的文本参数规格
    
    NSString *time = [self getCurrentTimes];
    
    NSString *mdStr = [NSString stringWithFormat:@"76e85e1eb449630feeb6da85a21496fcadzone_id108433400489app_key25401200formatjsonmethodtaobao.tbk.dg.material.optionalpage_no%@page_size20q%@sign_methodmd5timestamp%@v2.076e85e1eb449630feeb6da85a21496fc",self.page,self.keyWords,time];
    
    
    NSDictionary *params = @{
        //                         @"fields":@"title,pict_url,small_images,user_type,provcity,item_url,seller_id,volume,nick,zk_final_price",
        @"method":@"taobao.tbk.dg.material.optional",
        @"app_key":@"25401200",
        @"sign_method":@"md5",
        @"timestamp":time,
        @"format":@"json",
        @"v":@"2.0",
        @"page_size":@"20",
        @"page_no":self.page,
        @"q":self.keyWords,
        @"adzone_id":@"108433400489",
        @"sign":[self md5:mdStr].uppercaseString,
    };
    NSLog(@"taobao request data =%@",params);
    [manager POST:@"https://eco.taobao.com/router/rest" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSData *jsonData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        NSDictionary *xmlDoc = dict[@"tbk_dg_material_optional_response"];
        NSLog(@"%@",xmlDoc);
        
        if (xmlDoc) {
            for (int i=0 ; i<[xmlDoc[@"result_list"][@"map_data"] count]; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"taobao";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"title"]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"item_url"]];
                tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"pict_url"]];
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"zk_final_price"]];
                tmpDict[@"good_currency"] = [NSString stringWithFormat:@"CNY"];
                [self.allDataSource addObject:tmpDict];
            }
        }
        
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@",error);
        self.animationBackV.hidden = YES;
    }];
}
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchTf];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.animationBackV];
    
    
}
//初始化输入框
- (UITextField *)searchTf
{
    if (_searchTf == nil) {
        _searchTf = [[UITextField alloc]initWithFrame:CGRectMake( 10 , 10, SCREEN_WIDTH-20, 35)];
        _searchTf.backgroundColor = [UIColor whiteColor];
        _searchTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchTf.layer.borderWidth = 0.6;
        _searchTf.placeholder = NSLocalizedString(@"GlobalBuyer_SearchViewController_placeholder", nil);
        _searchTf.text = self.keyWords;
        _searchTf.delegate = self;
        _searchTf.returnKeyType = UIReturnKeySearch;
        
    }
    return _searchTf;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((kScreenW-10)/2, (kScreenW-10)/2+50);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70, kScreenW, kScreenH  - 70) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Cell_BgColor;
        _collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[NewSearchCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class])];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [_collectionView.mj_footer beginRefreshing];
            [self moreData];
            
        }];
        
    }
    return _collectionView;
}
//asdasdasdasd
- (void)moreData{
    [self.collectionView.mj_footer endRefreshing];
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    
    self.animationBackV.hidden = NO;
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    NSString *time = [self getCurrentTimes];
    NSString *mdStr = [NSString stringWithFormat:@"76e85e1eb449630feeb6da85a21496fcadzone_id108433400489app_key25401200formatjsonmethodtaobao.tbk.dg.material.optionalpage_no%@page_size20q%@sign_methodmd5timestamp%@v2.076e85e1eb449630feeb6da85a21496fc",self.page,self.keyWords,time];
    
    NSDictionary *params = @{
        //                         @"fields":@"title,pict_url,small_images,user_type,provcity,item_url,seller_id,volume,nick,zk_final_price",
        @"method":@"taobao.tbk.dg.material.optional",
        @"app_key":@"25401200",
        @"sign_method":@"md5",
        @"timestamp":time,
        @"format":@"json",
        @"v":@"2.0",
        @"page_size":@"20",
        @"page_no":self.page,
        @"q":self.keyWords,
        @"adzone_id":@"108433400489",
        @"sign":[self md5:mdStr].uppercaseString,
    };
    NSLog(@"taobao request data =%@",params);
    
    [manager POST:@"https://eco.taobao.com/router/rest" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSData *jsonData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        NSDictionary *xmlDoc = dict[@"tbk_dg_material_optional_response"];
        NSLog(@"%@",xmlDoc);
        
        for (int i=0 ; i<[xmlDoc[@"result_list"][@"map_data"] count]; i++) {
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
            tmpDict[@"good_site"] = @"taobao";
            tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"title"]];
            tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"item_url"]];
            tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"pict_url"]];
            tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"zk_final_price"]];
            tmpDict[@"good_currency"] = [NSString stringWithFormat:@"CNY"];
            [self.allDataSource addObject:tmpDict];
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.animationBackV.hidden = YES;
    }];
}
//初始化汇率数据源
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
}
- (UIView *)animationBackV{
    if (_animationBackV == nil) {
        _animationBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _animationBackV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        NSMutableArray *imgArr = [[NSMutableArray alloc]init];
        for (int i = 1 ; i < 19; i++) {
            NSString *str = [NSString stringWithFormat:@"search%d",i];
            UIImage *img = [UIImage imageNamed:str];
            [imgArr addObject:img];
        }
        UIImageView *loadingIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 100, kScreenH/2 - 100, 200, 200)];
        loadingIv.animationImages = imgArr;
        loadingIv.animationDuration = 9*0.15;
        loadingIv.animationRepeatCount = 0;
        [loadingIv startAnimating];
        [_animationBackV addSubview:loadingIv];
        _animationBackV.hidden = YES;
    }
    return _animationBackV;
}
- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
- (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}
- (NSMutableArray *)allDataSource
{
    if (_allDataSource == nil) {
        _allDataSource = [[NSMutableArray alloc]init];
    }
    return _allDataSource;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allDataSource.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class]) forIndexPath:indexPath];
    
    
    
    
    if (cell == nil) {
        cell = [[NewSearchCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenW/2, kScreenW/2+50)];
    }
    
    cell.price.font = [UIFont systemFontOfSize:12];
    cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.allDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
    cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.allDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.allDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
    //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
    cell.source.image = [UIImage imageNamed:@"淘宝分类"];
    cell.nameasd.text = self.allDataSource[indexPath.row][@"good_name"];
    cell.goodsLink = self.allDataSource[indexPath.row][@"good_link"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.page = @"1";
    self.keyWords = textField.text;
    [textField resignFirstResponder];
    [self downExternalTaobaoData];
    
    return YES;
}
@end
