//
//  ApplyExtensionViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/6/26.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#define HighLine 40
#define LineWidth 150
#define GapH 10

#import "ApplyExtensionViewController.h"
#import "JPhotoMagenage.h"

@interface ApplyExtensionViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIScrollView *backSV;

@property (nonatomic,strong)UILabel *nameLb;
@property (nonatomic,strong)UITextField *nameTF;

@property (nonatomic,strong)UILabel *sexLb;
@property (nonatomic,strong)UILabel *sex_nanLb;
@property (nonatomic,strong)UIButton *sex_nanBtn;
@property (nonatomic,strong)UILabel *sex_nvLb;
@property (nonatomic,strong)UIButton *sex_nvBtn;

@property (nonatomic,strong)UILabel *birthdayLb;
@property (nonatomic,strong)UITextField *birthdayTf;

@property (nonatomic,strong)UILabel *idNumberLb;
@property (nonatomic,strong)UITextField *idNumberTf;

@property (nonatomic,strong)UILabel *idCardFLb;
@property (nonatomic,strong)UILabel *idCardBLb;
@property (nonatomic,strong)UIImageView *idCardFV;
@property (nonatomic,strong)UIImageView *idCardBV;

@property (nonatomic,strong)NSMutableArray *areaCodeDataSource;
@property (nonatomic,strong)UIView *pickerViewBackV;
@property (nonatomic,strong)UIView *pickerViewSureOrCancelV;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSString *phoneRegionStr;
@property (nonatomic,strong)UILabel *mobilePhoneLb;
@property (nonatomic,strong)UILabel *areaCodeLb;
@property (nonatomic,strong)UITextField *mobilePhoneTf;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int countDownNum;

@property (nonatomic,strong)UILabel *verificationCodeLb;
@property (nonatomic,strong)UIButton *getVerificationCodeBtn;
@property (nonatomic,strong)UITextField *verificationCodeTf;

@property (nonatomic,strong)UILabel *emailLb;
@property (nonatomic,strong)UITextField *emailTf;

@property (nonatomic,strong)UILabel *bankIdLb;
@property (nonatomic,strong)UITextField *bankIdTf;


@property (nonatomic,strong)UIButton *applyBtn;

@property (nonatomic) CGPoint inputPoint0;//底部背景渐变颜色参数
@property (nonatomic) CGPoint inputPoint1;
@property (nonatomic) UIColor *inputColor0;
@property (nonatomic) UIColor *inputColor1;

@end

@implementation ApplyExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"GlobalBuyer_My_NavRight", nil);
    [self.view addSubview:self.backSV];
    [self.view addSubview:self.applyBtn];
    [self.view addSubview:self.pickerViewBackV];
}

- (UIScrollView *)backSV
{
    if (_backSV == nil) {
        _backSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [_backSV addSubview:self.nameLb];
        [_backSV addSubview:self.nameTF];
        
        [_backSV addSubview:self.sexLb];
        [_backSV addSubview:self.sex_nvLb];
        [_backSV addSubview:self.sex_nvBtn];
        [_backSV addSubview:self.sex_nanLb];
        [_backSV addSubview:self.sex_nanBtn];
        
        [_backSV addSubview:self.birthdayLb];
        [_backSV addSubview:self.birthdayTf];
        
        [_backSV addSubview:self.idNumberLb];
        [_backSV addSubview:self.idNumberTf];
        
        [_backSV addSubview:self.idCardFLb];
        [_backSV addSubview:self.idCardBLb];
        [_backSV addSubview:self.idCardFV];
        [_backSV addSubview:self.idCardBV];
        
        [_backSV addSubview:self.mobilePhoneLb];
        [_backSV addSubview:self.areaCodeLb];
        [_backSV addSubview:self.mobilePhoneTf];
        
        [_backSV addSubview:self.verificationCodeLb];
        [_backSV addSubview:self.getVerificationCodeBtn];
        [_backSV addSubview:self.verificationCodeTf];
        
        [_backSV addSubview:self.emailLb];
        [_backSV addSubview:self.emailTf];
        
        [_backSV addSubview:self.bankIdLb];
        [_backSV addSubview:self.bankIdTf];
        
        
        _backSV.contentSize = CGSizeMake(0, 680);
    }
    return _backSV;
}

- (UILabel *)nameLb
{
    if (_nameLb == nil) {
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, LineWidth, HighLine)];
        _nameLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_name", nil);
    }
    return _nameLb;
}

- (UITextField *)nameTF
{
    if (_nameTF == nil) {
        _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, GapH, LineWidth, HighLine)];
        _nameTF.textAlignment = NSTextAlignmentRight;
        _nameTF.layer.borderWidth = 0.7;
        _nameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _nameTF;
}

