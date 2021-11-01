//
//  NewAddressManagementViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/7.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "NewAddressManagementViewController.h"
#import "JPhotoMagenage.h"
#import "ShopCartSettlementDetailsViewController.h"

@interface NewAddressManagementViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *nameBackV;
@property (nonatomic,strong)UITextField *nameTf;

@property (nonatomic,strong)UIView *addBackV;
@property (nonatomic,strong)UITextField *addTf;

@property (nonatomic,strong)UIView *phoneBackV;
@property (nonatomic,strong)UITextField *phoneTf;

@property (nonatomic,strong)UIView *idCardBackV;
@property (nonatomic,strong)UITextField *idCardTf;

@property (nonatomic,strong)UIView *mailBackV;
@property (nonatomic,strong)UITextField *mailTf;

@property (nonatomic,strong)UIView *idCardImageBackV;
@property (nonatomic,strong)UIImageView *idCardFIV;
@property (nonatomic,strong)UIImageView *idCardBIV;
@property (nonatomic,strong)NSString *imageA;
@property (nonatomic,strong)NSString *imageB;

@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,strong)NSString *address_id;

@end

@implementation NewAddressManagementViewController

//@class ShopCartSettlementDetailsViewController ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    if ([self.editType isEqualToString:@"Edit"]) {
        self.address_id = [NSString stringWithFormat:@"%@",self.model.Id];
        self.nameTf.text = [NSString stringWithFormat:@"%@",self.model.fullname];
        self.addTf.text = [NSString stringWithFormat:@"%@",self.model.address];
        self.phoneTf.text = [NSString stringWithFormat:@"%@",self.model.mobile_phone];
        self.idCardTf.text = [NSString stringWithFormat:@"%@",self.model.idCardNum];
        [self.idCardFIV sd_setImageWithURL:[NSURL URLWithString:self.model.idcard_front] placeholderImage:[UIImage imageNamed:@"ic_id_background"]];
        [self.idCardBIV sd_setImageWithURL:[NSURL URLWithString:self.model.idcard_back] placeholderImage:[UIImage imageNamed:@"ic_id_background"]];
        self.mailTf.text = [NSString stringWithFormat:@"%@",self.model.zipcode];
    }
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent=NO;
//}
- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nameBackV];
    [self.view addSubview:self.addBackV];
    [self.view addSubview:self.phoneBackV];
    [self.view addSubview:self.idCardBackV];
    [self.view addSubview:self.mailBackV];
    [self.view addSubview:self.idCardImageBackV];
    [self.view addSubview:self.saveBtn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (UIView *)nameBackV{
    if (_nameBackV == nil) {
        _nameBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , kScreenW , 60)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 59, kScreenW - 20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [_nameBackV addSubview:lineV];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 59)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Addressee", nil);
        [_nameBackV addSubview:lb];
        self.nameTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW - 110, 50)];
        self.nameTf.delegate = self;
        [_nameBackV addSubview:self.nameTf];
        UIImageView *starIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 30, 25, 10, 10)];
        starIv.image = [UIImage imageNamed:@"must_fill"];
        [_nameBackV addSubview:starIv];
    }
    return _nameBackV;
}

- (UIView *)addBackV{
    if (_addBackV == nil) {
        _addBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 60 , kScreenW , 60)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 59, kScreenW - 20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [_addBackV addSubview:lineV];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 59)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_DetailedAddress", nil);
        [_addBackV addSubview:lb];
        self.addTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW - 110, 50)];
        self.addTf.delegate = self;
        [_addBackV addSubview:self.addTf];
        UIImageView *starIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 30, 25, 10, 10)];
        starIv.image = [UIImage imageNamed:@"must_fill"];
        [_addBackV addSubview:starIv];
    }
    return _addBackV;
}

