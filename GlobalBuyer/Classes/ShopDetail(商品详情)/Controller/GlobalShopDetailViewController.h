//
//  GlobalShopDetailViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/7/24.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "RootViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GoodsModel.h"
#import "ShopCartManager.h"
@protocol GlobalJSObjcDelegate <JSExport>

- (void)getGoodsInfo:(NSString *)string;
- (void)showCart:(NSString *)string;
- (void)assetComplete:(NSString *)string;

@end


@interface GlobalShopDetailViewController : RootViewController

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong)GoodsModel *model;
@property (nonatomic, strong)NSString *link;
@property (nonatomic, strong)NSString *nationalityStr;

@property (nonatomic, strong)NSString *websiteIntroductionStr;
@property (nonatomic, strong)NSString *websiteName;
@property (nonatomic, strong)NSString *guideMessage;

@property (nonatomic, strong)NSString * ebayUrl;
@property (nonatomic, assign)BOOL isShowText;//yes显示导航栏上方搜索框 no不显示

@end
