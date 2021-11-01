//
//  EditUserInfoViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "ChagenUserInfoViewController.h"
#import "ChangePasswordViewController.h"
#import "FileArchiver.h"
@interface EditUserInfoViewController ()<ChangePasswordViewControllerDelegate,ChagenUserInfoViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIView *choiceCurrencyV;
@property (nonatomic,strong) NSMutableArray *selectCountryArr;
@property (nonatomic,assign) NSInteger countryTag;
@property (nonatomic,assign) NSIndexPath *inPath;

@end

@implementation EditUserInfoViewController

- (NSMutableArray *)selectCountryArr
{
    if (_selectCountryArr == nil) {
        _selectCountryArr = [NSMutableArray new];
        NSArray *arr = [FileArchiver readFileArchiver:@"Country"];
        _selectCountryArr = [NSMutableArray arrayWithArray:arr];
    }
    return _selectCountryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
    // Do any additional setup after loading the view.
}

-(void)initData {
    [super initData];
    NSMutableDictionary *dict4 = [NSMutableDictionary new];
    [dict4 setValue:@"" forKey:@"value"];
    [dict4 setObject:NSLocalizedString(@"GlobalBuyer_UserInfo_ChangePassWord", nil) forKey:@"key"];
    [self.dataSource addObject:dict4];
}

-(void)setupUI{
    [super setupUI];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_UserInfo_changeInfo", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Address_Save", nil) style: UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
}

-(void)saveClick{
    
    //self.dataSource
    //第一个元素 用户名
    //第二个元素 性别
    //第三个元素 电话
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary new];
   
    NSDictionary *username = self.dataSource[0];
    NSDictionary *sex = self.dataSource[1];
    NSDictionary *phone = self.dataSource[2];
    NSDictionary *currency = self.dataSource[3];
    NSDictionary *emailname = self.dataSource[4];
    NSDictionary *password = self.dataSource[5];

    
    NSMutableDictionary *user = [NSMutableDictionary new];
    if (![password[@"value"] isEqualToString:@""] && password[@"value"] ) {
    
        [user setObject:password[@"value"]  forKey:@"password"];
        
    }else{
    
        // [user setObject:@"" forKey:@"password"];
        
    }
    
    if (![username[@"value"]  isEqualToString:@""] && username[@"value" ]) {
        
        [user setObject:username[@"value"]   forKey:@"username"];
        
    }else{
        
        //[user setObject:@""  forKey:@"username"];
        
    }
    
    if ([sex[@"value"]  isEqualToString:NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil)]) {
        
        [user setObject:@0  forKey:@"sex"];
        
    }else{
    
        [user setObject:@1  forKey:@"sex"];
    }
    
    if (![phone[@"value"] isEqualToString:@""] && phone[@"value"]) {
        
         [user setObject:phone[@"value"]  forKey:@"phone"];
    }
    
    if (![emailname[@"value"] isEqualToString:@""] && emailname[@"value"]) {
        [user setObject:emailname[@"value"] forKey:@"emailname"];
    }
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
//    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    //[params setObject:userToken forKey:@"api_token"];
//    NSData *data=[NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // [params setObject:jsonStr forKey:@"user"];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"secret_key"] = userToken;
    params[@"password"] = user[@"password"];
    params[@"fullname"] = user[@"username"];
    params[@"sex"] = user[@"sex"];
    params[@"mobile_phone"] = user[@"phone"];
    params[@"currency"] = currency[@"value"];
    params[@"email_name"] = user[@"emailname"];
    NSLog(@"jsonStr==%@",params);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Saveing", nil);

    [manager POST:UserInfoEditApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [hud hideAnimated:YES];
          if ([responseObject[@"code"] isEqualToString:@"success"]) {
              
              MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
              hud.mode = MBProgressHUDModeText;
              hud.label.text = NSLocalizedString(@"保存成功!", @"HUD message title");
              // Move to bottm center.
              hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
              [hud hideAnimated:YES afterDelay:3.f];
              
              NSDictionary *dict = responseObject[@"data"];
              UserModel *model = [[UserModel alloc]initWithDictionary:dict error:nil];
              if (!model.identity) {
                  model.identity = @"";
              }
              if (!model.sex) {
                  model.sex = @0;
              }
              
              if (!model.fullname || [model.fullname isEqualToString: @""]) {
                  model.fullname = @"YK1253920N";
              }
              if (!model.mobile_phone) {
                  model.mobile_phone = @"";
              }
              
              NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
              NSString *path=[paths    objectAtIndex:0];
              NSLog(@"path = %@",path);
              NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
              NSFileManager* fm = [NSFileManager defaultManager];
              [fm createFileAtPath:filename contents:nil attributes:nil];
                  //NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
              
                  //创建一个dic，写到plist文件里
              NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:model.email,@"email",model.fullname,@"fullname",model.email_name,@"email_name",model.currency,@"currency",model.mobile_phone,@"mobile_phone",model.sex,@"sex",nil];
              
              [dic writeToFile:filename atomically:YES];
              
              [self.dataSource removeObjectAtIndex:5];
              [self.delegate saveModel:self.dataSource];
              [self.navigationController popViewControllerAnimated:YES];

          }else{
              MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
              
              hud.mode = MBProgressHUDModeText;
              hud.label.text = NSLocalizedString(@"保存失败!", @"HUD message title");
              // Move to bottm center.
              hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
              [hud hideAnimated:YES afterDelay:3.f];
          }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"保存失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoCell *cell = TableViewCellDequeueInit(NSStringFromClass([UserInfoCell  class]));
    
    TableViewCellDequeueXIB(cell, UserInfoCell);
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.titileLa.text = dict[@"key"];
    cell.detailLa.text = dict[@"value"];
    cell.nextView.hidden = NO;
    return cell;
}

