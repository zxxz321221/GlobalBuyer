//
//  LoginRootViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/19.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "GreatLoginViewController.h"
#import "ImproveAccountInfoViewController.h"
#import "UserServiceAgreementViewController.h"

@interface GreatLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView *conview;
@property (nonatomic, strong)UIImageView *eMailImgView;
@property (nonatomic, strong)UITextField *eMailTextField;
@property (nonatomic, strong)UIImageView *passWordImgView;
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIButton *loginBtn;


@property (nonatomic, strong)UIButton *agreeBtn;    //服务条款按钮
@property (nonatomic, strong)UILabel *agreementLb;  //服务条款文字
@end

@implementation GreatLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_LoginView_login", nil);
    [self setupUI];
    
}



#pragma mark 创建UI界面
- (void)setupUI {
    
    [super setupUI];
    [self.scrollView addSubview:self.conview];
    [self.scrollView addSubview:self.eMailImgView];
    [self.scrollView addSubview:self.eMailTextField];
    [self.scrollView addSubview:self.passWordImgView];
    [self.scrollView addSubview:self.passWordTextField];
    [self.scrollView addSubview:self.line];
    [self.scrollView addSubview:self.loginBtn];

    [self.scrollView addSubview:self.agreeBtn];
    [self.scrollView addSubview:self.agreementLb];
    
    
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


- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.frame = CGRectMake(30, CGRectGetMaxY(self.conview.frame) + 20, CGRectGetWidth(self.conview.frame), 40);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:NSLocalizedString(@"GlobalBuyer_LoginView_login", nil) forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        
        _loginBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        
    }
    return _loginBtn;
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
        _eMailTextField.text = @"";
        _eMailTextField.frame = CGRectMake(CGRectGetMaxX(self.eMailImgView.frame) + 10, CGRectGetMinY(self.conview.frame) + 17,  CGRectGetWidth(self.conview.frame)  - CGRectGetMaxX(self.eMailImgView.frame) - 10, 30);
        _eMailTextField.placeholder = NSLocalizedString(@"GlobalBuyer_LoginView_inputAccount", nil);
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
        _passWordTextField.text = @"";
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

#pragma mark 收键盘 手势
- (void)tapGesture {
    [self.view endEditing:YES];
}



#pragma mark 提示框
- (void)showAlter:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark 登录事件
- (void)loginClick {
    NSLog(@"登录");
    [self.view endEditing:YES];
    if ([self.eMailTextField.text isEqualToString:@""]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_LoginView_AccountError", nil)];
        return;
    }
    if ([self.passWordTextField.text isEqualToString:@""]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_LoginView_PWError", nil)];
        return;
    }
    
    //未同意协议
    if (self.agreeBtn.selected == NO) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_RegisterView_Warningtips", nil)];
        return;
    }
    
    [self loginEmailApi];
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
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"],@"enterprise":@"22"};
    }else{
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"enterprise":@"22"};
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
            [hud hideAnimated:YES];
            
            [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setObject:@"22" forKey:@"enterprise"];
            
            
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
          
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
        
            
            NSString *userEmail = [[NSUserDefaults standardUserDefaults]objectForKey:@"USEREMAIL"];
            
            if (userEmail==nil||userEmail.length == 0) {
                ImproveAccountInfoViewController *vc = [[ImproveAccountInfoViewController alloc]init];
                vc.isLogin = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINVIEWCONTROLLERBACK" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }

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



- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_LoginView_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_PromptMessage", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