- (UIView *)phoneBackV{
    if (_phoneBackV == nil) {
        _phoneBackV = [[UIView alloc]initWithFrame:CGRectMake(0,60 + 60 , kScreenW , 60)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 59, kScreenW - 20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [_phoneBackV addSubview:lineV];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 59)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_phone", nil);
        [_phoneBackV addSubview:lb];
        self.phoneTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW - 110, 50)];
        self.phoneTf.delegate = self;
        [_phoneBackV addSubview:self.phoneTf];
        UIImageView *starIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 30, 25, 10, 10)];
        starIv.image = [UIImage imageNamed:@"must_fill"];
        [_phoneBackV addSubview:starIv];
    }
    return _phoneBackV;
}

- (UIView *)idCardBackV{
    if (_idCardBackV == nil) {
        _idCardBackV = [[UIView alloc]initWithFrame:CGRectMake(0,60 + 60 + 60, kScreenW , 60)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 59, kScreenW - 20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [_idCardBackV addSubview:lineV];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 59)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_ID", nil);
        [_idCardBackV addSubview:lb];
        self.idCardTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW - 110, 50)];
        self.idCardTf.delegate = self;
        [_idCardBackV addSubview:self.idCardTf];
        UIImageView *starIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 30, 25, 10, 10)];
        starIv.image = [UIImage imageNamed:@"must_fill"];
        [_idCardBackV addSubview:starIv];
    }
    return _idCardBackV;
}

- (UIView *)mailBackV{
    if (_mailBackV == nil) {
        _mailBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 60 + 60 + 60 + 60, kScreenW , 60)];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 59, kScreenW - 20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        [_mailBackV addSubview:lineV];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 59)];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = NSLocalizedString(@"邮编", nil);
        [_mailBackV addSubview:lb];
        self.mailTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW - 110, 50)];
        self.mailTf.delegate = self;
        [_mailBackV addSubview:self.mailTf];
    }
    return _mailBackV;
}

- (UIView *)idCardImageBackV{
    if (_idCardImageBackV == nil) {
        _idCardImageBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 60 + 60 + 60 + 60 + 60 + 10, kScreenW , 120)];
        self.idCardFIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 80, 80)];
        self.idCardFIV.userInteractionEnabled = YES;
        self.idCardFIV.tag = 666;
        self.idCardFIV.image = [UIImage imageNamed:@"ic_id_background"];
        [_idCardImageBackV addSubview:self.idCardFIV];
        UILabel *fLb = [[UILabel alloc]initWithFrame:CGRectMake( 100, 0, kScreenW/2 - 100, 120)];
        fLb.font = [UIFont systemFontOfSize:15];
        fLb.textAlignment = NSTextAlignmentCenter;
        fLb.numberOfLines = 0;
        fLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_ID_F", nil);
        [_idCardImageBackV addSubview:fLb];
        UITapGestureRecognizer *tapF = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
        tapF.numberOfTapsRequired = 1;
        tapF.numberOfTouchesRequired = 1;
        [self.idCardFIV addGestureRecognizer:tapF];
        
        self.idCardBIV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 + 10, 20, 80, 80)];
        self.idCardBIV.userInteractionEnabled = YES;
        self.idCardBIV.tag = 888;
        self.idCardBIV.image = [UIImage imageNamed:@"ic_id_background"];
        [_idCardImageBackV addSubview:self.idCardBIV];
        UILabel *bLb = [[UILabel alloc]initWithFrame:CGRectMake( kScreenW/2 + 100, 0, kScreenW/2 - 100, 120)];
        bLb.font = [UIFont systemFontOfSize:15];
        bLb.textAlignment = NSTextAlignmentCenter;
        bLb.numberOfLines = 0;
        bLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_ID_B", nil);
        [_idCardImageBackV addSubview:bLb];
        UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
        tapB.numberOfTapsRequired = 1;
        tapB.numberOfTouchesRequired = 1;
        [self.idCardBIV addGestureRecognizer:tapB];
    }
    return _idCardImageBackV;
}

