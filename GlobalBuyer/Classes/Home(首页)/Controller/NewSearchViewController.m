//
//  NewSearchViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "NewSearchViewController.h"
#import "NewSearchCollectionViewCell.h"
#import<CommonCrypto/CommonDigest.h>
#import "CurrencyCalculation.h"
#import "ShopDetailViewController.h"
#import "XMLDictionary.h"
#import "GlobalShopDetailViewController.h"

@interface NewSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic,strong)NSMutableArray *moneytypeArr;

@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)BOOL searching;
@property(nonatomic,strong)NSString *originalType;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)NSMutableArray *largeClassDataSource;
@property (nonatomic,strong)NSMutableArray *smallClassDataSource;

@property (nonatomic,strong)NSMutableArray *searchSource;

@property (nonatomic,strong)NSMutableArray *saleDataSource;
@property (nonatomic,strong)NSMutableArray *jdDataSource;
@property (nonatomic,strong)NSMutableArray *tbDataSource;
@property (nonatomic,strong)NSMutableArray *amDataSource;
@property (nonatomic,strong)NSMutableArray *tmDataSource;
@property (nonatomic,strong)NSMutableArray *pmDataSource;
@property (nonatomic,strong)NSMutableArray *ltDataSource;
@property (nonatomic,strong)NSMutableArray *mxDataSource;
@property (nonatomic,strong)NSMutableArray *rxDataSource;
@property (nonatomic,strong)NSMutableArray *ebDataSource;
@property (nonatomic,strong)NSMutableArray *allDataSource;
@property (nonatomic,strong)NSMutableArray *deleteSource;

@property (nonatomic,strong)UIView *sourceBackV;
@property (nonatomic,strong)UIButton *JDBtn;
@property (nonatomic,strong)UIButton *TaobaoBtn;
@property (nonatomic,strong)UIButton *TmallBtn;
@property (nonatomic,strong)UIButton *Amazonbtn;

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





@property (nonatomic,strong)NSString *enKeyWords;
@property (nonatomic,strong)NSString *jpKeyWords;

@property (nonatomic,strong)NSString *keywordTwo;
@property (nonatomic,strong)UIImageView *emptyIv;
@property (nonatomic,strong)UILabel *emptyLb;

@property (nonatomic,assign)BOOL textFieldSearch;

@property (nonatomic,strong)UIView *animationBackV;

@property (nonatomic,strong)NSString *page;
@end

@implementation NewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = @"1";
    NSLog(@"NewSearchViewController");
    // Do any additional setup after loading the view.
    [self.searchSource addObject:@"JD"];
    [self.searchSource addObject:@"Taobao"];
    [self.searchSource addObject:@"Tmall"];
    [self.searchSource addObject:@"Amazon"];
    self.searching = NO;
    self.sourceNum = @"0";
    [self createUI];
    [self downloadMoneytype];
    [self.tabBarController.view addSubview:self.animationBackV];
}





- (void)downLoadWithKeyWordPage:(NSString *)keyWord
{
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    self.currentClassStr = keyWord;
    self.searchOrClassification = NO;
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"keyword"] = keyWord;
    parameters[@"sort"] = @"0";
    parameters[@"more"] = @"1";

    parameters[@"page"] = self.page;
    
    [manager GET:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/bykeyword/webapi/list" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self.collectionView.mj_footer endRefreshing];
        self.animationBackV.hidden = YES;
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            
            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
//                if ([responseObject[@"data"][i][@"good_site"]isEqualToString:@"ebay"]) {
////                    return ;
//                }else{
                    [self.allDataSource addObject:responseObject[@"data"][i]];
//                }
                
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
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"6pm"]) {
                    [self.pmDataSource addObject:self.allDataSource[i]];
                }
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"rakuten"]) {
                    [self.ltDataSource addObject:self.allDataSource[i]];
                }
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"macys"]) {
                    [self.mxDataSource addObject:self.allDataSource[i]];
                }
                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"Nissen"]) {
                    [self.rxDataSource addObject:self.allDataSource[i]];
                }

            }
            
            self.animationBackV.hidden = YES;
            self.searching = YES;
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.animationBackV.hidden = YES;
        self.searching = YES;
        [self.collectionView reloadData];
        
    }];
}

//asdasdasdasd
- (void)downExternalEbayDataPage{
    
    self.page = [NSString stringWithFormat:@"%d",[self.page intValue]+1];
    [self.ebDataSource removeAllObjects];
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSDictionary *params = @{@"paginationInput.pageNumber":self.page,
                             @"keywords":self.enKeyWords
                             };
    [manager GET:@"https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=-0-PRD-0ea9e4abd-faed9a4b&REST-PAYLOAD&itemFilter(0).name=Currency&itemFilter(0).value=USD&itemFilter(1).name=HideDuplicateItems&itemFilter(1).value=true&outputSelector=SellerInfo&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=20" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.animationBackV.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"@count"]] isEqualToString:@"0"]) {
        }else{
            NSArray *tmpArr = responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"];
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"ebay";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"title"][0]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"https://www.ebay.com/itm/%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"itemId"][0]];

                tmpDict[@"good_pic"] = [[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"galleryURL"][0]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self downExternalJDDataPage];
    }];
}


- (void)downExternalJDDataPage{
    
    [self.jdDataSource removeAllObjects];
    self.animationBackV.hidden = NO;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml",@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *time = [self getCurrentTimes];
    

    NSString *mdStr = [NSString stringWithFormat:@"cf2109bc3d254ecba1a1a0b823b78bd1360buy_param_json{\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%@,\"pageSize\":20},\"orderField\":0}access_token031e8a1b04c545a6bc033929f200873amxztapp_key398230142d607c53011684710b966978methodjd.kpl.open.xuanpin.searchgoodstimestamp%@v1.0cf2109bc3d254ecba1a1a0b823b78bd1",self.keyWords,self.page,time];
    
    NSLog(@"mdStr============>%@",mdStr);

    
    NSString *url = [NSString stringWithFormat:@"https://api.jd.com/routerjson?access_token=031e8a1b04c545a6bc033929f200873amxzt&app_key=398230142d607c53011684710b966978&method=jd.kpl.open.xuanpin.searchgoods&v=1.0&timestamp=%@&360buy_param_json={\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%@,\"pageSize\":20},\"orderField\":0}&sign=%@",time,self.keyWords,self.page,[self md5:mdStr].uppercaseString];
    
    
    NSLog(@"url============>%@",url);
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:@"" progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
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
        [self.collectionView.mj_footer endRefreshing];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self.collectionView.mj_footer endRefreshing];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
    }];
}




