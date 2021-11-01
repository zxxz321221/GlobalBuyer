//
//  AppDelegate+AppLifeCircle.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppLifeCircle)
    /**
     监听网络
     */
-(void)networkReachability;
    /**
     监听键盘
     */
-(void)KeyboardReachability;
@end
