//
//  GreatLoginViewController.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2021/7/28.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "LRRootViewController.h"
#import "LoginRootViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GreatLoginViewController : LRRootViewController
@property (nonatomic, strong) id <LoginViewControllerDelegate>delegate;
@property (nonatomic,assign)BOOL pop;
- (void)setupUI;
@end

NS_ASSUME_NONNULL_END
