//
//  AppDelegate+RootController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AppDelegate.h"
#import "CurrencyViewController.h"
@interface AppDelegate (RootController)<UIScrollViewDelegate,CurrencyViewControllerDelegate>
    /**
     *  首次启动轮播图
     */
- (void)createLoadingScrollView;
    /**
     *  window实例
     */
- (void)setAppWindows;
    /**
     *  根视图
     */
- (void)setRoot;
    
- (void)setRootViewController;
-(void)gotoHomeVC;

@end