- (void)downExternalTaobaoDataPage{//76e85e1eb449630feeb6da85a21496fc
    
    self.animationBackV.hidden = NO;
    [self.tbDataSource removeAllObjects];
    //    NSArray * array = [[NSArray alloc]initWithObjects:@"app_key",@"cat",@"fields",@"method",@"q",@"sign_method",@"timestamp",@"v",nil];
    //    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
    //    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    //    NSComparator sort = ^(NSString *obj1,NSString *obj2){
    //        NSRange range =NSMakeRange(0,obj1.length);
    //        return [obj1 compare:obj2 options:comparisonOptions range:range];
    //    };
    //    NSArray *resultArray2 = [array sortedArrayUsingComparator:sort];
    //    NSLog(@"字符串数组排序结果%@",resultArray2);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml", nil];
    NSString *time = [self getCurrentTimes];
    NSString *mdStr = [NSString stringWithFormat:@"76e85e1eb449630feeb6da85a21496fcadzone_id108433400489app_key25401200cat16methodtaobao.tbk.dg.material.optionalpage_no%@q%@sign_methodmd5timestamp%@v2.076e85e1eb449630feeb6da85a21496fc",self.page,self.keyWords,time];
    NSDictionary *params = @{@"app_key":@"25401200",
                             @"cat":@"16",
//                             @"fields":@"title,pict_url,small_images,user_type,provcity,item_url,seller_id,volume,nick,zk_final_price",
                             @"method":@"taobao.tbk.dg.material.optional",
                             @"q":self.keyWords,
                             @"sign_method":@"md5",
                             @"timestamp":time,
                             @"v":@"2.0",
                             @"sign":[self md5:mdStr].uppercaseString,
                             @"adzone_id":@"108433400489",
                             @"page_no":self.page
                             };
    [manager POST:@"https://eco.taobao.com/router/rest" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:receiveStr];
        NSLog(@"%@",xmlDoc);
        
        for (int i=0 ; i<[xmlDoc[@"result_list"][@"map_data"] count]; i++) {
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
            tmpDict[@"good_site"] = @"taobao";
            tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"title"]];
            tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"item_url"]];
            tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"pict_url"]];
            tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"zk_final_price"]];
            tmpDict[@"good_currency"] = [NSString stringWithFormat:@"CNY"];
            [self.tbDataSource addObject:tmpDict];
        }
//        if ([xmlDoc[@"results"][@"n_tbk_item"] isKindOfClass:[NSDictionary class]]) {
//            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
//            tmpDict[@"good_site"] = @"sale";
//            tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][@"title"]];
//            tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][@"item_url"]];
//            tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][@"pict_url"]];
//            tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][@"zk_final_price"]];
//            tmpDict[@"good_currency"] = [NSString stringWithFormat:@"CNY"];
//            [self.tbDataSource addObject:tmpDict];
//        }else{
//            for (int i = 0 ; i < [xmlDoc[@"results"][@"n_tbk_item"] count] ; i++) {
//                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
//                tmpDict[@"good_site"] = @"sale";
//                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][i][@"title"]];
//                tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][i][@"item_url"]];
//                tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][i][@"pict_url"]];
//                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"results"][@"n_tbk_item"][i][@"zk_final_price"]];
//                tmpDict[@"good_currency"] = [NSString stringWithFormat:@"CNY"];
//                [self.tbDataSource addObject:tmpDict];
//            }
//        }
        
       
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.tbDataSource.count; i++) {
                [self.allDataSource addObject:self.tbDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.tbDataSource.count; i++) {
                [self.allDataSource insertObject:self.tbDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }

        [self.collectionView.mj_footer endRefreshing];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
//        [self downExternalNewRakutenAccPage];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self.collectionView.mj_footer endRefreshing];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
//        [self downExternalNewRakutenAccPage];
    }];
}

- (void)downExternalNewRakutenAccPage{
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    // 通过 ID ：密码 的格式，用Basic 的方式拼接成字符串
    NSString * authorization = [NSString stringWithFormat:@"Basic aEtGQ0V1TUFTcEpzczk3MjhaTkthNFhUamMwYTpWQmMxTkVyMnE5Tm8wc1pLY3g0anNoYkxZQndh"];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"username":@"daliandyh",
                             @"password":@"1236987abc",
                             @"scope":@"3358737",
                             @"grant_type":@"password"
                             };
    
    [manager POST:@"https://api.rakutenmarketing.com/token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.animationBackV.hidden = YES;
        [self downExternalNewRakutenDataWithKeyPage:responseObject[@"access_token"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.animationBackV.hidden = YES;
    }];
}

- (void)downExternalNewRakutenDataWithKeyPage:(NSString *)key{
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/xml", nil];
    // 通过 ID ：密码 的格式，用Basic 的方式拼接成字符串
    NSString * authorization = [NSString stringWithFormat:@"Bearer %@",key];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"keyword":self.enKeyWords,
                             @"max":@"50",
                             @"pagenumber":self.page
                             };
    
    [manager GET:@"https://api.rakutenmarketing.com/productsearch/1.0" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.mj_footer endRefreshing];
        self.animationBackV.hidden = YES;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:receiveStr];
        NSLog(@"%@",xmlDoc);
        if ([xmlDoc[@"item"] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
            tmpDict[@"good_site"] = @"sale";
            tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"productname"]];
            tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"linkurl"]];
            tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"imageurl"]];
            tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"price"][@"__text"]];
            tmpDict[@"good_currency"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"price"][@"_currency"]];
            [self.saleDataSource addObject:tmpDict];
        }else{
            for (int i = 0 ; i < [xmlDoc[@"item"] count] ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"sale";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"productname"]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"linkurl"]];
                tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"imageurl"]];
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"price"][@"__text"]];
                tmpDict[@"good_currency"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"price"][@"_currency"]];
                [self.saleDataSource addObject:tmpDict];
            }
        }
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.ebDataSource.count; i++) {
                [self.allDataSource addObject:self.saleDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.saleDataSource.count; i++) {
                [self.allDataSource insertObject:self.saleDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        
        [self.collectionView.mj_footer endRefreshing];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
//        [self downLoadWithKeyWordPage:self.currentClassStr];
//        return ;
        
//        [self downExternalRakutenDataPage];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
//        [self downLoadWithKeyWordPage:self.currentClassStr];
//        return ;
//        [self downExternalRakutenDataPage];
    }];
}

- (void)downExternalRakutenDataPage{
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSDictionary *params = @{@"page":self.page,
                             @"keyword":self.jpKeyWords
                             };
    [manager GET:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&applicationId=1065137018908384107&operation=ItemSearch&orFlag=0&asurakuFlag=0&genreInformationFlag=0&purchaseType=0&shipOverseasFlag=0&pointRateFlag=0&creditCardFlag=0&availability=1&genreId=&hits=30" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        if ([responseObject[@"Items"] count] > 0) {
            NSArray *tmpArr = responseObject[@"Items"];
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"rakuten";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"itemName"]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"itemUrl"]];
                if ([tmpArr[i][@"Item"][@"mediumImageUrls"] count] == 0){
                    tmpDict[@"good_pic"] = @"";
                }else{
                    tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"mediumImageUrls"][0][@"imageUrl"]];
                }
                
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"itemPrice"]];
                tmpDict[@"good_currency"] = @"JPY";
                [self.ltDataSource addObject:tmpDict];
            }
        }
        
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.ltDataSource.count; i++) {
                [self.allDataSource addObject:self.ltDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.ltDataSource.count; i++) {
                [self.allDataSource insertObject:self.ltDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        
        
        if (self.allDataSource.count == 0) {
            self.emptyIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 50, kScreenH/2 - 50, 100, 100)];
            self.emptyIv.image = [UIImage imageNamed:@"home_Empty"];
            [self.view addSubview:self.emptyIv];
            self.emptyLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 130, kScreenH/2 + 70, 260, 40)];
            self.emptyLb.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"GlobalBuyer_Home_SearchEmpty_one", nil),self.searchTf.text,NSLocalizedString(@"GlobalBuyer_Home_SearchEmpty_two", nil)];
            self.emptyLb.numberOfLines = 0;
            self.emptyLb.textColor = [UIColor lightGrayColor];
            self.emptyLb.font = [UIFont systemFontOfSize:12];
            self.emptyLb.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.emptyLb];
        }else{
            [self.emptyIv removeFromSuperview];
            [self.emptyLb removeFromSuperview];
        }
        
        self.searching = YES;
