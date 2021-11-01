//
//  AppDelegate.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+RootController.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+AppLifeCircle.h"
#import "NSBundle+Language.h"
#import "AllPaySDK.h"


#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@property (nonatomic , strong)NSDate *backgroundDate;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[self registerProxy];
    //if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserSelectLanguage"]) {
        //[NSBundle setLanguage:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserSelectLanguage"]];
    //}
//    [FIRApp configure];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [self setTaobaoSDK];
    
    [FIRAnalytics logEventWithName:@"啟動" parameters:nil];
    
    [self JPushInitWithapplication:application];
    [self sendErrorMessage];
    [self setLoadingViewNum];
    if (launchOptions) {
        [self getOptions:launchOptions];
    }

    [self registerMeiQia];
    [self setAppWindows];
//    [self setRootViewController];
    [self gotoHomeVC];
    [self.window makeKeyAndVisible];
    [self registerUmeng];
    [self registerGDMap];
    [self checkAppUpDataWithshowOption:YES];
    [self networkReachability];
    [self KeyboardReachability];
    [self registerJPushWithOptions:launchOptions Withapplication:application];
    [self registerBaiduExtension];
    
    return YES;
}







//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
    if (![[AlibcTradeSDK sharedInstance] application:app
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
        BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        if (!result) {

            // 其他如支付等SDK的回调
            [AllPaySDK openURL:url];
            return YES;
            BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                          openURL:url
                                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                            ];
            
            // Add any custom logic here.
            return handled;
        }
        return result;
    }
    return YES;
    

}

#endif
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
   
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            // 其他如支付等SDK的回调
            [AllPaySDK openURL:url];
            return YES;
        }
        return result;
    }
    return YES;
    

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        [AllPaySDK openURL:url];
        return YES;
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //[MQManager closeMeiqiaService];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@YES,@"state", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"enterBackground"  object:self userInfo:dict];
    
    self.backgroundDate = [NSDate date];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [MQManager openMeiqiaService];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@YES,@"state", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"enterForeground"  object:self userInfo:dict];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"enterForegroundPasteboard"  object:self userInfo:nil];
    
    [self JPushInitWithapplication:application];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.backgroundDate];
    if (interval > 30*60) {
        [[self currentViewController].navigationController popToRootViewControllerAnimated:NO];
        [[self currentViewController].navigationController.tabBarController setSelectedIndex:0];
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//获取当前控制器
- (UIViewController*)currentViewController {

    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (1) {

        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }

    }

    return vc;

}

@end
