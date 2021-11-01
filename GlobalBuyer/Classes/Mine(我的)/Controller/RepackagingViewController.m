//
//  RepackagingViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/22.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "RepackagingViewController.h"
#import "NoPayTableViewCell.h"

@interface RepackagingViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIScrollView *imageSV;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIPageControl *currentPage;

@end

@implementation RepackagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];

}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_ParcelDetails", nil);
    self.navigationItem.titleView = titleLabel;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
    btn.backgroundColor = Main_Color;
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_My_AuditStatus_clickandrepackage", nil) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
}

- (void)sureBtn
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"正在解包", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":userToken,@"packageId":self.dataSource[@"id"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PackageDeleteApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"解包成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"解包失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"解包失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[@"get_package_product"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (cell == nil) {
        cell = [[NoPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
    }
    NSString *string;
    if ([self.dataSource[@"get_package_product"][indexPath.row][@"get_pay_product"] isEqual:[NSNull null]]) {
        string = @"";
    }else{
        string = self.dataSource[@"get_package_product"][indexPath.row][@"get_pay_product"][@"body"];
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSString *pictureUrl;
    NSMutableString *pictureStr = jsonDict[@"picture"];
    NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
    if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
        pictureUrl = pictureStr;
    }else{
        NSMutableString *tmpStr = jsonDict[@"link"];
        NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
        NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
        if (tmpHttpArr.count > 0) {
            pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
        }else if(tmpHttpsArr.count > 0){
            pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
    cell.lb.text = jsonDict[@"name"];
    cell.priceLb.text = [NSString stringWithFormat:@"x%@",self.dataSource[@"get_package_product"][indexPath.row][@"get_pay_product"][@"quantity"]];
    cell.priceLb.textColor = [UIColor blackColor];
    
    
    NSString *inspectionPictureUrl = [NSString stringWithFormat:@"%@",self.dataSource[@"get_package_product"][indexPath.row][@"confirm_picture"]];
    if ([inspectionPictureUrl isEqualToString:@"<null>"] || inspectionPictureUrl == NULL) {
        
    }else{
        NSArray *numUrl = [inspectionPictureUrl componentsSeparatedByString:@","];
        NSLog(@"========%lu",(unsigned long)numUrl.count);
        if (numUrl.count != 0) {
            cell.showInspectionBtn.hidden = NO;
            cell.showInspectionBtn.tag = 800 + indexPath.row;
            [cell.showInspectionBtn addTarget:self action:@selector(showInspectionImage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
  
    
    return cell;
    
}

- (void)showInspectionImage:(UIButton *)btn
{
    NSString *inspectionPictureUrl = [NSString stringWithFormat:@"%@",self.dataSource[@"get_package_product"][btn.tag - 800][@"confirm_picture"]];
    NSArray *numUrl = [inspectionPictureUrl componentsSeparatedByString:@","];
    
    self.imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64)];
    self.imageSV.backgroundColor = [UIColor blackColor];
    self.imageSV.alpha = 0.7;
    self.imageSV.contentSize = CGSizeMake(kScreenW*numUrl.count, 0);
    self.imageSV.pagingEnabled = YES;
    [self.view addSubview:self.imageSV];
    self.imageSV.delegate = self;
    
    
    self.currentPage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenH - 100, kScreenW, 30)];
    self.currentPage.numberOfPages = numUrl.count;
    self.currentPage.tintColor = Main_Color;
    [self.view addSubview:self.currentPage];
    
    self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 70, 90, 40, 40)];
    [self.closeBtn setTitle:NSLocalizedString(@"GlobalBuyer_Close", nil) forState:UIControlStateNormal];
    self.closeBtn.layer.cornerRadius = 20;
    self.closeBtn.layer.borderWidth = 0.8;
    self.closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.closeBtn];
    [self.closeBtn addTarget:self action:@selector(closeInspectionImage) forControlEvents:UIControlEventTouchUpInside];
    for (int i = 0; i < numUrl.count; i++) {
        UIImageView *imageIV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 140 + kScreenW*i, kScreenH/2 - 180, 280, 280)];
        [imageIV setContentMode:UIViewContentModeScaleAspectFit];
        imageIV.clipsToBounds = YES;
        [imageIV sd_setImageWithURL:numUrl[i] placeholderImage:[UIImage imageNamed:@"goods.png"]];
        [self.imageSV addSubview:imageIV];
    }
}

- (void)closeInspectionImage
{
    [self.imageSV removeFromSuperview];
    [self.closeBtn removeFromSuperview];
    [self.currentPage removeFromSuperview];
    
    self.imageSV = nil;
    self.closeBtn = nil;
    self.currentPage = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pages = scrollView.contentOffset.x/kScreenW ;
    self.currentPage.currentPage = pages;
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