//        [self downLoadWithKeyWordPage:self.currentClassStr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self downLoadWithKeyWordPage:self.currentClassStr];
    }];
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

//初始化汇率数据源
-(NSMutableArray *)moneytypeArr {
    if (_moneytypeArr == nil) {
        _moneytypeArr = [NSMutableArray new];
    }
    return _moneytypeArr;
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

- (NSMutableArray *)saleDataSource{
    if (_saleDataSource == nil) {
        _saleDataSource = [[NSMutableArray alloc]init];
    }
    return _saleDataSource;
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

- (NSMutableArray *)pmDataSource
{
    if (_pmDataSource == nil) {
        _pmDataSource = [[NSMutableArray alloc]init];
    }
    return _pmDataSource;
}

- (NSMutableArray *)ltDataSource
{
    if (_ltDataSource == nil) {
        _ltDataSource = [[NSMutableArray alloc]init];
    }
    return _ltDataSource;
}

- (NSMutableArray *)mxDataSource
{
    if (_mxDataSource == nil) {
        _mxDataSource = [[NSMutableArray alloc]init];
    }
    return _mxDataSource;
}

- (NSMutableArray *)rxDataSource
{
    if (_rxDataSource == nil) {
        _rxDataSource = [[NSMutableArray alloc]init];
    }
    return _rxDataSource;
}

- (NSMutableArray *)ebDataSource
{
    if (_ebDataSource == nil) {
        _ebDataSource = [[NSMutableArray alloc]init];
    }
    return _ebDataSource;
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
        
        [self downLoadLargeClass];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.sourceBackV];
    
    [self.view addSubview:self.magnifierV];
    [self.view addSubview:self.searchTf];
//    [self.searchTf becomeFirstResponder];
//    UIView *brandSearchBackV = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + 64, kScreenW - 20, 40)];
//    brandSearchBackV.backgroundColor = [UIColor lightGrayColor];
//    brandSearchBackV.alpha = 0.7;
//    [self.view addSubview:brandSearchBackV];
//    
//    UIImageView *magnifierIv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15 + 64, 30, 30)];
//    magnifierIv.image = [UIImage imageNamed:@"放大镜"];
//    [self.view addSubview:magnifierIv];
//    
//    UITextField *brandSearchTv = [[UITextField alloc]initWithFrame:CGRectMake(50, 10 + 64, kScreenW - 50, 40)];
//    brandSearchTv.delegate = self;
//    brandSearchTv.returnKeyType = UIReturnKeySearch;
//    brandSearchTv.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:brandSearchTv];
//    brandSearchTv.placeholder = NSLocalizedString(@"GlobalBuyer_SearchViewController_placeholder", nil);
}

//初始化输入框
- (UITextField *)searchTf
{
    if (_searchTf == nil) {
//        _searchTf = [[UITextField alloc]initWithFrame:CGRectMake( 100 , 64 + 10, kScreenW - 110, 35)];//11
        _searchTf = [[UITextField alloc]initWithFrame:CGRectMake( 100 ,10, kScreenW - 110, 35)];
        _searchTf.backgroundColor = [UIColor whiteColor];
        _searchTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _searchTf.layer.borderWidth = 0.6;
        _searchTf.placeholder = NSLocalizedString(@"GlobalBuyer_SearchViewController_placeholder", nil);
//        [_searchTf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//        _searchTf.textColor = [UIColor whiteColor];
        _searchTf.delegate = self;
        _searchTf.returnKeyType = UIReturnKeySearch;
        //        [_searchTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTf;
}

//放大镜图标
- (UIView *)magnifierV
{
    if (_magnifierV == nil) {
//        _magnifierV = [[UIView alloc]initWithFrame:CGRectMake(10, 64 + 10, 90, 35)];//11
        _magnifierV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 90, 35)];
        _magnifierV.backgroundColor = [UIColor whiteColor];
        _magnifierV.layer.borderWidth = 0.7;
        _magnifierV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _magnifierV.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeWebSource)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_magnifierV addGestureRecognizer:tap];
        
        self.currentWebIconIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
        self.currentWebIconIV.image = [UIImage imageNamed:@"WebIconALL"];
        [_magnifierV addSubview:self.currentWebIconIV];
        self.currentWebLb = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 60 , 25)];
        self.currentWebLb.textAlignment = NSTextAlignmentCenter;
        self.currentWebLb.font = [UIFont systemFontOfSize:15];
        self.currentWebLb.text = @"ALL";
        [_magnifierV addSubview:self.currentWebLb];
    }
    return _magnifierV;
}

- (void)changeWebSource
{
    [self.view addSubview:self.changeWebIconV];
}

- (UIView *)changeWebIconV
{
    if (_changeWebIconV == nil) {
//        _changeWebIconV = [[UIView alloc]initWithFrame:CGRectMake(10, 64 + 10 + 35, 90, 35*8)];//11
        _changeWebIconV = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + 35, 90, 35*8)];
        _changeWebIconV.backgroundColor = [UIColor whiteColor];
        _changeWebIconV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _changeWebIconV.layer.borderWidth = 0.7;
        
        NSArray *arr;
        NSArray *arrName;
        if (self.textFieldSearch == YES) {
//            _changeWebIconV.frame = CGRectMake(10, 64 + 10 + 35, 90, 35*5);//11
            _changeWebIconV.frame = CGRectMake(10, 10 + 35, 90, 35*5);
//            arr = @[@"WebIconALL",@"ic_octopus_sale",@"淘宝分类",@"乐天",@"Ebay"];
//            arrName = @[@"ALL",@"Sale",@"TaoBao",@"rakuten",@"ebay"];
            arr = @[@"WebIconALL",@"京东分类",@"Ebay"];
            arrName = @[@"ALL",@"JD",@"Ebay"];
        }else{
//            _changeWebIconV.frame = CGRectMake(10, 64 + 10 + 35, 90, 35*9);//11
            _changeWebIconV.frame = CGRectMake(10, 10 + 35, 90, 35*9);
//            arr = @[@"WebIconALL",@"ic_octopus_sale",@"淘宝分类",@"天猫分类",@"京东分类",@"亚马逊分类",@"6pm",@"乐天",@"Ebay"];
//            arrName = @[@"ALL",@"Sale",@"TaoBao",@"Tmall",@"JD",@"Amazon",@"6pm",@"rakuten",@"ebay"];
            arr = @[@"WebIconALL",@"京东分类",@"Ebay"];
            arrName = @[@"ALL",@"JD",@"Ebay"];
        }
        for (int i = 0 ; i < arr.count; i++) {
            UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 35*i, 90, 35)];
            backV.tag = i;
            backV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShopIcon:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [backV addGestureRecognizer:tap];
            
            UIImageView *webIconIv = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5 , 25, 25)];
            webIconIv.image = [UIImage imageNamed:arr[i]];
            [backV addSubview:webIconIv];
            UILabel *webNameLb = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 60, 25)];
            webNameLb.textAlignment = NSTextAlignmentCenter;
            webNameLb.text = arrName[i];
            webNameLb.font = [UIFont systemFontOfSize:14];
            [backV addSubview:webNameLb];
            [_changeWebIconV addSubview:backV];
            
        }
    }
    return _changeWebIconV;
}

- (void)clickShopIcon:(UITapGestureRecognizer *)tap
{
    if (self.textFieldSearch == YES) {
        if ([tap view].tag == 0) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"WebIconALL"];
            self.currentWebLb.text = @"ALL";
            self.sourceNum = @"0";
        }
        if ([tap view].tag == 1) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"京东分类"];
            self.currentWebLb.text = @"JD";
            self.sourceNum = @"4";
