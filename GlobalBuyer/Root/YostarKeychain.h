//
//  YostarKeychain.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2020/10/9.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YostarKeychain : NSObject

// save ... to keychain
+ (void)save:(NSString *)service data:(id)data;

// take out ... from keychain
+ (id)load:(NSString *)service;

// delete ... from keychain
+ (void)delete:(NSString *)service;

@end
