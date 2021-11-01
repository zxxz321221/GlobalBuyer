//
//  AppDelegate+AppLifeCircle.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate+AppLifeCircle.h"

@implementation AppDelegate (AppLifeCircle)

-(void)networkReachability{

}

#pragma mark 键盘自动化
-(void)KeyboardReachability{

//    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarByPosition; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    //    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    
    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未识别的网络");
//                break;
//                
//            case AFNetworkReachabilityStatusNotReachable:
//                NotificationError(NSLocalizedString(@"GlobalBuyer_Network_StatusNotReachable", nil));
//                NSLog(@"不可达的网络(未连接)");
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"2G,3G,4G...的网络");
//                NotificationWarning(NSLocalizedString(@"GlobalBuyer_Network_StatusReachableViaWWAN", nil));
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"当前正在使用wifi");
//                NotificationSuccess(NSLocalizedString(@"GlobalBuyer_Network_StatusReachableViaWiFi", nil));
//                break;
//            default:
//                break;
//        }
//    }];
//    
//    [manager startMonitoring];
}

@end