//            self.currentWebIconIV.image = [UIImage imageNamed:@"ic_octopus_sale"];
//            self.currentWebLb.text = @"Sale";
//            self.sourceNum = @"1";
        }
        if ([tap view].tag == 2) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"Ebay"];
            self.currentWebLb.text = @"ebay";
            self.sourceNum = @"8";
//            self.currentWebIconIV.image = [UIImage imageNamed:@"淘宝分类"];
//            self.currentWebLb.text = @"TaoBao";
//            self.sourceNum = @"2";
        }
//        if ([tap view].tag == 3) {
//            self.currentWebIconIV.image = [UIImage imageNamed:@"乐天"];
//            self.currentWebLb.text = @"rakuten";
//            self.sourceNum = @"3";
//        }
        if ([tap view].tag == 3) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"Ebay"];
            self.currentWebLb.text = @"ebay";
            self.sourceNum = @"4";
        }
    }else{
        if ([tap view].tag == 0) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"WebIconALL"];
            self.currentWebLb.text = @"ALL";
            self.sourceNum = @"0";
        }
        if ([tap view].tag == 1) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"京东分类"];
            self.currentWebLb.text = @"JD";
            self.sourceNum = @"4";
//            self.currentWebIconIV.image = [UIImage imageNamed:@"ic_octopus_sale"];
//            self.currentWebLb.text = @"Sale";
//            self.sourceNum = @"1";
        }
        if ([tap view].tag == 2) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"Ebay"];
            self.currentWebLb.text = @"ebay";
            self.sourceNum = @"8";
//            self.currentWebIconIV.image = [UIImage imageNamed:@"淘宝分类"];
//            self.currentWebLb.text = @"TaoBao";
//            self.sourceNum = @"2";
        }
        if ([tap view].tag == 3) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"天猫分类"];
            self.currentWebLb.text = @"Tmall";
            self.sourceNum = @"3";
        }
        if ([tap view].tag == 4) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"京东分类"];
            self.currentWebLb.text = @"JD";
            self.sourceNum = @"4";
        }
        if ([tap view].tag == 5) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"亚马逊分类"];
            self.currentWebLb.text = @"Amazon";
            self.sourceNum = @"5";
        }
        if ([tap view].tag == 6) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"6pm"];
            self.currentWebLb.text = @"6pm";
            self.sourceNum = @"6";
        }
//        if ([tap view].tag == 7) {
//            self.currentWebIconIV.image = [UIImage imageNamed:@"乐天"];
//            self.currentWebLb.text = @"rakuten";
//            self.sourceNum = @"7";
//        }
        //    if ([tap view].tag == 7) {
        //        self.currentWebIconIV.image = [UIImage imageNamed:@"梅西百货"];
        //        self.currentWebLb.text = @"macys";
        //        self.sourceNum = @"7";
        //    }
        //    if ([tap view].tag == 8) {
        //        self.currentWebIconIV.image = [UIImage imageNamed:@"日线"];
        //        self.currentWebLb.text = @"Nissen";
        //        self.sourceNum = @"8";
        //    }
        if ([tap view].tag == 7) {
            self.currentWebIconIV.image = [UIImage imageNamed:@"Ebay"];
            self.currentWebLb.text = @"ebay";
            self.sourceNum = @"8";
        }

    }
    [self.changeWebIconV removeFromSuperview];
    self.changeWebIconV = nil;
    if (self.searching == NO) {
        return;
    }else{
        [self.collectionView reloadData];
    }
    NSLog(@"刷新%@",self.sourceNum);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.saleDataSource removeAllObjects];
    [self.jdDataSource removeAllObjects];
    [self.tbDataSource removeAllObjects];
    [self.tmDataSource removeAllObjects];
    [self.amDataSource removeAllObjects];
    [self.pmDataSource removeAllObjects];
    [self.ltDataSource removeAllObjects];
    [self.mxDataSource removeAllObjects];
    [self.rxDataSource removeAllObjects];
    [self.ebDataSource removeAllObjects];
    [self.allDataSource removeAllObjects];
    self.textFieldSearch = YES;
    self.page = @"1";
    
    self.keyWords = [NSString stringWithFormat:@"%@",textField.text];
    [textField resignFirstResponder];
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage containsString:@"zh-Hans"]) {
        self.originalType = @"zh";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        self.originalType = @"cht";
    }else{
        self.originalType = @"auto";
    }
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"appid":BaiDuAppid,
                             @"key":BaiDuKey,
                             @"q":textField.text,
                             @"salt":@"1521168024389",
                             @"from":self.originalType,
                             @"to":@"en",
                             @"sign":[self md5:[NSString stringWithFormat:@"%@%@%@%@",BaiDuAppid,textField.text,@"1521168024389",BaiDuKey]]};
    
    [manager POST:BaiDuTranslateApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.enKeyWords = [NSString stringWithFormat:@"%@",responseObject[@"trans_result"][0][@"dst"]];
        [self delayMethod1];
//        [self  performSelector:@selector(delayMethod1) withObject:nil afterDelay:1.0f];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    
    return YES;
}
- (void)delayMethod1{
    [self changeStrJ];
}
- (void)addGoodsData{
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage containsString:@"zh-Hans"]) {
        self.originalType = @"zh";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        self.originalType = @"cht";
    }else{
        self.originalType = @"auto";
    }
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"appid":BaiDuAppid,
                             @"key":BaiDuKey,
                             @"q":self.keyWords,
                             @"salt":@"1521168024389",
                             @"from":self.originalType,
                             @"to":@"en",
                             @"sign":[self md5:[NSString stringWithFormat:@"%@%@%@%@",BaiDuAppid,self.keyWords,@"1521168024389",BaiDuKey]]};
    
    [manager POST:BaiDuTranslateApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.enKeyWords = [NSString stringWithFormat:@"%@",responseObject[@"trans_result"][0][@"dst"]];
        NSLog(@"responseObject%@",responseObject[@"trans_result"]);
        [self changeStrJ];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)downExternalEbayData{
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downExternalEbayDataPage)];
    
    // 设置文字
    [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStatePulling", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateRefreshing", nil) forState:MJRefreshStateNoMoreData];
    
    _collectionView.mj_footer = footer;
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSDictionary *params = @{@"paginationInput.pageNumber":@"1",
                             @"keywords":self.enKeyWords
                             };
    NSLog(@"ebay请求参数%@",self.enKeyWords);
    [manager GET:@"https://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.13.0&SECURITY-APPNAME=-0-PRD-0ea9e4abd-faed9a4b&REST-PAYLOAD&itemFilter(0).name=Currency&itemFilter(0).value=USD&itemFilter(1).name=HideDuplicateItems&itemFilter(1).value=true&outputSelector=SellerInfo&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=20"parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.animationBackV.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"@count"]] isEqualToString:@"0"]) {
        }else{
            NSArray *tmpArr = responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"];
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"ebay";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"title"][0]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"https://www.ebay.com/itm/%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"itemId"][0]];
//                tmpDict[@"good_pic"] = [NSString stringWithFormat:@"http://galleryplus.ebayimg.com/ws/web/%@_1_10_1.jpg",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"itemId"][0]];
                tmpDict[@"good_pic"] = [[NSString stringWithFormat:@"%@",responseObject[@"findItemsByKeywordsResponse"][0][@"searchResult"][0][@"item"][i][@"galleryURL"][0]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
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
        
//        [self downExternalTaobaoData];
        
        [self downExternalJDData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败 %@",error);
//        [self downExternalTaobaoData];
        [self downExternalJDData];
    }];
}



