//
//  Config.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define USERTOKEN @"user_token"

#define API_ID  @"73555442"

#define TOKEN @"1cac1be88370a8934e6d871077180fde50a36771"

#define LogisticsAPI_ID @"26654731"

#define LogisticsTOKEN @"6fe97c37c43e778c16c5e2cb48c5f39a8d6f6c39"

//美国亚马逊
#define AWS_API_KEY @"AKIAITRPBHTRHO33O7CA"
#define AWS_API_SECRET_KEY @"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"
#define AWS_COUNTRY @"com"
#define AWS_ASSOCIATE_TAG @"partner04-20"

#define JPush_ID @"d512f551be7a3cdf7858577f"

#define MeiQiaAppKey @"ea62addaa6a391a1235534be1eac4a3e"

#define BaidueExtensionKey @"a144a49693"
//#define Main_Color [UIColor colorWithRed:0.50 green:0.76 blue:0.25 alpha:1]
//#define Main_Color [UIColor colorWithRed:20.0/255.0 green:14.0/255.0 blue:23.0/255.0 alpha:1]
#define Main_Color [UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1]
#define Cell_BgColor  [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kScaleW [UIScreen mainScreen].bounds.size.width/414.0
#define kScaleH [UIScreen mainScreen].bounds.size.height/736.0

#define kTabBarH        49.0f
#define kStatusBarH     20.0f
#define kNavigationBarH 44.0f




// iPhone X

#define  LL_iPhoneX (kScreenW >= 375.f && kScreenH >= 812.f ? YES : NO)



// Status bar height.

#define  LL_StatusBarHeight      (LL_iPhoneX ? 44.f : 20.f)



// Navigation bar height.

#define  LL_NavigationBarHeight  44.f



// Tabbar height.

#define  LL_TabbarHeight         (LL_iPhoneX ? (49.f+34.f) : 49.f)



// Tabbar safe bottom margin.

#define  LL_TabbarSafeBottomMargin         (LL_iPhoneX ? 34.f : 0.f)



// Status bar & navigation bar height.

#define  LL_StatusBarAndNavigationBarHeight  (LL_iPhoneX ? 88.f : 64.f)





#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height
#define labelTextColor [Unity getColor:@"#666666"]


#define USHARE_APPKEY @"5938beab2ae85b7dc000117f"

#define GDMAP_APPKEY @"ce5c940ce4635c310b1cb7b2ac21688c"

#define WX_APPKEY @"wx7bb0bcd9a4b73464"

#define WX_APPSECRER @"2052115739ab9820f787e3511fd8d904"

#define REURL @"http://buy.dayanghang.net/user_data/special/20190110/cn/Other.html?code=dyh-wotadaNooxoon"


#define GoodsShareURL @"http://buy.dayanghang.net/user_data/special/20180109/share.html?%@GlobalBuyers%@GlobalBuyers%@GlobalBuyers%@GlobalBuyers%@"

#define FACEBOOK_APPKEY @"1453710281370845"

#define PHONENUMBER @"0411-39621656"

#define BaiDuAppid @"20170513000047304"
#define BaiDuKey @"uZeXnPVkpPrURFgf4Ju9"

#define UserDefault [NSUserDefaults standardUserDefaults]

    //----------------------ABOUT SYSTYM & VERSION 系统与版本 ----------------------------
    //Get the OS version.       判断操作系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

    //judge the simulator or hardware device        判断是真机还是模拟器
#if TARGET_OS_IPHONE
    //iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
    //iPhone Simulator
#endif

/** 获取系统版本 */
#define iOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

/** 判断是否为iPhone */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/** 判断是否是iPad */
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define GDLocalizedString(key) [[Internationalization bundle] localizedStringForKey:(key) value:@"" table:nil]


/** 是否为iOS6 */
#define iOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) ? YES : NO)

/** 是否为iOS7 */
#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

/** 是否为iOS8 */
#define iOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

/** 是否为iOS9 */
#define iOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

/** 是否为iOS914 */
#define iOS14 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0) ? YES : NO)

/** 获取当前语言 */
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


    //----------------------ABOUT PRINTING LOG 打印日志 ----------------------------
    //Using dlog to print while in debug model.        调试状态下打印日志
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

    //Printing while in the debug model and pop an alert.       模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

/** print 打印rect,size,point */
#ifdef DEBUG
#define kLogPoint(point)    NSLog(@"%s = { x:%.4f, y:%.4f }", #point, point.x, point.y)
#define kLogSize(size)      NSLog(@"%s = { w:%.4f, h:%.4f }", #size, size.width, size.height)
#define kLogRect(rect)      NSLog(@"%s = { x:%.4f, y:%.4f, w:%.4f, h:%.4f }", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#endif

//----------------------SOMETHING ELSE 其他 ----------------------------

#define intToStr(S)    [NSString stringWithFormat:@"%d",S]

/**
 *  the saving objects      存储对象
 *
 *  @param __VALUE__ V
 *  @param __KEY__   K
 *
 *  @return
 */
#define UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

/**
 *  get the saved objects       获得存储的对象
 */
#define UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

/**
 *  delete objects      删除对象
 */
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define TableViewCellDequeueInit(__INDETIFIER__) [tableView dequeueReusableCellWithIdentifier:(__INDETIFIER__)];

#define TableViewCellDequeue(__CELL__,__CELLCLASS__,__INDETIFIER__) \
{\
if (__CELL__ == nil) {\
__CELL__ = [[__CELLCLASS__ alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:__INDETIFIER__];\
}\
}

#define TableViewCellDequeueXIB(__CELL__,__CELLCLASS__) \
{\
if (__CELL__ == nil) {\
__CELL__ = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([__CELLCLASS__  class]) owner:self options:nil]lastObject];\
}\
}

#define KEYWINDOW [UIApplication sharedApplication].keyWindow

    //Show Alert, brackets is the parameters.       宏定义一个弹窗方法,括号里面是方法的参数
#define ShowAlert    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning." message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: @"OK"];[alert show];

#define NotificationError(msg) [JDStatusBarNotification showWithStatus:msg dismissAfter:2.0 styleName:JDStatusBarStyleError]


    //
#define NotificationWarning(msg) [JDStatusBarNotification showWithStatus:msg dismissAfter:2.0 styleName:JDStatusBarStyleWarning]
    //
#define NotificationSuccess(msg) [JDStatusBarNotification showWithStatus:msg dismissAfter:2.0 styleName:JDStatusBarStyleSuccess]


#endif /* Config_h */
