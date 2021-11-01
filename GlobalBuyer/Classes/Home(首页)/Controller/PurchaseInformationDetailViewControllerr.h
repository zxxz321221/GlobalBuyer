//
//  PurchaseInformationDetailViewControllerr.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/29.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol HTMLJSObjcDelegate <JSExport>

- (void)openUrl:(NSString *)url :(NSString *)type;

@end

@interface PurchaseInformationDetailViewControllerr : UIViewController

@property (nonatomic,strong)NSString *htmlStr;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic,strong) NSString * navTitle;

@end