- (void)downExternalJDData{
    
    self.animationBackV.hidden = NO;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml",@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *time = [self getCurrentTimes];
    

    NSString *mdStr = [NSString stringWithFormat:@"cf2109bc3d254ecba1a1a0b823b78bd1360buy_param_json{\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%@,\"pageSize\":20},\"orderField\":0}access_token031e8a1b04c545a6bc033929f200873amxztapp_key398230142d607c53011684710b966978methodjd.kpl.open.xuanpin.searchgoodstimestamp%@v1.0cf2109bc3d254ecba1a1a0b823b78bd1",self.keyWords,self.page,time];
    
    NSLog(@"mdStr============>%@",mdStr);

    
    NSString *url = [NSString stringWithFormat:@"https://api.jd.com/routerjson?access_token=031e8a1b04c545a6bc033929f200873amxzt&app_key=398230142d607c53011684710b966978&method=jd.kpl.open.xuanpin.searchgoods&v=1.0&timestamp=%@&360buy_param_json={\"queryParam\":{\"keywords\":\"%@\",\"skuId\":\"\"},\"pageParam\":{\"pageNum\":%@,\"pageSize\":20},\"orderField\":0}&sign=%@",time,self.keyWords,self.page,[self md5:mdStr].uppercaseString];
    
    
    NSLog(@"url============>%@",url);
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:@"" progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
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
        [self reloadCollectionViewData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self reloadCollectionViewData];
    }];
}


- (void)reloadCollectionViewData{

    
    self.searching = YES;
    self.animationBackV.hidden = YES;
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
}




- (void)downExternalTaobaoData{//76e85e1eb449630feeb6da85a21496fc
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml", nil];
    NSString *time = [self getCurrentTimes];
    NSString *mdStr = [NSString stringWithFormat:@"76e85e1eb449630feeb6da85a21496fcadzone_id108433400489app_key25401200cat16methodtaobao.tbk.dg.material.optionalpage_no%@q%@sign_methodmd5timestamp%@v2.076e85e1eb449630feeb6da85a21496fc",self.page,self.keyWords,time];
    NSDictionary *params = @{@"app_key":@"25401200",
                             @"cat":@"16",
//                             @"fields":@"title,pict_url,small_images,user_type,provcity,item_url,seller_id,volume,nick,zk_final_price",
                             @"method":@"taobao.tbk.dg.material.optional",
                             @"q":self.keyWords,
                             @"sign_method":@"md5",
                             @"timestamp":time,
                             @"v":@"2.0",
                             @"sign":[self md5:mdStr].uppercaseString,
                             @"adzone_id":@"108433400489",
                             @"page_no":self.page
                             };
    [manager POST:@"https://eco.taobao.com/router/rest" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:receiveStr];
        NSLog(@"%@",xmlDoc);
        
        for (int i=0 ; i<[xmlDoc[@"result_list"][@"map_data"] count]; i++) {
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
            tmpDict[@"good_site"] = @"taobao";
            tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"title"]];
            tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"item_url"]];
            tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"pict_url"]];
            tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"result_list"][@"map_data"][i][@"zk_final_price"]];
            tmpDict[@"good_currency"] = [NSString stringWithFormat:@"CNY"];
            [self.tbDataSource addObject:tmpDict];
        }

        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.tbDataSource.count; i++) {
                [self.allDataSource addObject:self.tbDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.tbDataSource.count; i++) {
                [self.allDataSource insertObject:self.tbDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
//        [self downExternalNewRakutenAcc];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self downExternalNewRakutenAcc];
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
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

- (void)downExternalNewRakutenAcc{
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    // 通过 ID ：密码 的格式，用Basic 的方式拼接成字符串
    NSString * authorization = [NSString stringWithFormat:@"Basic aEtGQ0V1TUFTcEpzczk3MjhaTkthNFhUamMwYTpWQmMxTkVyMnE5Tm8wc1pLY3g0anNoYkxZQndh"];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"username":@"daliandyh",
                             @"password":@"1236987abc",
                             @"scope":@"3358737",
                             @"grant_type":@"password"
                             };
    
    [manager POST:@"https://api.rakutenmarketing.com/token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.animationBackV.hidden = YES;
        [self downExternalNewRakutenDataWithKey:responseObject[@"access_token"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)downExternalNewRakutenDataWithKey:(NSString *)key{
    
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/xml", nil];
    // 通过 ID ：密码 的格式，用Basic 的方式拼接成字符串
    NSString * authorization = [NSString stringWithFormat:@"Bearer %@",key];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"keyword":self.enKeyWords,
                             @"max":@"50",
                             @"pagenumber":@"1"
                             };
    
    [manager GET:@"https://api.rakutenmarketing.com/productsearch/1.0" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:receiveStr];
        NSLog(@"%@",xmlDoc);
        
        if ([xmlDoc[@"item"] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
            tmpDict[@"good_site"] = @"sale";
            tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"productname"]];
            tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"linkurl"]];
            tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"imageurl"]];
            tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"price"][@"__text"]];
            tmpDict[@"good_currency"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][@"price"][@"_currency"]];
            [self.saleDataSource addObject:tmpDict];
        }else{
            
            for (int i = 0 ; i < [xmlDoc[@"item"] count] ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"sale";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"productname"]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"linkurl"]];
                tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"imageurl"]];
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"price"][@"__text"]];
                tmpDict[@"good_currency"] = [NSString stringWithFormat:@"%@",xmlDoc[@"item"][i][@"price"][@"_currency"]];
                [self.saleDataSource addObject:tmpDict];
            }
        }
        
      
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.ebDataSource.count; i++) {
                [self.allDataSource addObject:self.saleDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.saleDataSource.count; i++) {
                [self.allDataSource insertObject:self.saleDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
        return ;
        
//        [self downExternalRakutenData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self downExternalRakutenData];
        [self.collectionView reloadData];
    }];
}

- (void)downExternalRakutenData{
    self.animationBackV.hidden = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSDictionary *params = @{@"page":@"1",
                             @"keyword":self.jpKeyWords
                             };
    [manager GET:@"https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?format=json&applicationId=1065137018908384107&operation=ItemSearch&orFlag=0&asurakuFlag=0&genreInformationFlag=0&purchaseType=0&shipOverseasFlag=0&pointRateFlag=0&creditCardFlag=0&availability=1&genreId=&hits=30" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.animationBackV.hidden = YES;
        if ([responseObject[@"Items"] count] > 0) {
            NSArray *tmpArr = responseObject[@"Items"];
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                tmpDict[@"good_site"] = @"rakuten";
                tmpDict[@"good_name"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"itemName"]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"itemUrl"]];
                if ([tmpArr[i][@"Item"][@"mediumImageUrls"] count] == 0){
                    tmpDict[@"good_pic"] = @"";
                }else{
                    tmpDict[@"good_pic"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"mediumImageUrls"][0][@"imageUrl"]];
                }
                tmpDict[@"good_price"] = [NSString stringWithFormat:@"%@",tmpArr[i][@"Item"][@"itemPrice"]];
                tmpDict[@"good_currency"] = @"JPY";
                [self.ltDataSource addObject:tmpDict];
            }
        }
        if (self.allDataSource.count == 0) {
            for (int i = 0 ; i < self.ltDataSource.count; i++) {
                [self.allDataSource addObject:self.ltDataSource[i]];
            }
        }else{
            for (int i = 0 ; i < self.ltDataSource.count; i++) {
                [self.allDataSource insertObject:self.ltDataSource[i] atIndex:arc4random()%self.allDataSource.count];
            }
        }
        
        if (self.allDataSource.count == 0) {
            self.emptyIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 35 + 50, kScreenH/2 - 50, 70, 70)];
            self.emptyIv.image = [UIImage imageNamed:@"home_Empty"];
            [self.view addSubview:self.emptyIv];
            self.emptyLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 130 + 100, kScreenH/2 + 70, 160, 60)];
            self.emptyLb.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"GlobalBuyer_Home_SearchEmpty_one", nil),self.searchTf.text,NSLocalizedString(@"GlobalBuyer_Home_SearchEmpty_two", nil)];
            self.emptyLb.numberOfLines = 0;
            self.emptyLb.textColor = [UIColor lightGrayColor];
            self.emptyLb.font = [UIFont systemFontOfSize:12];
            self.emptyLb.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.emptyLb];
        }else{
            [self.emptyIv removeFromSuperview];
            [self.emptyLb removeFromSuperview];
        }
        
        self.searching = YES;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.searching = YES;
        self.animationBackV.hidden = YES;
        [self.collectionView reloadData];
    }];
}

