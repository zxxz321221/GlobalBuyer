//
//  CollectionViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/24.
//  Copyright © 2017年 薛铭. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionTableViewCell.h"
#import "ShopDetailViewController.h"
#import "LoadingView.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *collectionListTv;
@property (nonatomic,strong)NSMutableArray *collectionListDataSource;
@property (nonatomic,strong)LoadingView *loadingView;

@property (nonatomic,strong)NSMutableArray *stateArr;
@property (nonatomic,strong)NSMutableArray *deleteArr;

@property (nonatomic,assign)BOOL isEditing;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self downLoadCollectionList];
}

//下载收藏列表
- (void)downLoadCollectionList
{
    [self.loadingView startLoading];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"group"] = @"all";
    
    [manager POST:FavoriteApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if ([responseObject[@"code"]isEqualToString:@"success"]) {
//            NSDictionary *dict = responseObject[@"data"];
//            if ([responseObject[@"data"] count] == 0) {
//                [UIView animateWithDuration:2 animations:^{
//                    self.loadingView.imgView.animationDuration = 3*0.15;
//                    self.loadingView.imgView.animationRepeatCount = 0;
//                    [self.loadingView.imgView startAnimating];
//                    self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//                } completion:^(BOOL finished) {
//                    [self.loadingView stopLoading];
//                }];
//                return ;
//            }
//            NSArray *arr = [dict allKeys];
//            for (int i = 0;  i < arr.count; i++) {
//                for (int j = 0; j < [dict[arr[i]] count]; j++) {
//                    [self.collectionListDataSource addObject:dict[arr[i]][j]];
//                }
//            }
//        }
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.collectionListDataSource = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            for (int i = 0; i < self.collectionListDataSource.count; i++) {
                [self.stateArr addObject:@"0"];
            }
        }
        [self.loadingView stopLoading];
//        [UIView animateWithDuration:2 animations:^{
//            self.loadingView.imgView.animationDuration = 3*0.15;
//            self.loadingView.imgView.animationRepeatCount = 0;
//            [self.loadingView.imgView startAnimating];
//            self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//        } completion:^(BOOL finished) {
//            
//        }];
        [self.collectionListTv reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//隐藏tabbar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
}

//显示tabbar
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
}

//数据源初始化
-(NSMutableArray *)collectionListDataSource
{
    if (_collectionListDataSource == nil) {
        _collectionListDataSource = [[NSMutableArray alloc]init];
    }
    return _collectionListDataSource;
}

//多选删除数据源
-(NSMutableArray *)deleteArr
{
    if (_deleteArr == nil) {
        _deleteArr = [[NSMutableArray alloc]init];
    }
    return _deleteArr;
}

//多选状态数据源
-(NSMutableArray *)stateArr
{
    if (_stateArr == nil) {
        _stateArr = [[NSMutableArray alloc]init];
    }
    return _stateArr;
}

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (void)createUI
{
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Collection", nil);
    self.navigationItem.titleView = titleLabel;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.collectionListTv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-(kNavigationBarH + kStatusBarH)) style:UITableViewStylePlain];
    self.collectionListTv.dataSource = self;
    self.collectionListTv.delegate = self;
    [self.view addSubview:self.collectionListTv];
    
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    
    [selectedBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_Edit", nil) forState:UIControlStateNormal];
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    
    self.navigationItem.rightBarButtonItem =selectItem;
    

}

