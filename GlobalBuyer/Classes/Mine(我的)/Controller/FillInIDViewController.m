//
//  FillInIDViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/14.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "FillInIDViewController.h"
#import "JPhotoMagenage.h"

@interface FillInIDViewController ()

@property (nonatomic,strong)UITextField *txf;
@property (nonatomic,strong)UIImageView *imvF;
@property (nonatomic,strong)UIImageView *imvB;
@property (nonatomic,strong)NSString *imageA;
@property (nonatomic,strong)NSString *imageB;

@property (nonatomic,strong)UIView *boIv;

@end

@implementation FillInIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_FillintheIDinfo", nil);
    self.navigationItem.titleView = titleLabel;
    
    self.txf = [[UITextField alloc]initWithFrame:CGRectMake(20, 20 + 64, kScreenW - 40, 40)];
    self.txf.placeholder = NSLocalizedString(@"GlobalBuyer_My_BindState_FillId", nil);
    self.txf.layer.borderWidth = 0.5;
    [self.txf becomeFirstResponder];
    [self.view addSubview:self.txf];
    
    
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        
        UILabel *idCardLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 20 + 64 + 40 + 5, kScreenW - 40, 20)];
        idCardLb.text = @"(非大陸居民可不上傳身份證圖片)";
        [self.view addSubview:idCardLb];
        
    }else if([currentLanguage isEqualToString:@"en"]){
    }else{
    }
    
    UIView *ivF = [[UIView alloc]initWithFrame:CGRectMake( kScreenW/2 - (kScreenW/2 - 25), 90 + 64 + 5, kScreenW/2 - 40,  kScreenW/2 - 80)];
    ivF.tag = 666;
    self.imvF = [[UIImageView alloc]initWithFrame:ivF.bounds];
//    self.imvF.image = [UIImage imageNamed:@"正面"];
    [self.imvF sd_setImageWithURL:[NSURL URLWithString:self.id_cardFUrl] placeholderImage:[UIImage imageNamed:@"正面"]];
    [ivF addSubview:self.imvF];
    ivF.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [ivF addGestureRecognizer:tap];
    [self.view addSubview:ivF];
    
    UIView *ivB = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 + 15, 90 + 64 + 5, kScreenW/2 - 40, kScreenW/2 - 80)];
    ivB.tag = 888;
    self.imvB = [[UIImageView alloc]initWithFrame:ivB.bounds];
//    self.imvB.image = [UIImage imageNamed:@"背面"];
    [self.imvB sd_setImageWithURL:[NSURL URLWithString:self.id_cardBUrl] placeholderImage:[UIImage imageNamed:@"背面"]];
    [ivB addSubview:self.imvB];
    ivB.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    tapB.numberOfTouchesRequired = 1;
    tapB.numberOfTapsRequired = 1;
    [ivB addGestureRecognizer:tapB];
    [self.view addSubview:ivB];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
//    btn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    btn.backgroundColor = Main_Color;
    [btn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureCommit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IDCard"]isEqualToString:@"YES"]) {
        
    }else{
        self.boIv = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 150, kScreenW, 150)];
        self.boIv.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:self.boIv];
        UILabel *tipsLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenW/3*2 - 40, 150)];
        tipsLb.textColor = [UIColor whiteColor];
        tipsLb.font = [UIFont systemFontOfSize:16];
        tipsLb.text = @"海关法律规定，大陆用户必须上传个人身份证，全球买手承诺会员个人资料将进行加密保护，防止外泄。";
        tipsLb.textAlignment = NSTextAlignmentCenter;
        tipsLb.numberOfLines = 0;
        [self.boIv addSubview:tipsLb];
        UIButton *enbtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - kScreenW/3 + 20, 50, kScreenW/3 - 40, 50)];
        [enbtn setTitle:NSLocalizedString(@"不再提示", nil) forState:UIControlStateNormal];
        [enbtn setTitleColor:Main_Color forState:UIControlStateNormal];
        [self.boIv addSubview:enbtn];
        [enbtn addTarget:self action:@selector(enClick) forControlEvents:UIControlEventTouchUpInside];
    }
    

    
}

- (void)enClick
{
    [self.boIv removeFromSuperview];
    self.boIv = nil;
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"IDCard"];
}

- (void)selectImage:(UITapGestureRecognizer *)tap
{
    [JPhotoMagenage getOneImageInController:self finish:^(UIImage *images) {
        NSLog(@"%@",images);
        if ([tap view].tag == 666) {
            self.imvF.image = images;
            NSLog(@"%@",[images accessibilityIdentifier]);
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/idF.png"];
            NSLog(@"%@",imagePath);
            self.imageA = imagePath;
            [UIImagePNGRepresentation(images) writeToFile:imagePath atomically:YES];
        }
        if ([tap view].tag == 888) {
            self.imvB.image = images;
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/idB.png"];
            NSLog(@"%@",imagePath);
            self.imageB = imagePath;
            [UIImagePNGRepresentation(images) writeToFile:imagePath atomically:YES];
        }
    } cancel:^{
        
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
        
        data = UIImageJPEGRepresentation(self.imvF.image, 0.1);
        NSLog(@"%lu",(unsigned long)data.length);
    } else {
        
        data = UIImagePNGRepresentation(self.imvF.image);
    }
    
    NSData *dataB;
    if (1) {
        
        dataB = UIImageJPEGRepresentation(self.imvB.image, 0.1);
        
    } else {
        
        dataB = UIImagePNGRepresentation(self.imvB.image);
    }
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"address_id":self.address_id,@"idcard_num":self.txf.text};
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
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.txf resignFirstResponder];
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
