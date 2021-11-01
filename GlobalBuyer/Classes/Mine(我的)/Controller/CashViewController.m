//
//  CashViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/26.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "CashViewController.h"
#import "CashDetailViewController.h"
#import "alertView.h"
@interface CashViewController ()<UITextFieldDelegate,alertViewDelegate>
{
    UIView  * KeyView;
    UIView * passWordView;
    NSString *password;
    NSMutableArray * textMuArray;
    BOOL isPass;
}
@property (nonatomic,strong) UIView * backV;
@property (nonatomic,strong) UILabel * symbol;//货币符号
@property (nonatomic,strong) UITextField * textField;//提现金额输入框
@property (nonatomic,strong) NSArray * keyList;
@property (nonatomic,strong) UIView * maskView;

@property (nonatomic,strong) alertView *altView;
@property(nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic , strong) UIView * PromptMaskView;
@property (nonatomic , strong) UIView * PromptView;
@property (nonatomic , strong) UILabel * prompL;
@end

@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.altView.delegate=self;
    password = @"";
    isPass=NO;
    NSLog(@"%f",[Unity countcoordinatesW:160]);
    self.view.backgroundColor = [UIColor py_colorWithHexString:@"#f0f0f0"];
    [self createUI];
    [self cashButton];
    [self createKeyboard];
    [self inputPassWord];
    [self PromptBox];
}
- (void)createUI{
    _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:150])];
    _backV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backV];
    [self.view bringSubviewToFront:_backV];
    
    UILabel * cashTitle = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashView_Withdrawal_amount", nil) _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[UIColor grayColor] _textAlignment:NSTextAlignmentLeft];
    
    CGFloat W = [Unity widthOfString:[Unity currencySymbol:self.currencyOfTheBalance] OfFontSize:30 OfHeight:[Unity countcoordinatesH:70]];
    _symbol = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(cashTitle.left, cashTitle.bottom, W, [Unity countcoordinatesH:70]) _string:[Unity currencySymbol:self.currencyOfTheBalance] _lableFont:[UIFont systemFontOfSize:30] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    
    _textField = [Unity textFieldAddSuperview_superView:_backV _subViewFrame:CGRectMake(_symbol.right, _symbol.top, kScreenW-W-[Unity countcoordinatesW:110], _symbol.height) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:nil];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.font = [UIFont systemFontOfSize:30];
    
    UIButton * allBtn = [Unity buttonAddsuperview_superView:_backV _subViewFrame:CGRectMake(_textField.right+[Unity countcoordinatesW:10], _textField.top+[Unity countcoordinatesH:25],[Unity countcoordinatesW:80] , [Unity countcoordinatesH:20]) _tag:self _action:@selector(allClick) _string:NSLocalizedString(@"GlobalBuyer_CashView_All_Withdrawal", nil) _imageName:@""];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [allBtn setTitleColor:[Unity getColor:@"#b444c8"] forState:UIControlStateNormal];
    
    UILabel * line = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(_symbol.left, _symbol.bottom, cashTitle.width, [Unity countcoordinatesH:1]) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentCenter];
    line.backgroundColor = [UIColor py_colorWithHexString:@"#f0f0f0"];
}
- (void)cashButton{
    UIButton * btn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _backV.bottom+[Unity countcoordinatesH:30], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]) _tag:self _action:@selector(cashClick) _string:NSLocalizedString(@"GlobalBuyer_CashView_Withdrawal", nil) _imageName:nil];
    btn.layer.cornerRadius = 25;
    [btn setTitleColor:[UIColor py_colorWithHexString:@"#b444c8"] forState:UIControlStateNormal];
    [btn.layer setBorderColor:[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
    [btn.layer setBorderWidth:1.0];
}

- (void)allClick{
    _textField.text = self.balance;
}
- (void)cashClick{
    if ([_textField.text intValue]>[self.balance intValue]) {
        [self cashFailureMessage:@"余额不足" Place:[NSString stringWithFormat:@"%.2f",[self.textField.text floatValue]]];
        [self.altView showAlertView];
        return;
    }
    if ([_textField.text isEqualToString:@""]) {
        return;
    }
    [self showKeyboard];
    [self showPass];
//    CashDetailViewController * CVC = [[CashDetailViewController alloc]init];
//    [self.navigationController pushViewController:CVC animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.title = NSLocalizedString(@"GlobalBuyer_CashView_Withdrawal", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction:)];
    self.navigationItem.leftBarButtonItem = itemleft;

}
- (void)popAction:(UIBarButtonItem *)barButtonItem
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"uitextfield=%@, string= %@",textField.text,string);
    /*
     NSLog(@"内容:%@",textField.text);//获取的是上一次所输入内容
     NSLog(@"Location:%lu Length:%lu",range.location,range.length);//范围为当前文字的位置，长度为零
     NSLog(@"==%@==",string);//实时获取当前输入的字符
     */
    
    //需求 实时获取当前文本框中的所有文字
    NSString * resultStr = [textField.text stringByAppendingString:string];
    NSLog(@"%@",resultStr);
    //可在该方法中判断所输入文字是否正确
    return YES;
    
}
- (void)didEnterPWD:(NSString *)pwd withType:(NSString *)type
{
    if ([type isEqualToString:@"enter"]) {
        NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
        NSDictionary *params = @{@"api_id":API_ID,
                                 @"api_token":TOKEN,
                                 @"secret_key":api_token,
                                 @"password":pwd,
                                 @"amount":[NSString stringWithFormat:@"%.2f",[self.textField.text floatValue]]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:PurseRefundApplicationApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject[@"code"]isEqualToString:@"success"]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = responseObject[@"message"];
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:1.f];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = responseObject[@"message"];
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:1.f];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"123123123123123123");
    [self showKeyboard];
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *)keyList{
    if (!_keyList) {
        _keyList = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"X",@"0",@"."];
    }
    return _keyList;
}
- (void)createKeyboard{
    NSArray * keylist = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"X",@"0",@"."];
    KeyView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, [Unity countcoordinatesH:200])];
    KeyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:KeyView];
    for (int i=0; i<keylist.count; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:KeyView _subViewFrame:CGRectMake((i%3)*(kScreenW/4), (i/3)*[Unity countcoordinatesH:50], kScreenW/4, [Unity countcoordinatesH:50]) _tag:self _action:@selector(keyBoardClick:) _string:@"" _imageName:@""];
        [btn setTitle:keylist[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:24];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 666+i;
    }
    NSArray * arr = @[@"key_cancel",@"confim_key"];
    for (int j=0; j<arr.count; j++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4*3, j*[Unity countcoordinatesH:100], kScreenW/4, [Unity countcoordinatesH:100])];
        [KeyView addSubview:btn];
        [btn addTarget:self action:@selector(keyBoardClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:arr[j]] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted = NO;
        btn.tag = 678+j;
    }
}
- (void)showKeyboard{
    [UIView animateWithDuration:0.5 animations:^{
        KeyView.frame = CGRectMake(0, kScreenH-[Unity countcoordinatesH:200]-64, kScreenW, [Unity countcoordinatesH:200]);
    }];
}
- (void)keyBoardClick:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (isPass) {
        if (btn.tag<675) {
            NSString * str = [NSString stringWithFormat:@"%ld",(long)btn.tag-665];
            [self passWordInput:str];
        }else if(btn.tag == 675){
            [self passWordInput:@""];
        }else if (btn.tag == 676){
            [self passWordInput:@"0"];
        }else if (btn.tag == 677){
            [self passWordInput:@"."];
        }else if (btn.tag == 678){
            [self passWordInput:@"-"];
        }
        
    }else{
        if (btn.tag<675) {
            NSString * str = [NSString stringWithFormat:@"%ld",btn.tag -665];
            _textField.text = [_textField.text stringByAppendingString:str];
        }else if(btn.tag == 675){
            _textField.text = @"";
        }else if (btn.tag == 676){
            NSString * str = [NSString stringWithFormat:@"%d",0];
            _textField.text = [_textField.text stringByAppendingString:str];
        }else if (btn.tag == 677){
            _textField.text = [_textField.text stringByAppendingString:@"."];
        }else if (btn.tag == 678){
            if (self.textField.text.length>0) {
                self.textField.text =[self.textField.text substringToIndex:self.textField.text.length-1];
            }
        }

    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!isPass) {
        [UIView animateWithDuration:0.5 animations:^{
            KeyView.frame = CGRectMake(0, kScreenH-64, kScreenW, [Unity countcoordinatesH:200]);
        }];
    }
}
- (void)inputPassWord{
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-[Unity countcoordinatesH:200])];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _maskView.hidden=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    
    passWordView = [[UIView alloc]initWithFrame:CGRectMake(0, _maskView.height-[Unity countcoordinatesH:150], kScreenW, [Unity countcoordinatesH:150])];
    passWordView.backgroundColor = [Unity getColor:@"#f5f5f5"];
    [_maskView addSubview:passWordView];
    
    UIButton * cancel = [Unity buttonAddsuperview_superView:passWordView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:12], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(cancelClick) _string:@"" _imageName:@"取消"];
    
    UILabel * tishi = [Unity lableViewAddsuperview_superView:passWordView _subViewFrame:CGRectMake(80, [Unity countcoordinatesH:10], kScreenW-160, [Unity countcoordinatesH:20]) _string:@"请输入密码" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    textMuArray = [NSMutableArray new];
    
    for (int i = 0; i < 6; i++)
    {
        UITextField * pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake(23+i*(kScreenW - 40)/6-(i+1), [Unity countcoordinatesH:40], (kScreenW - 40)/6, (kScreenW - 40)/6)];
        pwdLabel.layer.borderColor = [UIColor blackColor].CGColor;
        pwdLabel.enabled = NO;
        pwdLabel.backgroundColor = [UIColor whiteColor];
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.secureTextEntry = YES;//设置密码模式
        pwdLabel.layer.borderWidth = 1;
        [passWordView addSubview:pwdLabel];
        
        [textMuArray addObject:pwdLabel];
    }
    UIButton * forgotBtn = [Unity buttonAddsuperview_superView:passWordView _subViewFrame:CGRectMake((kScreenW-100)/2, [Unity countcoordinatesH:100], 100, [Unity countcoordinatesH:30]) _tag:self _action:@selector(forgotClick) _string:@"忘记密码?" _imageName:@""];
    forgotBtn.titleLabel.textColor = [Unity getColor:@"#b444c8"];
}
- (void)forgotClick{
    
}
- (void)cancelClick{
    [self hiddenPass];
    [self passWordInput:@""];
}
- (void)showPass{
    _maskView.hidden = NO;
    isPass = YES;
}
- (void)hiddenPass{
    _maskView.hidden = YES;
    isPass = NO;
}
- (void)passWordInput:(NSString *)num{
    if ([num isEqualToString:@""]) {
        password = @"";
        for (int i=0; i<6; i++) {
            UITextField *pwdtx = [textMuArray objectAtIndex:i];
            pwdtx.text = @"";
        }
        return;
    }else if ([num isEqualToString:@"-"]){
        if ([password isEqualToString:@""]) {
            return;
        }else{
            NSInteger len = password.length;
            UITextField *pwdtx = [textMuArray objectAtIndex:len-1];
            pwdtx.text = @"";
            password = [password substringToIndex:len-1];
        }
        NSLog(@"mima  %@",password);
    }else{
        password = [password stringByAppendingString:num];
    }

    for (int i = 0; i < textMuArray.count; i++)
    {
        UITextField *pwdtx = [textMuArray objectAtIndex:i];
        if (i < password.length)
        {
            NSString * pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }
    }
    
    if (password.length == 6)
    {
        [self cashPlace:self.textField.text Pwd:password];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入的密码是" message:password delegate:nil cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
//        [alert show];
    }
}
-(alertView *)altView{
    if (_altView == nil) {
        _altView = [alertView setAlertView:self.view];
    }
    return _altView;
}
- (void)alertBtnClick{
    [self.altView hiddenAlertView];
}
- (void)cashSuccessMessage:(NSString *)msg Place:(NSString *)place{
    _altView.titleL.text = @"提现申请成功";
    _altView.contentL.text = msg;
    _altView.placeL.text = place;
    _altView.imageView.image = [UIImage imageNamed:@"key_confim"];
    [_altView.btn setTitle:@"完 成" forState:UIControlStateNormal];
}
- (void)cashFailureMessage:(NSString *)msg Place:(NSString *)place{
    _altView.titleL.text = @"提现申请失败";
    _altView.contentL.text = msg;
    _altView.placeL.text = place;
    _altView.imageView.image = [UIImage imageNamed:@"失败"];
    [_altView.btn setTitle:@"返 回" forState:UIControlStateNormal];
}
- (void)cashPlace:(NSString *)place Pwd:(NSString *)pwd{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":api_token,
                             @"password":pwd,
                             @"amount":[NSString stringWithFormat:@"%.2f",[place floatValue]]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:PurseRefundApplicationApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            //提现请求时候  关闭密码框 键盘
            [UIView animateWithDuration:0.5 animations:^{
                KeyView.frame = CGRectMake(0, kScreenH-64, kScreenW, [Unity countcoordinatesH:200]);
            }];
            self.textField.text = @"";
            [self passWordInput:@""];
            [self hiddenPass];
            
            [self cashSuccessMessage:responseObject[@"message"] Place:[NSString stringWithFormat:@"%.2f",[self.textField.text floatValue]]];
            [self.altView showAlertView];
        }else{
            _prompL.text = responseObject[@"message"];
            _PromptMaskView.hidden=NO;
            _PromptView.hidden = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hideAnimated:YES];
    }];
}
- (void)PromptBox{
    _PromptMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _PromptMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _PromptMaskView.hidden=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_PromptMaskView];
    
    _PromptView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:20], [Unity countcoordinatesH:260], kScreenW-[Unity countcoordinatesW:40], [Unity countcoordinatesH:120])];
    _PromptView.layer.cornerRadius = 10;
    _PromptView.backgroundColor = [UIColor whiteColor];
    _PromptView.hidden = YES;
    [_PromptMaskView addSubview:_PromptView];
    
    _prompL = [Unity lableViewAddsuperview_superView:_PromptView _subViewFrame:CGRectMake([Unity countcoordinatesW:15], [Unity countcoordinatesH:20], _PromptView.width-[Unity countcoordinatesW:30], [Unity countcoordinatesH:20]) _string:@"" _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    
    UIButton * enterAgainBtn = [Unity buttonAddsuperview_superView:_PromptView _subViewFrame:CGRectMake(0, _prompL.bottom+[Unity countcoordinatesH:40], _PromptView.width/2, [Unity countcoordinatesH:20]) _tag:self _action:@selector(enterAgainClick) _string:@"重新输入" _imageName:@""];
    [enterAgainBtn setTitleColor:[Unity getColor:@"#b444c8"] forState:UIControlStateNormal];
    UIButton * forgotBtn = [Unity buttonAddsuperview_superView:_PromptView _subViewFrame:CGRectMake(enterAgainBtn.right, enterAgainBtn.top, enterAgainBtn.width, enterAgainBtn.height) _tag:self _action:@selector(forgotClick) _string:@"忘记密码?" _imageName:@""];
    [forgotBtn setTitleColor:[Unity getColor:@"#b444c8"] forState:UIControlStateNormal];
    
}
- (void)enterAgainClick{
    [self passWordInput:@""];
    _PromptMaskView.hidden = YES;
    _PromptView.hidden=YES;
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
