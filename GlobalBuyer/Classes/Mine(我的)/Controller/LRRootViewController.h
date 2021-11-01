//
//  LRRootViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"

@interface LRRootViewController : RootViewController
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *iconImgView;
- (void)setupUI;
@end