- (UIButton *)saveBtn{
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - 50-NavBarHeight, kScreenW, 50)];
        _saveBtn.backgroundColor = Main_Color;
        [_saveBtn setTitle:NSLocalizedString(@"GlobalBuyer_Address_Save", nil) forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(addAddressOrEditAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (void)selectImage:(UITapGestureRecognizer *)tap
{
    [JPhotoMagenage getOneImageInController:self finish:^(UIImage *images) {
        NSLog(@"%@",images);
        if ([tap view].tag == 666) {
            self.idCardFIV.image = images;
            NSLog(@"%@",[images accessibilityIdentifier]);
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/idF.png"];
            NSLog(@"%@",imagePath);
            self.imageA = imagePath;
            [UIImagePNGRepresentation(images) writeToFile:imagePath atomically:YES];
        }
        if ([tap view].tag == 888) {
            self.idCardBIV.image = images;
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/idB.png"];
            NSLog(@"%@",imagePath);
            self.imageB = imagePath;
            [UIImagePNGRepresentation(images) writeToFile:imagePath atomically:YES];
        }
    } cancel:^{
        
    }];
}

- (void)addAddressOrEditAddress{
    if ([self.editType isEqualToString:@"Edit"]) {
        [self editAddress];
    }else{
        [self addAddress];
    }
}

-(void)editAddress{
    
    if (self.nameTf.text.length < 1 &&
        self.addTf.text.length < 1 &&
        self.phoneTf.text.length < 1 &&
        self.idCardTf.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"带*项必填", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    AddressModel *model = [AddressModel new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *username = self.nameTf.text;
    NSString *phone = self.phoneTf.text;
    NSString *detail = [NSString stringWithFormat:@"%@",self.addTf.text];
    NSNumber *Default = @0;
    NSNumber *Id = self.model.Id;
    NSString *api_token =UserDefaultObjectForKey(USERTOKEN);
    
    
    //    if ([self.idLa.text isEqualToString:@""]) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号未填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Saveing", nil);
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"address_id":Id,@"fullname":username,@"address":detail,@"default":Default,@"mobile_phone":phone,@"zipcode":[NSString stringWithFormat:@"%@",self.mailTf.text]};
    
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

            [self sureCommit];
            
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
    
    if (self.nameTf.text.length < 1 &&
        self.addTf.text.length < 1 &&
        self.phoneTf.text.length < 1 &&
        self.idCardTf.text.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"带*项必填", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *username = self.nameTf.text;
    NSString *phone = self.phoneTf.text;
    NSString *detail = [NSString stringWithFormat:@"%@",self.addTf.text];
    NSNumber *Default = @0;
    NSString *api_token = UserDefaultObjectForKey(USERTOKEN);
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
            self.address_id = [responseObject[@"data"] lastObject][@"id"];
            [self sureCommit];
            
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

- (void)sureCommit
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"正在上传", nil);
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    
    NSData *data;
    if (1) {
        
        data = UIImageJPEGRepresentation(self.idCardFIV.image, 0.1);
        NSLog(@"%lu",(unsigned long)data.length);
    } else {
        
        data = UIImagePNGRepresentation(self.idCardFIV.image);
    }
    
    NSData *dataB;
    if (1) {
        
        dataB = UIImageJPEGRepresentation(self.idCardBIV.image, 0.1);
        
    } else {
        
        dataB = UIImagePNGRepresentation(self.idCardBIV.image);
    }
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"address_id":self.address_id,@"idcard_num":self.idCardTf.text};
    [manager POST:UploadID parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"idcard_front" fileName:@"idF.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:dataB name:@"idcard_back" fileName:@"idB.png" mimeType:@"image/png"];
        
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            BOOL ret = NO;
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ShopCartSettlementDetailsViewController class]]) {
                    ret = YES;
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            if (!ret) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"服务器忙请稍后重试!", @"HUD message title");
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
