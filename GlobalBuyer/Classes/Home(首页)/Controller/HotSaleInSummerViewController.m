//
//  HotSaleInSummerViewController.m
//  GlobalBuyer
//
//  Created by 澜与轩 on 2021/7/16.
//  Copyright © 2021 薛铭. All rights reserved.
//
#import "HotSalesCollectionViewCell.h"
#import "HotSaleInSummerViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "HotSalesHeaderCollectionViewCell.h"
#import "ShopDetailViewController.h"
#import "CurrencyCalculation.h"
@interface HotSaleInSummerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *goodArr;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL loadMore;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation HotSaleInSummerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"夏日熱賣";
    self.page = 1;
    self.loadMore = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // 商品列表
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
    if (self.reteDic == nil) {
        [self downloadMoneytype];
    }else{
        [self refreshData];
    }

   
}
#pragma mark 下载汇率数据
- (void)downloadMoneytype {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:moneyTypeApi parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.reteDic = [[NSDictionary alloc]init];
        self.reteDic = responseObject[@"data"];
        [self refreshData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"請求失敗!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (void)refreshData{
    self.page = 1;
    self.loadMore = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [self downExternalJDDataPage:self.page];
}

- (void)loadMoreData{
    
    self.page++;
    self.loadMore = YES;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    [self downExternalJDDataPage:self.page];
}


//分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//每组行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.goodArr.count;
}

// item
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        HotSalesHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotSalesHeaderCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    
    HotSalesCollectionViewCell *listCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotSalesCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.goodArr[indexPath.row];
    listCell.webIconIV.image = [UIImage imageNamed:@"京东分类"];
    [listCell.goodIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"good_pic"]]]];
    
    listCell.goodsPrice.text = [NSString stringWithFormat:@"%@%@",dic[@"good_currency"], dic[@"lowestPrice"]];
                                         
     listCell.goodsTitle.text = dic[@"skuName"];
    
    listCell.goodsPrice.text =  [CurrencyCalculation conversionCurrency:dic[@"lowestPrice"] Curr:dic[@"good_currency"] ReteDic:self.reteDic GoodSite:@"miao"];
    return listCell;
}



// item 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }

    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = self.goodArr[indexPath.row][@"good_link"];
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

// item 大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 150);
    }
    
    return CGSizeMake((SCREEN_WIDTH - 6) / 2, SCREEN_WIDTH/2.0+20);

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




- (void)downExternalJDDataPage:(NSInteger)page{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/xml",@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSString *time = [self getCurrentTimes];
    
    NSString *mdStr = [NSString stringWithFormat:@"cf2109bc3d254ecba1a1a0b823b78bd1360buy_param_json{\"goodsReq\":{\"eliteId\":2,\"pageIndex\":%ld}}app_key398230142d607c53011684710b966978methodjd.union.open.goods.material.querytimestamp%@v1.0cf2109bc3d254ecba1a1a0b823b78bd1",self.page,time];
    
    NSLog(@"mdStr============>%@",mdStr);
    
    
    NSString *url = [NSString stringWithFormat:@"https://api.jd.com/routerjson?app_key=398230142d607c53011684710b966978&method=jd.union.open.goods.material.query&v=1.0&timestamp=%@&360buy_param_json={\"goodsReq\":{\"eliteId\":2,\"pageIndex\":%ld}}&sign=%@",time,self.page,[self md5:mdStr].uppercaseString];
    
    
    NSLog(@"url============>%@",url);
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:@"" progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        NSString *returnString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果为：%@",returnString);
        
        
        NSData * data = [returnString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        //再解析
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (err) {
            NSLog(@"JSON 解析失败%@",err);
        }
        
        
        NSMutableArray * jdArr = [[NSMutableArray alloc]init];
        NSString *tmpString = dicData[@"jd_union_open_goods_material_query_responce"][@"queryResult"];
        NSLog(@"tmpString====>%@",tmpString);
//        tmpString = [tmpString stringByReplacingOccurrencesOfString:@"\\"  withString:@""];
//        tmpString = [tmpString stringByReplacingOccurrencesOfString:@"#crumb-wrap\""  withString:@""];
       
        NSLog(@"去除转移结果为：%@",tmpString);
        
        
        data = [tmpString dataUsingEncoding:NSUTF8StringEncoding];
        
        //再解析
        dicData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

        
        if (err) {
            NSLog(@"JSON 解析失败%@",err);
        }
        
        NSArray *tmpArr = dicData[@"data"];
        
        
        if (tmpArr==nil ||tmpArr.count == 0) {
        }else{
            
            for (int i = 0 ; i < tmpArr.count ; i++) {
                NSDictionary *dic = tmpArr[i];
 
                NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
                NSArray *imageList = dic[@"imageInfo"][@"imageList"];
                tmpDict[@"good_pic"] = @"";
                if (imageList.count>0) {
                    tmpDict[@"good_pic"] = imageList[0][@"url"];
                }
                tmpDict[@"skuName"] = [NSString stringWithFormat:@"%@",dic[@"skuName"]];
                tmpDict[@"good_link"] = [NSString stringWithFormat:@"https://item.m.jd.com/product/%@.html",dic[@"skuId"]];
                
                tmpDict[@"lowestPrice"] = [NSString stringWithFormat:@"%@",dic[@"priceInfo"][@"lowestPrice"]];
                tmpDict[@"good_currency"] = @"CNY";
                [jdArr addObject:tmpDict];
            }
        }
        if (!self.loadMore) {
            [self.goodArr removeAllObjects];
        }
        for (int i = 0 ; i < jdArr.count; i++) {
            [self.goodArr addObject:jdArr[i]];
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hideAnimated:YES];
        NSLog(@"%@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"請求失敗!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];


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

- (NSString *)str:(NSString *)string replaceStr:(NSString *)replaceStr{
    NSString *newString = string;
    if ([string rangeOfString:@"\\"].location != NSNotFound||[string rangeOfString:@"\""].location != NSNotFound) {
        NSArray  * arr = [string  componentsSeparatedByString:@"\\"];
        string  = arr[1];
        NSArray  * arr1 = [string  componentsSeparatedByString:@"\""];
        string = arr1[0];
        string = [NSString stringWithFormat:@"%@",string];
    }
    newString = [newString stringByReplacingOccurrencesOfString:string withString:replaceStr];
    return newString;
}

- (NSMutableArray *)goodArr
{
    if (_goodArr == nil) {
        _goodArr = [[NSMutableArray alloc]init];
    }
    return _goodArr;
}

#pragma mark - lazy
//列表懒加载
- (UICollectionView *)collectionView {
    if (_collectionView== nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

        [_collectionView registerNib:[UINib nibWithNibName:@"HotSalesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotSalesCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HotSalesHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotSalesHeaderCollectionViewCell"];
        
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStatePulling", nil) forState:MJRefreshStatePulling];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateRefreshing", nil) forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.arrowView.hidden = YES;
        
        _collectionView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
         //设置文字
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStatePulling", nil) forState:MJRefreshStateRefreshing];
        [footer setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_up_MJRefreshStateRefreshing", nil) forState:MJRefreshStateNoMoreData];

        _collectionView.mj_footer = footer;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
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
