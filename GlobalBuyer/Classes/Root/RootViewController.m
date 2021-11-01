//
//  RootViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "PurchasingCommissionViewController.h"
#import "ShopDetailViewController.h"
#import "UserModel.h"
@interface RootViewController ()

@property (nonatomic,strong) UIView *serviceV;
@property (nonatomic,strong) UIView *serviceNewMessageV;
@property (nonatomic,strong) UIView *SGQRCodeV;

@property (nonatomic,strong)NSString *webLink;

@property (nonatomic,strong)UILabel *shopCartNumLb;
@property (nonatomic,strong)UILabel *mineNumLb;

@end

@implementation RootViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self chenkPasteboard];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:@"enterForeground" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view from its nib.
    //[self createNoticeBtn];
    
}

- (void)enterForeground{
   
    NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSString *enterprise = [[NSUserDefaults standardUserDefaults]objectForKey:@"enterprise"];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    if (email&&password&&enterprise&&userToken) {
        [self loginWithemail:email password:password enterprise:enterprise];
    }
    
    
}

- (void)loginWithemail:(NSString *)email password:(NSString *)password enterprise:(NSString *)enterprise{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = [NSDictionary new];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"]) {
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"JPushId":[[NSUserDefaults standardUserDefaults]objectForKey:@"JPUSHregistrationID"],@"enterprise":enterprise};
    }else{
        params = @{@"api_id":API_ID,@"api_token":TOKEN,@"email":email,@"password":password,@"enterprise":enterprise};
    }


    [manager POST:UserLoginApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"error"]) {

        }
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self saveEmailLoginInfo:responseObject];
            
            [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"enterprise"];


        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    

}

- (void)setGoodsNumLb
{
    NSArray *itemArray = self.tabBarController.childViewControllers;
    UINavigationController *tabC = itemArray[0];
    self.shopCartNumLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/5 * 2 + (kScreenW/5 - 35), 3, 15, 15)];
    self.shopCartNumLb.layer.cornerRadius = 7.5;
    self.shopCartNumLb.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.shopCartNumLb.font = [UIFont systemFontOfSize:8];
    self.shopCartNumLb.textAlignment = NSTextAlignmentCenter;
    self.shopCartNumLb.textColor = [UIColor redColor];
    self.shopCartNumLb.layer.borderColor = [UIColor redColor].CGColor;
    self.shopCartNumLb.layer.borderWidth = 0.6;
    self.shopCartNumLb.hidden = YES;
    [tabC.tabBarController.tabBar addSubview:self.shopCartNumLb];
    
    
    self.mineNumLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/5 * 3 + (kScreenW/5 - 35), 3, 15, 15)];
    self.mineNumLb.layer.cornerRadius = 7.5;
    self.mineNumLb.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.mineNumLb.font = [UIFont systemFontOfSize:8];
    self.mineNumLb.textAlignment = NSTextAlignmentCenter;
    self.mineNumLb.textColor = [UIColor redColor];
    self.mineNumLb.layer.borderColor = [UIColor redColor].CGColor;
    self.mineNumLb.layer.borderWidth = 0.6;
    self.mineNumLb.hidden = YES;
    [tabC.tabBarController.tabBar addSubview:self.mineNumLb];
}

- (void)refreshGoodsNum
{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    if (userToken) {
        
    }else{
        self.shopCartNumLb.hidden = YES;
        self.mineNumLb.hidden = YES;
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;;
    parameters[@"secret_key"] = userToken;
    
    
    
    [manager POST:GetAllStateGoodsApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            if ([responseObject[@"data"][@"cartProducts"] intValue] == 0) {
                self.shopCartNumLb.hidden = YES;
            }else{
                self.shopCartNumLb.hidden = NO;
            }
            
            if ([responseObject[@"data"][@"payWaitOrder"] intValue] +
                [responseObject[@"data"][@"buyWaitProduct"] intValue] +
                [responseObject[@"data"][@"packWaitProduct"] intValue] +
                [responseObject[@"data"][@"payWaitPackage"] intValue] +
                [responseObject[@"data"][@"completePackage"] intValue] +
                [responseObject[@"data"][@"afterSale"] intValue] +
                [responseObject[@"data"][@"updateExpressProducts"] intValue] +
                [responseObject[@"data"][@"transportStoragePackage"] intValue]== 0) {
                self.mineNumLb.hidden = YES;
            }else{
                self.mineNumLb.hidden = NO;
            }
            
            self.shopCartNumLb.text = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"cartProducts"] intValue]];
