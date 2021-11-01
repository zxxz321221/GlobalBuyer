//
//  DateUtil.m
//  Demo
//
//  Created by BensonZhang on 15/11/16.
//  Copyright © 2015年 xunlian. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSString *)getDate:(NSString *)format
{
    ///设置标准时间格式
    NSDate * dateTime = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSString * formatterTime = [dateFormatter stringFromDate:dateTime];
    return formatterTime;
}

@end
