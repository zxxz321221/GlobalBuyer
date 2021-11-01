//
//  LoginRootViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/19.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "LoginRootViewController.h"
#import "RegisterViewController.h"
#import "WXApi.h"
#import "RegisterViewController.h"
#import "CooperationRegisterViewController.h"
#import "PasswordRetrievalViewController.h"
#import "ChoiceRegisterViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "SignInApple.h"
#import "GreatLoginViewController.h"
@interface LoginRootViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,SignInAppleDelegate>
@property (nonatomic, strong)UIView *conview;
@property (nonatomic, strong)UIImageView *eMailImgView;
@property (nonatomic, strong)UITextField *eMailTextField;
@property (nonatomic, strong)UIImageView *passWordImgView;
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton *registerOrdinaryBtn;
@property (nonatomic, strong)UIButton *registerBtn;
@property (nonatomic, strong)UIButton *forgotPasswordBtn;
@property (nonatomic, strong)UIButton *facebookBtn;
@property (nonatomic, strong)UIButton *wechatBtn;
@property (nonatomic, strong)UIButton *cooperationBtn;
@property (nonatomic, strong)UIView *leftLine;
@property (nonatomic, strong)UIView *rigthLine;
@property (nonatomic, strong)UILabel *detailLa;
@property (nonatomic, strong)NSString *uniID;
@property (nonatomic, strong)NSString *appleID;
@property (nonatomic, strong)NSString *appleToken;
@property (nonatomic, strong)NSString *fbidID;
@property (nonatomic, strong)NSString *emailID;
@property (nonatomic, strong)NSString *inviteCodeID;
@property (nonatomic, strong)NSString *headImgUrl;


@property (nonatomic, strong)UIView *bindPhoneNumberBackV;
@property (nonatomic, strong)UILabel *phoneRegionLb;
@property (nonatomic, strong)NSString *phoneRegionStr;
@property (nonatomic, strong)UITextField *phoneNumberTX;
@property (nonatomic, strong)UITextField *verificationCodeTX;
@property (nonatomic, strong)UIButton *getVerificationCodebtn;
@property (nonatomic, strong)UITextField *inviteCodeTX;

@property (nonatomic,strong) UIView *pickerViewBackV;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerViewSureOrCancelV;
@property (nonatomic,strong) NSMutableArray *areaCodeDataSource;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int countDownNum;

@property (nonatomic, strong) SignInApple *signInApple;
@property (nonatomic, strong) UIButton *appleIdBtn;
@end

@implementation LoginRootViewController

