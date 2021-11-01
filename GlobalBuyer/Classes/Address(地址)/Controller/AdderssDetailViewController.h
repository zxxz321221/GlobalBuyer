//
//  AdderssDetailViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"

@protocol AdderssDetailViewControllerDelegate <NSObject>

- (void)sendAdderssDetail:(NSString *)adderssDetail;

@end

@interface AdderssDetailViewController : RootViewController
@property (nonatomic, strong)id <AdderssDetailViewControllerDelegate> delegate;
@end
