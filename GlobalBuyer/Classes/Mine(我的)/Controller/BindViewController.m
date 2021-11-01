//
//  BindViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/16.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "BindViewController.h"

@interface BindViewController ()
@property (nonatomic , strong) UIButton * wechat;
@property (nonatomic , strong) UIButton * faceBook;

@property (nonatomic , strong) UIImageView * wechatIcon;
@property (nonatomic , strong) UILabel * wechatName;
@property (nonatomic , strong) UILabel * wechatL;
@property (nonatomic , strong) UIImageView * faceBookIcon;
@property (nonatomic , strong) UILabel * faceBookName;
@property (nonatomic , strong) UILabel * faceBookL;
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self creareUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"账号绑定";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREEN_WIDTH / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)creareUI{
    [self.view addSubview:self.wechat];
    [self.view addSubview:self.faceBook];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"WECHATBIND"]isEqualToString:@"NO"]) {
        [self isWechatBind:0];
    }else{
        [self isWechatBind:1];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBIND"]isEqualToString:@"NO"]) {
        [self isFaceBookBind:0];
    }else{
        [self isFaceBookBind:1];
    }
}
- (void)isWechatBind:(NSInteger )index{
    if (index == 0) {
        self.wechatIcon.image = [UIImage imageNamed:@"微信未绑定"];
        self.wechatName.text = NSLocalizedString(@"GlobalBuyer_My_bindWeChatLogin", nil);
        self.wechatL.text =  NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil);
        self.wechatL.textColor = [Unity getColor:@"#999999"];
    }else{
        self.wechatIcon.image = [UIImage imageNamed:@"微信已绑定"];
        self.wechatName.text = NSLocalizedString(@"GlobalBuyer_My_unbindWeChatLogin", nil);
        self.wechatL.text = NSLocalizedString(@"GlobalBuyer_My_BindState_YES", nil);
        self.wechatL.textColor = [Unity getColor:@"#333333"];
    }
}
- (void)isFaceBookBind:(NSInteger)index{
    if (index == 0) {
        self.faceBookIcon.image = [UIImage imageNamed:@"登录脸书未绑定"];
        self.faceBookName.text = NSLocalizedString(@"GlobalBuyer_My_bindFaceBookLogin", nil);
        self.faceBookL.text =  NSLocalizedString(@"GlobalBuyer_My_BindState_NO", nil);
        self.faceBookL.textColor = [Unity getColor:@"#999999"];
    }else{
        self.faceBookIcon.image = [UIImage imageNamed:@"登录脸书已绑定"];
        self.faceBookName.text = NSLocalizedString(@"GlobalBuyer_My_unbindFaceBookLogin", nil);
        self.faceBookL.text = NSLocalizedString(@"GlobalBuyer_My_BindState_YES", nil);
        self.faceBookL.textColor = [Unity getColor:@"#333333"];
    }
}
- (UIButton *)wechat{
    if (!_wechat) {
        _wechat = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:50])];
        [_wechat addTarget:self action:@selector(wechatClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:49], kScreenW, [Unity countcoordinatesH:1])];
        line.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_wechat addSubview:line];
        
        [_wechat addSubview:self.wechatIcon];
        [_wechat addSubview:self.wechatName];
        [_wechat addSubview:self.wechatL];
        
    }
    return _wechat;
}
- (UIButton *)faceBook{
    if (!_faceBook) {
        _faceBook = [[UIButton alloc]initWithFrame:CGRectMake(0, _wechat.bottom, kScreenW, [Unity countcoordinatesH:50])];
        [_faceBook addTarget:self action:@selector(faceBookClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:49], kScreenW, [Unity countcoordinatesH:1])];
        line.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_faceBook addSubview:line];
        
        [_faceBook addSubview:self.faceBookIcon];
        [_faceBook addSubview:self.faceBookName];
        [_faceBook addSubview:self.faceBookL];
    }
    return _faceBook;
}
- (UIImageView *)wechatIcon{
    if (!_wechatIcon) {
        _wechatIcon = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        _wechatIcon.image = [UIImage imageNamed:@"微信未绑定"];
    }
    return _wechatIcon;
}
- (UILabel *)wechatName{
    if (!_wechatName) {
        _wechatName = [[UILabel alloc]initWithFrame:CGRectMake(_wechatIcon.right+[Unity countcoordinatesW:10], [Unity countcoordinatesH:15], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20])];
        _wechatName.text = @"绑定微信登录";
        _wechatName.textAlignment = NSTextAlignmentLeft;
        _wechatName.textColor = [Unity getColor:@"#333333"];
        _wechatName.font = [UIFont systemFontOfSize:14];
    }
    return _wechatName;
}
- (UILabel *)wechatL{
    if (!_wechatL) {
        _wechatL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:100], [Unity countcoordinatesH:15], [Unity countcoordinatesW:90], [Unity countcoordinatesH:20])];
        _wechatL.text = @"未绑定";
        _wechatL.textAlignment = NSTextAlignmentRight;
        _wechatL.textColor = [Unity getColor:@"#999999"];
        _wechatL.font = [UIFont systemFontOfSize:14];
    }
    return _wechatL;
}
- (UIImageView *)faceBookIcon{
    if (!_faceBookIcon) {
        _faceBookIcon = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20])];
        _faceBookIcon.image = [UIImage imageNamed:@"登录脸书未绑定"];
    }
    return _faceBookIcon;
}
- (UILabel *)faceBookName{
    if (!_faceBookName) {
        _faceBookName = [[UILabel alloc]initWithFrame:CGRectMake(_wechatIcon.right+[Unity countcoordinatesW:10], [Unity countcoordinatesH:15], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20])];
        _faceBookName.text = @"绑定facebook登录";
        _faceBookName.textAlignment = NSTextAlignmentLeft;
        _faceBookName.textColor = [Unity getColor:@"#333333"];
        _faceBookName.font = [UIFont systemFontOfSize:14];
    }
    return _faceBookName;
}
- (UILabel *)faceBookL{
    if (!_faceBookL) {
        _faceBookL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:100], [Unity countcoordinatesH:15], [Unity countcoordinatesW:90], [Unity countcoordinatesH:20])];
        _faceBookL.text = @"未绑定";
        _faceBookL.textAlignment = NSTextAlignmentRight;
        _faceBookL.textColor = [Unity getColor:@"#999999"];
        _faceBookL.font = [UIFont systemFontOfSize:14];
    }
    return _faceBookL;
}
- (void)wechatClick{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"WECHATBIND"] isEqualToString:@"NO"]) {
        [self weChatClick];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureWeChat", nil) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //这里写选择确定之后的操作
            [self cancelWeChat];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //这里写选择取消之后的操作
        }]];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureWeChat", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
