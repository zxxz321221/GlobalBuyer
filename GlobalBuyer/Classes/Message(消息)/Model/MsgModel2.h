//
//  MsgModel2.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/14.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel2 : NSObject
@property (nonatomic, copy) NSString * title;
+ (instancetype)gzm_initWithDictionary:(NSDictionary *)dic;
@end
