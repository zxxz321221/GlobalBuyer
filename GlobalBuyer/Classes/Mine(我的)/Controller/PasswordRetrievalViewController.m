//
//  PasswordRetrievalViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/26.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "PasswordRetrievalViewController.h"

@interface PasswordRetrievalViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView *conview;
@property (nonatomic, strong)UIImageView *eMailImgView;
@property (nonatomic, strong)UITextField *eMailTextField;
@property (nonatomic, strong)UIImageView *passWordImgView;
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UIImageView *passWordAgainImgView;
@property (nonatomic, strong)UITextField *passWordAgainTextField;
@property (nonatomic, strong)UIImageView *cooIv;
@property (nonatomic, strong)UITextField *cooTx;
@property (nonatomic, strong)UIButton *registerBtn;
@property (nonatomic, strong)UIView *line;
@property (nonatomic, strong)UIView *line1;
@property (nonatomic, strong)UIView *line2;
@property (nonatomic ,strong)UIButton *sureBtn;
@property (nonatomic, strong)UILabel *detailLa;

@end

@implementation PasswordRetrievalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_My_sePassWord", nil);
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 创建UI界面

- (void)setupUI {
    
    [super setupUI];
    //    [self getAdd];
    [self.scrollView addSubview:self.conview];
    [self.scrollView addSubview:self.eMailImgView];
    [self.scrollView addSubview:self.eMailTextField];
    [self.scrollView addSubview:self.registerBtn];
}


- (UIButton *)registerBtn {
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc]init];
        _registerBtn.frame = CGRectMake(30, CGRectGetMaxY(self.conview.frame) + 20, CGRectGetWidth(self.conview.frame), 40);
        
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_sePassWord", nil) forState:UIControlStateNormal];
        
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        //_registerBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.42 blue:0.12 alpha:1];
        _registerBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        
        //_registerBtn.layer.cornerRadius = 5;
        
    }
    return _registerBtn;
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
        
    }
    return _eMailTextField;
}


- (UIView *)conview {
    if (_conview == nil) {
        _conview = [[UIView alloc]init];
        //_conview.backgroundColor = [UIColor colorWithRed:0.53 green:0.76 blue:0.36 alpha:1];
        _conview.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _conview.frame = CGRectMake(30, CGRectGetMaxY(self.iconImgView.frame) + 30, kScreenW - 60, 64);
        //_conview.layer.cornerRadius = 5;
    }
    return _conview;
}


#pragma mark 注册事件
- (void)registerClick {
    
    [self.view endEditing:YES];
    //邮箱格式不对
    if (![self isEmailAddress:self.eMailTextField.text]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_LoginView_EmailError", nil)];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= [NSString stringWithFormat:@"%@...",NSLocalizedString(@"GlobalBuyer_My_sePassWord", nil)];
    
    
    NSDictionary *param = @{@"api_id":API_ID,
                            @"api_token":TOKEN,
                            @"email":self.eMailTextField.text};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PasswordRetrievalApi parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_loginEmailBoxChangePassWord", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
            [alert show];
        }
        
        if ([responseObject[@"code"]isEqualToString:@"error"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputTureEmail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 提示框
- (void)showAlter:(NSString *)message {
    
    MSAlertController *alertController = [MSAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: message preferredStyle:MSAlertControllerStyleAlert];
    MSAlertAction *action = [MSAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
    }];
    [alertController addAction:action];
    
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
