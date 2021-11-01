//
//  ChangePasswordViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"

@protocol  ChangePasswordViewControllerDelegate<NSObject>

-(void) password:(NSString *)password;

@end

@interface ChangePasswordViewController : RootViewController
@property(nonatomic,strong)id<ChangePasswordViewControllerDelegate>delegate;
@end
