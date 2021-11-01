//
//  RegisterViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "CooperationRegisterViewController.h"
#import "UserServiceAgreementViewController.h"
#import "UserModel.h"
#import <CoreLocation/CoreLocation.h>
#import "ChoiceRegisterViewController.h"

@interface CooperationRegisterViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,ChoiceRegisterViewControllerDelegate>
//{
//    CLLocationManager *_locationManager;
//}
@property (nonatomic, strong)UIView *conview;
@property (nonatomic, strong)UIImageView *eMailImgView;
@property (nonatomic, strong)UITextField *eMailTextField;
@property (nonatomic, strong)UIImageView *passWordImgView;
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UIImageView *passWordAgainImgView;
@property (nonatomic, strong)UITextField *passWordAgainTextField;
@property (nonatomic, strong)UIImageView *cooIv;
@property (nonatomic, strong)UITextField *cooTx;
@property (nonatomic, strong)UIButton *scanfBtn;
@property (nonatomic, strong)UIButton *registerBtn;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIView *line1;
@property (nonatomic, strong)UIView *line2;
@property (nonatomic ,strong)UIButton *sureBtn;
@property (nonatomic, strong)UILabel *detailLa;

@property (nonatomic, strong)UIButton *agreeBtn;    //服务条款按钮
@property (nonatomic, strong)UILabel *agreementLb;  //服务条款文字

@end

@implementation CooperationRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[BaiduMobStat defaultStat] logEvent:@"event2" eventLabel:@"[注册]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    [FIRAnalytics logEventWithName:@"注册" parameters:nil];
    self.iconImgView.image = nil;
    //self.iconImgView.image = [UIImage imageNamed:@"职训局1"];
    //self.iconImgView.frame = CGRectMake(kScreenW/2 - 70, 10, 140, 140);
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_RegisterView_UserRegister", nil);
    [self setupUI];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

#pragma mark 创建UI界面

- (void)setupUI {
    
    [super setupUI];
//    [self getAdd];
    self.scrollView.frame = CGRectMake(0, LL_TabbarHeight, kScreenW, kScreenH);
    [self.scrollView addSubview:self.conview];
    [self.scrollView addSubview:self.eMailImgView];
    [self.scrollView addSubview:self.eMailTextField];
    [self.scrollView addSubview:self.passWordImgView];
    [self.scrollView addSubview:self.passWordTextField];
    [self.scrollView addSubview:self.passWordAgainTextField];
    [self.scrollView addSubview:self.passWordAgainImgView];
    [self.scrollView addSubview:self.cooIv];
    [self.scrollView addSubview:self.cooTx];
    [self.scrollView addSubview:self.scanfBtn];
    [self.scrollView addSubview:self.registerBtn];
    [self.scrollView addSubview:self.line];
    [self.scrollView addSubview:self.line1];
    [self.scrollView addSubview:self.line2];
    
    [self.scrollView addSubview:self.agreeBtn];
    [self.scrollView addSubview:self.agreementLb];
    
   
    self.qrInvitationCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"InvitationCode"];
    if (self.qrInvitationCode) {
        self.cooTx.text = self.qrInvitationCode;
    }
}

//定位
//- (void)getAdd
//{
//    // 初始化定位管理器
//    _locationManager = [[CLLocationManager alloc] init];
//    // 设置代理
//    _locationManager.delegate = self;
//    // 设置定位精确度到米
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    // 设置过滤器为无
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    // 开始定位
//    [_locationManager startUpdatingLocation];
//}

//定位代理
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        NSLog(@"%@",placemark.name);
//    }];
//}

- (UIButton *)registerBtn {
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc]init];
        _registerBtn.frame = CGRectMake(30, CGRectGetMaxY(self.conview.frame) + 20, CGRectGetWidth(self.conview.frame), 40);

        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Register", nil) forState:UIControlStateNormal];
        
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        //_registerBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.42 blue:0.12 alpha:1];
        _registerBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        //_registerBtn.layer.cornerRadius = 5;

    }
    return _registerBtn;
}

