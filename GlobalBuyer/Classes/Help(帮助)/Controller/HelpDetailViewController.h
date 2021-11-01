//
//  HelpDetailViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/14.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "HelpSectionModel.h"
@interface HelpDetailViewController : RootViewController
@property(nonatomic,strong)HelpCellModel *model;

@property (nonatomic,strong)NSString *bodyStr;

@end
