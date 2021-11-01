//
//  TaobaoShopCartViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "RootViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcADelegate <JSExport>

- (void)taobaoShopcartInfo:(NSString *)string;

@end

@interface TaobaoShopCartViewController : RootViewController
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic , strong) NSString * shopCartStr;
@property (nonatomic , assign) NSInteger type;//0淘宝 1京东 2严选 3 1688 4zixuan
@property (nonatomic , strong) NSString * navT;
@end