- (UIButton *)agreeBtn
{
    if (_agreeBtn == nil) {
        _agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.conview.frame) + 20 + 60, 25, 25)];
        [_agreeBtn setImage:[UIImage imageNamed:@"用户协议勾选"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"用户协议选中"] forState:UIControlStateSelected];
        [_agreeBtn addTarget:self action:@selector(agreeAgreement) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (void)agreeAgreement
{
    if (self.agreeBtn.selected == YES) {
        self.agreeBtn.selected = NO;
    }else{
        self.agreeBtn.selected = YES;
    }
}

- (UILabel *)agreementLb
{
    if (_agreementLb == nil) {
        _agreementLb = [[UILabel alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(self.conview.frame) + 20 + 60, 200, 25)];
        NSString *agreeStr = NSLocalizedString(@"GlobalBuyer_RegisterView_IAgree", nil);
        NSString *agreementStr = NSLocalizedString(@"GlobalBuyer_RegisterView_Agreement", nil);
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",agreeStr,agreementStr]];
        NSRange range = NSMakeRange(agreeStr.length, agreementStr.length);
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        _agreementLb.attributedText = content;
        
        _agreementLb.textColor = [UIColor whiteColor];
        _agreementLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(readAgreement)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_agreementLb addGestureRecognizer:tap];
    }
    return _agreementLb;
}

- (void)readAgreement
{
    UserServiceAgreementViewController *agreementVC = [[UserServiceAgreementViewController alloc]init];
    agreementVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:agreementVC animated:YES];
}

-(UIImageView *)passWordAgainImgView {
    if (_passWordAgainImgView == nil) {
        _passWordAgainImgView = [[UIImageView alloc]init];
        _passWordAgainImgView.frame =CGRectMake(40, CGRectGetMinY(self.conview.frame) + 64*2 +( 64- 25)/2, 25, 25);
         _passWordAgainImgView.image = [UIImage imageNamed:@"password"];
    }
    return _passWordAgainImgView;
}

-(UITextField *)passWordAgainTextField {

    if (_passWordAgainTextField == nil) {
        _passWordAgainTextField = [[UITextField alloc]init];
        _passWordAgainTextField.frame = CGRectMake(CGRectGetMaxX(self.eMailImgView.frame) + 10, CGRectGetMinY(self.conview.frame) + 64*2 +( 64- 25)/2,  CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10, 30);
        _passWordAgainTextField.placeholder = NSLocalizedString(@"GlobalBuyer_UserInfo_AgnPWGuide", nil);
        _passWordAgainTextField.textColor = [UIColor whiteColor];
        _passWordAgainTextField.delegate = self;
        _passWordAgainTextField.font = [UIFont systemFontOfSize:14];
        _passWordAgainTextField.secureTextEntry = YES;
        _passWordAgainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView *starTwoIV = [[UIImageView alloc]initWithFrame:CGRectMake(_passWordAgainTextField.frame.size.width - 20, 10, 10, 10)];
        starTwoIV.image = [UIImage imageNamed:@"must_fill"];
        [_passWordAgainTextField addSubview:starTwoIV];
    }
    return _passWordAgainTextField;

}

