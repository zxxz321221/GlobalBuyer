//
//  ServiceViewController.h
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/11/19.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN
@protocol HtmlJSDelegate <JSExport>

- (void)openHelp:(NSString *)numId;

@end
@interface ServiceViewController : UIViewController
@property (nonatomic , strong) JSContext * jsContext;
@end

NS_ASSUME_NONNULL_END
