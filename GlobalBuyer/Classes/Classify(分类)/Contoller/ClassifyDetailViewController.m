//
//  ClassifyDetailViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ClassifyDetailViewController.h"
#import "ClassifyDetaiCell.h"
#import "CategoryModel.h"
#import "FileArchiver.h"
#import "ClassifyHeaderCollectionReusableView.h"

static NSString *head = @"HeaderCollectionReusableView";
@interface ClassifyDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataSoucer;

@end

@implementation ClassifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

    [self readClassifyTitle:[NSString stringWithFormat:@"ClassiDetail%@",self.signId]];
    // Do any additional setup after loading the view.
}

- (void)readClassifyTitle:(NSString *)fileName
{
    NSArray *array = [FileArchiver readFileArchiver:fileName];
    if (array) {
        for (int i = 0; i < array.count; i++) {
            [self.dataSoucer addObject:array[i]];
        }
        [self.collectionView reloadData];
        [self performSelector:@selector(dowlondData) withObject:nil afterDelay:3.0f];
    }else{
        [self dowlondData];
    }
}

- (void)dowlondData {
    
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
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"field":@"sign",@"name":self.signId,@"locale":language,@"all_flag":@"1"};
    NSLog(@"分类接口 %@,%@",params,self.signId);
    [manager  POST: CategoryApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response %@",responseObject[@"datas"]);
        [self.collectionView.mj_header endRefreshing];
        [self.dataSoucer removeAllObjects];
        NSArray *dataArr = responseObject[@"data"];
        NSArray *arr = responseObject[@"datas"][@"original"][@"data"];
        NSLog(@"datas111%ld",arr.count);
        if (dataArr.count == 0) {
            return ;
        }
        NSMutableArray * dataArray = [NSMutableArray new];
        for (NSDictionary *dict in dataArr) {
            CategoryModel *model = [[CategoryModel alloc]initWithDictionary:dict error:nil];
            model.Description = dict[@"description"];
            [dataArray addObject:model];
        }
        [self.dataSoucer addObject:dataArray];
        NSLog(@" ddddd  %d",self.dataSoucer.count);
        /* ---------- */
        
        
        if (arr.count != 0 ) {
            NSMutableArray * datasArray = [NSMutableArray new];
            for (NSDictionary *dict in arr) {
                CategoryModel *model = [[CategoryModel alloc]initWithDictionary:dict error:nil];
                model.Description = dict[@"description"];
                [datasArray addObject:model];
            }
            [self.dataSoucer addObject:datasArray];
        }
        
        [FileArchiver writeFileArchiver:[NSString stringWithFormat:@"ClassiDetail%@",self.signId] withArray:self.dataSoucer];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self.collectionView.mj_header endRefreshing];
    }];
    
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
}

#pragma mark 创建视图
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(kScreenW/3, kScreenW/3);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - NavBarHeight -TabBarHeight - 44) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Cell_BgColor;
        _collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ClassifyHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:head];

        [_collectionView registerClass:[ClassifyDetaiCell class] forCellWithReuseIdentifier:NSStringFromClass([ClassifyDetaiCell class])];
        
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dowlondData)];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateIdle", nil) forState:MJRefreshStateIdle];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStatePulling", nil) forState:MJRefreshStatePulling];
        [header setTitle:NSLocalizedString(@"GlobalBuyer_Tabview_down_MJRefreshStateRefreshing", nil) forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.arrowView.hidden = YES;
        
        _collectionView.mj_header = header;
    }
    return _collectionView;
}

#pragma mark 初始化
-(NSMutableArray *)dataSoucer {
    if (_dataSoucer == nil) {
        _dataSoucer = [NSMutableArray new];
    }
    return _dataSoucer;
}

#pragma mark ————————— Header的大小 size —————————————

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(kScreenW, 60);
    
}

#pragma mark ————————— 自定义分区头  —————————————

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        ClassifyHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"offlineID" forIndexPath:indexPath];
        ClassifyHeaderCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:head forIndexPath:indexPath];
//        header.headeLab.text = [dict objectForSafeKey:@"组头"];
        reusableView = header;
    }
    return reusableView;
}

#pragma mark Collection代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSLog(@"section %d",self.dataSoucer.count);
    return self.dataSoucer.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.dataSoucer[0] count];
    }else if (section == 1){
        return [self.dataSoucer[1] count];
    }
    return [self.dataSoucer[0] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyDetaiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ClassifyDetaiCell class]) forIndexPath:indexPath];
    NSLog(@"%d , %d",indexPath.section,indexPath.row);
    CategoryModel *mo;
    if ([self.dataSoucer[indexPath.section] count] != 0) {
        mo = self.dataSoucer[indexPath.section][indexPath.row];
    }
    
    
//    NSDateFormatter * df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    
//    NSString * dateString2 = mo.created_at;
//    
//    NSDate *date1 = [NSDate date];
//    NSDate *date2 = [df dateFromString:dateString2];
//    
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    unsigned int unitFlags = NSDayCalendarUnit;
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date2  toDate:date1  options:0];
//
//    if (comps.day < 7) {
//        
//    }else{
//    }
    
    if ([mo.recommend isEqualToString:@"1"]) {
        cell.Iv.image = [UIImage imageNamed:@"hot"];
    }else{
        cell.Iv.image = nil;
    }
    

    
    cell.model = self.dataSoucer[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate selectAtIndexInClassifyDetailViewController:self.dataSoucer[indexPath.section][indexPath.row] WithSection:indexPath.section];
    
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
