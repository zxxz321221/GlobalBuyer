//
//  ImproveAccountInfoViewController.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2021/7/28.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRRootViewController.h"
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ImproveAccountInfoViewController : UIViewController
@property (nonatomic,assign)BOOL pop;
@property (nonatomic, strong)UIScrollView *scrollView;
- (void)setupUI;
@property (nonatomic,assign)BOOL isLogin;

@end

NS_ASSUME_NONNULL_END
