//
//  HelpSectionModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/14.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpSectionModel : NSObject
@property (nonatomic, copy) NSString *sectionTitle;
// 是否是展开的
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, strong) NSMutableArray *cellModels;
@end

@interface HelpCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@end