/*性别选择*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChagenUserInfoViewController *changeVC = [[ChagenUserInfoViewController alloc]init];
 
    if (indexPath.row == 1) {
        //底部弹窗
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_choesnanornv", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_UserInfo_nv", nil), nil];
            //展示行为列表
        [sheet showInView:self.view];
        
    }else if (indexPath.row == 3){
        self.inPath = indexPath;
        [self.tabBarController.view addSubview:self.choiceCurrencyV];
    }
    else if (indexPath.row == 5) {
        ChangePasswordViewController *changePasswordVC = [ChangePasswordViewController new];
        changePasswordVC.delegate = self;
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }else{
        changeVC.indexs = indexPath.row;
        changeVC.delegate = self;
        [self.navigationController pushViewController:changeVC animated:YES];
    }
}

- (UIView *)choiceCurrencyV
{
    if (_choiceCurrencyV == nil) {
        _choiceCurrencyV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _choiceCurrencyV.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
        UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 160, 300, 320)];
        iv.backgroundColor = [UIColor whiteColor];
        [_choiceCurrencyV addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300 - 40, 40)];
        lb.text = NSLocalizedString(@"GlobalBuyer_Selectcurrency", nil);
        lb.textColor = Main_Color;
        lb.font = [UIFont systemFontOfSize:22 weight:2];
        lb.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lb];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 70, 300 - 30, 1)];
        line.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [iv addSubview:line];
        
        UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 80, 270, 165)];
        backSv.contentSize = CGSizeMake(0, self.selectCountryArr.count/2*70);
        [iv addSubview:backSv];
        
        for (int i = 0; i < self.selectCountryArr.count; i++) {
            UIView *backIv = [[UIView alloc]initWithFrame:CGRectMake(10 + 15 * (i%2) + (i%2) * 115, 10 + ((i/2) * 50), 120, 40)];
            backIv.tag = 1000 + i;
            [backSv addSubview:backIv];
            UILabel *countryLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 120, 30)];
            countryLb.textColor = Main_Color;
            countryLb.textAlignment = NSTextAlignmentCenter;
            countryLb.text = self.selectCountryArr[i][@"name"];
            countryLb.font = [UIFont systemFontOfSize:14];
            [backIv addSubview:countryLb];
            if (i == 0) {
                backIv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
                self.countryTag = 1000;
            }else{
                backIv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCurrency:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [backIv addGestureRecognizer:tap];
        }
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 270, 300, 50)];
        sureBtn.backgroundColor = Main_Color;
        UILabel *sureLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        sureLb.textColor = [UIColor whiteColor];
        sureLb.text = NSLocalizedString(@"GlobalBuyer_Ok", nil);
        sureLb.font = [UIFont systemFontOfSize:20 weight:2];
        sureLb.textAlignment = NSTextAlignmentCenter;
        [sureBtn addSubview:sureLb];
        [iv addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureCurrency) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choiceCurrencyV;
}

- (void)selectCurrency:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < 10; i++) {
        UIView *iv = (UIView *)[self.choiceCurrencyV viewWithTag:i + 1000];
        if (iv.tag == [tap view].tag) {
            iv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.countryTag = [tap view].tag;
        }else{
            iv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}

- (void)sureCurrency
{
    
    [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"currency"] forKey:@"currency"];
    [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"sign"] forKey:@"currencySign"];
    [UserDefault setObject:self.selectCountryArr[self.countryTag - 1000][@"name"] forKey:@"currencyName"];
    
    NSLog(@"%@",self.selectCountryArr[self.countryTag - 1000][@"currency"]);
    [self.choiceCurrencyV removeFromSuperview];

    NSMutableDictionary *dict5 = [NSMutableDictionary new];
    [dict5 setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"currency"] forKey:@"value"];
    [dict5 setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_CurrentCurrency", nil) forKey:@"key"];
    [self.dataSource removeObjectAtIndex:3];
    [self.dataSource insertObject:dict5 atIndex:3];
    [self.tableView reloadData];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    NSDictionary *dict = self.dataSource[1];
  
    [self.dataSource removeObjectAtIndex:1];
   
    if (buttonIndex == 0) {
          [dict setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil) forKey:@"value"];
    }
    
    if (buttonIndex == 1) {
          [dict setValue:NSLocalizedString(@"GlobalBuyer_UserInfo_nv", nil) forKey:@"value"];
    }
    
    [self.dataSource insertObject:dict atIndex:1];
    
    [self.tableView reloadData];
    NSLog(@"%ld",(long)buttonIndex);
}

-(void)changeInfo:(NSString *)info AtIndex:(NSInteger)index{
    NSDictionary *dict = self.dataSource[index];
    [dict setValue:info forKey:@"value"];
    [self.dataSource removeObjectAtIndex:index];
    
    [self.dataSource insertObject:dict atIndex:index];
    
    [self.tableView reloadData];
}

-(void)password:(NSString *)password{
    NSDictionary *dict = self.dataSource[4];
    [dict setValue:password forKey:@"value"];
    [self.dataSource removeObject:[self.dataSource lastObject]];
    NSLog(@"%@",[self.dataSource lastObject]);
    [self.dataSource addObject:dict];
    [self.tableView reloadData];
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