//        alert.tag = 666;
//        [alert show];
    }
}
- (void)faceBookClick{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FACEBIND"] isEqualToString:@"NO"]) {
        [self facebookClick];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureFaceBook", nil) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //这里写选择确定之后的操作
            [self cancelFacebook];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //这里写选择取消之后的操作
        }]];

//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_areSureFaceBook", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
//        alert.tag = 888;
//        [alert show];
    }
}
- (void)weChatClick {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession  currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (error) {
            
        }else{
            if (resp.originalResponse[@"errcode"]) {
                NSLog(@"无效的openid");
                [self weChatClick];
            }else{
                [self bindWeChatWithUnionid:resp.originalResponse[@"unionid"] headImgUrl:resp.originalResponse[@"headimgurl"]];
            }
        }
    }];
}
- (void)bindWeChatWithUnionid:(NSString *)unionid headImgUrl:(NSString *)headImgUrl
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_binding", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"unionid"] = unionid;
    parameters[@"weixinAvatar"] = headImgUrl;
    
    [manager POST:BindWeChatApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"WECHATBIND"];

            [self isWechatBind:1];

            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_Hasbind", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}
//facebook
- (void)facebookClick {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Facebook currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        NSLog(@" originalResponse: %@", resp);
        if (!error) {
            
            [self bindfacebookLoginApi:resp.originalResponse[@"id"]];
        }
    }];
}
-(void)bindfacebookLoginApi:(NSString *)fbid
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_binding", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    parameters[@"fid"] = fbid;
    
    [manager POST:BindFaceBookApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"FACEBIND"];

            [self isFaceBookBind:1];
            
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_Hasbind", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_bindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}
- (void)cancelWeChat
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_unbinding", nil);
    
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:CancelBindWeChatApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
            
            [self isWechatBind:0];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}
- (void)cancelFacebook
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_My_unbinding", nil);
    
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    [manager POST:CancelBindFaceBookApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
            
            [self isFaceBookBind:0];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindSuccess", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_My_unbindFail", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
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