- (UIImageView *)eMailImgView{
    if (_eMailImgView == nil) {
        _eMailImgView = [[UIImageView alloc]init];
        _eMailImgView.frame = CGRectMake(40,CGRectGetMinY(self.conview.frame) + 24.5 ,25, 15);
        _eMailImgView.image = [UIImage imageNamed:@"eMail"];
    }
    return _eMailImgView;
}
- (UITextField *)eMailTextField {
    if (_eMailTextField == nil) {
        _eMailTextField = [[UITextField alloc]init];
        _eMailTextField.frame = CGRectMake(CGRectGetMaxX(self.eMailImgView.frame) + 10, CGRectGetMinY(self.conview.frame) + 17,  CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10, 30);
        _eMailTextField.placeholder = NSLocalizedString(@"GlobalBuyer_LoginView_inputEmail", nil);
        _eMailTextField.textColor = [UIColor whiteColor];
        _eMailTextField.delegate = self;
        _eMailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _eMailTextField.font = [UIFont systemFontOfSize:14];
        
        UIImageView *starTwoIV = [[UIImageView alloc]initWithFrame:CGRectMake(_eMailTextField.frame.size.width - 20, 10, 10, 10)];
        starTwoIV.image = [UIImage imageNamed:@"must_fill"];
        [_eMailTextField addSubview:starTwoIV];
        
    }
    return _eMailTextField;
}
-(UITextField *)passWordTextField{
    if (_passWordTextField == nil) {
        _passWordTextField = [[UITextField alloc]init];
        _passWordTextField.frame = CGRectMake(CGRectGetMaxX(self.eMailImgView.frame) + 10, CGRectGetMinY(self.conview.frame) + 64 +( 64- 25)/2,  CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10, 30);
        _passWordTextField.placeholder = NSLocalizedString(@"GlobalBuyer_UserInfo_PWGuide", nil);
        _passWordTextField.textColor = [UIColor whiteColor];
        _passWordTextField.delegate = self;
        _passWordTextField.font = [UIFont systemFontOfSize:14];
        _passWordTextField.secureTextEntry = YES;
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIImageView *starTwoIV = [[UIImageView alloc]initWithFrame:CGRectMake(_passWordTextField.frame.size.width - 20, 10, 10, 10)];
        starTwoIV.image = [UIImage imageNamed:@"must_fill"];
        [_passWordTextField addSubview:starTwoIV];
    }
    return _passWordTextField;
}

- (UIImageView *)passWordImgView{
    if (_passWordImgView == nil) {
        _passWordImgView = [UIImageView new];
        _passWordImgView.frame = CGRectMake(40, CGRectGetMinY(self.conview.frame) + 64 +( 64- 25)/2, 25, 25);
        _passWordImgView.image = [UIImage imageNamed:@"password"];
        
        
    }
    return _passWordImgView;
}

- (UITextField *)cooTx
{
    if (_cooTx == nil) {
        _cooTx = [[UITextField alloc]init];
        _cooTx.frame = CGRectMake(CGRectGetMaxX(self.eMailImgView.frame) + 10, CGRectGetMinY(self.conview.frame) + 64 + 64 + 64 +( 64- 25)/2,  CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10, 30);
        _cooTx.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil);
        _cooTx.textColor = [UIColor whiteColor];
        _cooTx.delegate = self;
        _cooTx.font = [UIFont systemFontOfSize:14];
    }
    return _cooTx;
}

- (UIImageView *)cooIv
{
    if (_cooIv == nil) {
        _cooIv = [UIImageView new];
        _cooIv.frame = CGRectMake(40, CGRectGetMinY(self.conview.frame) + 64 + 64 + 64 +( 64- 25)/2 + 2, 25, 25);
        _cooIv.image = [UIImage imageNamed:@"邀请码"];
    }
    return _cooIv;
}

