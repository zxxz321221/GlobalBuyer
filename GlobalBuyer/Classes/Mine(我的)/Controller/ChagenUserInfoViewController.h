//
//  ChagenUserInfoViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"

@protocol  ChagenUserInfoViewControllerDelegate <NSObject>

- (void)changeInfo:(NSString *)info AtIndex:(NSInteger)index;

@end

@interface ChagenUserInfoViewController : RootViewController
@property (nonatomic, assign) NSInteger indexs;
@property (nonatomic, strong) id<ChagenUserInfoViewControllerDelegate>delegate;
@end