- (void)changeStrJ
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"appid":BaiDuAppid,
                             @"key":BaiDuKey,
                             @"q":self.keyWords,
                             @"salt":@"1521168024389",
                             @"from":self.originalType,
                             @"to":@"zh",
                             @"sign":[self md5:[NSString stringWithFormat:@"%@%@%@%@",BaiDuAppid,self.keyWords,@"1521168024389",BaiDuKey]]};
    
    [manager POST:BaiDuTranslateApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject[@"trans_result"][0][@"dst"]){
            self.keyWords = [NSString stringWithFormat:@"%@",responseObject[@"trans_result"][0][@"dst"]];
        }
        
        [self delayMethod2];
//        [self  performSelector:@selector(delayMethod2) withObject:nil afterDelay:1.0f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)delayMethod2{
    [self changeStrJp];
}
- (void)changeStrJp{
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage containsString:@"zh-Hans"]) {
        self.originalType = @"zh";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        self.originalType = @"cht";
    }else{
        self.originalType = @"auto";
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"appid":BaiDuAppid,
                             @"key":BaiDuKey,
                             @"q":self.keyWords,
                             @"salt":@"1521168024389",
                             @"from":self.originalType,
                             @"to":@"jp",
                             @"sign":[self md5:[NSString stringWithFormat:@"%@%@%@%@",BaiDuAppid,self.keyWords,@"1521168024389",BaiDuKey]]};
    
    [manager POST:BaiDuTranslateApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.jpKeyWords = [NSString stringWithFormat:@"%@",responseObject[@"trans_result"][0][@"dst"]];
        if (self.textFieldSearch == YES) {
            [self downExternalEbayData];
        }else{
            [self downLoadWithSearchKeyWord:self.keyWords AmazonKeyWord:self.enKeyWords];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

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
    self.animationBackV.hidden = NO;
     [self downExternalEbayData];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//    parameters[@"api_id"] = API_ID;
//    parameters[@"api_token"] = TOKEN;
//    parameters[@"keyword"] = [NSString stringWithFormat:@"%@/%@/%@",keyWord,AmazonKeyWord,AmazonKeyWord];
//    parameters[@"sort_key"] = @"1";
//    parameters[@"more"] = @"1";
//    parameters[@"page"] = @"1";
//    if (self.keywordTwo.length > 0) {
//        parameters[@"keyword2"] = self.keywordTwo;
//    }
//
//    [manager GET:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/bykeyword/webapi/list" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//
//        self.animationBackV.hidden = YES;
//        if ([responseObject[@"code"]isEqualToString:@"success"]) {
//
//            [self.jdDataSource removeAllObjects];
//            [self.tbDataSource removeAllObjects];
//            [self.tmDataSource removeAllObjects];
//            [self.amDataSource removeAllObjects];
//            [self.pmDataSource removeAllObjects];
//            [self.ltDataSource removeAllObjects];
//            [self.mxDataSource removeAllObjects];
//            [self.rxDataSource removeAllObjects];
//            [self.ebDataSource removeAllObjects];
//            [self.allDataSource removeAllObjects];
//
//            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//
//            for (int i = 0 ; i < [responseObject[@"data"] count]; i++) {
//                if ([responseObject[@"data"][i][@"good_site"]isEqualToString:@"ebay"]) {
////                    return ;
//                }else{
//                     [self.allDataSource addObject:responseObject[@"data"][i]];
//                }
//
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
//                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"6pm"]) {
//                    [self.pmDataSource addObject:self.allDataSource[i]];
//                }
//                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"rakuten"]) {
//                    [self.ltDataSource addObject:self.allDataSource[i]];
//                }
//                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"macys"]) {
//                    [self.mxDataSource addObject:self.allDataSource[i]];
//                }
//                if ([self.allDataSource[i][@"good_site"]isEqualToString:@"Nissen"]) {
//                    [self.rxDataSource addObject:self.allDataSource[i]];
//                }
//
//            }
//            [self downExternalEbayData];
//        }
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//
//        [self downLoadWithSearchKeyWord:keyWord AmazonKeyWord:AmazonKeyWord];
//
//    }];
    
}

- (UIView *)sourceBackV
{
    if (_sourceBackV == nil) {
//        _sourceBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 60, kScreenW , 40)];//11
        _sourceBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenW , 40)];
        
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
    self.animationBackV.hidden = NO;
    
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
    
    [manager POST:BazhuayuTopClass parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
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
        
    }];
}

- (void)downLoadsmallClassWithLargeClass:(NSString *)largeClass
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"parent_class_name"] = largeClass;
    parameters[@"language"] = language;
    
    [manager POST:BazhuayuChildClass parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self.smallClassDataSource removeAllObjects];
            [self.emptyIv removeFromSuperview];
            [self.emptyLb removeFromSuperview];
            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                [self.smallClassDataSource addObject:responseObject[@"data"][i]];
            }
            
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
        }
        self.animationBackV.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.animationBackV.hidden = YES;
        [self.hud hideAnimated:YES];
    }];
}