- (void)selectedBtn:(UIButton *)button {
    
    //支持同时选中多行
    
//    self.collectionListTv.allowsMultipleSelectionDuringEditing = YES;
//    self.collectionListTv.allowsSelectionDuringEditing = YES;
//    self.collectionListTv.editing = !self.collectionListTv.editing;
    
    self.isEditing = !self.isEditing;
    
    if (self.isEditing) {
        
        for (int i = 0 ; i < self.collectionListDataSource.count; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CollectionTableViewCell *cell = [self.collectionListTv cellForRowAtIndexPath:tmpIndexPath];
            
            cell.logoLb.frame = CGRectMake(80 + 40, 10, [[UIScreen mainScreen] bounds].size.width - 80 - 40, 30);
            
            cell.logoIv.frame = CGRectMake(10 + 40, 10, 60, 60);
            
            cell.sourceLb.frame = CGRectMake(80 + 40, 45, 120, 10);
            
            cell.remakeLb.frame = CGRectMake(80 + 40, 60, 200, 10);
            
            cell.editBtn.hidden = NO;
        }

        
        [button setTitle:NSLocalizedString(@"GlobalBuyer_Address_dele", nil) forState:UIControlStateNormal];
        
    }else{
        
        if (self.deleteArr.count != 0) {
            [self deleteFavoritesWithArr:self.deleteArr];
        }else{
            for (int i = 0 ; i < self.collectionListDataSource.count; i++) {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                CollectionTableViewCell *cell = [self.collectionListTv cellForRowAtIndexPath:tmpIndexPath];
                
                cell.logoLb.frame = CGRectMake(80, 10, [[UIScreen mainScreen] bounds].size.width - 80 - 40, 30);
                
                cell.logoIv.frame = CGRectMake(10, 10, 60, 60);
                
                cell.sourceLb.frame = CGRectMake(80, 45, 120, 10);
                
                cell.remakeLb.frame = CGRectMake(80, 60, 200, 10);
                
                
                
                cell.editBtn.selected = NO;
                cell.editBtn.hidden = YES;
                
                [self.stateArr replaceObjectAtIndex:i withObject:@"0"];
            }
            
            [self.deleteArr removeAllObjects];
        }
        
    
        [button setTitle:NSLocalizedString(@"GlobalBuyer_Address_Edit", nil) forState:UIControlStateNormal];
        
    }
    
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectionListDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    if (cell == nil) {
        cell = [[CollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionCell"];
    }
    
    
    cell.logoLb.text = [NSString stringWithFormat:@"%@",self.collectionListDataSource[indexPath.row][@"title"]];
    cell.sourceLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_CollectionViewController_Source", nil),self.collectionListDataSource[indexPath.row][@"source"]];
    
    NSString *pictureUrl;
    
    NSMutableString *pictureStr = self.collectionListDataSource[indexPath.row][@"image"];
    NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
    if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
        pictureUrl = pictureStr;
    }else{
        NSMutableString *tmpStr = self.collectionListDataSource[indexPath.row][@"url"];
        NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
        NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
        if (tmpHttpArr.count > 0) {
            pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
        }else if(tmpHttpsArr.count > 0){
            pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
        }
    }
    
    [cell.logoIv sd_setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:nil];
    if ([self.collectionListDataSource[indexPath.row][@"remark"]isEqualToString:@""]) {
        
    }else{
        cell.remakeLb.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"GlobalBuyer_CollectionViewController_Remark", nil),self.collectionListDataSource[indexPath.row][@"remark"]];
    }

    if (self.isEditing) {
        
        if ([self.stateArr[indexPath.row] isEqualToString:@"1"]) {
            cell.editBtn.selected = YES;
        }else{
            cell.editBtn.selected = NO;
        }
        
        cell.logoLb.frame = CGRectMake(80 + 40, 10, [[UIScreen mainScreen] bounds].size.width - 80 - 40, 30);
        
        cell.logoIv.frame = CGRectMake(10 + 40, 10, 60, 60);
        
        cell.sourceLb.frame = CGRectMake(80 + 40, 45, 120, 10);
        
        cell.remakeLb.frame = CGRectMake(80 + 40, 60, 200, 10);
        cell.remakeLb.hidden = YES;
        cell.editBtn.hidden = NO;
        
    }else{
        cell.logoLb.frame = CGRectMake(80, 10, [[UIScreen mainScreen] bounds].size.width - 80 - 40, 30);
        
        cell.logoIv.frame = CGRectMake(10, 10, 60, 60);
        
        cell.sourceLb.frame = CGRectMake(80, 45, 120, 10);
        
        cell.remakeLb.frame = CGRectMake(80, 60, 200, 10);
        cell.remakeLb.hidden = YES;
        
        
        cell.editBtn.selected = NO;
        cell.editBtn.hidden = YES;
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.collectionListTv.editing)
    {
        //当表视图处于没有未编辑状态时选择多选删除
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else
    {
        //当表视图处于没有未编辑状态时选择左滑删除
        return UITableViewCellEditingStyleDelete;
    }
    
}

//跳转cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isEditing) {
        CollectionTableViewCell *cell = [self.collectionListTv cellForRowAtIndexPath:indexPath];
        cell.editBtn.selected = !cell.editBtn.selected;
        
        
        if (cell.editBtn.selected) {
            [self.stateArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [self.deleteArr addObject:self.collectionListDataSource[indexPath.row][@"id"]];
        }else{
            [self.stateArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            [self.deleteArr removeObject:self.collectionListDataSource[indexPath.row][@"id"]];
        }
        
        
        return;
    }
    
    if ([self.collectionListDataSource[indexPath.row][@"buy_type"]isEqualToString:@"item-price"]) {
        return;
    }
    

    
    ShopDetailViewController *shopDeV = [[ShopDetailViewController alloc]init];
    shopDeV.link = self.collectionListDataSource[indexPath.row][@"link"];
    shopDeV.showTabbar = NO;
    shopDeV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDeV animated:YES];
}

//编辑cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteFavoriteWithIndexpath:indexPath];
        
    }else if(editingStyle == (UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert))
    {
        
    }
}

- (void)deleteFavoritesWithArr:(NSMutableArray *)deleteIds
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_deleteAdd", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"favoriteIds"] = deleteIds;
    
    
    [manager POST:DeleteFavoriteApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            for (int i = 0 ; i < self.deleteArr.count; i++ ) {
                for (int j = 0; j < self.collectionListDataSource.count; j++) {
                    if (self.deleteArr[i] == self.collectionListDataSource[j][@"id"]) {
                        [self.collectionListDataSource removeObject:self.collectionListDataSource[j]];
                    }
                }
            }
            [self.collectionListTv reloadData];
            
            
            for (int i = 0 ; i < self.collectionListDataSource.count; i++) {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                CollectionTableViewCell *cell = [self.collectionListTv cellForRowAtIndexPath:tmpIndexPath];
                
                cell.logoLb.frame = CGRectMake(80, 10, [[UIScreen mainScreen] bounds].size.width - 80 - 40, 30);
                
                cell.logoIv.frame = CGRectMake(10, 10, 60, 60);
                
                cell.sourceLb.frame = CGRectMake(80, 45, 120, 10);
                
                cell.remakeLb.frame = CGRectMake(80, 60, 200, 10);
                
                
                
                cell.editBtn.selected = NO;
                cell.editBtn.hidden = YES;
                
                [self.stateArr replaceObjectAtIndex:i withObject:@"0"];
            }
            
            [self.deleteArr removeAllObjects];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

//删除服务器数据
- (void)deleteFavoriteWithIndexpath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_deleteAdd", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"favoriteId"] = self.collectionListDataSource[indexPath.row][@"id"];
    
    [manager POST:DeleteFavoriteApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            [self.collectionListDataSource removeObjectAtIndex:indexPath.row];
            [self.collectionListTv reloadData];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}


//获取http OR https
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
            
        {
            
            if (0 == i) {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }else
                
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
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
