//
//  FootHearModel.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/8.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FootHearModel : NSObject
@property (nonatomic,assign)BOOL isSelect;
@property(nonatomic,copy)NSString * days;
@property(nonatomic,strong)NSMutableArray * data;
@end

NS_ASSUME_NONNULL_END
