//
//  ChangePasswordViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *passwordAgainTF;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupUI {
    [self setNavigationBackBtn];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_UserInfo_changePW", nil);
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.passwordAgainTF];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style: UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordTF.frame) + 1, kScreenW, 1)];
    v.backgroundColor = Cell_BgColor;
    [self.view addSubview:v];
}

- (UITextField *)passwordTF {
    if (_passwordTF == nil) {
        _passwordTF = [[UITextField alloc]init];
        _passwordTF.backgroundColor = [UIColor whiteColor];
        _passwordTF.frame = CGRectMake(0, 64, kScreenW, 30);
        _passwordTF.placeholder = NSLocalizedString(@"GlobalBuyer_UserInfo_PWGuide", nil);
        _passwordTF.delegate = self;
        _passwordTF.font = [UIFont systemFontOfSize:14];
    }
    return _passwordTF;
}
- (UITextField *)passwordAgainTF {
    if (_passwordAgainTF == nil) {
        _passwordAgainTF = [[UITextField alloc]init];
        _passwordAgainTF.frame = CGRectMake(0,CGRectGetMaxY(self.passwordTF.frame)+2, kScreenW, 30);
        _passwordAgainTF.placeholder = NSLocalizedString(@"GlobalBuyer_UserInfo_AgnPWGuide", nil);
        _passwordAgainTF.delegate = self;
        _passwordAgainTF.font = [UIFont systemFontOfSize:14];
    }
    return _passwordAgainTF;
}

-(void)saveClick{
    //请输入6 - 20密码
    if (!(self.passwordTF.text.length >= 6 && self.passwordTF.text.length <= 20) || ![self checkPassword:self.passwordTF.text]){
        [self showAlter:NSLocalizedString(@"GlobalBuyer_UserInfo_PWError", nil)];
        return;
    }
    
    //两次密码不对
    if (![self.passwordTF.text isEqualToString:self.passwordAgainTF.text]) {
        [self showAlter:NSLocalizedString(@"GlobalBuyer_UserInfo_PWdif", nil)];
        return;
    }
    
    [self.delegate password:self.passwordTF.text];
    [self.navigationController popViewControllerAnimated:YES];
}

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

- (void)showAlter:(NSString *)message {
    
    MSAlertController *alertController = [MSAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message: message preferredStyle:MSAlertControllerStyleAlert];
    MSAlertAction *action = [MSAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:MSAlertActionStyleCancel handler:^(MSAlertAction *action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
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