- (UILabel *)sexLb
{
    if (_sexLb == nil) {
        _sexLb = [[UILabel alloc]initWithFrame:CGRectMake(10, GapH + HighLine + GapH, LineWidth, HighLine)];
        _sexLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_Gender", nil);
    }
    return _sexLb;
}

- (UILabel *)sex_nvLb
{
    if (_sex_nvLb == nil) {
        _sex_nvLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 10 - HighLine, self.nameTF.frame.size.height + self.nameTF.frame.origin.y + GapH, HighLine, HighLine)];
        _sex_nvLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_nv", nil);
        _sex_nvLb.font = [UIFont systemFontOfSize:20];
        _sex_nvLb.textAlignment = NSTextAlignmentCenter;
    }
    return _sex_nvLb;
}

- (UIButton *)sex_nvBtn
{
    if (_sex_nvBtn == nil) {
        _sex_nvBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 10 - HighLine - 26, self.nameTF.frame.size.height + self.nameTF.frame.origin.y + GapH + 7, 26, 26)];
        [_sex_nvBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_sex_nvBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_sex_nvBtn addTarget:self action:@selector(sexNvClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sex_nvBtn;
}

- (void)sexNvClick
{
    self.sex_nvBtn.selected = YES;
    self.sex_nanBtn.selected = NO;
}

- (UILabel *)sex_nanLb
{
    if (_sex_nanLb == nil) {
        _sex_nanLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 10 - HighLine - 26 - HighLine, self.nameTF.frame.size.height + self.nameTF.frame.origin.y + GapH, HighLine, HighLine)];
        _sex_nanLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_nan", nil);
        _sex_nanLb.font = [UIFont systemFontOfSize:20];
        _sex_nanLb.textAlignment = NSTextAlignmentCenter;
    }
    return _sex_nanLb;
}

- (UIButton *)sex_nanBtn
{
    if (_sex_nanBtn == nil) {
        _sex_nanBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 10 - HighLine - 26 - HighLine - 26, self.nameTF.frame.size.height + self.nameTF.frame.origin.y + GapH + 7, 26, 26)];
        [_sex_nanBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_sex_nanBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_sex_nanBtn addTarget:self action:@selector(sexNanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sex_nanBtn;
}

- (void)sexNanClick
{
    self.sex_nvBtn.selected = NO;
    self.sex_nanBtn.selected = YES;
}

- (UILabel *)birthdayLb
{
    if (_birthdayLb == nil) {
        _birthdayLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.sexLb.frame.size.height + self.sexLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _birthdayLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_Birthday", nil);
    }
    return _birthdayLb;
}

- (UITextField *)birthdayTf
{
    if (_birthdayTf == nil) {
        _birthdayTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, self.sexLb.frame.size.height + self.sexLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _birthdayTf.placeholder = @"1990/01/01";
        _birthdayTf.textAlignment = NSTextAlignmentRight;
        _birthdayTf.layer.borderWidth = 0.7;
        _birthdayTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _birthdayTf;
}

- (UILabel *)idNumberLb
{
    if (_idNumberLb == nil) {
        _idNumberLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.birthdayLb.frame.size.height + self.birthdayLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _idNumberLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_ID", nil);
    }
    return _idNumberLb;
}

- (UITextField *)idNumberTf
{
    if (_idNumberTf == nil) {
        _idNumberTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, self.birthdayLb.frame.size.height + self.birthdayLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _idNumberTf.textAlignment = NSTextAlignmentRight;
        _idNumberTf.layer.borderWidth = 0.7;
        _idNumberTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _idNumberTf;
}

- (UILabel *)idCardFLb
{
    if (_idCardFLb == nil) {
        _idCardFLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.idNumberLb.frame.size.height + self.idNumberLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _idCardFLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_ID_F", nil);
    }
    return _idCardFLb;
}

- (UILabel *)idCardBLb
{
    if (_idCardBLb == nil) {
        _idCardBLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2+10, self.idNumberLb.frame.size.height + self.idNumberLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _idCardBLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_ID_B", nil);
    }
    return _idCardBLb;
}

- (UIImageView *)idCardFV
{
    if (_idCardFV == nil) {
        _idCardFV = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.idCardFLb.frame.size.height + self.idCardFLb.frame.origin.y + GapH, kScreenW/2 - 20, kScreenW/2/1.7)];
        _idCardFV.image = [UIImage imageNamed:@"正面"];
        _idCardFV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(idCardFClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_idCardFV addGestureRecognizer:tap];
    }
    return _idCardFV;
}

- (void)idCardFClick
{
    [JPhotoMagenage getOneImageInController:self finish:^(UIImage *images) {
        NSLog(@"%@",images);
        
        self.idCardFV.image = images;

    } cancel:^{
        
    }];

}

- (UIImageView *)idCardBV
{
    if (_idCardBV == nil) {
        _idCardBV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 + 10, self.idCardBLb.frame.size.height + self.idCardBLb.frame.origin.y + GapH, kScreenW/2 - 20, kScreenW/2/1.7)];
        _idCardBV.image = [UIImage imageNamed:@"背面"];
        _idCardBV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(idCardBClick)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_idCardBV addGestureRecognizer:tap];
    }
    return _idCardBV;
}

