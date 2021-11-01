//
//  AddAdderssViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "EditAdderssViewController.h"
#import "AdderssDetailViewController.h"
#import "MapViewController.h"
#import "UIViewController+getContactInfor.h"
#import "FillInIDViewController.h"

@interface EditAdderssViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AdderssDetailViewControllerDelegate,MapViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UILabel *cityLa;
@property (weak, nonatomic) IBOutlet UILabel *addressLa;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (nonatomic, strong) UIView *botomView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *DetermineBtn;
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSMutableArray  *allCityArr;
@property (strong, nonatomic) NSMutableArray  *townCityArr;
@property (strong, nonatomic) UIButton *defaultBtn;
@property (strong, nonatomic) UILabel *defaultLa;
@property (nonatomic,assign) BOOL isEdit;
@end


@implementation EditAdderssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPickerData];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)gotoTelVC:(id)sender {
    
    // 3.弹出控制器
    [self.view endEditing:YES];
    [self dismiss];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self CheckAddressBookAuthorizationandGetPeopleInfor:^(NSDictionary *data) {
        if (data != nil) {
            self.nameTF.text = data[@"name"];
            self.phoneNumTF.text = data[@"phone"];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
  [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (IBAction)gotoMapVC:(id)sender {
    [self.view endEditing:YES];
    [self dismiss];
    MapViewController *mapVC = [[MapViewController alloc]init];
    mapVC.delegate = self;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(void)addAddress:(NSString *)addressStr addressDetail:(NSString *)addressDetStr{
    self.addressLa.text = addressDetStr;
    self.cityLa.text = addressStr;
}

#pragma mark 创建UI界面
- (void)setupUI {
    
    [self setNavigationBackBtn];
    self.nameTF.delegate = self;
    self.phoneNumTF.delegate = self;
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Address_EditAdd", nil);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressDetail)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.addressLa addGestureRecognizer:tapGesture];
    
    [self.view4 addGestureRecognizer:tapGesture];
    [self.view addSubview:self.botomView];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(city)];
    tapGesture1.numberOfTapsRequired = 1; //点击次数
    tapGesture1.numberOfTouchesRequired = 1; //点击手指数
    [self.cityLa addGestureRecognizer:tapGesture1];
    [self.view3 addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(end)];
    tapGesture2.numberOfTapsRequired = 1; //点击次数
    tapGesture2.numberOfTouchesRequired = 1; //点击手指数
    [self.view addGestureRecognizer:tapGesture2];
    
    [self.view addSubview:self.defaultBtn];
    [self.view addSubview:self.defaultLa];
    
    if (self.model) {
        self.isEdit = YES;
        self.nameTF.text = self.model.fullname;
        self.phoneNumTF.text = self.model.mobile_phone;
        if ([self.model.Default isEqual:@0]) {
            self.defaultBtn.selected = NO;
        }else{
            self.defaultBtn.selected = YES;
        }
        NSMutableString *address = [[NSMutableString alloc]init];
        for (NSString *province in self.provinceArray) {
            if([self.model.address rangeOfString:province].location !=NSNotFound){
                [address appendString:province];
                break;
            }
        }
        for (NSString *city in self.allCityArr) {
            if([self.model.address rangeOfString:city].location !=NSNotFound){
                [address appendString:city];
                break;
            }
        }
        for (NSString *town in self.townCityArr) {
            if([self.model.address rangeOfString:town].location !=NSNotFound){
                [address appendString:town];
                break;
            }
        }
        
        self.cityLa.text = address;
        NSString *str = self.model.address;
        str = [str stringByReplacingOccurrencesOfString:address withString:@""];
        self.addressLa.text = str;
        
    }else{
        self.isEdit = NO;
    }
}

- (UILabel *)defaultLa {
    if (_defaultLa == nil) {
        _defaultLa = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.defaultBtn.frame) + 8, CGRectGetMaxY(self.view4.frame)+8, 100, 15)];
        _defaultLa.text = NSLocalizedString(@"GlobalBuyer_Address_DefaultAdd", nil);
        _defaultLa.font = [UIFont systemFontOfSize:12];
    }
    return _defaultLa;
}

- (UIButton *)defaultBtn {
    if (_defaultBtn == nil) {
        _defaultBtn = [[UIButton alloc]init];
        _defaultBtn.frame = CGRectMake(8, CGRectGetMaxY(self.view4.frame)+8, 15, 15);
        [_defaultBtn setImage:[UIImage imageNamed:@"勾选边框"]  forState:UIControlStateNormal];
        [_defaultBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_defaultBtn addTarget:self action:@selector(defaultClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultBtn;
}

- (void)defaultClick{
    self.defaultBtn.selected = !self.defaultBtn.selected;
}

- (UIView *)botomView {
    if (_botomView == nil) {
        _botomView = [UIView new];
        _botomView.frame = CGRectMake(0, kScreenH , kScreenW, 240);
        _botomView.backgroundColor = [UIColor lightGrayColor];
        [_botomView addSubview:self.cancelBtn];
        [_botomView addSubview:self.pickerView];
        [_botomView addSubview:self.DetermineBtn];
    }
    return _botomView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(5, 0, 50, 40);
        [_cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)DetermineBtn {
    if (!_DetermineBtn) {
        _DetermineBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _DetermineBtn.frame = CGRectMake(kScreenW - 50, 0, 50, 40);
        [_DetermineBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_DetermineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DetermineBtn;
}

#pragma mark 收键盘
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self dismiss];
    return YES;
}

-(void)end{
    [self.view endEditing:YES];
    [self dismiss];
}

-(void)city{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH - 240;
        self.botomView.frame = frame;
    }];
}

#pragma mark 加载数据源
- (void)addressDetail {
    [self dismiss];
    AdderssDetailViewController *adderssDetailVC = [AdderssDetailViewController new];
    adderssDetailVC.delegate = self;
    [self.navigationController pushViewController:adderssDetailVC animated:YES];
}

- (void)sendAdderssDetail:(NSString *)adderssDetail{
    if ([adderssDetail isEqualToString:@""]) {
        return;
    }
    self.addressLa.text = adderssDetail;
}

#pragma pickView的代理方法
- (void)getPickerData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0] ];
    self.allCityArr  = [NSMutableArray new];
    self.townCityArr  = [NSMutableArray new];
    for (int i = 0 ; i < self.provinceArray.count; i++) {
        
        NSArray* selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:i] ];
        NSArray *city = [[ selectedArray objectAtIndex:0] allKeys];
        [self.allCityArr addObjectsFromArray:city];
        NSArray *townArray = [[selectedArray objectAtIndex:0] objectForKey:[city objectAtIndex:0]];
        [self.townCityArr addObjectsFromArray:townArray];
    }
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
}


