//
//  HelpHeaderView.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/14.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpSectionModel.h"
@interface HelpHeaderView : UITableViewHeaderFooterView

typedef void(^HeaderViewExpandCallback)(BOOL isExpanded);

@property (nonatomic, strong) HelpSectionModel *model;
@property (nonatomic, copy) HeaderViewExpandCallback expandCallback;
@end
