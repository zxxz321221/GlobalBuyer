//
//  AppUncaughtExceptionHandler.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/12/11.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