- (void)idCardBClick
{
    [JPhotoMagenage getOneImageInController:self finish:^(UIImage *images) {
        NSLog(@"%@",images);
        
        self.idCardBV.image = images;
        
    } cancel:^{
        
    }];
}

- (UILabel *)mobilePhoneLb
{
    if (_mobilePhoneLb == nil) {
        _mobilePhoneLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.idCardFV.frame.size.height + self.idCardFV.frame.origin.y + GapH, LineWidth, HighLine)];
        _mobilePhoneLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_phone", nil);
    }
    return _mobilePhoneLb;
}

- (UILabel *)areaCodeLb
{
    if (_areaCodeLb == nil) {
        _areaCodeLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10 - 80, self.idCardFV.frame.size.height + self.idCardFV.frame.origin.y + GapH, 80, HighLine)];
        _areaCodeLb.layer.borderWidth = 0.7;
        _areaCodeLb.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _areaCodeLb.text = @"中国 0086";
        _areaCodeLb.textAlignment = NSTextAlignmentCenter;
        _areaCodeLb.font = [UIFont systemFontOfSize:12];
        _areaCodeLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_areaCodeLb addGestureRecognizer:tap];
    }
    return _areaCodeLb;
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
    
    self.areaCodeLb.text = self.phoneRegionStr;
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


- (UITextField *)mobilePhoneTf
{
    if (_mobilePhoneTf == nil) {
        _mobilePhoneTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, self.idCardFV.frame.size.height + self.idCardFV.frame.origin.y + GapH, LineWidth, HighLine)];
        _mobilePhoneTf.textAlignment = NSTextAlignmentRight;
        _mobilePhoneTf.layer.borderWidth = 0.7;
        _mobilePhoneTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _mobilePhoneTf;
}

- (UILabel *)verificationCodeLb
{
    if (_verificationCodeLb == nil) {
        _verificationCodeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.mobilePhoneLb.frame.size.height + self.mobilePhoneLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _verificationCodeLb.text = NSLocalizedString(@"GlobalBuyer_LoginView_VerificationCode", nil);
    }
    return _verificationCodeLb;
}

- (UIButton *)getVerificationCodeBtn
{
    if (_getVerificationCodeBtn == nil) {
        _getVerificationCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10 - 80, self.mobilePhoneLb.frame.size.height + self.mobilePhoneLb.frame.origin.y + GapH, 80, HighLine)];
        _getVerificationCodeBtn.backgroundColor = Main_Color;
        _getVerificationCodeBtn.layer.borderWidth = 0.7;
        _getVerificationCodeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_getVerificationCodeBtn setTitle:NSLocalizedString(@"GlobalBuyer_LoginView_GetVerificationCode", nil) forState:UIControlStateNormal];
        [_getVerificationCodeBtn addTarget:self action:@selector(getVerificationCodeClick) forControlEvents:UIControlEventTouchUpInside];
        _getVerificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _getVerificationCodeBtn;
}