- (void)downLoadWithKeyWord:(NSString *)keyWord
{
    self.currentClassStr = keyWord;
    self.searchOrClassification = NO;
    self.animationBackV.hidden = NO;
    [self.saleDataSource removeAllObjects];

    self.searching = YES;
    [self addGoodsData];
    

}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        if (@available(iOS 11.0, *)) {
            flowLayout.estimatedItemSize = CGSizeZero;
        }
        flowLayout.itemSize = CGSizeMake((kScreenW-100)/2, (kScreenW-100)/2+50);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100, 64 + 70, kScreenW-100, kScreenH  - kNavigationBarH - kStatusBarH - 70) collectionViewLayout:flowLayout];//11
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100, 70, kScreenW-100, kScreenH  - LL_TabbarHeight-LL_StatusBarAndNavigationBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Cell_BgColor;
        _collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[NewSearchCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class])];
        
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.searching == NO) {
        return self.smallClassDataSource.count;
    }else{

        if (self.textFieldSearch == YES) {
            if ([self.sourceNum isEqualToString:@"0"]) {
                return self.allDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"1"]){
                return self.saleDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"2"]){
                return self.tbDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"3"]){
                return self.ltDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"4"]){
                return self.jdDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"8"]){
                return self.ebDataSource.count;
            }
        }else{
            if ([self.sourceNum isEqualToString:@"0"]) {
                return self.allDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"1"]){
                return self.saleDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"2"]){
                return self.tbDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"3"]){
                return self.tmDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"4"]){
                return self.jdDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"5"]){
                return self.amDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"6"]){
                return self.pmDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"7"]){
                return self.ltDataSource.count;
            }else if ([self.sourceNum isEqualToString:@"8"]){
                NSLog(@"ebay cell个数%ld",self.ebDataSource.count);
                return self.ebDataSource.count;
            }
        }

        
        return self.allDataSource.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NewSearchCollectionViewCell class]) forIndexPath:indexPath];

    
    
    
    if (cell == nil) {
        cell = [[NewSearchCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenW/2, kScreenW/2+50)];
    }
    
    
    
    
    if (self.searching == NO) {
        
        [cell.iv sd_setImageWithURL:[NSURL URLWithString:self.smallClassDataSource[indexPath.row][@"pic"]] placeholderImage:[UIImage imageNamed:@"goods"]];
        cell.price.text = self.smallClassDataSource[indexPath.row][@"name"];
        cell.price.font = [UIFont systemFontOfSize:14];
        cell.price.textColor = [UIColor blackColor];
        cell.source.image = nil;
        cell.nameasd.text = @"";
        
    }else{
        if (self.textFieldSearch == YES) {
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
                }else if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"sale"]){
                    cell.source.image = [UIImage imageNamed:@"ic_octopus_sale"];
                }
                
                cell.nameasd.text = self.allDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.allDataSource[indexPath.row][@"good_link"];
            }else if ([self.sourceNum isEqualToString:@"1"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.saleDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.saleDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.saleDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"ic_octopus_sale"];
                cell.nameasd.text = self.saleDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.saleDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"2"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tbDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.tbDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.tbDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"淘宝分类"];
                cell.nameasd.text = self.tbDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.tbDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"3"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.ltDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.ltDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.ltDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"乐天"];
                cell.nameasd.text = self.ltDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.ltDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"4"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.jdDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.jdDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.jdDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"京东分类"];
                cell.nameasd.text = self.jdDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.jdDataSource[indexPath.row][@"good_link"];
            }else if ([self.sourceNum isEqualToString:@"8"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.ebDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.ebDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.ebDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"Ebay"];
                cell.nameasd.text = self.ebDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.ebDataSource[indexPath.row][@"good_link"];
            }
        }else{
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
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.saleDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.saleDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.saleDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"ic_octopus_sale"];
                cell.nameasd.text = self.saleDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.saleDataSource[indexPath.row][@"good_link"];
            }else if ([self.sourceNum isEqualToString:@"2"]){
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
                
            }else if ([self.sourceNum isEqualToString:@"3"]){
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
                
            }else if ([self.sourceNum isEqualToString:@"4"]){
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
                
            }else if ([self.sourceNum isEqualToString:@"5"]){
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
            }else if ([self.sourceNum isEqualToString:@"6"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.pmDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.pmDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.pmDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"6pm"];
                cell.nameasd.text = self.pmDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.pmDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"7"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.ltDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.ltDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.ltDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"乐天"];
                cell.nameasd.text = self.ltDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.ltDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"8"]){
                if (self.ebDataSource.count<=indexPath.row) {
                    return cell;
                }
                NSLog(@"**************%lu",(unsigned long)self.ebDataSource.count);
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.ebDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.ebDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.ebDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"Ebay"];
                cell.nameasd.text = self.ebDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.ebDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"9"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.rxDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.rxDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.rxDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"日线"];
                cell.nameasd.text = self.rxDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.rxDataSource[indexPath.row][@"good_link"];
                
            }else if ([self.sourceNum isEqualToString:@"10"]){
                cell.price.font = [UIFont systemFontOfSize:12];
                cell.price.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
                [cell.iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.ebDataSource[indexPath.row][@"good_pic"]]] placeholderImage:[UIImage imageNamed:@"goods"]];
                cell.price.text = [CurrencyCalculation getcurrencyCalculation:[self.ebDataSource[indexPath.row][@"good_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.ebDataSource[indexPath.row][@"good_currency"] numberOfGoods:1.0];
                //        cell.price.text = self.allDataSource[indexPath.row][@"good_price"];
                cell.source.image = [UIImage imageNamed:@"Ebay"];
                cell.nameasd.text = self.ebDataSource[indexPath.row][@"good_name"];
                cell.goodsLink = self.ebDataSource[indexPath.row][@"good_link"];
                
            }
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
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"allDataSource===>%lu",(unsigned long)self.allDataSource.count);
    NSLog(@"indexpath.row = %d",indexPath.row);
    if (self.searching == NO) {
        self.textFieldSearch = NO;
        NSArray *arrStr = [self.smallClassDataSource[indexPath.row][@"keyword"] componentsSeparatedByString:@"/"];
        
        if (arrStr != 0) {
            self.keyWords = arrStr[0];
        }
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:0 error:nil];
        self.keyWords = [regularExpression stringByReplacingMatchesInString:self.keyWords options:0 range:NSMakeRange(0, self.keyWords.length) withTemplate:@""];
        self.keywordTwo = [NSString stringWithFormat:@"%@",self.smallClassDataSource[indexPath.row][@"keyword"]];
        [self downLoadWithKeyWord:self.smallClassDataSource[indexPath.row][@"keyword"]];
    }else{
        self.animationBackV.hidden = YES;
//        NewSearchCollectionViewCell * cell = (NewSearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (self.textFieldSearch == YES) {
            if ([self.sourceNum isEqualToString:@"0"]) {
                if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"sale"]) {
                    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                    parameters[@"api_id"] = API_ID;
                    parameters[@"api_token"] = TOKEN;;
                    parameters[@"link"] = self.allDataSource[indexPath.row][@"good_link"];
                    [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [self.hud hideAnimated:YES];
                        if ([responseObject[@"code"]isEqualToString:@"success"]) {
                            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                            shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
                            shopDetailVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:shopDetailVC animated:YES];
                        }else{
                            GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                            shopDetail.hidesBottomBarWhenPushed = YES;
                            shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];
                            [self.navigationController pushViewController:shopDetail animated:YES];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self.hud hideAnimated:YES];
                        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                        shopDetail.hidesBottomBarWhenPushed = YES;
                        shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];;
                        [self.navigationController pushViewController:shopDetail animated:YES];
                    }];
                }else{
//                    if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"ebay"]) {
//                        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
//                        shopDetail.hidesBottomBarWhenPushed = YES;
//                        shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];
//                        shopDetail.isShowText = YES;
//                        [self.navigationController pushViewController:shopDetail animated:YES];
//                    }else{
                        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                        shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
                        shopDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:shopDetailVC animated:YES];
