//
//  AppDelegate+AppService.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "SSProxyProtocol.h"
#import "AppUncaughtExceptionHandler.h"
#import "ShadowsocksClient.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h> 
#endif

#import <AlibcTradeSDK/AlibcTradeSDK.h>

static ShadowsocksClient *proxy;
// 如果需要使 idfa功能所需要引 的头 件(可选) #import <AdSupport/AdSupport.h>
@interface AppDelegate ()<UIAlertViewDelegate,JPUSHRegisterDelegate>
    
@end

@implementation AppDelegate (AppService)

#pragma mark 设置淘宝sdk
- (void)setTaobaoSDK
{
    
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
    
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    [[AlibcTradeSDK sharedInstance] setTaokeParams:nil];
    [[AlibcTradeSDK sharedInstance] setIsForceH5:YES];

}

#pragma mark 设置初始LoadingViewNum
- (void)setLoadingViewNum
{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"LoadingViewNum"];
}

#pragma  mark 注册Bugly
- (void)registerBugly {

}

#pragma mark 配置用户信息
- (void)configurationLaunchUserOption {
    
}

#pragma mark 注册mob
- (void)registerMob {
     
}

#pragma mark 注册美洽即时通讯
- (void)registerMeiQia{
    [MQManager initWithAppkey:MeiQiaAppKey completion:^(NSString *clientId, NSError *error) {
        NSLog(@"%@",clientId);
    }];
}

#pragma mark 注册激光推送

//程序启动时初始化角标数
- (void)JPushInitWithapplication:(UIApplication *)application{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"NotificationType"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"NotificationUrl"];
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

//注册激光推送
- (void)registerJPushWithOptions:(NSDictionary *)launchOptions Withapplication:(UIApplication *)application{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //消息中心监听客服新消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMQMessages:) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType notType = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:notType categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPush_ID channel:@"App Store" apsForProduction:YES advertisingIdentifier:nil];
    
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"===================================%@",registrationID);
        
        if (registrationID && UserDefaultObjectForKey(USERTOKEN)) {
            [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"JPUSHregistrationID"];
        }
    }];
}

//收到客服新消息 && 本地推送
- (void)didReceiveNewMQMessages:(NSNotification *)notification {
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isChating"]isEqualToString:@"YES"]) {
        return;
    }
    //NSArray *mqMessage = [notification.userInfo objectForKey:@"messages"];
    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
    localNotifi.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
    localNotifi.alertTitle = @"全球買手客服";
    localNotifi.alertBody = @"您收到了一条客服信息";
    localNotifi.applicationIconBadgeNumber = 1;
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"ChatState"];
}

//程序在前台时截取自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    //NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeTitle = [extras valueForKey:@"title"];
    NSString *customizeBody = [extras valueForKey:@"body"];
    NSString *customizeUrl = [extras valueForKey:@"url"];
    NSString *customizeType = [extras valueForKey:@"type"];
    
    if ([customizeType isEqualToString:@"external"]) {
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:customizeType forKey:@"NotificationType"];
        [UserDe setObject:customizeUrl forKey:@"NotificationUrl"];
    }else{
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:nil forKey:@"NotificationType"];
        [UserDe setObject:customizeUrl forKey:@"NotificationUrl"];
        NSLog(@"%@",[UserDe objectForKey:@"NotificationUrl"]);
    }
    
    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
    localNotifi.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
    localNotifi.alertTitle = customizeTitle;
    localNotifi.alertBody = customizeBody;
    localNotifi.applicationIconBadgeNumber = 1;
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
    
}

#pragma mark JPUSHRegisterDelegate
//将注册的token返回给极光
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//app启动时获取正常推送消息iOS8.0later
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if (userInfo.count == 0) {
      
    }else{
        if ([userInfo[@"type"]isEqualToString:@"external"]) {
            NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
            [UserDe setObject:userInfo[@"type"] forKey:@"NotificationType"];
            [UserDe setObject:userInfo[@"url"] forKey:@"NotificationUrl"];
        }else{
            NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
            [UserDe setObject:@"" forKey:@"NotificationType"];
            [UserDe setObject:userInfo[@"url"] forKey:@"NotificationUrl"];
        }
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

//app启动时获取正常推送消息iOS7.0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//app启动时点击推送消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isChating"]isEqualToString:@"YES"]) {
        return;
    }
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotMessage" object:nil];
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
}

