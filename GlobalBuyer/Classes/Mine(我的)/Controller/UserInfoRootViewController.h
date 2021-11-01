//
//  UserInfoRootViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "UserModel.h"
#import "UserInfoCell.h"
@interface UserInfoRootViewController : RootViewController
@property (nonatomic,strong)UserModel *model;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
-(void)setupUI;
-(void)initData;
@end