//                    }
//                    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//                    shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
//                    shopDetailVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:shopDetailVC animated:YES];
                }
            }
            if ([self.sourceNum isEqualToString:@"1"]) {
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                parameters[@"api_id"] = API_ID;
                parameters[@"api_token"] = TOKEN;;
                parameters[@"link"] = self.saleDataSource[indexPath.row][@"good_link"];
                [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self.hud hideAnimated:YES];
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                        shopDetailVC.link = self.saleDataSource[indexPath.row][@"good_link"];
                        shopDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:shopDetailVC animated:YES];
                    }else{
                        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                        shopDetail.hidesBottomBarWhenPushed = YES;
                        shopDetail.link = self.saleDataSource[indexPath.row][@"good_link"];;
                        [self.navigationController pushViewController:shopDetail animated:YES];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self.hud hideAnimated:YES];
                    GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                    shopDetail.hidesBottomBarWhenPushed = YES;
                    shopDetail.link = self.saleDataSource[indexPath.row][@"good_link"];;
                    [self.navigationController pushViewController:shopDetail animated:YES];
                }];
                //            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                //            shopDetailVC.link = self.saleDataSource[indexPath.row][@"good_link"];
                //            shopDetailVC.hidesBottomBarWhenPushed = YES;
                //            [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"2"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.tbDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"3"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.ltDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"4"]) {
                    GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                    shopDetail.hidesBottomBarWhenPushed = YES;
                    shopDetail.link = self.ebDataSource[indexPath.row][@"good_link"];
                    shopDetail.isShowText = YES;
                    [self.navigationController pushViewController:shopDetail animated:YES];
//                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//                shopDetailVC.link = self.ebDataSource[indexPath.row][@"good_link"];
//                shopDetailVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
        }else{
            if ([self.sourceNum isEqualToString:@"0"]) {
                if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"sale"]) {
                    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                    parameters[@"api_id"] = API_ID;
                    parameters[@"api_token"] = TOKEN;;
                    parameters[@"link"] = self.allDataSource[indexPath.row][@"good_link"];
                    [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        [self.hud hideAnimated:YES];
                        if ([responseObject[@"code"]isEqualToString:@"success"]) {
                            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                            shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
                            shopDetailVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:shopDetailVC animated:YES];
                        }else{
                            GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                            shopDetail.hidesBottomBarWhenPushed = YES;
                            shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];;
                            [self.navigationController pushViewController:shopDetail animated:YES];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self.hud hideAnimated:YES];
                        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                        shopDetail.hidesBottomBarWhenPushed = YES;
                        shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];;
                        [self.navigationController pushViewController:shopDetail animated:YES];
                    }];
                }else{
//                    if ([self.allDataSource[indexPath.row][@"good_site"]isEqualToString:@"ebay"]) {
//                        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
//                        shopDetail.hidesBottomBarWhenPushed = YES;
//                        shopDetail.link = self.allDataSource[indexPath.row][@"good_link"];
//                        shopDetail.isShowText = YES;
//                        [self.navigationController pushViewController:shopDetail animated:YES];
//                    }else{
                        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                        shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
                        shopDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:shopDetailVC animated:YES];
//                    }
//                    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//                    shopDetailVC.link = self.allDataSource[indexPath.row][@"good_link"];
//                    shopDetailVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:shopDetailVC animated:YES];
                }
            }
            if ([self.sourceNum isEqualToString:@"1"]) {
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                parameters[@"api_id"] = API_ID;
                parameters[@"api_token"] = TOKEN;;
                parameters[@"link"] = self.saleDataSource[indexPath.row][@"good_link"];
                [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self.hud hideAnimated:YES];
                    if ([responseObject[@"code"]isEqualToString:@"success"]) {
                        ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                        shopDetailVC.link = self.saleDataSource[indexPath.row][@"good_link"];
                        shopDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:shopDetailVC animated:YES];
                    }else{
                        GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                        shopDetail.hidesBottomBarWhenPushed = YES;
                        shopDetail.link = self.saleDataSource[indexPath.row][@"good_link"];;
                        [self.navigationController pushViewController:shopDetail animated:YES];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self.hud hideAnimated:YES];
                    GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                    shopDetail.hidesBottomBarWhenPushed = YES;
                    shopDetail.link = self.saleDataSource[indexPath.row][@"good_link"];;
                    [self.navigationController pushViewController:shopDetail animated:YES];
                }];
                //            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                //            shopDetailVC.link = self.saleDataSource[indexPath.row][@"good_link"];
                //            shopDetailVC.hidesBottomBarWhenPushed = YES;
                //            [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"2"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.tbDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
//            if ([self.sourceNum isEqualToString:@"3"]) {
//                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//                shopDetailVC.link = self.ltDataSource[indexPath.row][@"good_link"];
//                shopDetailVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:shopDetailVC animated:YES];
//            }
//            if ([self.sourceNum isEqualToString:@"4"]) {
//                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//                shopDetailVC.link = self.ebDataSource[indexPath.row][@"good_link"];
//                shopDetailVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:shopDetailVC animated:YES];
//            }
            if ([self.sourceNum isEqualToString:@"3"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.tmDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"4"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.jdDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"5"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.amDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"6"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.pmDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"7"]) {
                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
                shopDetailVC.link = self.ltDataSource[indexPath.row][@"good_link"];
                shopDetailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            if ([self.sourceNum isEqualToString:@"8"]) {
                    GlobalShopDetailViewController *shopDetail = [GlobalShopDetailViewController new];
                    shopDetail.hidesBottomBarWhenPushed = YES;
                    shopDetail.link = self.ebDataSource[indexPath.row][@"good_link"];
                    shopDetail.isShowText = YES;
                    [self.navigationController pushViewController:shopDetail animated:YES];
//                ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
//                shopDetailVC.link = self.ebDataSource[indexPath.row][@"good_link"];
//                shopDetailVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:shopDetailVC animated:YES];
            }
            //        if ([self.sourceNum isEqualToString:@"8"]) {
            //            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
            //            shopDetailVC.link = self.rxDataSource[indexPath.row][@"good_link"];
            //            shopDetailVC.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:shopDetailVC animated:YES];
            //        }
            //        if ([self.sourceNum isEqualToString:@"9"]) {
            //            ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
            //            shopDetailVC.link = self.ebDataSource[indexPath.row][@"good_link"];
            //            shopDetailVC.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:shopDetailVC animated:YES];
            //        }
        }

    }
}


- (UITableView *)tableV
{
    if (_tableV == nil) {
//        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 70 + 64 , 100, kScreenH - 100)];//11
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 70 , 100, kScreenH - 100)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [_tableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.largeClassDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.largeClassDataSource[indexPath.row][@"name"];
    //修改点击效果
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];//选中label颜色的变化
    cell.selectedBackgroundView.layer.cornerRadius=20;
    cell.selectedBackgroundView.backgroundColor = Main_Color;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.page = @"1";
    [self.allDataSource removeAllObjects];
    [self.ebDataSource removeAllObjects];
    [self.jdDataSource removeAllObjects];
    self.searching = NO;
    self.searchTf.text = @"";
    [self.searchTf resignFirstResponder];
    [self.collectionView reloadData];
    [self downLoadsmallClassWithLargeClass:self.largeClassDataSource[indexPath.row][@"class_name"]];
    _collectionView.mj_footer = nil;
    
}
//处理ebay数据
- (void)ebayData:(NSDictionary *)dic{
    NSString * url1 = @"http://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_ff3=2&pub=5575490065&toolid=10001&campid=5338507482&customid=1&icep_item=";
    NSString * url2 = @"&ipn=psmain&icep_vectorid=229466&kwid=902099&mtid=824&kw=lg";
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@:%@",key,obj);
        if ([key isEqualToString:@"good_link"]) {
            NSArray *array = [obj componentsSeparatedByString:@"?"];
            if (array.count<=1) {
                [dict setObject:obj forKey:key];
            }else{
                NSArray *arr = [array[0] componentsSeparatedByString:@"/"];
                NSInteger i = arr.count;
                NSString * str = [NSString stringWithFormat:@"%@%@%@",url1,arr[i-1],url2];
                [dict setObject:str forKey:key];
            }
        }else{
            [dict setObject:obj forKey:key];
        }
    }];
    [self.ebDataSource addObject:dict];
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
