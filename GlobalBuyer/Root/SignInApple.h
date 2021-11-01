//
//  SignInApple.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2020/10/9.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  SignInAppleDelegate <NSObject>
- (void)appleIdLoginApi:(NSString *_Nullable)apple_id;
@end

NS_ASSUME_NONNULL_BEGIN

@interface SignInApple : NSObject

// 处理授权
- (void)handleAuthorizationAppleIDButtonPress;

// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
- (void)perfomExistingAccountSetupFlows;
@property (nonatomic, strong) id<SignInAppleDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
