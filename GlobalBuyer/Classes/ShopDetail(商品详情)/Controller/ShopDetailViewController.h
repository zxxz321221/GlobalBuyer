//
//  ShopDetailViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GoodsModel.h"
#import "ShopCartManager.h"
@protocol JSObjcDelegate <JSExport>

- (void)getGoodsInfo:(NSString *)string;
- (void)showCart:(NSString *)string;
- (void)assetComplete:(NSString *)string;

@end

@interface ShopDetailViewController : RootViewController

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong)GoodsModel *model;
@property (nonatomic, strong)NSString *link;
@property (nonatomic, strong)NSString *nationalityStr;
@property (nonatomic, assign)BOOL showTabbar;

@property (nonatomic, strong)NSString *websiteIntroductionStr;
@property (nonatomic, strong)NSString *websiteName;
@property (nonatomic, strong)NSString *guideMessage;


@end