- (UIButton *)scanfBtn
{
    if (_scanfBtn == nil) {
        _scanfBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10 + 65, CGRectGetMinY(self.conview.frame) + 64 + 64 + 64 +( 64- 25)/2 + 3 , 20, 20)];
        [_scanfBtn setImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
        [_scanfBtn addTarget:self action:@selector(scanfInvitationCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanfBtn;
}

- (void)scanfInvitationCode
{
    
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        ChoiceRegisterViewController *vc = [[ChoiceRegisterViewController alloc] init];
                        vc.delegate = self;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            ChoiceRegisterViewController *vc = [[ChoiceRegisterViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }

    
//    ChoiceRegisterViewController *choiceRVC = [[ChoiceRegisterViewController alloc]init];
//    choiceRVC.delegate = self;
//    [self.navigationController pushViewController:choiceRVC animated:YES];
}

- (void)scanfInvitationCode:(NSString *)invitationCode
{
    self.cooTx.text = invitationCode;
}

- (UIView *)conview {
    if (_conview == nil) {
        _conview = [[UIView alloc]init];
        //_conview.backgroundColor = [UIColor colorWithRed:0.53 green:0.76 blue:0.36 alpha:1];
        _conview.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _conview.frame = CGRectMake(30, CGRectGetMaxY(self.iconImgView.frame) - 70, kScreenW - 60, 256);
        //_conview.layer.cornerRadius = 5;
    }
    return _conview;
}

-(UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.frame = CGRectMake(CGRectGetMinX(self.eMailTextField.frame), CGRectGetMinY(self.conview.frame) + 64,CGRectGetWidth(self.eMailTextField.frame) , 1);
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

-(UIView *)line1{
    if (_line1 == nil) {
        _line1 = [[UIView alloc]init];
        _line1.frame = CGRectMake(CGRectGetMinX(self.eMailTextField.frame), CGRectGetMinY(self.conview.frame) + 64*2,CGRectGetWidth(self.eMailTextField.frame) , 1);
        _line1.backgroundColor = [UIColor whiteColor];
    }
    return _line1;
}

- (UIView *)line2
{
    if (_line2 == nil) {
        _line2 = [[UIView alloc]init];
        _line2.frame = CGRectMake(CGRectGetMinX(self.eMailTextField.frame), CGRectGetMinY(self.conview.frame) + 64*3,CGRectGetWidth(self.eMailTextField.frame) , 1);
        _line2.backgroundColor = [UIColor whiteColor];
    }
    return _line2;
}



#pragma mark 注册事件
- (void)registerClick {
    
    [self.view endEditing:YES];
    //邮箱格式不对
    if (![self isEmailAddress:self.eMailTextField.text]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_LoginView_EmailError", nil)];
        return;
    }
    
    //请输入6 - 20密码
    if (!(self.passWordTextField.text.length >= 6 && self.passWordTextField.text.length <= 20) || ![self checkPassword:self.passWordTextField.text]){
        [self showAlter:NSLocalizedString(@"GlobalBuyer_UserInfo_PWError", nil)];
        return;
    }
    
    //两次密码不对
    if (![self.passWordTextField.text isEqualToString:self.passWordAgainTextField.text]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_UserInfo_PWdif", nil)];
        return;
    }
    
//    if ([self.cooTx.text isEqualToString:@""]) {
//        [self showAlter:NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil)];
//        return;
//    }
    
    //未同意协议
    if (self.agreeBtn.selected == NO) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_RegisterView_Warningtips", nil)];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
        // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_RegisterView_Registering", nil);

    
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
    
    NSString *email = self.eMailTextField.text;
    NSString *password = self.passWordTextField.text;
    NSString *cooStr = self.cooTx.text;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"email":email,
                             @"password":password,
                             @"inviteCode":cooStr,
                             @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                             @"locale":language};
    
    [manager POST:UserRegisterApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"error"]) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            // Move to bottm center.
            hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3];
        }
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"注册成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3];
            [self.navigationController popViewControllerAnimated:YES];
        }
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"注册失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3];
    }];
}

#pragma mark 提示框
- (void)showAlter:(NSString *)message {
    
//    MSAlertController *alertController = [MSAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: message preferredStyle:MSAlertControllerStyleAlert];
//    MSAlertAction *action = [MSAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
//    }];
//    [alertController addAction:action];
//
//    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alertController addAction:okAction];

    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 校验密码
- (BOOL)checkPassword:(NSString *)password {
      NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
        NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)] ;
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return NO;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return NO;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return YES;
    } else {
        return NO;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
}

#pragma mark 判断邮箱
- (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