//            self.mineNumLb.text = [NSString stringWithFormat:@"%d",
//                                   [responseObject[@"data"][@"payWaitOrder"] intValue] +
//                                   [responseObject[@"data"][@"buyWaitProduct"] intValue] +
//                                   [responseObject[@"data"][@"packWaitProduct"] intValue] +
//                                   [responseObject[@"data"][@"payWaitPackage"] intValue] +
//                                   [responseObject[@"data"][@"completePackage"] intValue] +
//                                   [responseObject[@"data"][@"afterSale"] intValue] +
//                                   [responseObject[@"data"][@"updateExpressProducts"] intValue] +
//                                   [responseObject[@"data"][@"transportStoragePackage"] intValue]+
//                                   [responseObject[@"data"][@"receiveCompletePackage"] intValue]];
            self.mineNumLb.text = [NSString stringWithFormat:@"%d",
                                   [responseObject[@"data"][@"payWaitOrder"] intValue] +
                                   [responseObject[@"data"][@"buyWaitProduct"] intValue] +
                                   [responseObject[@"data"][@"packWaitProduct"] intValue] +
                                   [responseObject[@"data"][@"payWaitPackage"] intValue] +
                                   [responseObject[@"data"][@"completePackage"] intValue] +
                                   [responseObject[@"data"][@"afterSale"] intValue] +
                                   [responseObject[@"data"][@"updateExpressProducts"] intValue] +
                                   [responseObject[@"data"][@"transportStoragePackage"] intValue]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
}

- (void)chenkPasteboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundPasteboard) name:@"enterForegroundPasteboard" object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"enterForegroundPasteboard" object:nil];
}

- (void)enterForegroundPasteboard
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSLog(@"board=============================%@",board.string);
    self.webLink = board.string;
    
    NSMutableArray *pictureHttpArr = [self getRangeStr:board.string findText:@"http"];
    NSMutableArray *pictureHttpsArr = [self getRangeStr:board.string findText:@"https"];
    
    if (self.webLink) {
        if (pictureHttpArr.count > 0 || pictureHttpsArr.count > 0) {
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            parameters[@"api_id"] = API_ID;
            parameters[@"api_token"] = TOKEN;;
            parameters[@"link"] = self.webLink;
            
            [manager POST:JudgeLinkApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([responseObject[@"code"]isEqualToString:@"success"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Home_PurchasingLink", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil), nil];
                    alert.tag = 999;
                    [alert show];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            

        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    
    
    if (buttonIndex == 1 && alertView.tag == 999) {
        
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.string = @"";
        
        ShopDetailViewController *shopVC = [[ShopDetailViewController alloc]init];
        shopVC.link = self.webLink;
        shopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shopVC animated:YES];
        
//        PurchasingCommissionViewController *PurchasingCommissionVC = [[PurchasingCommissionViewController alloc]init];
//        PurchasingCommissionVC.hidesBottomBarWhenPushed = YES;
//        PurchasingCommissionVC.webLink = self.webLink;
//        [self.navigationController pushViewController:PurchasingCommissionVC animated:YES];
    }
    
    if (buttonIndex == 0 && alertView.tag == 999) {
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.string = @"";
    }
}

//获取http OR https
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
            
        {
            
            if (0 == i) {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }else
                
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}


//- (void)createNoticeBtn
//{
    //消息中心监听客服新消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMQMessages:) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
    
//    self.serviceV = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 30, 30)];
//    UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 30, 30)];
//    im.image = [UIImage imageNamed:@"Service"];
//    [self.serviceV addSubview:im];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Service:)];
//    tap.numberOfTouchesRequired = 1;
//    tap.numberOfTapsRequired = 1;
//    [self.serviceV addGestureRecognizer:tap];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.serviceV];
//}

//弹出聊天页面
//- (void)Service:(UITapGestureRecognizer *)tap
//{
//    //发送用户已点击阅读客服消息信息
//    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
//    [chatViewManager pushMQChatViewControllerInViewController:self];
//}

//收到新消息 && 本地推送
//- (void)didReceiveNewMQMessages:(NSNotification *)notification {
//    
//    //NSArray *mqMessage = [notification.userInfo objectForKey:@"messages"];
//
//    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
//    localNotifi.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
//    localNotifi.alertTitle = @"全球買手客服";
//    localNotifi.alertBody = @"您收到了一条客服信息";
//    localNotifi.applicationIconBadgeNumber = 1;
//    localNotifi.soundName = UILocalNotificationDefaultSoundName;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"ChatState"];
//}

#pragma mark 判断是否登录
- (BOOL)chenkUserLogin {
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    if (userToken) {
        return  YES;
    }else{
        return NO;
    }
}

- (void)setNavigationBackBtn {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_mine"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
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
