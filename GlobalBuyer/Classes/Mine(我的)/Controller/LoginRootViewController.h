//
//  LoginRootViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/19.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "LRRootViewController.h"
#import "UserModel.h"
@protocol LoginViewControllerDelegate <NSObject>
- (void)userInfo:(UserModel *)model;
@end

@interface LoginRootViewController : LRRootViewController
@property (nonatomic, strong) id <LoginViewControllerDelegate>delegate;
@property (nonatomic,assign)BOOL pop;
@end
