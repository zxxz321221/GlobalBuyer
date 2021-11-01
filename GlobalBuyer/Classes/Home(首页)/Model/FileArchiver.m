//
//  FileArchiver.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "FileArchiver.h"

@implementation FileArchiver

+(NSArray *)readFileArchiver:(NSString *)fileName{
    NSString *path = [NSString stringWithFormat:@"%@/%@Archiver",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject,fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    // 3.解码并存到数组中
    NSArray *array = [unArchiver decodeObjectForKey:[NSString stringWithFormat:@"%@",fileName]];
    
    return array;
}

+(void)writeFileArchiver:(NSString *)fileName withArray:(NSArray *)array{
    NSMutableData *data = [NSMutableData data];
    
    // 2.创建归档对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 3.把对象编码
    [archiver encodeObject:array forKey:[NSString stringWithFormat:@"%@",fileName]];
    
    // 4.编码完成
    [archiver finishEncoding];
    
    // 5.保存归档
    NSString *path = [NSString stringWithFormat:@"%@/%@Archiver",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject,fileName];
    
    [data writeToFile:path atomically:YES];

}
@end
