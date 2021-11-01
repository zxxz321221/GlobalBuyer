//
//  AppDelegate+AppService.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)
    /**
     *  设置初始LoadingViewNum
     */
- (void)setTaobaoSDK;
    /**
     *  设置初始LoadingViewNum
     */
- (void)setLoadingViewNum;
    /**
     *  bug日志反馈
     */
- (void)registerBugly;
    
    /**
     *  基本配置
     */
- (void)configurationLaunchUserOption;
    
    /**
     *  友盟注册
     */
- (void)registerUmeng;

    /**
     *  地图注册
     */

- (void)registerGDMap;

    /**
     *  Mob注册
     */

- (void)registerMob;
    
    /**
     *  检查更新
     */
- (void)checkAppUpDataWithshowOption:(BOOL)showOption;
    
    /**
     *  上传用户设备信息
     */
- (void)upLoadMessageAboutUser;

    /**
     *  注册激光推送
     */
- (void)registerJPushWithOptions:(NSDictionary *)launchOptions Withapplication:(UIApplication *)application;
- (void)getOptions:(NSDictionary *)launchOptions;
- (void)JPushInitWithapplication:(UIApplication *)application;

    /**
     *  注册美洽即时通讯
     */
- (void)registerMeiQia;

    /**
     *  检测崩溃日志并发送
     */
- (void)sendErrorMessage;
/**
 *  注册百度统计
 */
- (void)registerBaiduExtension;

- (void)registerProxy;
@end
