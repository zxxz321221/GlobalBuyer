//
//  MsgModel1.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/14.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MsgModel1.h"

@implementation MsgModel1
//字典转模型
+ (instancetype)gzm_initWithDictionary:(NSDictionary *)dic
{
    id myObj = [[self alloc] init];
    
    unsigned int outCount;
    
    //获取类中的所有成员属性
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        
        //获取属性名字符串
        //model中的属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = dic[propertyName];
        
        if (propertyValue != nil) {
            [myObj setValue:propertyValue forKey:propertyName];
        }
    }
    
    free(arrPropertys);
    
    return myObj;
}

@end