- (void)getVerificationCodeClick
{
    if ([self.mobilePhoneTf.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_LoginView_InputPhoneNumber", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.countDownNum = 60;
    self.getVerificationCodeBtn.selected = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountDownSixty) userInfo:nil repeats:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = [NSDictionary new];
    
    if (self.mobilePhoneTf.text) {
        params = @{@"api_id":API_ID,
                   @"api_token":TOKEN,
                   @"prefix":self.areaCodeLb.text,
                   @"phone":self.mobilePhoneTf.text,
                   @"sign":@"personal_spreader_register"};
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
    
    [self.getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%ds",self.countDownNum] forState:UIControlStateSelected];
    
    if (self.countDownNum <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.getVerificationCodeBtn.selected = NO;
    }
    
    self.countDownNum--;
}

- (UITextField *)verificationCodeTf
{
    if (_verificationCodeTf == nil) {
        _verificationCodeTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, self.mobilePhoneLb.frame.size.height + self.mobilePhoneLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _verificationCodeTf.textAlignment = NSTextAlignmentRight;
        _verificationCodeTf.layer.borderWidth = 0.7;
        _verificationCodeTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _verificationCodeTf;
}

- (UILabel *)emailLb
{
    if (_emailLb == nil) {
        _emailLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.verificationCodeLb.frame.size.height + self.verificationCodeLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _emailLb.text = @"Email";
    }
    return _emailLb;
}

- (UITextField *)emailTf
{
    if (_emailTf == nil) {
        _emailTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, self.verificationCodeLb.frame.size.height + self.verificationCodeLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _emailTf.textAlignment = NSTextAlignmentRight;
        _emailTf.layer.borderWidth = 0.7;
        _emailTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _emailTf;
}

- (UILabel *)bankIdLb
{
    if (_bankIdLb == nil) {
        _bankIdLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.emailLb.frame.size.height + self.emailLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _bankIdLb.text = NSLocalizedString(@"GlobalBuyer_UserInfo_BankId", nil);
    }
    return _bankIdLb;
}

- (UITextField *)bankIdTf
{
    if (_bankIdTf == nil) {
        _bankIdTf = [[UITextField alloc]initWithFrame:CGRectMake(kScreenW - LineWidth - 10, self.emailLb.frame.size.height + self.emailLb.frame.origin.y + GapH, LineWidth, HighLine)];
        _bankIdTf.textAlignment = NSTextAlignmentRight;
        _bankIdTf.layer.borderWidth = 0.7;
        _bankIdTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _bankIdTf;
}

- (UIButton *)applyBtn
{
    if (_applyBtn == nil) {
        _applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
        [_applyBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Submit", nil) forState:UIControlStateNormal];
        self.inputColor0 = [UIColor colorWithRed:202.0/255.0 green:24.0/255.0 blue:254.0/255.0 alpha:1];
        self.inputColor1 = [UIColor colorWithRed:246.0/255.0 green:18.0/255.0 blue:240.0/255.0 alpha:1];
        self.inputPoint0 = CGPointMake(0, 1);
        self.inputPoint1 = CGPointMake(1, 1);
        CAGradientLayer *layer1 = [CAGradientLayer new];
        layer1.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
        layer1.startPoint = _inputPoint0;
        layer1.endPoint = _inputPoint1;
        layer1.frame = _applyBtn.bounds;
        [_applyBtn.layer addSublayer:layer1];
        [_applyBtn addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (void)applyClick
{
    if (self.sex_nanBtn.selected == NO &&
        self.sex_nvBtn.selected == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_UserInfo_DataError", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.nameTF.text isEqualToString:@""]||
        [self.birthdayTf.text isEqualToString:@""]||
        [self.idNumberTf.text isEqualToString:@""]||
        [self.mobilePhoneTf.text isEqualToString:@""]||
        [self.verificationCodeTf.text isEqualToString:@""]||
        [self.emailTf.text isEqualToString:@""]||
        [self.bankIdTf.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_UserInfo_DataError", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self upLoadData];
}

- (void)upLoadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = [NSDictionary new];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSString *sexNum;
    if (self.sex_nanBtn.selected == YES) {
        sexNum = @"1";
    }else{
        sexNum = @"2";
    }
    
    params = @{@"api_id":API_ID,
               @"api_token":TOKEN,
               @"secret_key":userToken,
               @"full_name":[NSString stringWithFormat:@"%@",self.nameTF.text],
               @"sex":[NSString stringWithFormat:@"%@",sexNum],
               @"birth":[NSString stringWithFormat:@"%@",self.birthdayTf.text],
               @"id_card":[NSString stringWithFormat:@"%@",self.idNumberTf.text],
               @"area_code":[NSString stringWithFormat:@"%@",self.areaCodeLb.text],
               @"telephone":[NSString stringWithFormat:@"%@",self.mobilePhoneTf.text],
               @"sms_code":[NSString stringWithFormat:@"%@",self.verificationCodeTf.text],
               @"email":[NSString stringWithFormat:@"%@",self.emailTf.text],
               @"bank_card_number":[NSString stringWithFormat:@"%@",self.bankIdTf.text]
               };
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"提交资料中", nil);
    

    NSData *data;
    if (1) {
        
        data = UIImageJPEGRepresentation(self.idCardFV.image, 0.1);
        NSLog(@"%lu",(unsigned long)data.length);
    } else {
        
        data = UIImagePNGRepresentation(self.idCardFV.image);
    }
    
    NSData *dataB;
    if (1) {
        
        dataB = UIImageJPEGRepresentation(self.idCardBV.image, 0.1);
        
    } else {
        
        dataB = UIImagePNGRepresentation(self.idCardBV.image);
    }
    
    [manager POST:PersonalDataSubmissionApi parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"id_card_image_f" fileName:@"idF.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:dataB name:@"id_card_image_b" fileName:@"idB.png" mimeType:@"image/png"];
        
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"申请成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"申请失败!", @"HUD message title");
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
