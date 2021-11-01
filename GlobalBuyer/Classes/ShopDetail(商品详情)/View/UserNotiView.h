//
//  UserNotiView.h
//  测试程序
//
//  Created by why on 2019/3/18.
//  Copyright © 2019年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+PYSearchExtension.h"

@interface UserNotiView : UIControl

//-(instancetype)initWithActionTitle:(NSString *)titleStr message:(NSString *)message action:(void(^)(NSDictionary *message))block;

//-(void)showActionTitle:(NSString *)titleStr message:(NSString *)message action:(void (^)(NSDictionary *))block;

-(instancetype)initWithTitle:(NSString *)titleStr message:(NSString *)message action:(void (^)(NSDictionary *))block;

@end