//程序启动时截取推送消息
- (void)getOptions:(NSDictionary *)launchOptions
{
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //通知内容
    //remoteNotification[@"aps"][@"alert"];
    //多余字段
    //remoteNotification[@"自定义字段"];
    
    if ([remoteNotification[@"type"]isEqualToString:@"buy"]) {
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:remoteNotification[@"type"] forKey:@"NotificationType"];
        [UserDe setObject:remoteNotification[@"link"] forKey:@"NotificationLink"];
    }else if([remoteNotification[@"type"]isEqualToString:@"entrust"]){
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:remoteNotification[@"type"] forKey:@"NotificationType"];
        [UserDe setObject:remoteNotification[@"link"] forKey:@"NotificationLink"];
    }else if([remoteNotification[@"type"]isEqualToString:@"browse"]){
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:remoteNotification[@"type"] forKey:@"NotificationType"];
        [UserDe setObject:remoteNotification[@"link"] forKey:@"NotificationLink"];
    }else if([remoteNotification[@"type"]isEqualToString:@"List"]){
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:remoteNotification[@"type"] forKey:@"NotificationType"];
        [UserDe setObject:remoteNotification[@"link"] forKey:@"NotificationLink"];
        [UserDe setObject:remoteNotification[@"headImageUrl"] forKey:@"NotificationheadImageUrl"];
        [UserDe setObject:remoteNotification[@"AdUrl"] forKey:@"NotificationAdUrl"];
    }else if([remoteNotification[@"type"]isEqualToString:@"dialog"]){
        NSUserDefaults *UserDe = [NSUserDefaults standardUserDefaults];
        [UserDe setObject:remoteNotification[@"type"] forKey:@"NotificationType"];
        [UserDe setObject:remoteNotification[@"link"] forKey:@"NotificationLink"];
        [UserDe setObject:remoteNotification[@"dialogImage"] forKey:@"NotificationdialogImage"];
        [UserDe setObject:remoteNotification[@"dialogType"] forKey:@"NotificationdialogType"];
    }else{

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotMessage" object:nil];
}

#pragma 注册友盟
- (void)registerUmeng {
    
    [[UMSocialManager defaultManager] openLog:YES];
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    [self configUSharePlatforms];
    
}

- (void)configUSharePlatforms {
        /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPKEY appSecret:WX_APPSECRER redirectURL:REURL];
    
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:FACEBOOK_APPKEY  appSecret:nil redirectURL:REURL];

}




#pragma mark 注册高德地图
- (void)registerGDMap {
    [AMapServices sharedServices].apiKey = GDMAP_APPKEY;
}

-(void)checkBlack {
        
}
    
#pragma mark 上传用户信息
- (void)upLoadMessageAboutUser {
        
}

#pragma mark 注册代理
- (void)registerProxy
{
//    proxy = [[ShadowsocksClient alloc] initWithHost:@"47.90.93.67"
//                                               port:8181
//                                           password:@"mzq123456"
//                                             method:@"aes-256-cfb"];
    proxy = [[ShadowsocksClient alloc] initWithHost:@"202.182.102.29"
                                               port:9191
                                           password:@"dayanghang"
                                             method:@"aes-128-cfb"];
    [proxy startWithLocalPort:1081];
    [SSProxyProtocol setLocalPort:1081];
    [NSURLProtocol registerClass:[SSProxyProtocol class]];
}

#pragma mark 版本更新检测
- (void)checkAppUpDataWithshowOption:(BOOL)showOption {
    //版本更新
    if (showOption) {
        [iVersion sharedInstance].applicationBundleID = [[NSBundle mainBundle] bundleIdentifier];
//        [iVersion sharedInstance].updatePriority=iVersionUpdatePriorityMedium;
//        NSLog(@"%ld", (long)([iVersion sharedInstance].updatePriority=iVersionUpdatePriorityMedium));
    }

}

- (void)sendErrorMessage
{

#pragma mark -- 崩溃日志
    [AppUncaughtExceptionHandler setDefaultHandler];
    // 发送崩溃日志
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {

        [self sendExceptionLogWithData:data];
        
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentsPath];
        for (NSString *fileName in enumerator) {
            [[NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
        }
    }

}

#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    //读取txt时用0x80000632解码
    NSError *error;
    NSString *content = [[NSString alloc] initWithContentsOfFile:dataPath encoding:0x80000632 error:&error];
    NSLog(@"%@",error);
    NSLog(@"%@",content);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary new];
//    params[@"api_id"] = API_ID;
//    params[@"api_token"] = TOKEN;
    params[@"title"] = @"iOS崩溃日志";
    params[@"text"] = content;
    params[@"level"] = @"normal";
    params[@"group"] = @"app-ios";

    
    [manager POST:ErrorApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
        // 删除文件
        NSFileManager *fileManger = [NSFileManager defaultManager];
        [fileManger removeItemAtPath:dataPath error:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}

//注册百度统计
- (void)registerBaiduExtension
{
    [[BaiduMobStat defaultStat] logEvent:@"event7" eventLabel:@"[开启app]" attributes:@{@"收货区域":[NSString stringWithFormat:@"[%@]",[[NSUserDefaults standardUserDefaults]objectForKey:@"currencyName"]]}];
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:BaidueExtensionKey];
}

@end