- (void)viewDidLoad {
    //Name:globalBuyer
   // Key ID:5WHTK5WMB7

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"LOGINVIEWCONTROLLERBACK" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_LoginView_login", nil);
    [self setupUI];
    
    [self getThridLogin];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backClick{
    if (self.pop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShoppingCart" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)back{
    
    
    if (self.pop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShoppingCart" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)getThridLogin{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:ThirdappopenApi parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger data = [responseObject[@"data"] integerValue];
        if (data == 0) {

        }else{
            
               [self.scrollView addSubview:self.facebookBtn];
               [self.scrollView addSubview:self.detailLa];
               [self.scrollView addSubview:self.rigthLine];
               [self.scrollView addSubview:self.leftLine];
               [self.scrollView addSubview:self.appleIdBtn];
            
            if ([WXApi isWXAppInstalled]) {
                [self.scrollView addSubview:self.wechatBtn];
                
            }else{
                [self.wechatBtn removeFromSuperview];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}


#pragma mark 创建UI界面
- (void)setupUI {
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [super setupUI];
    [self.scrollView addSubview:self.conview];
    [self.scrollView addSubview:self.eMailImgView];
    [self.scrollView addSubview:self.eMailTextField];
    [self.scrollView addSubview:self.passWordImgView];
    [self.scrollView addSubview:self.passWordTextField];
    [self.scrollView addSubview:self.line];
    [self.scrollView addSubview:self.loginBtn];
    
    [self.scrollView addSubview:self.registerOrdinaryBtn];
    //[self.scrollView addSubview:self.registerBtn];
    [self.scrollView addSubview:self.forgotPasswordBtn];
   
    //[self.scrollView addSubview:self.cooperationBtn];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [self.scrollView addGestureRecognizer:tapGesture];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
}


//- (void)configAppleIDButton{
//    // 使用系统提供的按钮，要注意不支持系统版本的处理
//    if (@available(iOS 13.0, *)) {
//        // Sign In With Apple Button
//        ASAuthorizationAppleIDButton *appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhite];
//        appleIDBtn.frame = CGRectMake((kScreenW - 55)/2, 450, 55, 55);
//        appleIDBtn.cornerRadius = 22.f;
//        [appleIDBtn addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:appleIDBtn];
//    }
//}




- (UIView *)leftLine {
    if (_leftLine == nil) {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = [UIColor whiteColor];
        _leftLine.frame = CGRectMake(CGRectGetMaxX(self.detailLa.frame), CGRectGetMidY(self.detailLa.frame), CGRectGetMinX(self.detailLa.frame) - 30, 1);
    }
    return _leftLine;
}

- (UIView *)rigthLine {
    if (_rigthLine == nil) {
        _rigthLine = [[UIView alloc]init];
        _rigthLine.backgroundColor = [UIColor whiteColor];
        _rigthLine.frame = CGRectMake(30,  CGRectGetMidY(self.detailLa.frame), CGRectGetMinX(self.detailLa.frame) - 30, 1);
    }
    return _rigthLine;
}

- (UILabel *)detailLa {
    if (_detailLa == nil) {
        _detailLa = [[UILabel alloc]init];
        _detailLa.text = NSLocalizedString(@"GlobalBuyer_LoginView_thirdlogin", nil);
        _detailLa.font = [UIFont systemFontOfSize:15];
        _detailLa.textColor = [UIColor whiteColor];
        _detailLa.textAlignment = NSTextAlignmentCenter;
        _detailLa.frame = CGRectMake((kScreenW - 120)/2, 420, 120, 30);
    }
    return _detailLa;
}

- (UIButton *)facebookBtn {
    if (_facebookBtn == nil) {
        _facebookBtn = [[UIButton alloc]init];
        _facebookBtn.frame = CGRectMake(kScreenW / 4 - 25, 450, 50, 50);
        [_facebookBtn setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
        [_facebookBtn addTarget:self action:@selector(facebookClick) forControlEvents:UIControlEventTouchUpInside];
        _facebookBtn.layer.cornerRadius = 25;
        _facebookBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _facebookBtn.layer.borderWidth = 1;
    }
    return _facebookBtn;
}



- (void)cooperationClick
{
    CooperationRegisterViewController *cooVc = [[CooperationRegisterViewController alloc]init];
    [self.navigationController pushViewController:cooVc animated:YES];
}

-(UIButton *)wechatBtn {
    
    if (_wechatBtn == nil) {
        _wechatBtn = [[UIButton alloc]init];
        _wechatBtn.frame = CGRectMake((kScreenW / 4) * 3  - 25, 450, 50, 50);
        [_wechatBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [_wechatBtn addTarget:self action:@selector(weChatClick) forControlEvents:UIControlEventTouchUpInside];
        _wechatBtn.layer.cornerRadius = 25;
        _wechatBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _wechatBtn.layer.borderWidth = 1;
        
    }
    return _wechatBtn;
}

- (UIButton *)forgotPasswordBtn {
    if (_forgotPasswordBtn == nil) {
        _forgotPasswordBtn = [[UIButton alloc]init];
        [_forgotPasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forgotPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_forgotPasswordBtn setTitle:[NSString stringWithFormat:@"%@?",NSLocalizedString(@"GlobalBuyer_LoginView_forgotPW", nil)] forState:UIControlStateNormal];
        _forgotPasswordBtn.frame = CGRectMake(kScreenW/2 - 35, CGRectGetMaxY(self.loginBtn.frame) + 220, 70, 20);
        [_forgotPasswordBtn addTarget:self action:@selector(forgotPasswordClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgotPasswordBtn;
}

- (UIButton *)registerBtn {
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc]init];
        _registerBtn.frame = CGRectMake(30, CGRectGetMaxY(self.loginBtn.frame) + 10, 70, 20);
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setTitle:NSLocalizedString(@"GlobalBuyer_LoginView_register", nil) forState:UIControlStateNormal];
        
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
}

- (UIButton *)cooperationBtn
{
    if (_cooperationBtn == nil) {
        _cooperationBtn = [[UIButton alloc]init];
        _cooperationBtn.frame = CGRectMake(kScreenW - 135, CGRectGetMaxY(self.loginBtn.frame) + 10, 100, 20);
        _cooperationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cooperationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cooperationBtn setTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_CooperationRegister", nil) forState:UIControlStateNormal];
        
        [_cooperationBtn addTarget:self action:@selector(cooperationClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cooperationBtn;
}

- (UIButton *)registerOrdinaryBtn
{
    if (_registerOrdinaryBtn == nil) {
        _registerOrdinaryBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.conview.frame) + 20 + 50, CGRectGetWidth(self.conview.frame), 40)];
        [_registerOrdinaryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerOrdinaryBtn setTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Register", nil) forState:UIControlStateNormal];
        [_registerOrdinaryBtn addTarget:self action:@selector(cooperationClick) forControlEvents:UIControlEventTouchUpInside];
        //_registerOrdinaryBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.42 blue:0.12 alpha:1];
        _registerOrdinaryBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    }
    return _registerOrdinaryBtn;
}

- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.frame = CGRectMake(30, CGRectGetMaxY(self.conview.frame) + 20, CGRectGetWidth(self.conview.frame), 40);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:NSLocalizedString(@"GlobalBuyer_LoginView_login", nil) forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        //_loginBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.42 blue:0.12 alpha:1];
        _loginBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        //_loginBtn.layer.cornerRadius = 5;
    }
    return _loginBtn;
}

//超赞登录
- (UIButton *)appleIdBtn {
    if (_appleIdBtn == nil) {
        _appleIdBtn = [[UIButton alloc]init];
        _appleIdBtn.frame = CGRectMake((kScreenW - 55)/2, 450, 55, 55);
        [_appleIdBtn.layer setMasksToBounds:YES];
        [_appleIdBtn setImage:[UIImage imageNamed:@"超赞"] forState:UIControlStateNormal];
        [_appleIdBtn.layer setCornerRadius:22.f];
        
        [_appleIdBtn addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_appleIdBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
    return _appleIdBtn;
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
        _eMailTextField.font = [UIFont systemFontOfSize:14];
        _eMailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _eMailTextField;
}

-(UITextField *)passWordTextField{
    if (_passWordTextField == nil) {
        _passWordTextField = [[UITextField alloc]init];
        _passWordTextField.frame = CGRectMake(CGRectGetMaxX(self.eMailImgView.frame) + 10, CGRectGetMidY(self.conview.frame) + 17,  CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10, 30);
        _passWordTextField.placeholder = NSLocalizedString(@"GlobalBuyer_LoginView_inputPW", nil);
        _passWordTextField.textColor = [UIColor whiteColor];
        _passWordTextField.delegate = self;
        _passWordTextField.font = [UIFont systemFontOfSize:14];
        _passWordTextField.secureTextEntry = YES;
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passWordTextField;
}

- (UIImageView *)passWordImgView{
    if (_passWordImgView == nil) {
        _passWordImgView = [UIImageView new];
        _passWordImgView.frame = CGRectMake(40, CGRectGetMidY(self.conview.frame) + (64 - 25)/2, 25, 25);
        _passWordImgView.image = [UIImage imageNamed:@"password"];
        
    }
    return _passWordImgView;
}

- (UIView *)conview {
    if (_conview == nil) {
        _conview = [[UIView alloc]init];
        //_conview.backgroundColor = [UIColor colorWithRed:0.53 green:0.76 blue:0.36 alpha:1];
        _conview.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _conview.frame = CGRectMake(30, CGRectGetMaxY(self.iconImgView.frame) + 30, kScreenW - 60, 128);
        //_conview.layer.cornerRadius = 5;
    }
    return _conview;
}

-(UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.frame = CGRectMake(CGRectGetMinX(self.eMailTextField.frame), CGRectGetMidY(self.conview.frame),CGRectGetWidth(self.eMailTextField.frame) , 1);
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

#pragma mark  使用系统提供的按钮调用处理授权的方法
- (void)didAppleIDBtnClicked{

//    NSLog(@"****didAppleIDBtnClicked***");
//    // 封装Sign In with Apple 登录工具类，使用这个类时要把类对象设置为全局变量，或者直接把这个工具类做成单例，如果使用局部变量，和IAP支付工具类一样，会导致苹果回调不会执行
//    self.signInApple = [[SignInApple alloc] init];
//    self.signInApple.delegate = self;
//    [self.signInApple handleAuthorizationAppleIDButtonPress];
    
    GreatLoginViewController *vc = [[GreatLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
- (void)perfomExistingAccount{
    // 封装Sign In with Apple 登录工具类，使用这个类时要把类对象设置为全局变量，或者直接把这个工具类做成单例，如果使用局部变量，和IAP支付工具类一样，会导致苹果回调不会执行
    self.signInApple = [[SignInApple alloc] init];
    [self.signInApple perfomExistingAccountSetupFlows];
}

#pragma mark 收键盘 手势
- (void)tapGesture {
    [self.view endEditing:YES];
}

#pragma mark 注册事件
- (void)registerClick {
    NSLog(@"注册");
    RegisterViewController *registerVC = [RegisterViewController new];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark 提示框
- (void)showAlter:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 找回密码
- (void)forgotPasswordClick {
    PasswordRetrievalViewController *passWordReVC = [[PasswordRetrievalViewController alloc]init];
    [self.navigationController pushViewController:passWordReVC animated:YES];
    NSLog(@"找回密码");
}

#pragma mark 登录事件
- (void)loginClick {
    NSLog(@"登录");
    [self.view endEditing:YES];
    if (![self isEmailAddress:self.eMailTextField.text]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_LoginView_EmailError", nil)];
        return;
    }
    if ([self.passWordTextField.text isEqualToString:@""]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_LoginView_PWError", nil)];
        return;
    }
    [self loginEmailApi];
}

#pragma mark 判断邮箱
- (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 登录Api
-(void)loginEmailApi{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_LoginView_logining", nil);
    NSString *email = self.eMailTextField.text;
    NSString *password = self.passWordTextField.text;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = [NSDictionary new];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
    }else{
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password};
    }


    [manager POST:UserLoginApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"error"]) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"登录失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self saveEmailLoginInfo:responseObject];
            
            [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"enterprise"];
            
            [hud hideAnimated:YES];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"登录失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@",error);
    }];
}

#define mark 存储个人信息
-(void)saveEmailLoginInfo:(id _Nullable)responseObject {

    NSDictionary *dict = responseObject[@"data"];
    
    
    NSLog(@"============%lu",(unsigned long)[responseObject[@"bind"] count]);
    
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
    
    [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"id"] forKey:@"UserLoginId"];
    
    for (int i = 0; i < [responseObject[@"bind"] count] ; i++) {
        if ([responseObject[@"bind"][i]isEqualToString:@"weixin"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"WECHATBIND"];
        }
        
        if ([responseObject[@"bind"][i]isEqualToString:@"facebook"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"FACEBIND"];
        }
    }

    
    UserModel *model = [[UserModel alloc]initWithDictionary:dict error:nil];
    if (!model.sex) {
        model.sex = 0;
    }
    
    NSString *mobileStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mobile_phone"]];
    NSString *emailName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"email_name"]];
//    if (!model.fullname || [model.fullname isEqualToString: @"未命名"]) {
//        model.fullname = @"YK1253920N";
//    }
    if (!model.mobile_phone) {
        model.mobile_phone = @"";
    }
    
    
    [[NSUserDefaults standardUserDefaults]setObject:model.mobile_phone forKey:@"UserPhone"];
    [[NSUserDefaults standardUserDefaults]setObject:model.email forKey:@"USEREMAIL"];
    [[NSUserDefaults standardUserDefaults]setObject:model.avatar forKey:@"UserHeadImgUrl"];

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filename contents:nil attributes:nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.email,@"email",model.fullname,@"fullname",mobileStr,@"mobile_phone",model.currency,@"currency",emailName,@"email_name",model.sex,@"sex",model.created_at,@"created_at",nil];
    [dic writeToFile:filename atomically:YES];
    
    
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"dic is:%@",dic2);
    
    UserDefaultSetObjectForKey(model.secret_key, USERTOKEN);
    
    [self checkDistributorBoss];
    
}

#pragma mark 检测是否是分销商老大
- (void)checkDistributorBoss{
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"login" object:nil userInfo:dict];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:CheckDistributorBossApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            if ([responseObject[@"status"]isEqualToString:@"true"]) {
                [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:@"DistributorBoss"];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:@"false" forKey:@"DistributorBoss"];
            }
        }
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        if (self.pop) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadShoppingCart" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        if (self.pop) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark 第三方登录事件
- (void)facebookClick {
    NSLog(@"Facebook登录");
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Facebook currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
         [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        NSLog(@" originalResponse: %@", resp);
        if (!error) {
            
            [self facebookLoginApi:resp.originalResponse[@"id"]];
        }
    }];
}
- (void)appleIdLoginApi:(NSString *)apple_id{
    

    self.appleID = apple_id;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Change the background view style and color.
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        hud.label.text =  NSLocalizedString(@"GlobalBuyer_LoginView_logining", nil);
        
    
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

        NSDictionary *params = [NSDictionary new];
        if (self.verificationCodeTX.text && self.phoneNumberTX.text && self.phoneRegionLb.text) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
                params = @{@"api_id":API_ID,
                           @"api_token":TOKEN,
                           @"appleid":apple_id,
                           @"check":self.verificationCodeTX.text,
                           @"prefix":self.phoneRegionLb.text,
                           @"phone":self.phoneNumberTX.text,
                           @"inviteCode":self.inviteCodeID,
                           @"password":[self randomPassword],
                           @"locale":language,
                           @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]
                           ,@"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
            }else{
                params = @{@"api_id":API_ID,
                           @"api_token":TOKEN,
                           @"appleid":apple_id,
                           @"check":self.verificationCodeTX.text,
                           @"prefix":self.phoneRegionLb.text,
                           @"phone":self.phoneNumberTX.text,
                           @"inviteCode":self.inviteCodeID,
                           @"password":[self randomPassword],
                           @"locale":language,
                           @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
            }

        }else{
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
                params = @{@"api_id":API_ID,
                           @"api_token":TOKEN,
                           @"appleid":apple_id,
                           @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                           @"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
            }else{
                params = @{@"api_id":API_ID,
                           @"api_token":TOKEN,
                            @"appleid":apple_id,
                           @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
            }

        }
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
        NSNotification *notification =[NSNotification notificationWithName:@"login" object:nil userInfo:dict];
        
        [manager POST:AppleIdLoginApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"] isEqualToString:@"error"]) {
                [hud hideAnimated:YES];
                
                if ([responseObject[@"type"]isEqualToString:@"registerFail"]) {
                    
                    [self.view addSubview:self.bindPhoneNumberBackV];
                    [self.view addSubview:self.pickerViewBackV];
                }
                
                if ([responseObject[@"type"]isEqualToString:@"hasEmail"]) {
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    // Set the text mode to show only text.
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail",nil);
                    // Move to bottm center.
                    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                    
                    [hud hideAnimated:YES afterDelay:3.f];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_hasEmail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                    [alert show];
                }
                
                if ([responseObject[@"type"] isEqualToString:@"verifyFail"]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputTureEmail", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                    [alert show];
                }
                
                
                if ([responseObject[@"type"] isEqualToString:@"inviteCodeFail"]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inviteCodeFail", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                    [alert show];
                }
            }
            if ([responseObject[@"code"]isEqualToString:@"success"]) {
                
                [self saveEmailLoginInfo:responseObject];
                
                [hud hideAnimated:YES];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [hud hideAnimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"登录失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            NSLog(@"%@",error);
        }];
    
    
}

-(void)facebookLoginApi:(NSString *)fbid{
    self.fbidID = fbid;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_LoginView_logining", nil);
    
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
    
    NSDictionary *params = [NSDictionary new];
    if (self.verificationCodeTX.text && self.phoneNumberTX.text && self.phoneRegionLb.text) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"fbid":fbid,
                       @"check":self.verificationCodeTX.text,
                       @"prefix":self.phoneRegionLb.text,
                       @"phone":self.phoneNumberTX.text,
                       @"inviteCode":self.inviteCodeID,
                       @"password":[self randomPassword],
                       @"locale":language,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                       @"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
        }else{
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"fbid":fbid,
                       @"check":self.verificationCodeTX.text,
                       @"prefix":self.phoneRegionLb.text,
                       @"phone":self.phoneNumberTX.text,
                       @"inviteCode":self.inviteCodeID,
                       @"password":[self randomPassword],
                       @"locale":language,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
        }

    }else{
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"fbid":fbid,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                       @"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
        }else{
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"fbid":fbid,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
        }
        
 

    }
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"login" object:nil userInfo:dict];
    
    [manager POST:FCLoginApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"error"]) {
            [hud hideAnimated:YES];
            
            
            
            if ([responseObject[@"type"]isEqualToString:@"registerFail"]) {
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Bindmailbox", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                //                alert.tag = 111;
                //                [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                //                UITextField *txtName = [alert textFieldAtIndex:0];
                //                txtName.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_Inputmailbox", nil);
                //                UITextField *txtInviteCode = [alert textFieldAtIndex:1];
                //                txtInviteCode.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil);
                //                [alert show];
                
                [self.view addSubview:self.bindPhoneNumberBackV];
                [self.view addSubview:self.pickerViewBackV];
            }
            
            if ([responseObject[@"type"]isEqualToString:@"hasEmail"]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                // Set the text mode to show only text.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail",nil);
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                
                [hud hideAnimated:YES afterDelay:3.f];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_hasEmail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                [alert show];
            }
            
            if ([responseObject[@"type"] isEqualToString:@"verifyFail"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputTureEmail", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                [alert show];
            }
            
            if ([responseObject[@"type"] isEqualToString:@"inviteCodeFail"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inviteCodeFail", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                [alert show];
            }
            
        }
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self saveEmailLoginInfo:responseObject];
            
            [hud hideAnimated:YES];
            
            
            //            //通过通知中心发送通知
            //            [[NSNotificationCenter defaultCenter] postNotification:notification];
            //
            //            if (self.pop) {
            //                [self dismissViewControllerAnimated:YES completion:nil];
            //            }else{
            //                [self.navigationController popViewControllerAnimated:YES];
            //            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"登录失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@",error);
        
    }];

}
- (void)weChatClick {
    NSLog(@"微信登录");
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession  currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (error) {
            
        }else{
            if (resp.originalResponse[@"errcode"]) {
                NSLog(@"无效的openid");
                [self weChatClick];
            }else{
                [self weChatLoginApi:resp.originalResponse[@"unionid"] headerImg:resp.originalResponse[@"headimgurl"]];
            }
        }
    }];
}

- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_LoginView_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_PromptMessage", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)weChatLoginApi:(NSString *)openid headerImg:(NSString *)headerImg{
    self.uniID = openid;
    self.headImgUrl = headerImg;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_LoginView_logining", nil);
    
    
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

    NSDictionary *params = [NSDictionary new];
    if (self.verificationCodeTX.text && self.phoneNumberTX.text && self.phoneRegionLb.text) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"unionid":openid,
                       @"check":self.verificationCodeTX.text,
                       @"prefix":self.phoneRegionLb.text,
                       @"phone":self.phoneNumberTX.text,
                       @"inviteCode":self.inviteCodeID,
                       @"password":[self randomPassword],
                       @"weixinAvatar":headerImg,
                       @"locale":language,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]
                       ,@"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
        }else{
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"unionid":openid,
                       @"check":self.verificationCodeTX.text,
                       @"prefix":self.phoneRegionLb.text,
                       @"phone":self.phoneNumberTX.text,
                       @"inviteCode":self.inviteCodeID,
                       @"password":[self randomPassword],
                       @"weixinAvatar":headerImg,
                       @"locale":language,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
        }

    }else{
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"unionid":openid,
                       @"weixinAvatar":headerImg,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"],
                       @"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]};
        }else{
            params = @{@"api_id":API_ID,
                       @"api_token":TOKEN,
                       @"unionid":openid,
                       @"weixinAvatar":headerImg,
                       @"currency":[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]};
        }

    }
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@YES,@"state", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"login" object:nil userInfo:dict];
    
    [manager POST:WXLoginApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"error"]) {
            [hud hideAnimated:YES];

            
            
            if ([responseObject[@"type"]isEqualToString:@"registerFail"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Bindmailbox", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
//                alert.tag = 111;
//                [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
//                UITextField *txtName = [alert textFieldAtIndex:0];
//                txtName.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_Inputmailbox", nil);
//                UITextField *txtInviteCode = [alert textFieldAtIndex:1];
//                txtInviteCode.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil);
//                [alert show];
                
                [self.view addSubview:self.bindPhoneNumberBackV];
                [self.view addSubview:self.pickerViewBackV];
            }
            
            if ([responseObject[@"type"]isEqualToString:@"hasEmail"]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                // Set the text mode to show only text.
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail",nil);
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                
                [hud hideAnimated:YES afterDelay:3.f];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_hasEmail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                [alert show];
            }
            
            if ([responseObject[@"type"] isEqualToString:@"verifyFail"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputTureEmail", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                [alert show];
            }
            
            
            if ([responseObject[@"type"] isEqualToString:@"inviteCodeFail"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inviteCodeFail", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
                [alert show];
            }
        }
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            [self saveEmailLoginInfo:responseObject];
            
            [hud hideAnimated:YES];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:headerImg forKey:@"UserHeadImgUrl"];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//            if (self.pop) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }else{
//                [self.navigationController popViewControllerAnimated:YES];
//            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"登录失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@",error);
    }];
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1 && alertView.tag == 111) {
//        UITextField *txt = [alertView textFieldAtIndex:0];
//        NSLog(@"%@",txt.text);
//        self.emailID = txt.text;
//        
//        UITextField *inviteCodetxt = [alertView textFieldAtIndex:1];
//        if (inviteCodetxt.text) {
//            self.inviteCodeID = inviteCodetxt.text;
//        }else{
//            self.inviteCodeID = @"";
//        }
//
//        if (self.uniID != nil) {
//            [self weChatLoginApi:self.uniID headerImg:self.headImgUrl];
//        }else{
//            [self facebookLoginApi:self.fbidID];
//        }
//        
//    }
//    
//    //找回密码
//    if (buttonIndex == 1 && alertView.tag == 222) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_loginEmailBoxChangePassWord", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
//        [alert show];
//        [self passwordRetrieval];
//    }
//    
//    if (buttonIndex == 0 && alertView.tag == 222) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Bindmailbox", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
//        alert.tag = 111;
//        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
//        UITextField *txtName = [alert textFieldAtIndex:0];
//        txtName.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_Inputmailbox", nil);
//        UITextField *txtInviteCode = [alert textFieldAtIndex:1];
//        txtInviteCode.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil);
//        [alert show];
//    }
//    
//    if (alertView.tag == 333) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_RegisterView_Bindmailbox", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
//        alert.tag = 111;
//        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
//        UITextField *txtName = [alert textFieldAtIndex:0];
//        txtName.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_Inputmailbox", nil);
//        UITextField *txtInviteCode = [alert textFieldAtIndex:1];
//        txtInviteCode.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil);
//        [alert show];
//    }
//}

-(NSString *)randomPassword{
    //自动生成8位随机密码
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSLog(@"now:%.8f",random);
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    NSLog(@"randompassword:%@",randompassword);
    
    return randompassword;
}

- (void)passwordRetrieval
{
    NSDictionary *param = @{@"api_id":API_ID,
                            @"api_token":TOKEN,
                            @"email":self.emailID};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PasswordRetrievalApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"Success!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UIView *)bindPhoneNumberBackV
{
    if (_bindPhoneNumberBackV == nil) {
        _bindPhoneNumberBackV = [[UIView alloc]initWithFrame:self.view.bounds];
        _bindPhoneNumberBackV.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        int imageBgY = LL_iPhoneX?340:300;
        UIImageView *imageBg = [[UIImageView alloc]init];
        imageBg.frame = CGRectMake(15, kScreenH/2 - imageBgY, kScreenW-30, 400);
        imageBg.image = [UIImage imageNamed:@"紫色底"];
        [_bindPhoneNumberBackV addSubview:imageBg];
        
        UILabel *bindPhoneTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2-120, kScreenH/2 - imageBgY+12, 240, 20)];
        bindPhoneTitleLb.font = [UIFont boldSystemFontOfSize:20];
        bindPhoneTitleLb.textColor = [UIColor whiteColor];
        bindPhoneTitleLb.text = NSLocalizedString(@"GlobalBuyer_LoginView_BindPhoneNumber", nil);
        bindPhoneTitleLb.textAlignment = NSTextAlignmentCenter;
        [_bindPhoneNumberBackV addSubview:bindPhoneTitleLb];
        
        
        UIView *bindPhoneNumberV = [[UIView alloc]initWithFrame:CGRectMake(30, kScreenH/2 - imageBgY+40, kScreenW-60, 340)];
        bindPhoneNumberV.clipsToBounds = YES;
        bindPhoneNumberV.layer.cornerRadius = 5;
        bindPhoneNumberV.backgroundColor = [UIColor whiteColor];
        [_bindPhoneNumberBackV addSubview:bindPhoneNumberV];
        
        
        self.phoneRegionLb = [[UILabel alloc]initWithFrame:CGRectMake(13, 16, kScreenW-60-26, 44)];
        self.phoneRegionLb.layer.borderWidth = 0.6;
        self.phoneRegionLb.layer.borderColor = [UIColor blackColor].CGColor;
        self.phoneRegionLb.textAlignment = NSTextAlignmentCenter;
        NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
        NSLog(@"当前使用的语言：%@",currentLanguage);
        if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
            self.phoneRegionLb.text = @"中国 0086";
        }else if([currentLanguage isEqualToString:@"zh-Hant"]){
            self.phoneRegionLb.text = @"台灣 00886";
        }else if([currentLanguage isEqualToString:@"en"]){
            self.phoneRegionLb.text = @"中国 0086";
        }else if([currentLanguage isEqualToString:@"Japanese"]){
            self.phoneRegionLb.text = @"中国 0086";
        }else{
            self.phoneRegionLb.text = @"中国 0086";
        }
        
        self.phoneRegionLb.font = [UIFont systemFontOfSize:14];
        self.phoneRegionLb.userInteractionEnabled = YES;
        self.phoneRegionLb.clipsToBounds = YES;
        self.phoneRegionLb.layer.borderColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1].CGColor;
        self.phoneRegionLb.layer.cornerRadius = 22;
        [bindPhoneNumberV addSubview:self.phoneRegionLb];
        
        
        UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(13, self.phoneRegionLb.frame.origin.y+16+44, kScreenW-60-26, 44)];
        phoneView.layer.borderWidth = 0.6;
        phoneView.clipsToBounds = YES;
        phoneView.layer.borderColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1].CGColor;
        phoneView.layer.cornerRadius = 22;
        [bindPhoneNumberV addSubview:phoneView];
        
        UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手机"]];
        [phoneView addSubview:phoneImage];
        phoneImage.frame = CGRectMake(15, 22-12.5, 17, 25);
        
        UILabel *phoneLine = [[UILabel alloc]initWithFrame:CGRectMake(15+20+17, 22-7.5, 1, 15)];
        [phoneView addSubview:phoneLine];
        phoneLine.backgroundColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1];
        
        UITapGestureRecognizer *phoneRegionLbTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView)];
        phoneRegionLbTap.numberOfTapsRequired = 1;
        phoneRegionLbTap.numberOfTouchesRequired = 1;
        [self.phoneRegionLb addGestureRecognizer:phoneRegionLbTap];
        
        
        [phoneView addSubview:self.phoneNumberTX];
        
        UIView *verificationCodeView = [[UIView alloc]initWithFrame:CGRectMake(13, phoneView.frame.origin.y+16+44, kScreenW-60-26, 44)];
        verificationCodeView.layer.borderWidth = 0.6;
        verificationCodeView.clipsToBounds = YES;
        verificationCodeView.layer.borderColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1].CGColor;
        verificationCodeView.layer.cornerRadius = 22;
        [bindPhoneNumberV addSubview:verificationCodeView];
        
        UIImageView *verificationCodeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"suo"]];
        [verificationCodeView addSubview:verificationCodeImage];
        verificationCodeImage.frame = CGRectMake(15, 22-11, 17, 22);
        
        UILabel *verificationCodLine = [[UILabel alloc]initWithFrame:CGRectMake(15+20+17, 22-7.5, 1, 15)];
        [verificationCodeView addSubview:verificationCodLine];
        verificationCodLine.backgroundColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1];
        
        [verificationCodeView addSubview:self.verificationCodeTX];
        
        UILabel *verificationCodLine2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-60-32-30-61, 22-7.5, 1, 15)];
        [verificationCodeView addSubview:verificationCodLine2];
        verificationCodLine2.backgroundColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1];
        
        self.getVerificationCodebtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-60-32-30-51, 22-15,70 , 30)];
        [self.getVerificationCodebtn setTitleColor:[UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1] forState:UIControlStateNormal];
        [self.getVerificationCodebtn setTitle:NSLocalizedString(@"GlobalBuyer_LoginView_GetVerificationCode", nil) forState:UIControlStateNormal];
        self.getVerificationCodebtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [verificationCodeView addSubview:self.getVerificationCodebtn];
        
        [self.getVerificationCodebtn addTarget:self action:@selector(getVerificationCodeClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *inviteCodeView = [[UIView alloc]initWithFrame:CGRectMake(13, verificationCodeView.frame.origin.y+16+44, kScreenW-60-26, 44)];
        inviteCodeView.layer.borderWidth = 0.6;
        inviteCodeView.clipsToBounds = YES;
        inviteCodeView.layer.borderColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1].CGColor;
        inviteCodeView.layer.cornerRadius = 22;
        [bindPhoneNumberV addSubview:inviteCodeView];
        
        UIImageView *inviteCodeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"邀请"]];
        [inviteCodeView addSubview:inviteCodeImage];
        inviteCodeImage.frame = CGRectMake(15, 22-11, 20, 22);
            
        UILabel *inviteCodeLine = [[UILabel alloc]initWithFrame:CGRectMake(15+20+17, 22-7.5, 1, 15)];
        [inviteCodeView addSubview:inviteCodeLine];
        inviteCodeLine.backgroundColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1];
        
        
        [inviteCodeView addSubview:self.inviteCodeTX];
        
        //181,70,200
        UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, inviteCodeView.frame.origin.y+30+44, kScreenW-60-26, 44)];
        submitBtn.backgroundColor = [UIColor colorWithRed:181.0f/255.0f green:70.0f/255.0f blue:200.0f/255.0f alpha:1];;
        submitBtn.layer.cornerRadius = 22;
        [submitBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Submit", nil) forState:UIControlStateNormal];
        [bindPhoneNumberV addSubview:submitBtn];
        [submitBtn addTarget:self action:@selector(submitPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bindPhoneNumberBackV;
}

- (void)submitPhoneNumber
{
    
    if ([self.phoneNumberTX.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_InputPhoneNumber", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }else{

    }
    
    if ([self.verificationCodeTX.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_InputVerificationCode", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }else{

    }
    
    if (self.inviteCodeTX.text) {
        self.inviteCodeID = self.inviteCodeTX.text;
    }else{
        self.inviteCodeID = @"";
    }
    
    
    if (self.uniID != nil) {
        [self weChatLoginApi:self.uniID headerImg:self.headImgUrl];
    }else if (self.appleID != nil) {
        [self appleIdLoginApi:self.appleID];
    }else{
        [self facebookLoginApi:self.fbidID];
    }
}

- (void)getVerificationCodeClick
{
    if (self.getVerificationCodebtn.selected == YES) {
        return;
    }
    
    if ([self.phoneNumberTX.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_InputPhoneNumber", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        
    }
    
    self.countDownNum = 60;
    self.getVerificationCodebtn.selected = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDownSixty) userInfo:nil repeats:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = [NSDictionary new];
    
    if (self.phoneNumberTX.text) {
        params = @{@"api_id":API_ID,
                   @"api_token":TOKEN,
                   @"prefix":self.phoneRegionLb.text,
                   @"phone":self.phoneNumberTX.text};
    }else{
        return;
    }

    
    [manager POST:VerificationCodeApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_RepeatedAcquisition", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)CountDownSixty
{
    [self.getVerificationCodebtn setTitle:[NSString stringWithFormat:@"%ds",self.countDownNum] forState:UIControlStateSelected];
    
    if (self.countDownNum <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.getVerificationCodebtn.selected = NO;
    }
    
    self.countDownNum--;
}

- (UITextField *)phoneNumberTX
{
    if (_phoneNumberTX == nil) {
        _phoneNumberTX = [[UITextField alloc]initWithFrame:CGRectMake(15+10+17+31, 22-15, 200, 30)];
        _phoneNumberTX.placeholder = NSLocalizedString(@"GlobalBuyer_LoginView_InputPhoneNumber", nil);
        _phoneNumberTX.keyboardType = UIKeyboardTypeNamePhonePad;
        _phoneNumberTX.returnKeyType = UIReturnKeyDone;
        _phoneNumberTX.delegate = self;
    }
    return _phoneNumberTX;
}

- (UITextField *)verificationCodeTX
{
    if (_verificationCodeTX == nil) {
        _verificationCodeTX = [[UITextField alloc]initWithFrame:CGRectMake(15+10+17+31, 22-15, 120, 30)];
        _verificationCodeTX.placeholder = NSLocalizedString(@"GlobalBuyer_LoginView_InputVerificationCode", nil);
        _verificationCodeTX.keyboardType = UIKeyboardTypeNamePhonePad;
        _verificationCodeTX.returnKeyType = UIReturnKeyDone;
        _verificationCodeTX.delegate = self;
    }
    return _verificationCodeTX;
}

- (UITextField *)inviteCodeTX
{
    if (_inviteCodeTX == nil) {
        _inviteCodeTX = [[UITextField alloc]initWithFrame:CGRectMake(15+10+17+31, 22-15, 200, 30)];
        _inviteCodeTX.placeholder = NSLocalizedString(@"GlobalBuyer_RegisterView_InputInvitation", nil);
        _inviteCodeTX.keyboardType = UIKeyboardTypeNamePhonePad;
        _inviteCodeTX.returnKeyType = UIReturnKeyDone;
        _inviteCodeTX.delegate = self;
    }
    return _inviteCodeTX;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (NSMutableArray *)areaCodeDataSource
{
    if (_areaCodeDataSource == nil) {
        _areaCodeDataSource = [NSMutableArray new];
        NSArray *tmpArr = @[@"中国 0086",
                            @"台灣 00886",
                            @"香港 00852",
                            @"日本 0081",
                            @"한국 0082",
                            @"RepublikIndonesia 0062",
                            @"россия 007",
                            @"Britain 0044",
                            @"USA 001",
                            @"Australia 0061",
                            @"NewZealand 0064"];
        _areaCodeDataSource = [NSMutableArray arrayWithArray:tmpArr];
    }
    return _areaCodeDataSource;
}

- (UIView *)pickerViewBackV
{
    if (_pickerViewBackV == nil) {
        _pickerViewBackV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 230)];
        [_pickerViewBackV addSubview:self.pickerViewSureOrCancelV];
        [_pickerViewBackV addSubview:self.pickerView];
    }
    return _pickerViewBackV;
}

- (UIView *)pickerViewSureOrCancelV
{
    if (_pickerViewSureOrCancelV == nil) {
        _pickerViewSureOrCancelV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        _pickerViewSureOrCancelV.backgroundColor = Main_Color;
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelPick) forControlEvents:UIControlEventTouchUpInside];
        [_pickerViewSureOrCancelV addSubview:cancelBtn];
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 60, 0, 60, 30)];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(surePick) forControlEvents:UIControlEventTouchUpInside];
        [_pickerViewSureOrCancelV addSubview:sureBtn];
    }
    return _pickerViewSureOrCancelV;
}

//滚动选择视图
- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kScreenW, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.tag = 111;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (void)showPickView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH - 230, kScreenW, 230);
    }];
}

- (void)cancelPick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH , kScreenW, 230);
    }];
}

- (void)surePick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH , kScreenW, 230);
    }];
    
    self.phoneRegionLb.text = self.phoneRegionStr;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.areaCodeDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.areaCodeDataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.phoneRegionStr = self.areaCodeDataSource[row];
    
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