#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}



#pragma mark pickerView取消事件
- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH;
        self.botomView.frame = frame;
    }];
}

#pragma mark pickerView确定事件
- (void)determineBtnAction:(UIButton *)btn {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.botomView.frame;
        frame.origin.y = kScreenH;
        self.botomView.frame = frame;
    }];
    self.cityLa.text = [NSString stringWithFormat:@"%@%@%@",[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],[self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
}

#pragma mark 保存事件
- (IBAction)saveClick:(id)sender {
    
    if ([self.nameTF.text isEqualToString:@""] || [self.phoneNumTF.text isEqualToString:@""] ||[self.addressLa.text isEqualToString:@"详细地址"] ||[self.cityLa.text isEqualToString:@"地区选择"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Address_MessageIncomplete", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (self.isEdit) {
        [self editAddress];
    }else{
        [self addAddress];
    }
}

-(void)editAddress{
    AddressModel *model = [AddressModel new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *username = self.nameTF.text;
    NSString *phone = self.phoneNumTF.text;
    NSString *detail = [NSString stringWithFormat:@"%@%@",self.cityLa.text,self.addressLa.text];
    NSNumber *Default ;
    NSNumber *Id = self.model.Id;
    NSString *api_token =UserDefaultObjectForKey(USERTOKEN);
    if (self.defaultBtn.selected) {
        Default = @1;
    }else{
        Default = @0;
    }
    
    
//    if ([self.idLa.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号未填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Saveing", nil);
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"address_id":Id,@"fullname":username,@"address":detail,@"default":Default,@"mobile_phone":phone};
    
    [manager POST:EditAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [hud hideAnimated:YES];
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"保存成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            [self.delegate addAddressModel:model];
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"保存失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

-(void)addAddress{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *username = self.nameTF.text;
    NSString *phone = self.phoneNumTF.text;
    NSString *detail = [NSString stringWithFormat:@"%@%@",self.cityLa.text,self.addressLa.text];
    NSNumber *Default ;
    NSString *api_token = UserDefaultObjectForKey(USERTOKEN);
    if (self.defaultBtn.selected) {
        Default = @1;
    }else{
        Default = @0;
    }
    [[BaiduMobStat defaultStat] logEvent:@"event9" eventLabel:@"[添加收货地址]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"添加收貨地址" parameters:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Saveing", nil);
    
    AddressModel *model = [AddressModel new];
    model.fullname = username;
    model.mobile_phone = phone;
    model.address = detail;
    model.Default = Default;
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"fullname":model.fullname,@"address":model.address,@"mobile_phone":model.mobile_phone,@"default":model.Default};
    [manager POST:AddAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"success"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"保存成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            [self.delegate addAddressModel:model];
            
            FillInIDViewController *vc = [[FillInIDViewController alloc]init];
            vc.address_id = [responseObject[@"data"] lastObject][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
            
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
