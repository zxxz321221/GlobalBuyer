//
//  EditUserInfoViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "UserInfoRootViewController.h"

@protocol EditUserInfoViewControllerDelegate <NSObject>

-(void)saveModel:(NSMutableArray *)arr;

@end

@interface EditUserInfoViewController : UserInfoRootViewController

@property (nonatomic,strong)id<EditUserInfoViewControllerDelegate>delegate;

@end
