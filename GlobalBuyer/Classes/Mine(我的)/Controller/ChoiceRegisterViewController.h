//
//  ChoiceRegisterViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/10/31.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "LRRootViewController.h"

@protocol ChoiceRegisterViewControllerDelegate <NSObject>

- (void)scanfInvitationCode:(NSString *)invitationCode;

@end

@interface ChoiceRegisterViewController : LRRootViewController

@property (nonatomic,weak)id<ChoiceRegisterViewControllerDelegate>delegate;

@end
